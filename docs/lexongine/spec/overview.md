# Lexongine v1 scope and architecture

Lexongine combines computation requests into one prepared graph, shares eligible exact computations and executes their updates while preserving each consumer's observable behavior. Humans, agents and later optimization controllers can inspect and configure the same descriptions. Actual calculations retain meaningful scalar, series, matrix, model and state types; a universal row or numerical inheritance hierarchy is not required.

Sources deliver validated data under explicit contracts. Reducers derive bars/features and can consume reducers. Explicit adapters transform types or timing. Mathematical operations produce intermediate results. A composition declares dependencies, parameters and observation requests. Custom typed code remains possible when there is no useful common abstraction.

## Boundaries

| Owner | Responsibility |
| --- | --- |
| Lexongine | Description/registry, preparation, exact sharing, state advancement, immutable publication, resource accounting, reusable output artifacts and execution evidence |
| Qaedalus | Ingestion, adaptation, storage, query and checked replay; financial experiment/strategy, orders/fills/costs/risk/accounting/evaluation |
| Axthena | Evidence about news, events and actors, possibly future explicit research inputs |

Lexongine does not silently acquire data, aggregate trades into bars, invent fill models or implement a complete backtester to demonstrate the engine. The first milestone includes deterministic complete-bar calculations, runtime plugins, CLI/C++ API, source/host seams, independent tests and automatic valid result reuse.

## Preparation and execution

A composition describes a run; a PreparedPlan is its validated immutable blueprint; a RunInstance owns fresh cursor/state/slots. Preparation resolves plugins/types/configuration, validates the DAG and full required source scope, calculates startup/resources, rejects attributed incompatible requests, freezes logical order, performs exact interning, validates reusable artifacts and exports before/after graph evidence. Execution advances applicable updates and observes them under explicit request scopes. The graph and parameters do not change during that run.

Hashing is only candidate selection. Equality includes source identity/version/content, operation and actual implementation, parameters, ordered upstream computation history, types, initialization, actual scopes, timing/numerics/state/effect contracts. Unique effects cannot be deduplicated. No algebraic rewriting or globally optimal graph claim is made. Fewer nodes do not establish better performance.

Shared producer state advances once per applicable input update; consumer reads cannot advance it. Producer output is a complete immutable bundle. A failure stops the entire admitted run, preserving earlier partial evidence. Numerical completion, host completion, required evidence finalization, acceptance and cache publication are distinct outcomes.

## First acceptance experiment

The [XML example](../examples/first-computation.xml) generates 120 synthetic complete bars, extracts close prices, computes duplicated SMA20 requests, SMA50 and their difference. Six logical producers become five physical producers. Four observations each receive 71 values from key49; spread is raw150000000 (Price9, 0.15). A separate lag fixture produces 70 values from key50 with spread raw160000000. These fixtures establish engine semantics; they are not a complete strategy.

See [execution](execution.md), [components](components.md), [reuse](reuse.md), [resources/evidence](resources-evidence.md), [configuration](configuration.md) and [integration](qaedalus-integration.md) for the operative rules. The [decision ledger](../decisions.md) records why scope is settled and what remains deferred.
