# Axthena — research and artifact index

**Repository edition:** this packet was imported into the separate Axthena branch. Read `../START_HERE.md` first; it supersedes old repository-location wording. A few historical source copies omit private-note links and non-technical study framing, recorded in `repository-adaptations.json`. Original source hashes are in `manifest-original.json` and `source-inventory-original.json`; original experiments are unchanged. The current `manifest.json` describes this repository edition.

Compiled 15 October 2026. This index makes prior work reusable without presenting dated proposals as current decisions.

## Precedence and evidence

1. Latest explicit owner decisions, recorded in the updated contexts through AX-054 and ENG-045.
2. Current handoff's decision map and specification, with every new mechanism labelled proposed until accepted.
3. Dated research, model reviews, prompts and experiments as supporting evidence, not automatic choices.

Two context snapshots were freshly retrieved in full before consolidation: business context version 56 (132,210 UTF-8 bytes) and engineering context version 37 (139,313 bytes). They are preserved under `sources/history/`. Updated contexts under `sources/` add the graph-review/planning milestone and display conventions, and distinguish the new advice from accepted decisions. `source-inventory.json` records source metadata and hashes.

## Main retained documents

All named files below are in `sources/` unless stated otherwise.

| File or group | Reusable contribution | Limit / current status |
|---|---|---|
| `Axthena-context.md`, `Axthena-engineering-context.md` | Full decisions in Decision / Reason / Invariant / Trade-offs / Implementation scope / Required tests form | Historical entries remain; apply explicit supersessions |
| `Axthena-model-review-2026-10-13.md`, `Axthena-second-review-2026-10-13.md` | Initial logical stress tests and progression into technical specification | Source-first availability was clarified later; do not restore collection-only eligibility |
| `Axthena-research-catalogue-2026-10-14.md` | Referenced open-source, graph, retrieval, systems/compiler and scientific-analogy research | Research directions, not evidence of Axthena novelty or a selected stack |
| `Axthena-three-round-design-review-2026-10-14.md` | Three iterative design critiques and proposed combinations | Preserve useful arguments; later owner decisions override suggestions |
| `Axthena-proposed-implementation-plan-2026-10-14.md` | Earlier implementation thinking | **Historical, superseded as an active plan by this handoff.** It predates later union, automatic creation, partial-result and ChatGPT-access decisions |
| `Axthena-model-lab.md`, load/queries and `Axthena-model-stress-review-2026-10-14.md` | Graph model tests and F-001–F-007 findings | Fixture defects and diagnostic counterexamples are not passing production tests |
| `Axthena-creation-time-opinion-grouping-research-2026-10-14.md` | Shared meaning, retrieval/indexing and creation-time grouping approaches | Task-specific semantic equivalence still needs Axthena reference cases; unrelated benchmark rankings do not decide it |
| `Axthena-opinion-grouping-benchmark-snapshot.json`, `Axthena-opinion-grouping-review-cases.json` | Dated benchmark context and reusable review contrasts | Preserve the snapshot date, task, dataset and caveats; do not claim a universal best method |
| `Axthena-extraction-research-2026-10-14.md`, `Axthena-extraction-reference-index-2026-10-14.json` | Grounded extraction practices, model/evaluation literature and source index | No production model/provider selected; historical prices/scores are not current offers or Axthena accuracy |
| `Axthena-LLM-boundary-proposal-2026-10-14.md` | Separating model communication from domain validation/application | Exact interface is a proposal; current experiment access is ChatGPT, not an assumed paid API |
| `Axthena-ChatGPT-trial-2026-10-15.md` and original ZIP | Three instruction variants on the initial small fictional packet | Supplied candidates/scaffolding; single responses; assistant-authored reference |
| `Axthena-hard-trial-results-2026-10-15.md` and original ZIP | Expanded 36-report fictional trial, raw answers, scorers, reviews and six unscored gaps | No real ingestion, retrieval, clustering, full-year coverage or predictive test |
| `Axthena-graph-review-guide-2026-10-15.md`, load/queries and original ZIP | Deterministic A-only graph projection, exact evidence, diagnostic trace | 373 nodes/715 edges are packet size, not scale evidence. Ideas are singleton per report; pair comparisons did not merge them |
| `review/company-view.cypher`, `review/company-view.md` | Latest company/subsidiary/stock/judgment explanation view and colours | New review helper preserved in this handoff; not executed against a live database here |

## Existing diagnostic evidence, precisely bounded

The hard trial retained 36 report outputs, 12 supplied identity decisions and 36 supplied meaning comparisons per variant A/B/C; each yielded 38 Ideas and 14 stock judgments. Exact quote counts were 42, 48 and 52 respectively. A later A-only order/side check reused the same 36 meanings. These results support the retained examples under their supplied assumptions. They are not representative accuracy estimates or a model ranking.

The graph package reconstructs the existing A outputs and retains source paragraphs, passages, metadata and run provenance. Offline checks establish projection fidelity, not Cypher runtime performance or production behaviour. The user subsequently expressed satisfaction with graph inspection. No evidence establishes that every supplied query, rerun or acceptance test was executed.

The current plan deliberately requires fresh contracts and tests for G01–G06, Event/Fact/Confirmation/dependency output, organisation-domain pairing, actual retrieval/creation, shared-Idea insertion, condition-preserving reads and source-version uncertainty. HM03/HM13 remain owner equivalence-boundary cases.

## New architecture documentation used in this handoff

The complete primary-source list S1–S15 is in `03-architecture-proposal.md`. It covers the official SQLite C/C++/foreign-key/transaction/backup/FTS5 documentation, Ladybug C++ APIs, libcurl, nlohmann/json, CTest, Zstandard, ONNX Runtime, Sentence Transformers' export caveats, an author model card and ONNX Runtime Extensions.

These sources establish documented capabilities and integration constraints. The recommendation of a small relational store plus explicit relationships is an engineering inference from Axthena's bounded local workload, not a result reported by those sources. No Axthena storage/retrieval benchmark has been run. The encoder remains a candidate; direct full-page retrieval of its large model card failed, while the author-hosted search-indexed material was inspected. No highest-benchmark claim is made.

The older scientific and compiler analogies are retained as inspiration. Do not implement speculative adaptation, a graph compiler or a custom database before an observed problem justifies the work.

## Reuse rules

Preserve existing raw experiments and their reference/score hashes. Add new prompts/contracts/runs under new versions. A revised expected answer cannot improve the score of an already executed experiment. Keep operational failure, insufficient source information and a genuinely wrong model decision separate.

The original archives retain their own internal checksums. The handoff manifest checks the archive bytes and current documents; it does not rerun their experiments or certify product correctness.
