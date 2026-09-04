# Project Context

## Project objective

- **Accepted:** Build a personal C++20/Python quant-development platform that teaches professional engineering, provides Quant Developer portfolio and interview evidence, and grows into a usable research and backtesting platform.

## Accepted direction

- **Accepted:** Phase 1 is a small but complete research and backtesting system spanning data, features/indicators, strategy/signals, orders, risk, execution/fills, portfolio/accounting, PnL, and validation/reporting.
- **Accepted:** Phase 1 includes dataset discovery and ingestion, validation and normalization, interactive Python research, experimentation, configuration and reproducibility, experiment tracking and artifacts, result validation, promotion of accepted research logic, and an explicitly designed C++/Python boundary.
- **Accepted:** Phase 2 may evolve toward an Eurex-style exchange and execution environment with microstructure, limit-order-book behavior, matching and partial fills, latency, realistic execution, and relevant systems topics.
- **Accepted:** Phase 2 must not prematurely overcomplicate or distort Phase 1.

## Constraints

- **Accepted:** Architecture and design precede production implementation; user-requested research-data acquisition is allowed without creating production implementation.
- **Accepted:** Start with responsibilities, boundaries, data flow, and invariants; separate domain logic from infrastructure.
- **Accepted:** Prefer correctness, clarity, testability, reproducibility, and free/open-source options before performance complexity.
- **Accepted:** Do not invent missing requirements or present proposals as decisions.
- **Accepted:** CLion is the intended IDE; future tooling choices must remain compatible without assuming a build system yet.
- **Accepted:** Implementation should be idiomatic, concise, human-maintainable, and free of AI markers, unnecessary boilerplate, or artificial attribution.
- **Accepted:** Significant architectural trade-offs and changes must be presented for approval rather than silently decided.
- **Accepted:** Accepted architecture decisions live in `docs/architecture/`; their problem/reasoning/source checks live in `docs/project/engineering-book.md`.
- **Accepted:** Repository engineering/architecture documentation stays technical; do not include council/persona/fictional-character framing, motivational commentary, or unrelated study-session material.
- **Accepted:** The repository owner acts as engineering manager for architecture/product/major trade-off decisions. Implementation agents execute accepted designs and must stop for a focused question rather than silently resolving a conflicting boundary.

## Superseded ideas

- **Accepted:** A standalone matching engine is not the project definition or the whole portfolio.
- **Accepted:** "Vectorized Phase 1, event-driven Phase 2" is not a fixed architectural rule.
- **Accepted:** Python research is a first-class workflow, not an afterthought.
- **Accepted:** Concurrency, networking, and optimization are introduced only when a demonstrated problem justifies them.

## Data architecture — accepted iteration 1

- **Accepted:** Databento is the first serious Phase 1 data provider; Alpaca remains a later second adapter/provider-independence check.
- **Accepted:** Phase 1 use is primarily stocks/equities, while canonical instrument identity remains extensible to later type-specific options/futures metadata.
- **Accepted:** Provider-specific formats and terminology stop at adapters; the core uses provider-independent canonical semantics.
- **Accepted:** Canonical market concepts include L3/MBO events, Trades, Quotes/L1, L2/price-level views, and Bars.
- **Accepted:** High-information observations can be reduced/derived into lower-granularity views where source semantics allow it; reverse reconstruction is not assumed.
- **Accepted:** Stable internal `InstrumentId` is canonical identity. Symbols/external identifiers live in time-aware reference/reconciliation data through `ReferenceHistory`.
- **Accepted:** Source ordering evidence is preserved; C++ enforces provider-valid ordering/validation before persistence/use. Timestamp-only sorting is not sufficient.
- **Accepted:** Observed canonical data lives conceptually in an original pool; derived data lives in a transformed pool and references ancestry through a lineage DAG.
- **Accepted:** Venue/market state and data-quality state are separate histories reduced into `MarketState` and `DataState`.
- **Accepted:** Corrections/revisions do not silently overwrite observed history. The revisioned-event mental model is nicknamed FGIT (Financial Git).
- **Accepted:** Mutable/reconstructed state is derived through reducers from immutable history.
- **Accepted:** `Price`, `Quantity`, and `Money` use exact decimal/fixed-point semantics rather than binary floating point.
- **Accepted:** Snapshots are derived recovery checkpoints tied to a history position, not canonical historical truth.
- **Accepted:** Canonical data is not an ML tensor or feature table; research/ML datasets are later derived views.

See `docs/architecture/phase1-data-model.md` for the accepted model and `docs/project/engineering-book.md` for the reasoning and source checks.

## Current repository state

- **Implemented:** The executable C++20 data-model slice exists under `src/quant/data/`, with framework-free invariant tests in `tests/data_model_tests.cpp`.
- **Implemented:** Iteration 2 uses binary point-in-time lookup, compact `uint32_t` venue/source IDs with separate metadata tables, fixed-scale integer `Price`/`Quantity`/`Money`, and a synchronous typed MBO writer/buffer/view path.
- **Implemented:** `MboRecord` is a 64-byte, 64-byte-aligned fixed-stride record with presence bits and a shared instrument/venue/source stream context.
- **Implemented:** The dependency-free synchronous ingestion skeleton exists under `src/quant/ingestion/`, covering canonical query/range resolution, cache/recovery ports, shared quality reduction, metadata/result envelopes, mapping/provider fakes, and L3 orchestration tests.
- **Implemented:** The first ingestion result reuses one optional existing `MboBuffer`; mixed instrument/venue/source stream scopes are rejected explicitly rather than changing the 64-byte record or introducing a second physical MBO representation.
- **Implemented:** The reviewed ingestion quality correction is complete: event presence/absence without explicit quality or coverage evidence reduces to `Unknown`.
- **Verified:** The existing data-model test and all six ingestion tests pass with C++20 warnings-as-errors.
- **Measured:** The dependency-free benchmark in `benchmarks/data_model_benchmark.cpp` measured 32/40/48/64-byte candidates, padding, alignment, cache-line crossings, traversal, memory usage, and binary reference lookup on Apple clang 21 arm64. The 64-byte record is finalized for this boundary.
- **Deferred:** No real provider adapter, storage, replay, lineage persistence, Python binding, or backtesting implementation has been created.
- **Generated:** The living Mermaid data model has matching outputs at `diagrams/data-model.svg` and `diagrams/data-model.pdf`.
- **Generated:** The current Phase 1 status summary is maintained in `docs/project/phase1-status-summary.md` and `docs/project/phase1-status-summary.mmd`, with the rendered PDF at `docs/project/phase1-status-summary.pdf`.
- **Accepted:** A one-month Alpaca historical-data sample for `SPY`, `AAPL`, `MSFT`, and `AMZN` exists under Git-ignored `data/raw/alpaca/`, using `1Day`, `feed=iex`, and `adjustment=raw`; it does not define the canonical Phase 1 provider/model.
- **Accepted:** The public repository is `https://github.com/zenpuddah/quant-project` on `main`.
- **Accepted:** The documentation baseline now includes `AGENTS.md`, `docs/project/context.md`, `docs/project/engineering-book.md`, `docs/project/alpaca-data-acquisition.md`, `docs/project/opencode-handoff.md`, `docs/project/opencode-review-2026-09-04.md`, `docs/architecture/phase1-system-context.md`, `docs/architecture/phase1-data-model.md`, `docs/architecture/phase1-data-model-implementation.md`, the dependency-free benchmark at `benchmarks/data_model_benchmark.cpp`, and the living Mermaid overview `docs/architecture/data-model.md`.
- **Accepted:** The canonical market-data iteration was checked against current Databento documentation, current Nasdaq TotalView-ITCH specification references, and NautilusTrader order-book documentation before being recorded.

## Historical ingestion architecture — accepted 2026-09-03

See `docs/architecture/phase1-historical-ingestion.md` for the full accepted direction.

- **Accepted:** Databento is the only real provider target for the first historical-ingestion slice. Alpaca remains a ghost/provider-independence check and is not implemented now.
- **Accepted:** The first provider path is L3/MBO. Direct Databento MBP-10/L2 and MBP-1/L1 support is deferred.
- **Accepted:** `MarketDataQuery` expresses canonical intent (`InstrumentId`, optional venue constraint, L1/L2/L3 intent, half-open time range). Databento dataset/schema/symbology request details stay behind the provider boundary.
- **Accepted:** Synchronous ingestion is implemented first. Async/multithreading must later reuse the same domain/query/planning semantics rather than create a second ingestion model.
- **Accepted:** Batch/chunk processing is the ingestion primitive; a single record is a batch of one. Whole historical requests must not be assumed to fit in memory.
- **Accepted:** Caching is abstracted by `CachePort`; the first implementation is a `NoopCache` that always misses. No file/memory/database cache is implemented yet.
- **Accepted:** Cache identity/coverage is canonical-query based, not Databento-request based. Future cache coverage is segmented and patchable over `[start, end)` intervals.
- **Accepted:** Ingestion generates independent metadata for actual coverage, quality/provenance, artifact/version identity, and reproducibility. The cache does not create this metadata.
- **Accepted:** Canonical/provider identity bootstrap uses a human-maintained XML mapping registry. Provider ID is optional; mapping intervals are time-aware so historical symbol/provider-ID changes can split one canonical query into several provider segments.
- **Accepted:** AI/heuristics may later suggest or validate ambiguous mappings, but deterministic human-approved mapping is the ingestion authority. Automated reconciliation is deferred.
- **Accepted:** Provider/ingestion data-quality evidence feeds the same canonical quality mechanism: `DataQualityObservation -> DataStateReducer -> DataState`. Do not duplicate a separate quality model inside cache/ingestion or bloat every `MboRecord` with quality state.
- **Accepted:** Recovery is a policy seam. The first implementation is no-op; retry/backoff/repair execution is deferred.
- **Accepted:** Future overlapping concurrent jobs use range resolution/coordinator logic to join active work and fetch uncovered intervals. The synchronous slice has no active-job concurrency.
- **Accepted:** Future parallel normalization may use a map/reduce-like ordering stage; the synchronous slice preserves incoming provider-valid order and does not add threading infrastructure.
- **Accepted:** Partial query success is represented naturally by segmented coverage plus `DataState`; no extra transaction abstraction is needed.
- **Accepted:** Metadata keeps version identity sufficient for future regeneration/migration. No migration framework/scripts are built now.
- **Accepted:** Storage/access/replay remain intentionally deferred unless the current ingestion slice exposes a concrete incompatibility.

## Post-implementation ingestion review — 2026-09-04

See `docs/project/opencode-review-2026-09-04.md` before continuing ingestion work.

- **Completed:** Event presence/absence is not data-quality evidence. Valid events without explicit provider/adapter quality or coverage evidence enter the buffer but reduce to `Unknown`; zero events without evidence also reduce to `Unknown`; explicit quality evidence remains authoritative.
- **Accepted constraint:** The current fake `ProviderBatch` materializes a `std::vector<MboEvent>` only to prove orchestration. Do not cement full-request materialization into the real Databento boundary. Real provider integration must remain capable of incremental bounded batches/chunks without introducing premature async/concurrency/storage machinery.
- **Unresolved engineering-manager decision:** The implementation exposed the `InstrumentId` versus venue-listing boundary. A query with unspecified venue can potentially resolve multiple venue/source stream scopes, while `IngestionResult` currently owns one optional single-scope `MboBuffer`. Do not change `MboBuffer`, create a multi-buffer canonical result, or redefine identity until the engineering manager decides whether one `InstrumentId` means one tradable venue listing or can span several venue listings of the same economic security.
- **Accepted behavior until that decision:** Mixed MBO stream scopes remain explicitly rejected rather than hidden or coerced.
- **Implementation gate:** Do not start the real Databento adapter or XML parser before the identity/listing decision and dependency review are completed.

## Open questions

- **Current engineering-manager question:** Should one canonical `InstrumentId` represent one specific tradable venue listing, or can one `InstrumentId` span several venue listings of the same economic security?
- Exact Databento C++ client/dependency integration. Do not add a dependency before engineering-manager review.
- Exact XML parsing library/dependency. Do not add a dependency before engineering-manager review.
- Exact minimal `DataState` vocabulary/precedence if real provider evidence exposes ambiguity beyond the accepted quality cases.
- Storage/database/file format, physical layout, query/replay API, snapshots, and schema evolution implementation.
- C++/Python responsibility split and research-logic promotion.
- Minimum execution/fill/cost/slippage/risk fidelity.
- Experiment reproducibility/artifact requirements beyond the ingestion metadata baseline.
- Paper/live execution boundary.
- CLion-compatible compiler/build/test/debug workflow.
- ML feature/label temporal correctness when the research-dataset builder is designed.

## Current architecture task

- **Accepted:** The Phase 1 system context is established at a useful first level.
- **Accepted:** Canonical market-data model Iteration 1 is complete enough to stop adding abstract concepts.
- **Implemented:** Iteration 2 exercises canonical integer values, compact reference IDs, binary reference lookup, typed MBO writes, fixed-stride round trips, and structural invariants.
- **Implemented:** Historical-ingestion Tasks 1–6 are complete with deterministic fakes/no-op policies and no external dependencies, provider SDK, XML parser, storage, replay, retry, or concurrency infrastructure.
- **Implemented:** The generic synchronous ingestion skeleton is directionally accepted and its required event-count quality-inference correction is complete. The identity/result-shape decision remains unresolved without requiring broad redesign.

## Next action

1. **Engineering-manager decision:** Resolve whether canonical `InstrumentId` is venue-listing identity or can span multiple venue listings. Until resolved, preserve the current explicit mixed-scope rejection.
2. **Dependency review:** Choose the Databento C++ integration approach and XML parser before adding either dependency.
3. **Provider-boundary review:** Before the real Databento adapter, propose the minimum chunk-capable synchronous provider interface; do not add full concurrency/backpressure infrastructure.
4. **Then:** Connect the reviewed skeleton to real Databento historical MBO and the XML-backed mapping registry.

## Last updated

- **Accepted:** 2026-09-04.
