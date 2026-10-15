# Lexongine implementation handoff

Lexongine is the computation engine used by Qaedalus. The owner has accepted the bounded v1 direction and delegated routine engineering choices. This package prepares implementation; it does not claim an implemented engine or a complete financial backtester.

## Read order and authority

1. Read [AGENTS.md](../../AGENTS.md), [shared context](../project/context.md) and [Lexongine context](../project/lexongine-context.md). Preserve local and unpushed work.
2. Read [overview](spec/overview.md), then the six linked specifications below. These are the consolidated operative contracts.
3. Read the [decision ledger](decisions.md), [twelve-task plan](implementation/plan.md), [examples](examples/first-computation.xml) and [reference cases](examples/reference-cases.json).
4. Start from the [OpenCode prompt](implementation/opencode-start.md). Record actual results in [progress](implementation/progress.md).

| Specification | Owns |
| --- | --- |
| [Components](spec/components.md) | Owned records, typed callbacks, registry and source service |
| [Execution](spec/execution.md) | Schedule, state, history, causal timing, Strict/Skip, SMA and lag |
| [Reuse](spec/reuse.md) | Ordered transitive identity, artifact eligibility and local result store |
| [Resources and evidence](spec/resources-evidence.md) | Immutable ownership, quotas, diagnostics and final acceptance |
| [Configuration and codecs](spec/configuration.md) | XML vocabulary, deterministic identity encoding and artifact formats |
| [Qaedalus integration](spec/qaedalus-integration.md) | Checked replay adapter, Arrow boundary and host-driven execution |

Owner-approved behavior governs. These specifications consolidate the accepted conversation and delegated implementation details. The plan schedules them; examples illustrate them; [research](research/README.md) explains their origins. Dated discovery notes, old questionnaires and earlier narrow task gates do not override the current contract. If local context contains a newer owner decision, reconcile it visibly before dependent work. Major contradictions go to the owner in one focused batch; routine choices are recorded and executed.

## Folder discipline

Keep each rule in the specification that owns it. Cross-link rather than append a new competing contract. Update the decision ledger when scope changes, progress when verification changes, and the plan when tasks change. Research remains optional reading and cannot silently authorize features. Put product code under the proposed code paths in the plan; do not implement the engine inside documentation examples.
