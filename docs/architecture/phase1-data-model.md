# Phase 1 Canonical Market Data Model — Iteration 1

## Status

- **Accepted:** First-iteration canonical market-data design, reviewed on 2026-08-31.
- **Accepted:** This document defines domain meaning, boundaries, information flow, and invariants.
- **Implemented for the in-memory boundary:** Concrete C++ value/identity layouts and the fixed-stride MBO buffer are recorded in `phase1-data-model-implementation.md`.
- **Deferred:** Storage formats, database schemas, and provider API signatures.

## Design goal

The model must answer three classes of questions without coupling the core to one provider:

- **Trader:** what instrument, venue, price, size, side, and event are we looking at, and when did it happen?
- **Researcher:** what market state and data state existed at a point in time, and what transformations produced a result?
- **Engineer:** can provider data be normalized, ordered, validated, replayed, reconstructed, revised, and evolved without losing semantics?

Iteration 1 optimizes for information preservation, explicit semantics, deterministic reconstruction, and traceability before storage/performance choices.

## High-level model

```text
Instrument / Reference Data
├── InstrumentId
├── InstrumentType
├── ReferenceHistory
└── venue/listing/external identifiers

Observed Canonical Data
├── L3 / MBO events
├── Trades
├── Quotes / L1
├── L2 / price-level views
├── Bars
├── venue/market-state events
└── data-quality observations

Derived State / Data
├── reconstructed L3 book
├── L2
├── L1 / BBO
├── Trades where derivable from source semantics
├── Bars
├── MarketState
├── DataState
└── later research / ML datasets

History / Traceability
├── original pool
├── transformed pool
├── lineage DAG
├── revision history (FGIT)
└── snapshots / checkpoints
```

These are canonical concepts, not final C++ class names.

## Data flow

```text
External provider
      ↓
Provider adapter
      ↓
Canonical observed records
      ↓
C++ validation / ordering
      ↓
Original pool
      ↓
Reducers / transformations
      ↓
Transformed pool
      ↓
Storage / access / replay
      ↓
C++ backtesting + Python research
```

## Provider boundary

- **Accepted:** Provider-specific terminology and message formats stop at the adapter.
- **Accepted:** The core uses project terminology and project invariants.
- **Accepted:** Equivalent provider semantics are normalized by the adapter.
- **Accepted:** Provider-specific distinctions that may matter later are preserved through source/provenance metadata rather than silently discarded.
- **Accepted:** Databento is the first serious Phase 1 provider.
- **Accepted:** Alpaca remains useful as a later second adapter and provider-independence check.
- **Open:** Provider port/interface design follows the concrete canonical type pass.

## Instrument identity and reference history

### Problem

Symbols are not stable identities. They can change, be reused, differ by provider, or represent a listing rather than the underlying economic security.

### Decision

- **Accepted:** The core owns a stable internal `InstrumentId`.
- **Accepted:** Market records reference `InstrumentId`; ticker/symbol is reference data, not canonical identity.
- **Accepted:** Provider IDs, symbols, venue/listing IDs, ISIN/FIGI/CUSIP when available, and other external identifiers belong to reference/reconciliation data.
- **Accepted:** Instrument metadata is time-aware through `ReferenceHistory`.
- **Accepted:** Point-in-time lookup follows:

```text
InstrumentId + EventTime
        ↓
ReferenceHistory
        ↓
reference version valid at EventTime
```

- **Accepted:** Validity intervals belong to reference-data versions, not every market event.
- **Accepted:** Phase 1 use is primarily equities/stocks, while the identity boundary remains generic enough for later type-specific option/future metadata.

### Adapter reconciliation

The adapter/reconciliation layer maps provider identities into canonical `InstrumentId` values.

Deterministic provider/security-master identifiers are authoritative when available. Name/symbol similarity, venue/currency/type checks, and sampled overlapping prices can be used as validation evidence for ambiguous mappings, but they do not establish identity by themselves.

- **Open:** Exact economic-security versus venue-listing type split.

## Canonical market semantics

### L3 / MBO

The highest-information canonical market representation is an ordered stream of normalized order-level events when the source provides sufficiently complete MBO/L3 semantics.

Conceptually an L3 event preserves:

```text
identity / scope
├── InstrumentId
└── venue / book scope

ordering
├── event time
├── receive time when available
├── provider sequence / channel information
└── relevant logical-event / quality flags

order semantics
├── order id
├── action
├── side
├── price
└── quantity

provenance
└── provider/source information needed to preserve original meaning
```

Working canonical action vocabulary: `Add`, `Modify`, `Cancel`, `Execute`, `Clear`.

- **Accepted:** Typed `MboAdd`, `MboModify`, `MboCancel`, `MboExecute`, and `MboClear` inputs normalize into a fixed-size tagged physical record. The logical `MboEvent` shape remains available at the boundary; provider-extension mechanisms remain open.

The first physical MBO buffer is scoped to one instrument, venue, and source. Its records retain event time, receive time, sequence, order fields, source flags, channel, action, and presence bits. Instrument, venue, and source scope is stored once in the buffer context and restored by consumer views. The buffer is synchronous and single-threaded; it does not define a transport or storage layer.

### Execution is not Trade

- **Accepted:** An execution event changes or consumes resting order state.
- **Accepted:** A `Trade` is a transaction observation.
- **Accepted:** They may be related by provider semantics, but the canonical model does not collapse them into one concept.

### Information-reduction graph

```text
L3 / MBO
├── reconstruct book
│     ↓
│     L2 / price levels
│       ↓
│       L1 / venue BBO
│
└── execution/trade semantics where valid
      ↓
      Trades
        ↓
        Bars
```

- **Accepted:** Lower-granularity views are projections/derivations when source semantics make that valid.
- **Accepted:** Reverse reconstruction after information loss is not assumed.
- **Accepted:** Provider-native Trades, Quotes, L2, and Bars may coexist with internally derived versions.
- **Accepted:** Provider-native and internally derived versions are not assumed to match exactly because filtering, corrections, sessions, venue coverage, and timestamp conventions can differ.

## Time and ordering

### Problem

Timestamp order alone is not enough to reconstruct event-driven market state.

### Decision

- **Accepted:** Preserve source information needed to establish provider-valid order: event time, receive time when available, sequence/channel information, and relevant flags.
- **Accepted:** Ordering and validation are enforced by C++ before persistence/use.
- **Accepted:** Do not blindly sort by timestamp.
- **Accepted:** Do not invent a global order across independent source channels when the source does not define one.
- **Deferred:** A project-owned monotonically increasing canonical sequence is introduced only if implementation proves it useful.

## Original pool, transformed pool, and lineage

### Problem

A provider-supplied bar and a bar aggregated internally can have the same fields while having different meaning.

### Decision

- **Accepted:** Keep an **original pool** for observed canonical data and a **transformed pool** for internally derived data.
- **Accepted:** A transformed item references ancestry instead of duplicating all source metadata.
- **Accepted:** Transformations form a lineage DAG, not only a chain, because data can branch and multiple parents can feed one derivation.
- **Accepted:** Transformation lineage records enough information to identify parents, operation, parameters/configuration, and code/schema version once those become concrete.
- **Accepted:** Source data owns original provider/venue/scope facts; descendants inherit them through lineage unless a transformation explicitly changes scope or meaning.

## Venue / market state

- **Accepted:** Model venue/market state separately from individual trade/book records.
- **Accepted:** Preserve ordered market-state events/history.
- **Accepted:** Use a reducer/state machine to obtain `MarketState` at a requested time.
- **Accepted:** Exact state vocabulary is venue-aware and should come from provider/exchange semantics rather than guessed globally.

## Data state and quality

- **Accepted:** Model data quality/completeness separately from market state.
- **Accepted:** Quality evidence can include sequence gaps, provider quality flags, corrupted/unavailable ranges, corrections, or other source-specific evidence.
- **Accepted:** Use a reducer over quality/completeness observations to derive `DataState` for a range or point in time.
- **Accepted:** Derived data can discover compromised ancestry through lineage instead of copying every quality fact into every record.

## Revisions and corrections: FGIT

Providers/exchanges can publish cancellations, trade breaks, amendments, late records, and other corrections. Overwriting history destroys reproducibility and auditability.

Use a revisioned event model, nicknamed **FGIT (Financial Git)**:

```text
immutable observed history
        ↓
revision / correction records
        ↓
reducers
        ↓
materialized accepted state
```

Working terminology:

- `Event`: original immutable observation.
- `Revision`: amendment/correction referring to prior history.
- `Parent`: event/node a revision or derivation depends on.
- `Reducer`: deterministic logic that materializes state from history.
- `Snapshot`: checkpoint of reduced state.
- `Head`: latest accepted/materialized view.
- `History`: full revision/lineage ancestry.

**Guardrail:** FGIT is a domain mental model, not permission to build a general-purpose version-control system. Branch/merge/content-addressing machinery remains out of scope until a concrete requirement exists.

## Reducer pattern

```text
L3 events             -> order-book reducer -> book state
market-state events   -> market reducer     -> MarketState
data-quality events   -> quality reducer    -> DataState
revision history      -> revision reducer   -> accepted view
```

## Exact financial values

- **Accepted:** Canonical `Price`, `Quantity`, and `Money` use exact decimal/fixed-point semantics rather than binary floating point.
- **Accepted:** They become strong domain value types rather than unlabeled primitive numbers.
- **Accepted:** Instrument/reference metadata provides constraints such as tick size, lot size, currency, and precision where applicable.
- **Accepted for Iteration 2:** `Price` uses a 9-decimal `int64_t` scale, `Quantity` uses a 6-decimal `int64_t` scale, and `Money` uses a 2-decimal `int64_t` scale.
- **Accepted for Iteration 2:** Boundary normalization upscales with checked overflow and downscales only when discarded digits are zero. Same-scale arithmetic is checked; implicit rounding and binary floating-point conversion are not allowed.
- **Deferred:** Cross-domain products such as price times quantity require a later explicit accounting policy.

## Snapshots / checkpoints

- **Accepted:** Snapshots are derived checkpoints for faster state recovery; they are not canonical historical truth.
- **Accepted:** A snapshot is tied to the history/revision position from which it was produced.
- **Deferred:** Snapshot format, cadence, persistence, and invalidation rules belong to storage/replay design.

## AI / ML boundary

- **Accepted:** The canonical market model is not an ML tensor or feature table.
- **Accepted:** Research/ML representations are derived, regenerable views built from canonical history.
- **Deferred:** Feature/label temporal correctness, sampling, windowing, and ML dataset lineage will be designed with the research-dataset builder.

## Iteration-1 invariants

1. Provider schemas do not leak into core consumers.
2. `InstrumentId` is canonical identity; symbols are reference data.
3. Time-varying reference metadata is resolved point-in-time.
4. Timestamp alone does not define replay order.
5. Observed history is not silently overwritten.
6. Market state and data state are separate.
7. Derived data is traceable to its ancestry.
8. Information-reducing transformations are explicit.
9. Mutable/reconstructed state is derived from immutable history.
10. Financial values use exact semantics.
11. Storage/layout decisions do not define financial meaning.
12. Phase 1 remains stock-focused in use while the model boundary stays extensible to other instrument types.
13. Venue and source strings are reference metadata, not repeated event payload.
14. Fixed-stride MBO storage preserves action semantics through a tag and presence bits.

## Deliberately unresolved after iteration 1

- Provider port and Databento adapter API.
- Provider-extension mechanism for actions beyond the current canonical vocabulary.
- Economic-security versus venue-listing type split.
- Storage/database/file format and physical layout.
- Index/query/replay API.
- Snapshot/checkpoint format and cadence.
- Schema-evolution strategy.
- Detailed C++/Python research boundary.
- ML feature/label dataset model.
- Options/futures-specific reference fields.
- Paper/live execution boundary.

## Resource check

Before committing, the design was checked against current primary provider/exchange documentation and a mature open-source engine:

- Databento MBO schema: https://databento.com/docs/schemas-and-data-formats/mbo
- Databento Security Master: https://databento.com/docs/schemas-and-data-formats/security-master
- Databento Symbology: https://databento.com/docs/standards-and-conventions/symbology
- Databento MBO snapshots: https://databento.com/docs/standards-and-conventions/mbo-snapshot
- Nasdaq TotalView-ITCH 5.0 specification / current specification references: https://www.nasdaqtrader.com/
- NautilusTrader `OrderBookDeltas`: https://nautilustrader.io/docs/latest/concepts/data/order_book_deltas/

The checked sources support the market/feed semantics used here: order-ID-keyed MBO events, multiple timestamps, sequence/channel/flags, fixed-scale prices, point-in-time reference data, historical symbology, snapshots, and grouped book deltas. The lineage DAG, original/transformed pool terminology, reducer decomposition, `DataState`, `ReferenceHistory` naming, and FGIT terminology are project design choices rather than vendor-prescribed models.
