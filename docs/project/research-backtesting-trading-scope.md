# Research, Backtesting, and Trading Study Scope

## Status

- **Accepted:** The near-term objective is an interview-grade demonstration of quantitative-finance and trading-domain reasoning, not a cutting-edge production trading platform.
- **Accepted:** Research/backtesting/trading work prioritizes explicit data flow, point-in-time correctness, costs and fills, state transitions, risk, PnL, validation, and reproducibility.
- **Accepted:** Transparent baselines are preferred: a small research loop, an explainable backtest, simple execution/cost assumptions, and one or two interpretable strategies.
- **Deferred:** Low-latency optimization, exchange matching simulation, distributed infrastructure, ML-heavy research, complex portfolio optimization, and live trading remain deferred until a concrete requirement justifies them.
- **Proposal:** The minimal implementation slice below is a study target, not an accepted production architecture. Review it before implementation.

## Purpose

Use the existing canonical market-data, ingestion, and storage/replay work to study the path from observed data to a research result and simulated trading outcome. Every layer should be explainable in an interview:

- which information was available at decision time;
- how a feature became a signal;
- how a signal became a target position and order;
- how an order became a fill under explicit assumptions;
- how fills changed positions, cash, exposure, and PnL;
- why a result may or may not generalize out of sample.

## Study Sequence

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

### 1. Research Workflow

Study the research loop before designing classes:

```text
question / hypothesis
        ↓
point-in-time dataset
        ↓
feature or transformation
        ↓
signal / target
        ↓
historical evaluation
        ↓
validation and interpretation
```

The first research examples should use interpretable features and simple baselines. A moving-average crossover or a basic mean-reversion rule is useful for learning the mechanics; it is not presented as evidence of alpha.

### 2. Backtest Mechanics

The backtester must make time and execution assumptions explicit:

- event or bar clock;
- information available at each decision point;
- strategy callback or decision function;
- order-intent generation;
- risk and sizing checks;
- fill model;
- fees, spread, and slippage;
- position and cash updates;
- mark-to-market equity and PnL;
- performance and diagnostic output.

If a signal uses the close of bar `t`, the default teaching assumption is execution at bar `t+1` unless same-bar execution is explicitly justified and modeled.

### 3. Trading-Domain Vocabulary

Keep these concepts distinct:

- **Signal:** a model observation or directional/score output.
- **Target position:** desired exposure after applying sizing rules.
- **Order intent:** requested change from the current position toward the target.
- **Order:** a trading instruction with lifecycle state and execution constraints.
- **Fill:** an actual executed quantity and price, including fees when applicable.
- **Position:** current inventory and average/realized cost state.
- **Portfolio:** positions, cash, valuation, exposure, and PnL.
- **Risk check:** a constraint applied before an order is accepted or simulated.

The minimum event flow is:

```text
market data
    -> feature
    -> signal
    -> target position
    -> order intent
    -> risk check
    -> order
    -> fill
    -> position / cash
    -> portfolio value / PnL
```

### 4. Validation and Metrics

Study both financial metrics and research failure modes:

- simple and log returns;
- cumulative return and equity curve;
- volatility and Sharpe ratio limitations;
- maximum drawdown and recovery;
- turnover, fees, spread, and slippage impact;
- exposure, leverage, and concentration;
- hit rate, payoff ratio, and trade distribution;
- look-ahead bias;
- survivorship and selection bias;
- data snooping and overfitting;
- train/validation/test separation and walk-forward evaluation.

Metrics are evidence about a specified experiment, not proof that a strategy will work in production.

## Minimal Implementation Target

The first implementation proposal is intentionally small:

- one interpretable strategy;
- one transparent research dataset interface;
- one deterministic event/bar backtest loop;
- one simple fill model with explicit fees and slippage;
- minimal order, fill, position, cash, portfolio, and risk types;
- deterministic performance and diagnostic report;
- at least one out-of-sample or walk-forward check.

The current MBO, Trades, OrderExecution, Arrow, Parquet, and replay work remains the data foundation. The first strategy does not need to consume raw MBO directly; a derived trade/bar view is acceptable when its construction and limitations are documented.

## Explicit Non-Goals

- exchange matching-engine simulation;
- nanosecond or low-latency optimization;
- distributed research infrastructure;
- generalized portfolio optimization;
- ML-heavy alpha research;
- live order routing;
- production broker/exchange integration;
- a large strategy library;
- a custom binary replay format before measurement.

## Open Decisions

- first strategy and market frequency;
- bar-based versus event-driven first backtest loop;
- minimal research dataset API;
- fill and cost model details;
- exact order lifecycle states;
- first portfolio/PnL accounting conventions.

These decisions should be made after the concepts above are studied and discussed. They are not silently fixed by this document.
