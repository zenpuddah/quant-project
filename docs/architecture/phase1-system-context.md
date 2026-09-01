# Phase 1 System Context

- **Accepted:** This is the first architecture layer. It describes purpose, boundary, actors, inputs, outputs, responsibilities, flow, non-goals, and decision points without selecting unnecessary implementation mechanisms.
- **Accepted:** Detailed data-domain decisions are maintained in `docs/architecture/phase1-data-model.md`; reasoning and source checks are maintained in `docs/project/engineering-book.md`.

## Phase 1 purpose

- **Accepted:** Phase 1 is a small but complete research and backtesting system for the end-to-end path from market data through validated PnL and reporting.
- **Accepted:** Research is a first-class workflow: discover and ingest data, validate and normalize it, investigate it in Python, experiment with features and strategies, track artifacts, validate results, and promote accepted logic into backtesting.
- **Accepted:** Phase 1 must teach professional C++20, Python, quant-development, and software-architecture practices while producing credible portfolio/interview evidence.
- **Accepted:** Phase 1 evolves later without importing Phase 2 complexity before it solves a demonstrated problem.

## System boundary

- **Accepted:** The Phase 1 platform boundary contains dataset discovery/ingestion, validation/normalization, canonical market data, Python research, experimentation, backtesting, configuration/reproducibility, artifacts, result validation, and reporting.
- **Accepted:** Within that boundary, the backtesting path covers features/indicators, strategy/signals, orders, risk, execution/fills, portfolio/accounting, PnL, and validation/reporting.
- **Accepted:** Data providers are external systems reached through provider adapters. Provider schemas do not define the core domain model.
- **Accepted:** Databento is the first serious Phase 1 provider. Alpaca remains useful as a later second adapter/provider-independence check; the existing Alpaca daily-bar sample does not define the canonical model.
- **Open question:** Whether paper/live trading and a real exchange execution boundary belong in Phase 1 remains undecided.
- **Open question:** The detailed promotion boundary from Python research into C++ backtesting remains undecided.

## Initial instrument and market-data scope

- **Accepted:** Phase 1 work is primarily stock/equity-focused.
- **Accepted:** Canonical `Instrument` identity remains generic enough to add type-specific options/futures metadata later.
- **Accepted:** The data model supports L3/MBO order events, Trades, Quotes/L1, L2/price-level views, and Bars as distinct financial concepts.
- **Accepted:** Databento's multiple granularities may be ingested directly; lower-granularity views may also be derived from richer history where source semantics permit it.
- **Accepted:** Information-reducing transformations are explicit and traceable.
- **Accepted:** Supporting L3/MBO does not imply building a full exchange/matching simulator in Phase 1.

## Users and external actors

- **Accepted:** The primary user is the developer/researcher who explores data, defines experiments, evaluates results, and accepts/rejects research logic.
- **Accepted:** A data provider supplies datasets and metadata through a provider adapter.
- **Proposed:** An interactive Python environment supports inspection/experiments and consumes tracked results/artifacts.
- **Proposed:** A reviewer/interviewer consumes selected documentation, validation evidence, artifacts, and performance results as portfolio evidence.

## Inputs

- **Accepted:** Inputs include market observations, instrument/reference data, venue/market context where available, data-quality information, researcher-authored logic, and reproducibility configuration.
- **Accepted:** Canonical market observations are provider-independent and reference stable internal instrument identity.
- **Proposed:** Backtests additionally receive run-selection criteria, risk/execution assumptions, and starting portfolio conditions.
- **Open question:** Exact corporate-action, fee, calendar, and initial-portfolio requirements will be refined with the first concrete backtest slice.

## Outputs

- **Accepted:** The platform produces validated research/backtest results that can be inspected and compared.
- **Proposed:** Outputs include reproducibility metadata, experiment configurations, versioned artifacts, generated orders/fills, portfolio/accounting state, PnL, validation findings, and human-readable reports.
- **Proposed:** Accepted research logic is promoted through an explicit reviewable path rather than copied informally.

## Major responsibilities

- **Accepted:** Provider adapters translate provider-specific data/semantics into the canonical model without leaking provider schemas into core consumers.
- **Accepted:** C++ validation/ordering preserves source sequencing semantics and establishes whether canonical data is safe for persistence/replay.
- **Accepted:** Canonical observations preserve market facts; derived state and lower-granularity views are produced by reducers/transformations.
- **Accepted:** `ReferenceHistory` provides point-in-time instrument metadata.
- **Accepted:** Lineage records transformed-data ancestry.
- **Accepted:** Market state and data-quality state are modeled separately and derived from their respective histories.
- **Accepted:** Dataset discovery/ingestion brings research data into the workflow.
- **Accepted:** Python research supports inspection, feature experimentation, strategy experimentation, and hypothesis development.
- **Accepted:** Features/indicators transform validated data into information used by strategies/analysis.
- **Accepted:** Strategies/signals express research logic that can lead to orders.
- **Accepted:** Orders represent intended actions before risk and execution outcomes.
- **Accepted:** Risk constrains intended actions according to the accepted Phase 1 scope.
- **Accepted:** Execution/fills model simulated outcomes at the accepted fidelity.
- **Accepted:** Portfolio/accounting maintains holdings, cash/equivalent balances, and state needed for PnL.
- **Accepted:** Validation/reporting tests, explains, and presents results.
- **Open question:** Precise responsibility allocation across C++, Python, and infrastructure remains to be designed.

## High-level flows

Core trading/backtest responsibility flow:

`Data -> Features/Indicators -> Strategy/Signals -> Orders -> Risk -> Execution/Fills -> Portfolio/Accounting -> PnL -> Validation/Reporting`

Canonical data flow:

`Provider -> Adapter -> Canonical Observations -> C++ Validation/Ordering -> Original Pool -> Reducers/Transformations -> Transformed Pool -> Storage/Access -> Consumers`

Research lifecycle:

`Dataset Discovery/Ingestion -> Validation/Normalization -> Interactive Python Research -> Feature/Strategy Experimentation -> Configuration/Reproducibility -> Experiment Tracking/Artifacts -> Result Validation -> Promotion -> Backtesting`

These describe responsibilities and information movement; they do not prescribe vectorized or event-driven processing everywhere.

## Explicit non-goals

- **Accepted:** Phase 1 is not defined as a standalone matching engine.
- **Accepted:** Phase 1 does not commit to a fixed "vectorized now, event-driven later" rule.
- **Accepted:** L3 support does not prematurely require a realistic exchange matching engine, latency model, networking stack, concurrency model, or low-level optimization.
- **Accepted:** This layer does not choose database, serialization format, project layout, build system, or concrete C++ APIs.
- **Accepted:** No production implementation is authorized by architecture documents alone without the next concrete type/implementation-design pass.

## Important open questions

- Exact canonical C++ type definitions and invariants.
- Provider port and Databento adapter contract.
- Storage/access/replay architecture and schema evolution.
- C++/Python responsibility boundary and research-logic promotion.
- Minimum execution/fill/cost/slippage/risk fidelity.
- Reproducibility and artifact requirements.
- Paper/live execution scope.
- CLion-compatible compiler/build/test/debug workflow.
