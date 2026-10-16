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
8       8      source_receive_time
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

---

# 2026-09-03 — Historical ingestion architecture and bottleneck pass

## Starting point

After Data Model Iteration 2, the next concrete question became how historical provider data enters the system without making Databento, caching, storage, or future concurrency define the canonical model.

The design conversation deliberately worked through failure modes one at a time before implementation. The target was not a production ingestion platform; it was a thin synchronous slice whose boundaries survive later cache/storage/async work.

## 1. Cache our canonical query, not the provider request

### Problem

A cache keyed by exact Databento request parameters would leak provider semantics into the core and would not naturally represent partial overlapping coverage.

### Decision

`MarketDataQuery` expresses canonical intent. A future cache reasons about canonical coverage segments over half-open `[start, end)` intervals.

```text
MarketDataQuery
      ↓
CachePort
      ↓
Miss / FullHit / PartialHit
```

The first implementation is `NoopCache`, always returning the full canonical range as missing.

### Why the real cache is deferred

The current slice does not yet know whether persisted data will be files, a database, memory, object storage, or a combination. The policy boundary is useful now; a storage-specific write contract is premature.

## 2. Generate cache/reproducibility metadata even while the cache is a ghost

### Problem

Deferring caching must not mean losing the information a future cache needs.

### Decision

Ingestion owns `IngestionMetadata`; cache implementations consume it later.

```text
MarketDataQuery   = requested intent
IngestionMetadata = actual coverage / quality / provenance / version evidence
```

Metadata is designed to carry actual coverage segments, provider/source provenance, quality state/evidence, optional source-artifact identity/checksum, and adapter/canonical-schema/mapping version identity.

This keeps migration/regeneration possible without implementing a migration framework now.

## 3. Instrument reconciliation starts human-managed and time-aware

### Problem

Canonical `InstrumentId` cannot simply equal a Databento ID or ticker. Historical symbols and provider mappings can change through time.

### Source observation

Databento's symbology documentation preserves historical symbols as they appeared at the event time and exposes mapping intervals. A requested symbol can partially resolve over a range.

### Decision

Bootstrap provider reconciliation with a human-maintained XML registry.

Each canonical instrument may own several provider mapping intervals:

```text
InstrumentId 42
├── [2012, 2022-06-09) -> FB / provider mapping A
└── [2022-06-09, ...)  -> META / provider mapping B
```

Provider ID is optional. Symbol, venue/listing evidence, type/currency/reference information and interval validity can participate in the mapping. A query crossing a mapping boundary can split into multiple provider subqueries and normalize all returned records back to the same canonical `InstrumentId` where appropriate.

AI/heuristics may later rank ambiguous candidates; they are not ingestion authority. Human-approved deterministic mapping remains authoritative.

The XML parser dependency itself is intentionally not chosen yet.

## 4. One quality model for ingestion and canonical data

### Problem

Provider ingestion can return degraded, missing, corrupt, or structurally invalid data. If ingestion invents its own quality state, the same problem will later be represented differently in cache, replay, research, and the canonical model.

### Source observation

Databento exposes historical dataset conditions including available, degraded, pending, and missing, plus `last_modified_date`. Those are provider evidence, not our canonical state vocabulary.

### Decision

Translate provider/validation evidence into canonical `DataQualityObservation` and reduce it through the same `DataState` mechanism already accepted in the data model.

```text
provider evidence
      ↓
DataQualityObservation
      ↓
DataStateReducer
      ↓
DataState
```

Ingestion workflow state remains separate. Provider/job `pending` does not automatically become a market-data quality state.

No quality field is copied into every hot `MboRecord`.

## 5. Recovery is a ghost policy seam

### Problem

Missing/degraded data will eventually need retries or range repair, but implementing retry workers before the quality/range boundaries are exercised would create unnecessary infrastructure.

### Decision

Preserve a `RecoveryPolicy` seam. The first implementation always chooses `NoAction`.

Retry loops, backoff, scheduling, and repair execution remain deferred.

## 6. Batch is the primitive; synchronous execution comes first

### Problem

MBO/L3 ranges can be too large to assume the whole query fits in memory. Future parallel work can also complete out of order.

### Decision

Treat the pipeline as batch/chunk oriented; a single record is a batch of one.

The first executor is synchronous. It processes provider-valid order without adding threads, queues, futures, or locks.

Future async/multithreading must reuse the same query/range/mapping/provider/quality semantics. Processing completion order is not market-event order. A future parallel form may use map/normalize workers followed by an ordering/reduce stage that respects provider sequence/channel semantics and does not invent a global order across independent channels.

## 7. Overlapping work uses range resolution, not cache-specific logic

### Problem

Two future ingestion jobs may overlap:

```text
A wants [1,10)
B already works [5,8)
```

### Decision

Keep interval math in a reusable `RangeResolver`. A future `IngestionCoordinator` can join/wait for `[5,8)` and fetch `[1,5)` plus `[8,10)`.

The synchronous first slice has no active-job registry. It only implements the pure range logic needed later.

## 8. Partial results need no extra transaction abstraction

Coverage segments plus `DataState` already represent:

```text
[1,5)  complete
[5,8)  complete
[8,10) unresolved/degraded
```

Successful data is not discarded, and failed ranges are not pretended to exist. Future recovery can target only unresolved segments.

## 9. Provider leakage guardrail

### Problem

A generic query containing `dataset`, `mbo`, `stype_in`, or Databento request classes would simply be a Databento API in disguise.

### Decision

Canonical query fields remain provider-independent. The Databento implementation owns dataset/schema/symbology/request translation. Alpaca remains a ghost structural check: the provider port must not require concepts that only Databento can represent.

Databento is still the only real provider implementation target now.

## 10. L3 first

### Source observation

Databento documents MBO as L3/full order-book data, MBP-10 as L2/top-ten price levels, and MBP-1 as L1/BBO updates.

### Decision

Implement only the L3/MBO path first. Direct MBP-10/MBP-1 provider ingestion remains deferred. Later reducers may derive lower-information views from sufficiently complete L3 input, and direct provider-native lower-level data can be added for comparison/other use cases.

## 11. Version evolution and storage stay constraints, not projects

Metadata keeps adapter/canonical-schema/mapping version identity. Raw provider artifacts should generally be regenerable through newer adapters when retained; canonical/derived data may later need explicit migrations.

No migration framework is built now.

Storage/access/replay remain intentionally deferred. The only current guardrails are that ingestion does not assume one permanent in-memory representation, does not expose database/file operations through canonical query semantics, and operates on bounded batches/segments.

## 12. Engineering-manager / implementation-agent boundary

The repository owner acts as engineering manager for major architecture/product/trade-off decisions. OpenCode is an implementation agent.

The next code slice is deliberately dependency-free and fake-driven. If implementation exposes an interface contradiction, hidden provider requirement, new external dependency, major ownership/performance issue, or need to make a ghost component real, the implementation agent must stop and ask one focused engineering-manager question instead of silently redesigning.

## Source check

Primary Databento documentation rechecked before recording this iteration:

1. Schemas/data formats  
   https://databento.com/docs/knowledge-base

   Supports: MBO is L3/full order-book data, MBP-10 is L2, MBP-1 is L1.

2. MBO schema  
   https://databento.com/docs/schemas-and-data-formats/mbo

   Supports: order-ID-keyed MBO events and the event/receive timestamp, channel/sequence, price/size and source fields used by the existing canonical design.

3. Symbology  
   https://databento.com/docs/standards-and-conventions/symbology

   Supports: historical symbols remain point-in-time; mapping results contain validity intervals and can partially/not resolve over a requested date range.

4. Historical dataset condition  
   https://databento.com/docs/api-reference-historical/basics/authentication

   Supports: provider-side availability/quality evidence (`available`, `degraded`, `pending`, `missing`) and `last_modified_date`.

## Source-supported versus project-created

**Source-supported mechanisms:** Databento L1/L2/L3 schema hierarchy, MBO ordering/provenance fields, point-in-time symbology mappings, and dataset condition/version evidence.

**Project-created architecture choices:** canonical `MarketDataQuery`, `CachePort`/`NoopCache`, segmented canonical coverage, XML bootstrap registry, `IngestionMetadata`, recovery-policy seam, range resolver/coordinator split, batch-first synchronous execution, and engineering-manager implementation gate.

## Implementation handoff

Accepted architecture: `docs/architecture/phase1-historical-ingestion.md`.

OpenCode execution plan: `docs/project/opencode-handoff.md`.

The first implementation must stop after the generic synchronous skeleton is verified. Real Databento client and XML parser dependencies require a separate engineering-manager review.

---

# 2026-09-05 — Provider receive time and acquisition provenance

## Problem

The first Databento adapter preserved `ts_recv` under the generic name `receive_time`. That name can be read as the time our own live infrastructure observed an event, which is not true for historical records. Mapping validity also needs a single unambiguous time basis, while a result must identify whether its data entered through historical or live ingestion.

## Decision

- Canonical observations and query filters call the provider-side timestamp `source_receive_time` / `source_receive_time_range`.
- Instrument mappings are resolved only against `event_time` validity. A query with both ranges resolves mappings by event time and applies source receive time as an additional record filter. Source-receive-time-only ingestion is rejected for now.
- Historical ingestion does not fabricate a local per-event receive timestamp. `ingestion_time` remains the operation timestamp.
- `AcquisitionMode::Historical` and `AcquisitionMode::Live` identify the acquisition path at ingestion-result metadata level; the mode is not added to the 64-byte `MboRecord`.

## What it solves

- Provider/source timestamp ownership is explicit.
- Symbol/provider-identity validity cannot be incorrectly inferred from receive time.
- Historical and future live results can be distinguished without changing the hot record layout.

## What remains open

Live ingestion wiring and any future receive-time-based mapping model remain out of scope for the first Databento historical slice.

---

# 2026-09-06 — Shared query planning and data usability

## Problem

The synchronous ingestor resolved cache misses, mapping intervals, provider queries, and post-fetch filtering inline. That made the actual provider-call decisions difficult to inspect and allowed consumer coverage choices to be confused with factual `DataState`.

## Observation / mechanism

The existing flow already had the required mechanisms: half-open canonical ranges, event-time mapping validity, optional source-receive-time filtering, provider fetch derivation policy, and segmented `DataState`. The missing boundary was a reusable description of the decisions before provider execution.

## Decision

- Introduce `QueryPlanner` and `QueryPlan` as a small diagnostic/planning layer.
- Keep each planned segment tied to one event-time mapping interval and a mapping-clipped canonical provider query.
- Represent the provider fetch range with canonical `TimeBasis` and `TimeRange`; keep Databento request translation in the adapter.
- Route both `SynchronousIngestor::explain()` and `SynchronousIngestor::ingest()` through the same planner.
- Introduce injectable `DataUsabilityPolicy`. The initial policy treats `Complete` and `Degraded` as usable and all other factual states as unusable.

## What it solves

- Explain output cannot silently diverge from the mapping segments used for execution.
- Mapping-boundary and dual-time behavior can be tested without a real provider request.
- Consumers can choose usability without rewriting or collapsing factual data quality state.
- Future policies can distinguish a usable degraded range from a range that must be repaired without changing canonical state semantics.

## Trade-offs

- The first planner shares the existing `NoopCache` full-miss limitation; partial cache execution remains deferred.
- Provider fetch derivation is represented with canonical source-receive semantics because the accepted first real provider path requires it. Provider-specific date/schema/request translation remains adapter-owned.
- `explain()` is exposed on the synchronous ingestor for the supported L3 path; it is not a general query execution or serialization framework.

## Source check

No new external provider fact was introduced in this pass. The planner relies on the already accepted dual-time and event-time mapping decisions recorded in `phase1-databento-first-integration.md` and the 2026-09-05 provider receive-time entry above. The new policy and plan structures are project-created boundaries, not vendor concepts.

## What remains open

Partial-cache planning, bounded provider batch streaming, asynchronous execution, and provider-specific explain extensions remain deferred until a concrete requirement justifies them.

---

# 2026-09-26 — Storage and replay foundations

## Problem

The canonical in-memory model now needs a persistence boundary that serves both columnar analytical consumers and future event-by-event replay. Choosing a file format as the consumer interface would couple replay and strategy code to archive details, while persisting only replay fields would discard useful canonical evidence.

## Decision

- Use Arrow record batches as the in-memory columnar interchange layer.
- Use Parquet as the first persisted analytical/archive format.
- Introduce a small `DataFragment` identity containing data kind, canonical stream identity, half-open time range, schema version, and storage locator.
- Keep dataset-local metadata with the persisted artifact and keep static/reference metadata external.
- Expose `read_batches` and sequential canonical `stream_events` through a storage-independent reader boundary. The Parquet implementation owns Parquet APIs and replay column selection.
- Persist MBO, Trades, and OrderExecution first. Keep Bars, Features, and Fills possible later without adding a generalized catalog now.
- Defer a fixed-stride binary replay backend until measurements show that Parquet-to-Arrow sequential replay is insufficient.
- Keep Arrow/Parquet integration in an isolated CMake target using an environment-provided installation. Do not redesign the root build system.

## Reasoning

Arrow provides one batch-oriented interchange representation for C++ analytical access and the Parquet adapter. Parquet provides portable columnar archival storage without making it the domain model. A reader boundary lets research request batches and replay request ordered events through the same storage implementation while keeping future backends possible.

MBO persistence uses the already-finalized physical fields, including the `control` word, so optional values, action, side, and ordering/provenance presence remain recoverable without changing the 64-byte record. Stream identity and dataset context are stored once as fragment metadata rather than repeated in every event row.

## Trade-offs

- The initial Parquet path is simpler and more portable than a custom replay format, but replay performance is intentionally unoptimized until measured.
- The root remains dependency-free, so storage integration requires a separately provisioned Apache Arrow C++ installation and cannot be verified by the existing standalone test commands alone.
- Parquet key-value metadata is sufficient for the first dataset-local metadata set; a sidecar manifest or catalog remains available if concrete metadata needs exceed this mechanism.
- The first replay projection is canonical-data-kind-specific rather than a generalized query/catalog language.

## Source check

Apache Arrow C++ documentation describes `RecordBatch` as the columnar batch abstraction and documents the Parquet Arrow adapter's iterative `FileWriter`/`FileReader` interfaces and CMake package targets. These are implementation mechanisms, not canonical market-data semantics. The Arrow/Parquet role split, `DataFragment`, metadata split, and deferred binary backend are project architecture decisions.

Sources checked:

- `https://arrow.apache.org/docs/cpp/`
- `https://arrow.apache.org/docs/cpp/parquet.html`
- `https://arrow.apache.org/docs/cpp/build_system.html`

## What remains open

Binary replay backend measurements, catalog/discovery requirements, sidecar-manifest requirements, schema migration machinery, and the C++/Python consumer boundary remain deferred.

---

# 2026-09-29 — Interview-oriented research and trading scope

## Problem

The full Phase 1 objective spans research, features, strategies, orders, risk, execution, portfolio accounting, PnL, validation, and reproducibility. Treating every layer as a production-grade system would expand scope before the project demonstrates the domain reasoning it is intended to communicate.

## Decision

Prioritize a small, explainable vertical slice that shows how canonical market data becomes a research hypothesis, signal, simulated order, fill, position, portfolio value, and performance report. Prefer transparent baseline models and explicit assumptions over cutting-edge performance or infrastructure.

The study and implementation order is:

```text
research workflow
      ↓
backtest mechanics
      ↓
trading-domain state
      ↓
validation and performance attribution
      ↓
minimal end-to-end implementation
```

## Reasoning

Interview discussion is stronger when every result can be explained: which information was available at decision time, how an order became a fill, how fees and slippage affected PnL, and why a result may not generalize. This requires domain-correct boundaries, but not an exchange simulator, low-latency engine, distributed data platform, or ML research stack.

## Trade-offs

- The project will demonstrate breadth and correctness rather than production-scale performance.
- Simple execution and cost models are acceptable when their assumptions and limitations are explicit.
- More realistic microstructure, portfolio optimization, ML, and live execution remain available later but are not prerequisites for the interview slice.

## What remains open

The exact first strategy, research dataset interface, event/bar backtest loop, fill model, and minimal order/position/portfolio types should be selected after the corresponding domain concepts are studied and reviewed.

---

# 2026-10-01 — Decision coverage and storage closure review

## Problem

The owner requested a design-decision audit before the next architecture slice. Successful synthetic Arrow/Parquet round trips establish conversion behavior, but do not by themselves demonstrate every canonical-history invariant or a reproducible ingestion-to-research path.

## Observation / mechanism

Most first-slice responsibilities are represented: canonical identity and exact values, event-time mapping, dual-time filters, scoped quality, injected usability/recovery, isolated provider dependencies, Arrow schemas, Parquet persistence and sequential readers.

Temporary C++ probes reproduced gaps at the persistence boundary: a repeated write changes what an existing fragment reads; an out-of-range event can be stored under an unrelated interval; mismatched or mixed stream identity is not rejected; a zero-quantity Trade can bypass canonical validation; and an arbitrary version label is accepted by current codecs. The eight standalone tests and both storage CTest targets still pass because their intended inputs do not exercise these contracts.

## Review outcome — no closure policy accepted yet

Recorded evidence, priorities and proposed remedies in `docs/project/design-decision-review-2026-10-01.md`. Updated agent guidance to read later accepted ingestion supplements, the storage testing guide and the review. No production behavior was changed or new storage ownership/version/publication contract silently selected.

## Reasoning and trade-offs

- Immutable publication supports reproducibility without requiring a revision-management framework; overwrite rejection versus content-verified idempotency still needs owner acceptance.
- Binding scope before codecs discard identity is necessary if the system is to reject mislabeled batches; the generic writer cannot validate source identity after it has been removed.
- Explicit canonical row validation adds work, whereas caller-only validation requires a trustworthy, documented precondition. Responsibility and enforcement must be accepted rather than assumed.
- Unknown-version rejection can stay small and separate from deferred schema migration machinery.
- Provider-valid ordering requires source-specific semantics, not timestamp sorting or a universal consecutive-sequence rule.
- Persisting all ingestion evidence and joining independent data kinds are separate future integration decisions. Neither should be implemented as convenience infrastructure during this audit.

## Source check

Compared accepted repository architecture/engineering entries against current code and assertions; reproduced the storage behaviors against the installed PyArrow 21 C++ libraries. No live provider request or new exchange/provider assumption was introduced. The findings are current implementation evidence; the proposed remedies are project choices pending acceptance.

## What remains open

First accept the artifact immutability/repeated-write contract, then scope/range/row validation ownership and supported-version behavior. Continue studying the minimal research/backtest slice without presenting its proposed types, clock, fills or accounting rules as accepted implementation decisions.

---

# 2026-10-03 — Data-integrity architecture session and readiness review

## Problem

The owner reviewed the reproduced storage gaps one at a time and requested a complete recap before implementation. The discussion expanded preservation into separately persisted provider, canonical, and consumer stages. The implementation handoff must distinguish accepted principles from unspecified contracts.

## Accepted decisions

Recorded Decision / Reason / Invariant / Trade-offs / Implementation scope / Required tests in `docs/architecture/phase1-data-integrity-session-2026-10-03.md`: compact row StreamId with catalog resolution, one stream per canonical file, conversion-time identity checks, post-filter query/range checks, staged row-level failures and explicit recovery, immutable publication with exact input versions, known-version reader contracts, source-specific ordering checks and a separate pre-split ordinal, and separately retained stage outputs with lineage.

## Reasoning and remaining trade-offs

The row ID preserves identity but still depends on immutable/available reference meaning. Staging retains evidence without authorizing research consumption. An ordinal proves our preservation relative to its input association rather than exchange correctness; filtered gaps, normalization groups, and snapshots need source semantics. Separate stages permit regeneration, but complete publication must retain required evidence and operation/version identities.

Three contracts were initially presented as proposals and subsequently accepted in the owner acceptance below: catalog stability/reference snapshot persistence; minimum evidence plus complete/non-replacing publication and explicit retry identity; and consumer eligibility/initialization. Existing DefaultDataUsabilityPolicy accepts Degraded, including SequenceGap, so it cannot silently serve as the new unresolved-order gate. Full strategy/research/accounting design remains separate.

## Source check

Checked official Databento common fields/flags, XNAS normalization, snapshots, dataset conditions, engineering guidance, and Nasdaq MoldUDP64 session/message numbering. Dataset-condition start/end dates are inclusive; current rounding to the next date explains the previous extra-day evidence. Day-local clipping still requires implementation and regression verification. Source URLs and repository observations are in the recap.

## Verification and implementation boundary

Reviewed the pinned commit and relevant implementation; no production code changed and no implementation tests or paid provider requests were run. The accepted principles alone are not a complete implementation specification. Following the owner acceptance below, write the bounded specification and focused plan with invariant and failure tests.

## Owner acceptance after recap

The owner accepted the three final points: stable catalog identity with retained exact reference definitions; complete publication of data and reproducibility evidence; explicit eligibility gating and starting state for order-dependent consumers. The session recap now records these as accepted with reasons, invariants, trade-offs, scope, and required tests. The design contracts for the reviewed ingestion/storage gaps are settled; implementation mechanisms and the focused execution plan are next. This acceptance does not mean the new guarantees are implemented or that the deferred research/backtesting design is complete.

## Repository guidance and OpenCode handoff

The owner requested publication of the accepted context and agent guidance to GitHub, followed by an OpenCode prompt. Updated AGENTS.md, context, and historical review/storage/handoff cross-references, and added `docs/project/opencode-data-integrity-handoff-2026-10-03.md`. The handoff requires a bounded specification and plan before implementation, uses the recap rather than unaccepted audit proposals as authority, and names the required negative and publication-failure regressions. Documentation publication does not imply that production code has changed or that these regressions have passed.

## 2026-10-03 implementation checkpoint — domain preparation

The explicitly requested implementation starts at `95993a8` on a local implementation branch. Recorded a bounded specification and plan before code. Added separate StreamId/ordinal/evidence types, immutable tuple/reference checks, post-selection canonical validation, conservative dependency gating, and a source checker that permits repeated native sequences and snapshot succession without timestamp sorting. Normalized 56-byte DBN interpretation stays in an ingestion adapter; its field/flag definitions were cross-checked with the pinned official SDK and official DBN source. Session-reset evidence remains unresolved rather than guessed.

Meaningful standalone regressions cover invalid quantities/shapes, retained bytes, recovery revalidation, group boundaries/filtering, snapshots, ordinal association, receive versus event time, initialization and Degraded bypass. Strict and ASan/UBSan runs pass, as do existing standalone tests. Persisted capture/publication/reader guarantees are not yet claimed by this checkpoint. A required raw acquisition sink/journal is specified so errors during decoding cannot discard delivered provider evidence; record-before-conversion durability intentionally takes priority over unmeasured throughput.

## Provider-retention checkpoint

Added an explicit retained-acquisition method to the provider port and synchronous planner. Each request gets a named scope; the sink receives request/complete SDK metadata/original bytes before any interpretation or query filtering. Acquisition exceptions retain operation outcome and fetched evidence rather than becoming canonical Missing. The old logical ingestion method remains an inspection/orchestration baseline; it cannot supply the new publication's required raw/evidence package by itself.

Corrected inclusive condition endpoints and UTC-day clipping using the accepted source clarification. SDK-record byte decoding agrees with the existing adapter in deterministic tests; midnight/mixed-day/extra-date conditions are scoped correctly. No credentialed request was made. Durable filesystem capture and complete publication are still pending at this checkpoint.

## Bound interchange checkpoint

Added deliberately named v2 row binding columns outside MboRecord. Conversion checks original headers/context before dropping identity; decoding checks the persisted binding as well as column types. Mixed streams, zero Trade/OrderExecution quantity, malformed control/presence representation and duplicate ordinals are rejected. New version-pinning fields and checked/scoped replay methods remain storage-independent.

Added bounded token-text evidence/reference serialization and dependency-free SHA-256/file primitives for the next publication slice. Known-answer and round-trip tests pass with strict warnings and ASan/UBSan against Arrow 21. Published availability is not inferred from this codec-only checkpoint.

## Complete publication and reader checkpoint

Implemented separate staged capture/canonical and published raw/reference/canonical/archival-consumer packages. Source IDs and exact reference definitions are create-only in the compact store; each version embeds the needed snapshot. Original record bytes are journaled before conversion, and failed/truncated operations remain investigable. Row-shape failures, missing requested timestamps and scoped SequenceGap evidence cannot silently become eligible data.

Publication exclusively reserves a version/attempt, syncs required files/evidence, verifies schemas and original event associations, then atomically exposes COMPLETE without replacement. Explicit new attempts reprocess identical retained input; changed input requires a new acquisition. Current selection changes separately and does not mutate old handles. Readers verify the full package and retain the checked batch objects before callbacks; replay cannot weaken mandatory ordering/group checks, or initialization for MBO.

The archival consumer preserves canonical meaning and includes opaque source-byte witnesses; replay projects these out. This closes association/projection tests without putting provider types into the hot record or replay interface. Synthetic/retained E2E, interrupted publication, immutable correction, moved references, unsupported contracts and internally consistent-but-wrong witnesses pass strict and sanitizer checks. The supported first scope is synchronous/local POSIX, qualified provider-returned succession and bounded in-memory validation. No independent exchange completeness, native Arrow package support, automated repair/checkpoint acquisition, or production-scale throughput is claimed.


## 2026-10-14 — Lexongine computation boundary and implementation handoff

Problem: repeated component calculations should be shared without changing strategy behavior, losing input update history, introducing future information or confusing the computation engine with the financial backtester. A collection of dated discovery documents and appended plans also made the implementer infer which rules were current.

Accepted direction: fixed synchronous runs, explicit contracts/startup/policies, typed numerical implementations and immutable outputs; exact eligible sharing with full ordered transitive lineage; unique effects and original logical delivery order; automatic valid exact-full-scope output reuse in v1; explicit Strict/Skip complete-bar gaps and fixed-count lag. Repeated equal inputs still advance. Saved outputs do not restore reducer state. Failures stop the admitted run; preparation and financial execution remain distinct.

Engineering selection: freeze logical Kahn order before interning, execute each physical producer at its first logical occurrence and reach aliases at their own boundaries. Use owned descriptors, semantic type plus C++ witness, host-controlled module/lifetime pins and precharged resources. Required sinks/host outcome finalize before accepted cache eligibility; uncertain publication withholds success. Point-time and interval-time are explicit tagged data, and gap ledgers participate in coverage/identity.

Integration: checked MarketDataReader callback replay materializes a bounded validated immutable selected slice; no implicit cross-acquisition merge or bar aggregation. The actual reader requires Arrow even for fake API tests. One advance_one/finish primitive supports standalone and hosted use. Qaedalus owns strategies/orders/fills/costs/risk/accounts/PnL; probes do not choose financial models.

Source check: all 25 Markdown files and relevant data/replay headers inspected at remote f75cd3c179f3b070f9a85c054ec3704b89f4cb69. Research references and limits are in [Lexongine research](../lexongine/research/README.md). No local project checkout, product implementation or native macOS build was verified by the advisor. Research oracle counts are not product test evidence.

Trade-offs: trusted same-build native plugins, bounded materialization and exact full-scope cache are deliberately narrow v1 engineering choices. Concurrency, checkpoints, richer alignment/gap recovery, numerical upgrades, stronger isolation/durability and ML feedback remain future work. See [decisions](../lexongine/decisions.md), [operative handoff](../lexongine/README.md) and [implementation progress](../lexongine/implementation/progress.md). Keep rules in their owning specification rather than duplicating this chronology as a new contract.

### 2026-10-15 — Initial owned-contract and lifetime implementation

The local baseline/handoff divergence was documentation-only and was reconciled
without changing the accepted specifications or domain code. Initial framework-free
checks now exercise owned descriptors, typed parameter/state preparation, immutable
payload holders, bounded diagnostics, reservations, and atomic bundle visibility.
A runtime test reproduced duplicate-key state advancement; a pre-callback key
guard fixes that case without changing its assertion.

The accepted host-held module pin rule motivates a common compiled core library
for erased control and callback-manager destruction: the pin remains alive until
the paired typed destructor returns. Headers still carry typed numerical adapters;
no Arrow or XML dependency enters the core. Current evidence is two passing strict
and ASan/UBSan targets, not a native-plugin or whole-milestone result. Full
pre-admission accounting and the remaining task-card matrix still need closure.
The owner approved provisioning the already accepted TinyXML2 and Arrow/Parquet
dependencies; source pin and network failures are recorded in implementation
progress. No new provider/financial assumptions were introduced.

### Publication provenance interface clarification — owner accepted 2026-10-15

Problem/source check: the written typed interfaces exposed only value/lease on
ReadValue and Outputs in Published, while accepted retained-input/lag behavior
requires preserving an earlier parent's original timing and lineage. Inspection
of components/execution/cache contracts exposed a missing communication path;
an allocation-only PublicationAllocator could not implicitly supply it.

The owner selected a typed provenance envelope over a separate host lineage
selector. ReadValue gains immutable metadata access and Published carries explicit
bounded parent selections. The host verifies input authority, history, order and
causal availability. This keeps selection next to the typed calculation and avoids
duplicating numerical history selection in a second state machine. Trade-off:
the typed callback envelope changes and requires additional metadata lifetime and
adversarial validation checks. The owning components specification records the
accepted contract. Acceptance of the choice is distinct from implementation proof.

### Independent canonical-price arithmetic checkpoint

Implemented the accepted signed64 bounded sum and ties-even policy using the
existing Price representation/operators. Eviction precedes addition so a legal
full window cannot overflow solely because of update ordering. State retains exact
inputs and sum; rounded means never feed working state. Unsigned magnitude plus
quotient/remainder handles signed-minimum rounding without negation overflow or
doubling a remainder. State allocations are checked/reserved before ring creation.

The generator uses the specified synthetic IDs, intervals, prices, optionals and
volume; canonical validation checks every generated Bar. A separate Python Fraction
oracle recomputes full windows and fixed-count lags from raw inputs. Strict and
sanitized helper/oracle checks pass; exact counts and commands are in progress.
Source/check: inspected existing `value_types.hpp`, `observations.hpp`, and
`validation.hpp` plus the accepted numerical specifications/reference cases. No
provider assumptions or alternative financial types were added. Pure mathematical
window tests remain distinct from the pending graph/source/host integration.

### Exact graph identity and implementation-selector clarification

Inspection found that registry keys distinguished implementation selectors while
the draft wire operation identity omitted them. Distinct factories in one binary
could therefore receive identical implementation records. The owner selected
including the selector alongside actual digests, rather than forbidding such
registrations. Updated the pre-implementation v1 schema and tested recursive
identity changes under a constant candidate hash.

The graph compiler freezes logical Kahn order before interning. Its physical order
is only first-occurrence projection; the reusable walk still visits logical aliases
at their own boundaries. The S,p1,A,p2,B counterexample and failure prefix pass.
Full field encoding is counted before buffer reservation/allocation and includes
ordered full parent records. Eligibility propagates separately through dependencies;
an unshareable upstream cannot be hidden by a pure child. A runtime regression
also exposed and fixed an unchecked producer/consumer Strict/Skip mismatch.

Source check/evidence: accepted configuration/execution/reuse contracts, actual
registry key definition, product tests and the existing storage reader header.
All 5 current strict/sanitized CTest targets pass; a direct actual-reader prototype
also passes with cached official Arrow static libraries. Full source, native
package, plugin and executor verification are still separate pending work.

### Strict XML authoring boundary

Implemented two explicit stages: owned authoring declarations/plugin paths/raw
literals, followed by frozen-registry parameter-schema resolution. Source/history
preparation remains responsible for actual initialization ranges and source-policy
validity. This avoids borrowing a DOM or inventing source facts while parsing.

Checked the pinned TinyXML2 11.0.0 source, including its attribute duplicate path.
A narrow preflight enforces the accepted vocabulary, counts/depth/text, namespaces,
DTD/entity/PI restrictions and duplicate attributes before DOM construction. Tests
exposed that generic XML declaration parsing did not enforce our version/encoding
contract; explicit validation now rejects that case. Another failing test closed
static source/observation missing-policy mismatch. Typed schema resolution calls
no executable factory and inserts no required parameter value.

The explicit preparation account is charged before DOM/owned-record allocation;
the conservative ceiling is separate from a process-RSS claim. Supplied TinyXML2
version 11.0.1 is rejected at configuration. Eight frontend cases pass strict and
sanitized, alongside the existing core/numerical/graph checks (six targets total).
Full source and execution acceptance is still pending; commands/limits are recorded
in implementation progress.

### Native same-build plugin implementation and platform boundary

The native probe first reproduced a concrete platform mismatch: modern macOS
records delayed-initialization dylib use (CoreFoundation here), while ordinary
active-image enumeration need not list that image. The installed SDK loader.h
documents dylib_use_command and its flags; Apple's dyld Loader.cpp distinguishes
loaded and delayLoaded collections. Sources checked: the local Apple SDK 26.5
header and https://github.com/apple-oss-distributions/dyld/blob/main/dyld/Loader.cpp.

The owner selected a bounded trust boundary: actual hashes for plugin/core and
non-system dependency files, observed UUID/OS/SDK facts for Apple platform images,
and explicit deferred system references. Full shared-cache byte verification is
not claimed. This preserves an explainable same-build plugin mechanism without
turning the task into a platform loader/shared-cache framework.

Implemented generated build facts and a binary-bound source/build sidecar,
transactional registration, exact type witnesses and host-held destruction pins.
Output allocation uses declared prebound policies and combines operation/type
pins; the registry can bind an existing nominal SDK type only when its native
witness agrees. The native test deliberately tears down registry, definition,
prepared factory and instance before releasing an external custom typed output.
Four native test cases and all seven current CTest targets pass strict and
sanitized. Commands, reproduced failures and remaining scope are in progress.

### Coverage/history preparation and native storage prerequisite recovery

Implemented independent preparation helpers for the exact complete-key/gap
partition, retained original keys, source bounds and required count history.
Readiness counts actual usable inputs before the first eligible requested update;
it never shifts the configured evaluation interval. Chained requirements use
max-parent history plus the local count, rather than summing fan-out duplicates.
These are timeline/admission helpers, not provider-correctness or payload-validity
proofs; full source services still need integration.

The previously stalled approved dependency provisioning now completed with native
Arrow/Parquet 26.0.0. An intermediate extracted-bottle shared link failed because
Homebrew install-name placeholders were unrelocated; the official installation
resolved that. Native CONFIG/shared linking passes the actual-reader prototype,
all nine current Lexongine targets, and all four existing storage targets in the
normal build. The Lexongine project sanitizer suite also passes nine targets;
prebuilt dependency binaries are not instrumented. No storage implementation was
changed, and these results do not stand in for the unfinished Lexongine adapter
or whole-run acceptance. Exact commands and dependency versions are in progress.
