# Decision ledger

Consolidated 2026-10-14. Owner-approved behavior and delegated routine engineering selections form the operative v1 package. This ledger records scope; detailed mechanics live in the linked specifications. Implementation/verification is separately recorded in [progress](implementation/progress.md).

| Status | Decision | Owning specification |
| --- | --- | --- |
| Owner accepted | Fixed composition/parameters per run, synchronous first | [Execution](spec/execution.md) |
| Owner accepted | Once per applicable input update; read-only consumers; equal values retain update/history identity | [Execution](spec/execution.md) |
| Owner accepted | Exact sharing, hash then equality, whole ordered upstream lineage; unique effects separate | [Reuse](spec/reuse.md) |
| Owner accepted | Full required validation, explicit startup/readiness, complete bars and causal point-in-time availability | [Execution](spec/execution.md) |
| Owner accepted | Explicit Strict/Skip gaps and positive fixed-count lag in v1; no implicit filling | [Execution](spec/execution.md) |
| Owner accepted | Immutable publication, planned bounded memory and separate retention diagnostics | [Resources/evidence](spec/resources-evidence.md) |
| Owner accepted | Failure stops the admitted run in v1; incompatible requests rejected before execution | [Execution](spec/execution.md) |
| Owner accepted | Automatic compatible cross-run output reuse in v1; continuation rebuilds state from history | [Reuse](spec/reuse.md) |
| Owner accepted | XML first, strong CLI and C++ API, before/after graph inspection, runtime plugins; macOS first | [Configuration](spec/configuration.md) |
| Owner accepted | Qaedalus canonical numerical types; explicit checked int64 SMA and ties-even policy | [Execution](spec/execution.md) |
| Owner accepted | f75 baseline, isolated Lexongine branch; preserve local context and existing domain code | [Plan](implementation/plan.md) |
| Delegated engineering selection | Logical Kahn order frozen before sharing; first-occurrence physical execution and later alias boundaries | [Execution](spec/execution.md) |
| Delegated engineering selection | Owned typed records, candidate/full equality, field-tagged encoding and strict versioned XML projections | [Components](spec/components.md), [configuration](spec/configuration.md) |
| Delegated engineering selection | Trusted same-build native plugin bootstrap, type witness and host-held destructor pins | [Components](spec/components.md) |
| Delegated engineering selection; cache mechanism owner accepted | Bounded local exact-full-scope store, lock/capacity policies and final acceptance marker | [Reuse](spec/reuse.md), [evidence](spec/resources-evidence.md) |
| Owner delegated integration | Bounded checked replay materialization and one shared advance_one/finish primitive for standalone/hosted runs | [Integration](spec/qaedalus-integration.md) |
| Routine clarification in this consolidation | PointTime/Interval tagged extent; explicit gap coverage codecs; actual-reader Arrow test prerequisite | [Components](spec/components.md), [configuration](spec/configuration.md), [integration](spec/qaedalus-integration.md) |

## Deferred beyond this milestone

Dynamic graph/parameter changes; concurrency; algebraic rewriting; partial-overlap result splice and state checkpoints; generalized joins/multirate clocks; arbitrary conditional/outcome-aware numerical graphs; mutability; hot reload/stable foreign ABI/sandboxing; distributed caches, auto eviction/repair and stronger crash durability; elapsed-time windows, real calendars/filling/reset policies; precision/performance upgrades across Qaedalus/Axthena; visualization and coordinated breakpoints; ML/fitting/data-split revisits; explicit portfolio feedback inputs.

Real complete-bar production and financial strategy/fill/cost/accounting models are separate Qaedalus design/implementation, not defaults for the Lexongine milestone. Advanced component examples test abstraction flexibility and do not commit v1 to implementing every example.

No numerical C++ inheritance hierarchy, universal row representation, hidden policy or globally optimal graph has been accepted. Future ideas are retained for investigation, not implementation authority.
