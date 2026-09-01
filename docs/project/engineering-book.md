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
