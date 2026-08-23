# Phase 1 System Context

- **Accepted:** This is a draft of the first architecture layer. It describes purpose, boundary, actors, inputs, outputs, responsibilities, flow, non-goals, and decision points without selecting detailed implementation mechanisms.
- **Accepted:** Every statement in this artifact is explicitly marked as Accepted, Proposed, or Open question so that draft interpretations are not mistaken for decisions.

## Phase 1 purpose

- **Accepted:** Phase 1 will be a small but complete research and backtesting system for the end-to-end path from market data through validated PnL and reporting.
- **Accepted:** Phase 1 will make research a first-class workflow: a researcher can discover and ingest data, validate and normalize it, investigate it interactively in Python, experiment with features and strategies, track experiments and artifacts, validate results, and promote accepted logic into backtesting.
- **Accepted:** Phase 1 must teach professional C++20, Python, quant-development, and software-architecture practices while producing credible portfolio and interview evidence.
- **Accepted:** Phase 1 must be structured for later evolution without importing Phase 2 complexity before it solves a demonstrated problem.

## System boundary

- **Proposed:** The Phase 1 platform boundary contains the software and documented workflow that discovers and ingests research data, validates and normalizes it, supports Python research, runs feature and strategy experiments, executes backtests, tracks configurations and artifacts, validates outcomes, and reports results.
- **Proposed:** Within that boundary, the backtesting path covers features/indicators, strategy/signals, orders, risk, execution/fills, portfolio/accounting, PnL, and validation/reporting.
- **Proposed:** Data providers, local data sources, the human researcher, and the interactive Python environment are external collaborators of the platform boundary rather than implementation details of this context layer.
- **Open question:** Whether paper or live trading, real-time data, and a real exchange connection belong in Phase 1 or remain outside the boundary must be decided before those concerns are designed.
- **Open question:** The boundary between the research workflow and the backtesting runtime, including the promotion path for accepted research logic, requires an explicit decision.

## Users and external actors

- **Accepted:** The primary user is the developer/researcher who explores data, defines experiments, evaluates results, and accepts or rejects research logic.
- **Proposed:** A data source or provider supplies datasets and any associated metadata used by discovery and ingestion.
- **Proposed:** An interactive Python environment lets the researcher inspect data and run feature or strategy experiments, then consumes tracked results and artifacts.
- **Proposed:** A reviewer or interviewer consumes selected documentation, validation evidence, experiment artifacts, and performance results as portfolio evidence.
- **Open question:** The first concrete data source, venue context, and external execution actor are not yet selected.

## Inputs

- **Accepted:** The platform receives data relevant to research and backtesting, researcher-authored research or strategy logic, and configuration needed to reproduce an experiment.
- **Proposed:** The platform also receives run-selection criteria, risk and execution assumptions, and the starting conditions needed to interpret portfolio and PnL results.
- **Open question:** The exact required inputs, including instrument metadata, corporate or contract events, fees, calendar rules, and initial portfolio conditions, depend on the initial Phase 1 scope.

## Outputs

- **Accepted:** The platform produces validated research and backtest results that can be inspected and compared.
- **Proposed:** Outputs include reproducibility metadata, experiment configurations, versioned artifacts, generated orders and fills, portfolio/accounting state, PnL, validation findings, and human-readable reports.
- **Proposed:** Accepted research logic is promoted through an explicit, reviewable path into the backtesting system rather than being copied informally.
- **Open question:** The required artifact formats, retention expectations, and acceptance criteria for promoting research logic are not yet decided.

## Major responsibilities

- **Accepted:** Dataset discovery and ingestion locate and bring research data into the platform workflow.
- **Accepted:** Validation and normalization establish whether data is usable and make its representation suitable for downstream work.
- **Accepted:** Interactive Python research supports inspection, feature experimentation, strategy experimentation, and hypothesis development.
- **Accepted:** Features and indicators transform validated data into information used by strategies and analysis.
- **Accepted:** Strategies and signals express research logic that can lead to orders.
- **Accepted:** Orders represent intended trading actions before risk and execution outcomes are applied.
- **Accepted:** Risk evaluates or constrains intended actions according to the accepted Phase 1 risk scope.
- **Accepted:** Execution and fills model how intended orders become simulated outcomes within the accepted Phase 1 fidelity.
- **Accepted:** Portfolio and accounting maintain holdings, cash or equivalent balances, and other state needed to calculate results.
- **Accepted:** PnL calculates performance from portfolio and accounting state.
- **Accepted:** Validation and reporting test, explain, and present research and backtest results.
- **Accepted:** Configuration, reproducibility, experiment tracking, artifact management, and promotion connect the research lifecycle to repeatable backtests.
- **Open question:** The allocation of these responsibilities across C++, Python, and infrastructure is not yet decided.

## High-level end-to-end flow

- **Accepted:** The core responsibility flow is `Data -> Features/Indicators -> Strategy/Signals -> Orders -> Risk -> Execution/Fills -> Portfolio/Accounting -> PnL -> Validation/Reporting`.
- **Accepted:** The broader research lifecycle includes `Dataset Discovery/Ingestion -> Validation/Normalization -> Interactive Python Research -> Feature/Strategy Experimentation -> Configuration/Reproducibility -> Experiment Tracking/Artifacts -> Result Validation -> Promotion of Accepted Logic -> Backtesting`.
- **Proposed:** The two flows share validated data and tracked configuration, with promotion serving as a controlled handoff from research into the backtesting path.
- **Accepted:** This flow describes responsibilities and information movement; it does not prescribe vectorized or event-driven processing.
- **Open question:** The precise handoff points, lifecycle states, and validation gates between research, promotion, and backtesting require a later design decision.

## Explicit non-goals

- **Accepted:** Phase 1 is not defined as only a standalone matching engine.
- **Accepted:** Phase 1 does not commit to a fixed "vectorized now, event-driven later" architecture.
- **Accepted:** Phase 1 does not prematurely require a realistic Eurex-style limit-order-book, exchange matching engine, latency model, networking stack, concurrency model, or low-level performance optimization.
- **Accepted:** This system-context artifact does not choose classes, libraries, databases, serialization formats, APIs, event types, directory structures, or detailed C++/Python interfaces.
- **Accepted:** No production implementation is authorized by this draft alone.
- **Open question:** Whether live or paper execution is a Phase 1 requirement remains outside the current commitment until explicitly decided.

## Important unknowns requiring a decision

- **Open question:** What single initial instrument or asset scope, venue context, historical period, and data granularity will make Phase 1 small enough to finish while still demonstrating the full workflow?
- **Open question:** What must be implemented in C++ for the first usable path, and what may remain in Python, including the representation and review process for promoted research logic?
- **Open question:** What execution and risk fidelity is sufficient for trustworthy Phase 1 results without importing Phase 2 microstructure complexity?
- **Open question:** What evidence makes a research result reproducible and eligible for promotion into backtesting?
- **Open question:** What CLion-compatible compiler, build, test, and debug workflow should be used once implementation design is accepted?
