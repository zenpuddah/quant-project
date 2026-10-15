# Axthena — implementation handoff

**Repository edition:** this packet was imported into the separate Axthena branch. Read `../START_HERE.md` first; it supersedes old repository-location wording. A few historical source copies omit private-note links and non-technical study framing, recorded in `repository-adaptations.json`. Original source hashes are in `manifest-original.json` and `source-inventory-original.json`; original experiments are unchanged. The current `manifest.json` describes this repository edition.

Compiled 15 October 2026, after Badr's positive graph review. Latest accepted corrections: automated OpenCode-style LLM communication (ENG-047) and a first source trial of 20 articles (ENG-048). Read `../START_HERE.md` and the latest supplement first.

**The discovery history is now consolidated into a reviewable implementation handoff.** This packet preserves the accepted model, later changes, proposed technical design, behaviours, tests and ordered implementation tasks. Production code has not started. Badr retains the final architecture decisions.

**Active execution plan (ENG-049):** [`../implementation/v1-slices.md`](../implementation/v1-slices.md), with an owner checkpoint after each of seven slices. The older 13-task plan below is supporting detail.

## Start here

1. [Review decisions and V2 boundaries](06-review-decisions-and-v2.md) — the six grouped choices/gates needed to turn the draft into an approved execution plan. No renewed general discovery checklist.
2. [Data and behaviour specification](02-data-and-behaviour-specification.md) — the current world model, extraction, identity, confirmation, time and query contracts; accepted meaning versus proposed representation.
3. [Implementation plan](05-implementation-plan.md) — five milestones and S0 plus T0–T12, with proposed file paths, interfaces, dependencies, tests and deliverables.

Supporting documents:

| Document | Purpose |
|---|---|
| [01 — Scope and decisions](01-scope-and-decisions.md) | Current requirements, every AX/ENG decision family, superseded rules and unresolved gaps |
| [03 — Architecture proposal](03-architecture-proposal.md) | Recommended small C++ track, alternative and primary technical documentation |
| [04 — Acceptance and test plan](04-acceptance-and-test-plan.md) | 36 scenario families; prior evidence separated from future production acceptance |
| [07 — Implementation-agent brief](07-implementation-agent-brief.md) | Portable instructions for a future implementation session |
| [08 — Research and artifact index](08-research-and-artifact-index.md) | Retained source documents, experiments, research and limits |
| [09 — Handoff review notes](09-handoff-review-notes.md) | Documentation checks, review fixes and remaining limitations |
| [Company-view guide](review/company-view.md) | Latest requested graph colours and explanation view |

## What is settled

Axthena is separate from Qaedalus/Lexongine. C++ is the main application language. V1 runs locally, downloads configured source material, retains original evidence, processes separately and queries prepared data. Nvidia and Microsoft are the primary targets; the source collection covers a selected continuous twelve-month interval with relevant suppliers, competition and broad dependencies.

Reports, source Expressions, shared Ideas, Events, Facts/Confirmations and inferred relationships remain distinguishable. Optional stock judgments are supported UP/DOWN claims with their period and qualifications. Original evidence, identities, available timestamps and processing history remain traceable. Person vectors may carry available labelled dummy values; predictive training and empirical scoring are outside V1.

Name and vector retrieval produce separate organisation candidate lists; their union goes to AI. A completed decision selecting no existing organisation creates automatically, including uncertainty. A retrieval/model failure is not a completed no-match. Shared meaning retains every source expression.

## What changed in consolidation

| Older wording | Current rule |
|---|---|
| Strictly one Idea per article | At most two separately developed, most articulated Ideas |
| Collection date alone controls historical inclusion | Seek supported availability of the exact source information; retain actual collection/processing separately |
| Uncertain organisation identity waits for review | Completed no-selection creates automatically; only qualifying fact conflicts require personal resolution |
| Whole report must succeed | Valid partial results are readable, with incomplete work visible |
| Actor-role categories | Excluded from V1; available person weights are separate dimensions |
| Dedicated reasons/thought-process model | Deferred; material reasons/conditions stay in summary/evidence and meaning comparisons |
| Old plan starts without embeddings | Actual name/vector union remains a V1 requirement; fixtures only test plumbing |
| Graph display implies selected backend | Cypher/Neo4j is a review surface; production store remains unselected |
| Reviewed extraction is the whole world model | Explicit Event, Fact/Confirmation and dependency extraction still needs its final contract |

The new architecture recommendation is a single C++ application with SQLite structured records, immutable evidence files, a small read surface and graph export; Ladybug is an alternative. This is **advice**, not an accepted change. Model transport is automated, patterned after OpenCode; a pinned headless-runtime adapter is the current recommendation. Retained packets are written automatically. A numeric embedding pipeline and later full-year feasibility still need evidence.

## How to interpret this packet

- **Accepted decisions:** the current decision map and full six-field context records.
- **Proposals:** exact schemas, technology bundle, interface names, defaults, limits and implementation tasks awaiting review.
- **Observed evidence:** retained fictional experiments and offline graph checks, with their original limits.
- **Pending tests:** production acceptance cases and real-source/performance/recovery gates. They have not run.

`sources/` contains updated full project contexts, preserved pre-handoff snapshots, dated research and original experiment archives. Historical files retain then-current wording; later decisions and this handoff take precedence. `manifest.json` records hashes and sizes for package integrity. No original experimental input, output or score was rewritten.

The next step is review of the concrete decision sheet and specification, then approval of the execution plan. It is not another open-ended discovery round.
