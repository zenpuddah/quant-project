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

- **Implemented:** The first executable C++20 data-model slice exists under `src/quant/data/`, with framework-free invariant tests in `tests/data_model_tests.cpp`.
- **Implemented:** The slice covers strong IDs, exact fixed-decimal values, source/order evidence, point-in-time reference history, and MBO/Trade/Quote/Bar record validation.
- **Deferred:** No provider adapter, storage, replay, reducers, lineage persistence, Python binding, or backtesting implementation has been created.
- **Generated:** The living Mermaid data model has matching outputs at `diagrams/data-model.svg` and `diagrams/data-model.pdf`.
- **Accepted:** A one-month Alpaca historical-data sample for `SPY`, `AAPL`, `MSFT`, and `AMZN` exists under Git-ignored `data/raw/alpaca/`, using `1Day`, `feed=iex`, and `adjustment=raw`; it does not define the canonical Phase 1 provider/model.
- **Accepted:** The public repository is `https://github.com/zenpuddah/quant-project` on `main`.
- **Accepted:** The documentation baseline now includes `AGENTS.md`, `docs/project/context.md`, `docs/project/engineering-book.md`, `docs/project/alpaca-data-acquisition.md`, `docs/architecture/phase1-system-context.md`, `docs/architecture/phase1-data-model.md`, `docs/architecture/phase1-data-model-implementation.md`, and the living Mermaid overview `docs/architecture/data-model.md`.
- **Accepted:** The canonical market-data iteration was checked against current Databento documentation, current Nasdaq TotalView-ITCH specification references, and NautilusTrader order-book documentation before being recorded.

## Current architecture task

- **Accepted:** The Phase 1 system context is established at a useful first level.
- **Accepted:** Canonical market-data model iteration 1 is complete enough to stop adding abstract concepts.
- **Implemented:** A first concrete data-model slice now exercises exact values, reference intervals, observed record shapes, and structural invariants.
- **Accepted:** `docs/architecture/data-model.md` is the living Mermaid representation to update with every data-model change.
- **Next:** Review and accept the provisional concrete choices: exact fields, required/optional semantics, invariants, event/action representation, and transformation contracts.
- **Then:** Design storage/access/replay and the provider port/Databento adapter against those concrete types.

## Open questions

- Final canonical C++ type/variant layout, decimal arithmetic/overflow policy, and invariants.
- Whether the provisional action-plus-optional-fields MBO representation should become typed variants.
- Provider port and Databento adapter API.
- Economic-security versus venue-listing type split.
- Storage/database/file format, physical layout, query/replay API, snapshots, and schema evolution.
- C++/Python responsibility split and research-logic promotion.
- Minimum execution/fill/cost/slippage/risk fidelity.
- Experiment reproducibility/artifact requirements.
- Paper/live execution boundary.
- CLion-compatible compiler/build/test/debug workflow.
- ML feature/label temporal correctness when the research-dataset builder is designed.

## Next action

- **Accepted:** Stop abstract architecture expansion after documenting iteration 1.
- **Accepted:** Begin the concrete canonical-type implementation pass with a deliberately provisional, reviewable slice.
- **Next session:** review the implementation slice before expanding into storage, replay, or provider integration.

## Last updated

- **Accepted:** 2026-09-01.
