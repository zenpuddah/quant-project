# Engineering Book

## Purpose

This is the reasoning companion to the architecture documents in `docs/architecture/`.

The architecture documents say **what is accepted**. This book records **why the problem existed, how we reasoned about it, what decision we made, what it solves, what sources we checked, and what is still open**.

The default reasoning shape is:

```text
Problem
  ↓
Observation / mechanism
  ↓
Constraint
  ↓
Decision
  ↓
What it solves
  ↓
What remains open
```

The project should not start from frameworks or abstractions. Start from the mechanism, find the problem, add only the concept that solves it, and defer anything whose constraints are not known yet.

Before an architecture decision that depends on market/provider semantics:

1. Check the relevant primary provider or exchange documentation.
2. Cross-check a mature implementation when useful.
3. Separate source-supported facts from our own engineering choices.
4. Record any new concept we introduced and why it became necessary.
5. Do not turn a useful mental model into infrastructure before a real requirement justifies it.

---

# 2026-08-31 — Canonical market-data model, iteration 1

## Starting point

The repository already had a Phase 1 system boundary, but the data layer was still too vague:

```text
provider
   ↓
?
   ↓
research / backtester
```

The first instinct was to design the provider/ingestion interface. We stopped because that interface cannot be correct until the core answers a more basic question:

> What does our system mean by market data independent of Databento, Alpaca, Python, C++, or a database?

That changed the order of work:

```text
canonical semantics
      ↓
canonical data model
      ↓
relationships / transformations
      ↓
storage / access
      ↓
provider port + adapters
```

The important decision was to define the financial/core meaning before defining how a provider supplies it.

## 1. Provider-specific data stops at the adapter

### Problem

Different providers expose different names, schemas, IDs, flags, and edge cases. If those leak into the core, every downstream component becomes provider-aware.

### Observation

Databento MBO exposes order IDs, actions, sides, timestamps, sequence/channel data, price, size, and flags. NautilusTrader normalizes venue/provider data into its own instrument and order-book delta model.

### Decision

```text
provider-native format
        ↓
adapter
        ↓
our canonical terminology
```

The adapter does semantic translation, not only parsing.

### What it solves

- Databento does not become our internal model.
- Alpaca can later map into the same core.
- Core consumers reason in one terminology.

### What remains open

The exact provider port/API is deferred until the concrete canonical types exist.

## 2. Preserve information hierarchy

### Problem

Bars, trades, quotes, L2, and L3 are all market data, but they do not contain the same amount of information.

### Observation

For sufficiently complete order-level data:

```text
L3 / MBO
├── reconstruct book -> L2 -> L1
└── trade/execution semantics -> Trades -> Bars
```

Moving downward loses information. Moving upward usually cannot recover information that was discarded.

### Decision

Treat `L3/MBO`, `Trade`, `Quote/L1`, `L2`, and `Bar` as distinct canonical financial concepts. Transformations between them must be explicit.

### What it solves

- high-fidelity data stays available for later research;
- simpler strategies can still consume lower-granularity views;
- provider-native lower-granularity data can be compared against our own derivations.

### Limit

Derivability depends on source semantics. We do not assume every provider MBO stream reproduces every provider trade, quote, or bar exactly.

## 3. Stable InstrumentId + ReferenceHistory

### Problem

A symbol is useful to humans but weak as historical identity. Symbols can change, differ by venue/provider, or be reused.

### Observation

Databento's Security Master is point-in-time and distinguishes security, listing group, and listing IDs. Its symbology documentation preserves historical symbol changes instead of rewriting the past.

### Decision

```text
market event
  └── InstrumentId

InstrumentId + EventTime
        ↓
ReferenceHistory
        ↓
metadata valid at T
```

The adapter/reconciliation layer maps provider identities into our internal `InstrumentId`.

### Validation idea

Name/symbol similarity, venue/currency/type checks, and sampled overlapping prices may help detect a bad mapping. They are validation evidence, not identity authority.

### What it solves

- symbol changes do not rewrite history;
- events stay small;
- time-varying metadata has one place to live;
- the same mechanism can later support options/futures metadata.

### What remains open

The exact split between economic security and venue listing.

## 4. Preserve ordering evidence; do not sort only by timestamp

### Problem

L3 reconstruction is order-sensitive. Multiple events may share timestamps, and feeds can define ordering through sequence/channel semantics.

### Observation

Databento MBO includes `ts_event`, `ts_recv`, `sequence`, `channel_id`, and flags. NautilusTrader also carries sequence/timestamp/flag data in book deltas and uses event-boundary flags.

### Decision

Preserve enough source ordering evidence in the canonical event. C++ validates and establishes provider-valid ordering before persistence or replay.

### What it solves

- deterministic reconstruction where the provider defines deterministic order;
- tie/gap detection;
- no fake precision from timestamp-only ordering.

### Deferred

A project-owned global sequence number. Add it only if storage/replay later shows a concrete benefit.

## 5. Observation is not state

### Problem

A mutable order book is useful during runtime, but it is a poor historical source of truth.

### Decision

```text
immutable history
      ↓
reducer
      ↓
materialized state
```

Examples:

```text
L3 events            -> book reducer    -> book state
market-state events  -> market reducer  -> MarketState
quality events       -> quality reducer -> DataState
```

### What it solves

- state can be rebuilt;
- reducers are testable from small histories;
- bugs can be traced to transitions;
- runtime mutation does not destroy history.

## 6. Original pool + transformed pool + lineage DAG

### Problem

Two records can have identical fields while having different meaning. A provider bar and our own aggregated bar are the obvious example.

### First idea

Think of derived data like a mutation chain: keep the ancestor and each transformation.

### Problem with the first idea

A chain is not enough because transformations can branch and can combine multiple parents.

### Decision

Use a lineage DAG:

```text
original observation
├── transform A -> descendant A
├── transform B -> descendant B
└── ...
```

A derived node references its parent(s) and the transformation that produced it.

### What it solves

- provenance;
- reproducibility;
- debugging;
- later ML dataset traceability;
- no need to duplicate provider/venue metadata on every descendant.

## 7. Venue market state is separate

### Problem

The same trade or quote can mean something different during pre-open, auction, continuous trading, halt, or close.

### Decision

Model market-state history separately and reduce it to state at time `T`.

```text
Venue + Instrument + Time
        ↓
market-state history
        ↓
reducer
        ↓
MarketState
```

### What it solves

Research can ask what market regime surrounded an event without embedding duplicated state into every record.

## 8. Data state is separate from market state

### Problem

No event for a period can mean either "nothing happened" or "our data is incomplete." Event sparsity alone cannot distinguish the two.

### Decision

Maintain data-quality/completeness observations separately and reduce them into `DataState`.

```text
MarketState = ContinuousTrading
DataState   = GapDetected
```

### What it solves

We do not confuse market inactivity with feed/data failure. Derived data can trace quality problems through lineage.

## 9. Corrections become history, not overwrite — FGIT

### Problem

Feeds can contain corrections, late events, trade breaks, amendments, or cancellations. Replacing the original record destroys auditability and reproducibility.

### Mental model

Use a Git-like idea: preserve the original, record the revision, derive the currently accepted view.

### Decision

Nicknamed **FGIT — Financial Git**:

```text
immutable history
    ↓
revision / correction
    ↓
reducer
    ↓
accepted materialized view
```

### What it solves

- correction handling;
- auditability;
- reproducibility;
- debugging;
- natural support for snapshots/checkpoints.

### Guardrail

FGIT is a mental/domain model. We are not building a general version-control system for market data. No branch/merge/content-addressing machinery unless a real need appears.

## 10. Exact financial values

### Problem

Binary floating point is a bad default for canonical price/money equality, tick constraints, and exact replay.

### Observation

Databento represents MBO prices as scaled `int64` values. Mature engines such as NautilusTrader use explicit `Price` and `Quantity` domain types.

### Decision

`Price`, `Quantity`, and `Money` get exact semantics and become strong domain value types.

### What remains open

Scale, bit width, overflow rules, and physical C++ representation belong to the concrete type pass.

## 11. Snapshots are checkpoints, not truth

### Problem

Replaying from the beginning forever is unnecessary, but making snapshots authoritative would duplicate/corrupt historical truth.

### Observation

Databento provides synthetic MBO snapshots for state recovery. NautilusTrader models snapshots as clear/add delta groups marked by snapshot/event flags.

### Decision

Snapshots are derived recovery checkpoints tied to a specific history position.

### Deferred

Snapshot cadence, physical format, persistence, and invalidation rules belong to storage/replay design.

## New concepts introduced in this iteration

| Concept | Why it became necessary |
| --- | --- |
| `ReferenceHistory` | Instrument metadata and symbols change through time. |
| Original/transformed pools | Observed and derived records can look identical but mean different things. |
| Lineage DAG | A simple mutation chain cannot represent branching or multi-parent transformations. |
| `MarketState` reducer | Venue/session context changes independently from individual market records. |
| `DataState` reducer | Market inactivity must be distinguishable from missing/corrupt data. |
| FGIT / revisioned event model | Corrections should change the accepted view without destroying original observations. |
| Snapshot/checkpoint | Fast recovery needs anchors without replacing event history. |
| Exact financial value types | Price/money semantics should not depend on binary floating-point behavior. |

None of these concepts imply a database, event-sourcing framework, or class hierarchy yet.

## Pre-commit resource check

The design was checked again before writing the repository documentation.

### Primary provider / exchange material

1. Databento MBO schema  
   https://databento.com/docs/schemas-and-data-formats/mbo

   Supports: order-ID-keyed L3/MBO records, `ts_event`, `ts_recv`, `action`, `side`, scaled integer `price`, `size`, `channel_id`, `flags`, and `sequence`.

2. Databento Security Master  
   https://databento.com/docs/schemas-and-data-formats/security-master

   Supports: point-in-time reference data, effective timestamps, security/listing identities, multiple listings, and external identifiers.

3. Databento Symbology  
   https://databento.com/docs/standards-and-conventions/symbology

   Supports: historical symbol changes are preserved at original event time; symbol mapping is time-dependent.

4. Databento MBO snapshot documentation  
   https://databento.com/docs/standards-and-conventions/mbo-snapshot

   Supports: snapshots as state-recovery material rather than replacement history.

5. Nasdaq TotalView-ITCH 5.0 current specification references  
   https://www.nasdaqtrader.com/

   Used to cross-check exchange-native order-event semantics and the fact that TotalView-ITCH 5.0 remains the current referenced depth-feed specification in 2026.

### Mature open-source implementation

6. NautilusTrader `OrderBookDeltas`  
   https://nautilustrader.io/docs/latest/concepts/data/order_book_deltas/

   Supports: canonical `InstrumentId`, grouped book deltas, sequence numbers, event timestamps, flags, and snapshot/event-boundary semantics.

## Source-supported versus project-created

**Source-supported mechanisms:** order IDs, market actions, multiple timestamps, sequence/channel information, fixed-scale prices, point-in-time reference data, historical symbology, snapshots, and grouped book updates.

**Project-created architecture choices:** original/transformed pool terminology, lineage DAG policy, reducer decomposition, `DataState`, `ReferenceHistory` naming, and FGIT terminology.

These project choices are kept because each solves a specific engineering problem identified above. They are not presented as vendor-prescribed architecture.

## End of iteration 1

The first design iteration is complete enough to stop adding abstract concepts.

Next pass:

```text
canonical concepts
      ↓
concrete fields
      ↓
required / optional semantics
      ↓
invariants
      ↓
event/action representation
      ↓
transformation contracts
```

Only after that should storage/access/replay and the provider port be designed in detail.

---

# 2026-09-01 — First executable canonical-data-model slice

## Problem

The accepted market-data model defined the required concepts and invariants, but the repository still had no executable representation against which those decisions could be checked.

## Implementation scope

The first implementation pass was intentionally limited to the domain boundary:

- strong identity, venue, source, timestamp, currency, and exact-value types;
- point-in-time reference history for one instrument;
- observed MBO, Trade, Quote, and Bar record shapes;
- structural validation for those records;
- framework-free tests compiled directly with C++20.

No provider, storage, replay, reducer, lineage, Python binding, or backtesting infrastructure was added.

## Concrete implementation choices

### Exact values

`FixedDecimal` uses an `int64` coefficient and a decimal scale from 0 through 18. `Price`, `Quantity`, and `Money` are strong wrappers. Decimal comparisons align scales without converting through binary floating point. The representation retains the supplied scale; arithmetic, overflow, and final scale policy remain open.

### Ordering evidence

`EventHeader` carries event time, optional receive time, optional provider sequence, optional channel, and opaque source flags. The implementation does not create a project-wide sequence or sort records, because the provider-valid ordering policy depends on source semantics.

### Record representation

`MboEvent` currently uses an action enum with optional order fields. This makes incomplete source records representable for validation and quality handling without adding a provider schema to the core. Action-specific checks determine whether an event is structurally usable. A typed variant remains an open alternative.

### Reference history

`ReferenceHistory` is append-only for one instrument and uses explicit half-open validity intervals. It rejects mixed instruments, overlapping intervals, invalid intervals, and appending after an open interval. It permits gaps so unknown reference data is not invented.

## What this solves

- Core records can refer to stable instrument identity rather than symbols.
- Exact financial values are not represented as unlabeled floating-point primitives.
- Provider ordering facts have a place without inventing global ordering.
- Reference metadata can be resolved at an event's point in time.
- Basic record invariants are executable and reviewable before provider/storage work begins.

## Trade-offs and remaining questions

This is a provisional C++ representation, not a final architecture freeze. Numeric provider IDs, per-value decimal scale, action-plus-optionals, Unix nanoseconds, and the current validation rules are suitable for the first slice but must be reviewed against the concrete Databento adapter and the first replay requirements. No new provider API was introduced in this pass; the existing provider source check remains the basis for the deferred adapter design.

## Verification

The framework-free test executable passed with:

```text
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src tests/data_model_tests.cpp
```

---

# 2026-09-01 — Data-model Iteration 2 concrete types and MBO layout

## Problem

The first executable slice preserved domain semantics but left several hot representations provisional: point-in-time lookup scanned history backwards, venue and source strings were repeated in event headers, decimal comparisons aligned strings at runtime, and MBO actions lived beside independent optional fields. The accepted Iteration 2 directions required concrete, measurable replacements without introducing storage, replay, provider, or concurrency infrastructure.

## Scope

This pass implements only:

- binary point-in-time lookup over the existing ordered `ReferenceHistory` vector;
- `uint32_t` `VenueId` and `SourceId` values with separate metadata tables;
- boundary normalization into fixed-scale `int64_t` `Price`, `Quantity`, and `Money` values;
- typed MBO writer inputs, a synchronous contiguous buffer, and action-aware record views;
- layout and sequential-traversal measurements for 32/40/48/64-byte candidates.

Original/transformed pools, lineage, revisions, snapshots, provider adapters, storage/replay, backtesting, networking, and concurrency remain deferred.

## Source check

The existing primary-source check remains applicable: Databento MBO documents order IDs, actions, event/receive timestamps, sequence/channel information, flags, and scaled integer prices. Nasdaq TotalView-ITCH references and NautilusTrader order-book documentation were used as cross-checks for order-event and grouped-delta semantics. Those sources support the mechanisms; they do not prescribe this project's `MboBuffer`, reference tables, scales, or common-header split.

## Decisions

### Reference lookup

`ReferenceHistory::at()` uses `std::upper_bound` over ascending `valid_from` values and checks the one candidate interval. This preserves gaps and `[valid_from, valid_until)` semantics while reducing lookup work from a reverse linear scan to logarithmic search. Append validation and ownership remain unchanged.

### Compact references

`VenueId` and `SourceId` are non-zero `uint32_t` strong IDs. `VenueReferenceTable` owns venue codes, and `SourceMetadataTable` owns provider/dataset/schema strings. `EventHeader` carries only the IDs. The tables are intentionally simple in-memory reference-data containers, not a storage or concurrent registry design.

### Exact values

The canonical scales are:

| Type | Scale | Represented unit | Maximum positive value |
| --- | ---: | --- | ---: |
| `Price` | 9 | 1e-9 price units | 9,223,372,036.854775807 |
| `Quantity` | 6 | 1e-6 quantity units | 9,223,372,036,854.775807 |
| `Money` | 2 | minor currency units | 92,233,720,368,547,758.07 |

Each hot value stores one signed `int64_t`. `Quantity` rejects negative values. Boundary input may have a decimal coefficient and scale through 18; upscaling checks overflow, while downscaling rejects non-zero discarded digits rather than rounding. Same-scale addition/subtraction is checked, money arithmetic requires the same currency, and cross-domain products such as price times quantity remain explicit future accounting operations.

### MBO representation

The writer boundary has typed `MboAdd`, `MboModify`, `MboCancel`, `MboExecute`, and `MboClear` inputs. `MboBuffer` is scoped to one instrument, venue, and source. Each `MboRecord` stores:

```text
offset  width  field
0       8      event_time
8       8      receive_time
16      8      sequence
24      8      order_id
32      8      canonical price
40      8      canonical quantity
48      8      source_flags
56      4      channel_id
60      4      action/presence control
```

The record is `alignas(64)` and `sizeof(MboRecord) == 64`. The control word contains the action, optional-field presence bits, and side encoding. This avoids sentinel loss for valid zero timestamps, sequence values, channel values, or numeric values. Stream scope is stored once in `MboStreamContext`; views combine it with each record to restore `EventHeader`. The physical buffer is a `std::vector<MboRecord>` and is deliberately synchronous and single-threaded.

## Measurement

The standalone benchmark used Apple clang 21 on arm64, `-O2`, 1,000,000 records, three sequential traversal passes, and a 64-byte cache-line model:

| Candidate | `sizeof` | `alignof` | Padding | Cache lines | Records crossing lines | Traversal records/s |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 32 bytes | 32 | 8 | 0 | 500,000 | 0 (0%) | 1.06414e9 |
| 40 bytes | 40 | 8 | 0 | 625,000 | 500,000 (50%) | 1.35621e9 |
| 48 bytes | 48 | 8 | 0 | 750,000 | 500,000 (50%) | 1.29436e9 |
| 64 bytes | 64 | 64 | 0 | 1,000,000 | 0 (0%) | 1.14002e9 |

The 32/40/48-byte structs are footprint probes with progressively incomplete fields. The 64-byte record is the smallest measured candidate carrying the selected event-local ordering, order, provenance flags, channel, action, and presence semantics. Its one-record-per-cache-line alignment also removes record-boundary crossings. The throughput numbers are a single-machine microbenchmark, not a universal performance claim; semantic completeness and predictable traversal determine the final choice.

At 1,000,000 records, fixed 64-byte payload uses 64,000,000 bytes. The requested hypothetical variable layout with 70% 64-byte records and 30% 32-byte `Clear` records uses 54,400,000 bytes, a 9,600,000-byte (15%) fixed-stride premium.

The same run performed 1,000,000 lookups across 100,000 reference versions at 39.9909 million lookups per second. This confirms the binary-search path is operational; it is not a domain-performance contract.

## Trade-offs

- Fixed stride spends space on unused `Clear` payload slots and uses more memory than the hypothetical variable layout.
- The shared MBO stream context assumes a buffer has one instrument/venue/source scope; mixed-scope buffers are rejected rather than duplicating IDs in every record.
- Fixed scales make hot comparisons integer-only but require the future adapter to normalize provider formats and require explicit policies for products/rescaling not exactly representable at the target scale.
- The reference tables use simple linear lookup because they are outside the event hot path; their ownership and future persistence API remain open.

## Verification

The framework-free tests pass with C++20 warnings-as-errors. They cover scale normalization, range/overflow behavior, compact metadata references, binary lookup boundaries and gaps, typed MBO round trips, presence bits, fixed stride, scope validation, and the existing trade/quote/bar invariants. The benchmark compiles and runs independently without a build-system or third-party dependency.
