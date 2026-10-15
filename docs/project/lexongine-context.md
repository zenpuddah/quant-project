# Lexongine — current context

Last consolidated: 2026-10-14. Publication update: 2026-10-15. Owner: Badr; implementation agent: OpenCode; architectural decisions remain the owner's responsibility.

## Current task and evidence

The behavioral and bounded technical design rounds are closed for this milestone. Proceed through the [implementation handoff](../lexongine/README.md) and [plan](../lexongine/implementation/plan.md). No repeated baseline/cache/gap questionnaire is required. Routine researched implementation choices are delegated; major deviations must be surfaced.

The advisor inspected all 25 repository Markdown files and relevant data/replay headers at remote `implementation/data-integrity-2026-10-03`, commit `f75cd3c179f3b070f9a85c054ec3704b89f4cb69`. Remote main was `95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5`. These were remote evidence snapshots, not a local checkout. No Lexongine product implementation or macOS build was verified. No owner-local/unpushed files were available to the advisor. Preserve and reconcile them in the actual checkout before coding.

The owner accepted an isolated `implementation/lexongine-v1` baseline from f75. Qaedalus integrity remains published on its separate branch and unmerged in the inspected main. Do not merge it into main as a side effect of this task. Record actual HEAD, dirty status and divergence in [progress](../lexongine/implementation/progress.md).

## Settled scope

- Fixed graph and parameters per run; synchronous execution; immutable published values; typed numerical implementations with inspectable descriptions.
- Exact eligible sharing by candidate hash plus full ordered semantic equality. Once per applicable producer update; observations and actions retain their own logical boundaries. Equal numerical values do not erase updates.
- Explicit history, readiness, complete-bar status, causal availability, Strict/Skip missing-interval policy and numerical policy. No hidden inputs, parameter defaults, adapters or cross-acquisition ordering.
- Automatic validated exact-full-scope output reuse across runs in v1, including whole ordered transitive lineage. Saved outputs do not restore working state. Fresh continuation reconstructs required input history.
- Trusted same-build runtime plugins; macOS first; explicit preparation, bounded resources and required structured evidence; whole admitted-run fail-stop.
- Checked Qaedalus replay adapter and a host-driven single-update API are included seams. The synthetic complete-bar fixture is generated locally. Real bar construction and financial simulation models remain separate Qaedalus work.

Use the [decision ledger](../lexongine/decisions.md) for accepted/delegated/deferred distinctions and the specifications for precise mechanics. Lexongine is a building block of backtesting. Qaedalus owns strategy decisions, risk, orders, fills, costs, cash, positions, valuation and PnL. Axthena owns information evidence.

## Current implementation status

All twelve product tasks start Pending in this handoff. Research arithmetic/graph probes are supporting design evidence, not product tests. OpenCode must update progress after meaningful checkpoints with exact commands, results, limitations and commit IDs; do not rewrite historical test transcripts as fresh evidence.

**Implementation checkpoint — 2026-10-15:** The published owner handoff has been
reconciled with the local baseline record in the isolated worktree. Tasks 1–2 are
InProgress: initial owned/typed contracts and publication/lifetime primitives have
two passing strict and sanitizer CTest targets. This is partial foundation
evidence, not task closure. The owner authorized provisioning accepted build
dependencies; TinyXML2 11.0.0 is pinned locally, while native Arrow installation
is still pending network retries. See the progress record for exact commands,
the reproduced runtime failure/fix and remaining obligations.

**Subsequent checkpoint:** The owner selected a typed provenance envelope to close
the payload-only publication interface gap. Its initial typed binding/lifetime
checks pass with the reservation and scalar-copy regressions (8 contract + 7
lifetime cases, strict and ASan/UBSan). Native Arrow configuration still fails;
download retries were stopped and the reader prototype remains Blocked/Unverified.
Independent core work continues at the user's request. All milestone claims remain
bounded by the current progress evidence.

## Deferred work

Concurrency, dynamic run reconfiguration, algebraic equivalence, richer joins/alignments, checkpoint continuation, general outcome-aware branching, stronger plugin isolation, mutable outputs, stronger crash durability, real session/filling policies, numerical/performance upgrades, interactive visualization/breakpoints and ML feedback protocols remain future work. Explicit fixed-count lag and automatic validated cross-run reuse are already v1, not deferred.

## Repository publication — 2026-10-15

The owner authorized publishing this context and its linked implementation handoff. They are published together on `implementation/lexongine-v1`, based on the inspected f75 baseline. This documentation publication does not implement the engine or change main. OpenCode should use this branch as its starting point, record the actual checked-out HEAD and preserve local work before implementation.
