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

**Numerical helper checkpoint:** The canonical-Price SMA/lag/difference and Bar
fixture slice now has 6 focused cases and an independent Python Fraction oracle.
All four currently defined core/numerical CTest targets pass strict and sanitized
builds. This verifies arithmetic and generated fields, not registered component
scheduling, source validation, graph/cache behavior or host acceptance. Task 7
remains InProgress pending those integrations; graph work can proceed independently.

**Graph and reader-prototype checkpoint:** The owner approved including the
implementation selector in recursive operation identity. Product graph/identity
and logical-walk tests now pass (8 cases; all 5 current CTest targets pass strict
and sanitized). Direct actual-reader prototype verification also passes with the
cached official Arrow 25 static libraries, separate from native CONFIG/full
adapter/persisted-source checks, which remain unverified. The graph work does not
attest supplied source facts or complete the run lifecycle.

**XML checkpoint:** The pinned TinyXML2 11.0.0 frontend and owned registry-schema
resolution pass 8 focused cases. The six current CTest targets pass normal and
sanitized configurations. Declaration/encoding and policy-acceptance regressions
were observed failing before their fixes. This is configuration evidence, not
source admission or execution; CLI/projection integration remains pending.

**Resume:** Clean checkpoint `24557020537e2935f37fc0ec08a8d96614df31fa` confirmed.
Lifetime hardening now passes 9 cases in strict and sanitizer builds, including
exclusive transfer, temporal extent, bounded history and staged-failure cleanup.
Proceeding into the accepted native plugin mechanism; task/milestone closure is
still governed by the full progress matrix.

**Native plugin checkpoint:** Task 3's bounded macOS same-build mechanism is now
verified: 4 native cases cover bootstrap, registry rollback, exact RTTI, content
identity, limits and externally retained typed output lifetime. Strict and
sanitized full suites pass 7/7 targets. The owner accepted hashing application
dependencies while recording/trusting the Apple shared-cache/delayed platform
boundary. Broader source/run/cache/CLI acceptance remains pending.

**Native prerequisites recovered:** Approved Homebrew provisioning completed at
Arrow/Parquet 26.0.0. Current Lexongine suites pass 9/9 targets normally and with
project sanitizers, now including native CONFIG/shared-library reader-prototype
verification. The existing storage suite passes 4/4 normally. Preparation coverage
and history helpers pass four focused cases; the full source service/adapter and
execution/reuse/CLI integration remain pending. Historical blocked entries above
describe their earlier checkpoints.

## Deferred work

Concurrency, dynamic run reconfiguration, algebraic equivalence, richer joins/alignments, checkpoint continuation, general outcome-aware branching, stronger plugin isolation, mutable outputs, stronger crash durability, real session/filling policies, numerical/performance upgrades, interactive visualization/breakpoints and ML feedback protocols remain future work. Explicit fixed-count lag and automatic validated cross-run reuse are already v1, not deferred.

## Repository publication — 2026-10-15

The owner authorized publishing this context and its linked implementation handoff. They are published together on `implementation/lexongine-v1`, based on the inspected f75 baseline. This documentation publication does not implement the engine or change main. OpenCode should use this branch as its starting point, record the actual checked-out HEAD and preserve local work before implementation.
