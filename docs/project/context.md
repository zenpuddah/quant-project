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
- **Accepted:** The developer intends to use CLion; future tooling choices must remain compatible without assuming a build system yet.
- **Accepted:** Implementation should be idiomatic, concise, human-maintainable, and free of AI markers, unnecessary boilerplate, or artificial attribution.
- **Accepted:** The developer retains decision authority and implementation agency; significant trade-offs and changes must be presented for approval rather than silently decided by the assistant.
- **Accepted:** The assistant acts as a tool and collaborator, not an autonomous owner; repository creation, commits, pushes, architecture decisions, and other consequential actions require explicit authorization.

## Superseded ideas

- **Accepted:** A standalone matching engine is not the project definition or the whole portfolio.
- **Accepted:** "Vectorized Phase 1, event-driven Phase 2" is not a fixed architectural rule.
- **Accepted:** Python research is a first-class workflow, not an afterthought.
- **Accepted:** Concurrency, networking, and optimization are introduced only when a demonstrated problem justifies them.

## Accepted decisions

- **Accepted:** The first architecture artifact is a Phase 1 system-context draft, not a detailed component or implementation design.
- **Accepted:** Detailed classes, libraries, databases, serialization formats, APIs, event types, and directory structures remain undecided.

## Current repository state

- **Accepted:** The repository was empty at session start and contained no existing guidance, source, configuration, documentation, or Git metadata.
- **Accepted:** The initial documentation baseline now consists of this file, root `AGENTS.md`, and `docs/architecture/phase1-system-context.md`.
- **Accepted:** No production source code has been created.
- **Accepted:** A user-requested one-month Alpaca historical-data sample for `SPY`, `AAPL`, `MSFT`, and `AMZN` was acquired on 2026-08-23 under `data/raw/alpaca/`; the raw data is Git-ignored and no credentials were stored.
- **Accepted:** The acquisition uses Alpaca `1Day` bars with `feed=iex` and `adjustment=raw`; this operational choice does not establish the canonical Phase 1 data source or feed.
- **Accepted:** A local Git repository was initialized on `main` on 2026-08-23; the initial documentation baseline is committed locally, while no GitHub remote has been configured and no push has been performed.

## Current architecture task

- **Accepted:** The first Phase 1 system-context layer has been drafted and reviewed before moving to more detailed architecture.
- **Open question:** The system context must be refined after the initial Phase 1 scope and boundary decisions are answered.
- **Accepted:** The Alpaca acquisition was completed as a data-input exercise without designing the C++ model or changing the Phase 1 architecture boundary.

## Open questions

- **Open question:** What initial instrument or asset scope, venue context, historical period, and data granularity should define Phase 1?
- **Open question:** Whether the Alpaca IEX sample should become the canonical Phase 1 dataset remains undecided.
- **Open question:** Which responsibilities belong in C++ and which remain in Python during Phase 1, including how accepted research logic is promoted into backtesting?
- **Open question:** What minimum execution, fill, cost, slippage, and risk fidelity is required for Phase 1 correctness?
- **Open question:** What configuration, environment, input-data, result-validation, and artifact information must make an experiment reproducible?
- **Open question:** Is Phase 1 strictly historical research/backtesting, or must it include paper or live execution boundaries?
- **Open question:** Which CLion-compatible compiler, build, test, and debug workflow should be accepted when implementation begins?

## Next action

- **Open question:** Answer the initial Phase 1 instrument/data scope question first; use that answer to narrow the system boundary and then decide the C++/Python boundary.

## Last updated

- **Accepted:** 2026-08-23.
