# Axthena V1 implementation plan

> **Status:** proposed execution plan for owner review, 15 October 2026. No production implementation has started. The owner-requested S0 20-article trial is already authorized; begin that bounded probe without another plan-approval question. Resolve the applicable decisions in `06-review-decisions-and-v2.md` and review the production specification/plan before later application implementation. Do not treat proposed technologies or defaults as previously accepted decisions.

**Immediate goal (ENG-048):** the first OpenCode task is a source trial of 20 articles. **Later V1 goal:** deliver a local C++ application for the bounded stock-information corpus, preserves evidence, prepares traceable records and supports useful stock/date queries and graph inspection for Nvidia and Microsoft.

**Architecture:** proposed single native application; one structured store; immutable evidence/model artifacts; separate collection, processing and reading; replaceable task/answer transport; explicit organisation identity and shared-meaning preparation. This is a conceptual graph regardless of backend.

**Tech stack:** C++ is accepted. The concrete candidate track below uses C++20, CMake/CTest, SQLite, nlohmann/json, libcurl, a separately approved local embedding package and an optional lossless codec. These choices are **unselected**. If Ladybug is selected instead, revise the storage/schema/query tasks before implementation; do not implement two backends.

**Specification:** `02-data-and-behaviour-specification.md`; accepted requirements and supersessions in `01-scope-and-decisions.md`; cases AT-01–AT-36 in `04-acceptance-and-test-plan.md`.

**Global constraints:** owner decides architecture; independent Axthena repository; local sequential workflow; retain exact evidence and failed attempts; no network/model side effects during reads; no automatic fact-conflict resolution; completed uncertain organisation resolution creates automatically; no quant integration, training, role classifier, simulator, active edit monitor or dedicated reason system.

**Review focus:** source/version time, confirmation scope, material conditions, actual retrieval versus fixtures, immutable history, idempotent partial retries, missing world records and automated-provider compatibility/throughput. A graph-shaped export is not evidence that the production system has these behaviours.

## 1. Milestones and dependency order

| Milestone | Tasks | Observable deliverable | Exit condition |
|---|---|---|---|
| M0 Source trial and reviewed contract | S0, then T0 | Signed-off specification, choices, frozen examples | No material V1 meaning silently unresolved |
| M1 Evidence and a useful first read | T1–T5 | One retained real report → automatically obtained model answer → validated stock/date evidence read | Passage, subject, qualification, date basis and trace survive restart |
| M2 Real identity and shared meaning | T6–T8 | Actual two-branch retrieval, automatic identity continuation, scoped world facts and grouping | Sequential reuse and damaging non-merges demonstrated |
| M3 Investigator workflow | T9–T10 | Full query catalogue, graph export and bounded real-source corpus | Owner reviews useful application outputs and coverage |
| M4 Release candidate | T11–T12 | Measured local performance, restore demonstration, packaged native application | Frozen acceptance packet passes; limits and missing coverage explicit |

M1 is intentionally incomplete. It may replay supplied identities while implementing the evidence path, but must be labelled `identity_fixture` until T6 runs both real retrieval branches. The twelve-month collection is not represented by fictional reports or by a handful of successful examples.

Each task should finish as one or a few reviewable commits. Keep documentation/tests alongside the implementation. Do not publish, merge or deploy merely because this document contains commit boundaries.

## 2. Proposed repository layout and interfaces

All paths below are **future repository-relative paths**, not files created by this handoff. The final repository location and target machine are not selected.

| Area | Exact proposed paths |
|---|---|
| Build/configuration | `CMakeLists.txt`, `CMakePresets.json`, `config/example.json`, `config/schema.json` |
| Domain and contracts | `include/axthena/domain/types.hpp`, `include/axthena/domain/time.hpp`, `schemas/task.json`, `schemas/answer.json`, `schemas/query-result.json` |
| Evidence/storage | `include/axthena/storage/store.hpp`, `src/storage/sqlite_store.cpp`, `src/storage/artifact_store.cpp`, `migrations/001_initial.sql` |
| Collection | `include/axthena/collection/source.hpp`, `src/collection/collector.cpp`, `src/collection/news_api_source.cpp` |
| Model exchange/validation | `include/axthena/model/task_exchange.hpp`, `src/model/opencode_transport.cpp`, `src/model/answer_validator.cpp`, `prompts/extract-v1.txt`, `prompts/resolve-organisation-v1.txt`, `prompts/compare-idea-v1.txt` |
| Resolution/retrieval | `src/retrieval/name_candidates.cpp`, `src/retrieval/vector_candidates.cpp`, `src/retrieval/candidate_union.cpp`, `src/resolution/organisation_resolver.cpp`, `src/grouping/idea_matcher.cpp` |
| Preparation/world | `src/processing/preparer.cpp`, `src/processing/publication.cpp`, `src/world/claims.cpp`, `src/world/confirmation.cpp`, `src/world/relationships.cpp` |
| Reads/export | `include/axthena/query/query_service.hpp`, `src/query/query_service.cpp`, `src/query/eligibility.cpp`, `src/export/graph_export.cpp`, `src/cli/main.cpp` |
| Tests and evidence | `tests/unit/`, `tests/integration/`, `tests/acceptance/`, `tests/fixtures/`, `benchmarks/`, `docs/decisions/`, `docs/runbook.md` |

The exact record definitions are completed at T0; these ownership boundaries avoid a generic framework. Proposed interfaces:

```text
SourceAdapter.fetch(CollectionRequest, Cursor) -> Result<SourcePage>
ArtifactStore.retain(bytes, metadata) -> Result<ArtifactRef>
TaskExchange.prepare(TaskEnvelope) -> Result<PendingTask>
TaskExchange.submit(TaskEnvelope) -> Result<AttemptId>
TaskExchange.await_result(AttemptId) -> Result<AnswerArtifact>
AnswerValidator.validate(TaskEnvelope, AnswerArtifact) -> ValidationReport
CandidateRetriever.retrieve(Mention, CatalogueVersion) -> CandidateBatch
OrganisationResolver.apply(ValidatedIdentityDecision, ApplyKey) -> IdentityResult
Preparer.apply(ValidatedOutput, ApplyKey) -> PreparationResult
Publication.publish(PreparedManifest) -> Result<RunId>
QueryService.read(QuerySpec, RunId, ViewVersion) -> QueryResult
```

`Result` denotes a typed success/error value, not a selected third-party type or C++23 requirement. Errors retain stage, reason and retryability. `CandidateBatch` records both branch outcomes, candidates and intersection. `ValidationReport` separates structural errors, evidence failures, semantic issues and valid components. `QueryResult` separates domain records from coverage/status/limits. Do not return raw pointers into a database row buffer.

## 3. Execution tasks

### S0 — First OpenCode task: 20-article source trial

**Owner-requested immediate task (ENG-048).** Begin this bounded source probe before a broad application build or full-year collection. It does not depend on choosing every database/library/detail in T0.

1. Inspect source access already available, beginning with the EODHD candidate or another explicitly configured source. Use a short recorded date interval and target 20 unique news articles relevant to Nvidia/Microsoft, including relevant surroundings where available. Keep the retained trial set capped at 20 articles. If access/text quality prevents reaching 20, report the actual count and reason rather than expanding scope or inventing content.
2. Retain actual response/body, source URL/ID, declared dates, collection time, text availability and request outcome. Aim for coverage of both targets; distinguish a provider's ticker tags from verified entity resolution. Do not fetch a year as part of this trial.
3. Establish one automated OpenCode-style model call using the configured provider; pin the observed runtime/model/configuration and capture requests/answers automatically. Start with one retained article, then process the retained set when that path works. No per-article copy/paste. No new paid source/model purchase is implied.
4. Deliver an inspectable article inventory and processing output with exact passages and visible gaps, plus a small graph/query review where the current contract supports it. Mark unresolved contract fields rather than silently narrowing the intended world model.
5. Review the 20-article result with Badr before enlarging the corpus. Use failures to inform T0/T3/T4; trial utilities remain clearly labelled, and application implementation follows the reviewed contract.

**Deliverable:** the bounded source trial and an evidence-based provider/automation recommendation. No full-year coverage, production retrieval or whole-model accuracy claim.

### T0 — Freeze decisions, exact formats and reference cases

**Depends on:** owner review of the six grouped decisions. Documentation only; do not build the application as part of this task.

**Create:** `docs/specification.md`, `docs/decisions/accepted.md`, `schemas/task.json`, `schemas/answer.json`, `schemas/query-result.json`, `tests/fixtures/reference-manifest.json` in the future repository after implementation is authorized.

1. Record D1–D6 outcomes in the required six-field form. Choose one backend and a concrete source pilot; record unresolved later-stage inputs without claiming readiness for those tasks.
2. Freeze common IDs, time precision/window boundaries, subject pairings, optional/absent values, confirmation policy, hold visibility, failure states and condition-preserving read envelope.
3. Define output records for Events, scoped Facts/Confirmations and dependencies; update instructions to cover G01–G06. Preserve current experimental artifacts unchanged.
4. Ask Badr to resolve HM03/HM13 and the chosen membership policy using paired examples. Freeze expected outcomes before the new trial.
5. Select the minimum real-source packet and a distinct held-out part. Name each metric and denominator; synthetic volume fixtures are not semantic accuracy references.

**Verification:** contract review maps each accepted invariant to at least one AT case; every proposed field has an owner decision or explicit pending status. No production pass claim.

**Deliverable:** one reviewed contract commit. Blocks all tasks whose semantics depend on the selected outcomes.

### T1 — Native foundation and target-machine conformance

**Depends on:** T0/D1.

**Create:** build/config files, `include/axthena/domain/types.hpp`, `include/axthena/domain/time.hpp`, `src/cli/main.cpp`, `tests/integration/platform_gate.cpp`.

1. Pin compatible tool/dependency versions for the chosen OS/architecture; document their licenses and build settings. Select a digest and ID implementation without custom cryptography.
2. Add typed identifiers, explicit missing values and configuration-version loading. Reject unknown required settings and invalid date/limit values with clear errors.
3. Build one native executable and the small test runner. Establish parameter binding, owned result values, restart persistence and read-only rejection for the selected store.
4. Add the agreed command structure and human-readable error output. No HTTP server or custom query language.

**Tests:** `platform_gate`, `configuration_contract`; wrong database path, dangling references, malformed configuration and multirow lifetime cases. Relevant AT-34/35.

**Deliverable:** reproducible native build and recorded platform gate; no domain completeness claim.

### T2 — Exact evidence, durable records and processing ledger

**Depends on:** T1.

**Create:** storage files, migration, `tests/integration/evidence_roundtrip.cpp`, `tests/integration/publication_recovery.cpp`.

1. Implement stable Report identity separately from content hashes and acquired snapshots.
2. Retain acquired bytes before extraction. Version text normalization and map exact spans to the retained material; handle repeated quotations without ambiguous offsets.
3. Store run/task/configuration provenance and separate operational status. Add a published-run manifest with immutable record-version selection.
4. Make record application idempotent. Reject missing/corrupt evidence references. Document file/database publication ordering and unfinished staging handling.
5. Implement backup/restore of the structured store **and every referenced artifact**. Codec selection can wait until T11; exact recovery cannot.

**Tests:** byte equality, quote resolution, same bytes/different reports, repeated ingestion, crash before and during publication, restore into a new directory. AT-01–09 and AT-34 as applicable.

**Deliverable:** retained evidence and restart-safe records, independent of an LLM.

### T3 — One configured source adapter

**Depends on:** T2 and D4 source selection.

**Create:** collection files, `tests/integration/collection_replay.cpp`, `tests/fixtures/source-pages/`, source configuration in `config/example.json`.

1. Implement one reviewed provider adapter: request scope, pagination, stable provider IDs, date fields and body acquisition. Retain source responses and extracted-body lineage.
2. Keep credentials outside evidence/logs. Record sanitized request metadata and material response provenance; do not discard evidence solely because processing will fail.
3. Distinguish successful empty scope, unavailable body, rate limit, partial pagination and failure. Retry only within explicit limits and preserve request outcomes.
4. Demonstrate repeat collection without publication duplication. Do not assume URL alone or content hash alone solves publication identity.

**Tests:** replay retained provider pages without network; missing body, duplicate page, partial failure and time-field ambiguity. Small real fetch is a separate integration check using the selected access path. AT-05–09/33.

**Deliverable:** real retained source packet plus coverage ledger. No unreviewed full-year purchase or crawl.

### T4 — Automated OpenCode-style LLM communication

**Depends on:** T2 and D3 transport contract.

**Create:** model exchange files/schemas, `tests/unit/task_validation.cpp`, `tests/integration/answer_import.cpp`.

1. Export a self-contained, versioned request packet with evidence, task ID, required schema and applicable instructions. Treat article text as untrusted data, not application instructions.
2. Submit and receive automatically through a pinned OpenCode-style provider adapter. Retain the actual request, raw response/events, completed answer and task/attempt correlation without human exchange. Unknown model version/token/cost information stays unknown.
3. Keep pending, completed, refused, malformed, truncated, failed and uncertain outcomes distinct. An incomplete JSON container is not automatically a valid partial result.
4. Validate IDs, enum values, references and exact quotations before domain application. Keep short grounded explanations; do not claim access to private model reasoning.
5. Replay stored answers without contacting ChatGPT. A different answer or prompt creates a new attempt/version.

**Tests:** automatic submission/capture without per-article human exchange, raw-event versus completed-answer distinction, fresh-session isolation, wrong task, unknown candidate ID, fabricated passage, prompt-injection text, repeated completion/application, changed source hash, malformed response, refusal/timeout and no-response states. AT-01/02/07/09/36 plus the explicit transport cases in the architecture document.

**Deliverable:** automated transport boundary demonstrated with the available configured account/model. Replaying files is a diagnostic capability, not the operating workflow. A paid API or browser automation is not assumed.

### T5 — First evidence-to-query slice

**Depends on:** T3/T4 and frozen basic extraction contract.

**Create:** `src/processing/preparer.cpp`, extraction prompt, minimal query service, `tests/acceptance/first_stock_read.cpp`.

1. Extract at most two separately articulated Ideas, Expressions and supported UP/DOWN judgments, with paired organisation/domain subjects and passages.
2. Preserve quotation exclusions, qualitative/missing horizons, inferred/configured provenance and material conditions. No business-growth-to-UP shortcut.
3. Retain available Person/account attribution, optional weak/moderate/strong Expression agreement with its evidence, and supplied global PersonWeight versions with status, origin and time. Preserve missing/dummy distinctions; implement no scoring/training algorithm.
4. Make one successful Idea readable when another fails. Keep deliberate cap selection distinct from failure.
5. Return one stock/date result with the exact source, summary, judgment/window/qualification and collection/processing coverage. Assert that reading triggers no external call.

**Tests:** profits-only, conditional UP, two independently developed Ideas, joint two-stock Idea, no forecast, missing period, one-of-two failure and repeated import. AT-22 specifically tests strong agreement with DOWN versus weak agreement on another Expression, missing/excluded not zero, domain-independent supplied weights and a later dummy-vector revision preserving old values. AT-06/17–23/25. Use explicit fixture identity labels until T6.

**Deliverable:** first inspectable native vertical slice. Badr reviews one real-source example before expanding the implementation.

### T6 — Real organisation identity retrieval and application

**Depends on:** T4/T5 and D3 embedding selection/parity gate.

**Create:** retrieval/resolution files, `tests/unit/candidate_union.cpp`, `tests/integration/organisation_resolution.cpp`, embedding manifest under `config/`.

1. Run actual normalized-name/alias retrieval and actual vector retrieval separately. Pin encoder/tokenizer/pooling/normalization and record language support.
2. Verify a reference embedding packet against the approved package with a declared tolerance. Benchmark retrieval recall on owner-reviewed aliases/near names, not just downstream AI answers.
3. Build the deduplicated union and retain both ranks/scores/sets/intersection. Pass full context to AI for the identity decision.
4. Apply reuse or automatic creation, including completed uncertainty. A failed branch/transport/invalid candidate decision cannot be mistaken for no-match.
5. Make each new organisation searchable by the next mention; retrying the same applied decision reuses its ID. Preserve alias/identity version history.

**Tests:** lexical-only and vector-only candidates both survive; case variants; parent versus subsidiary; same-name limitation; no-match; completed uncertainty; failed retrieval; next-item reuse; duplicate application. AT-10–12.

**Deliverable:** measured real retrieval and sequential resolution. Supplied candidate fixtures alone cannot pass this milestone.

### T7 — Scoped world records, confirmation and holds

**Depends on:** T5/T6 and D2 full-world contract.

**Create:** world files, `tests/acceptance/world_scope.cpp`, `tests/acceptance/confirmation_history.cpp`.

1. Add supported stock/issuer/group links, organisation activities, broad resources/processes/dependencies and direct Idea subject links.
2. Extract separate Event records where supported, preserving announcement versus occurrence and source-claim versus confirmed-fact distinctions.
3. Apply the approved external confirmation policy to the precise claim. Preserve authority/process evidence, disagreement and time.
4. Implement on-hold personal resolution and historical reads of the pre-resolution state. No model chooses a winner automatically.
5. Keep potential relevance distinct from realised business effect; no unsupported geographical/supply premise is invented.

**Tests:** shared domain without shared supplier, subsidiary-only subject, announcement versus production, earthquake without confirmed factory damage, confidential-source news, scoped confirmation and dated conflict resolution. AT-24–31.

**Deliverable:** the missing world concepts become queryable structured data, not only prose classification.

### T8 — Creation-time shared meaning and spread

**Depends on:** T6/T7 and D3 grouping boundary.

**Create:** grouping file/prompt, `tests/integration/idea_membership.cpp`, `tests/acceptance/spread_counts.cpp`.

1. First-filter by any shared organisation ID; preserve missing-subject failure rather than invent empty overlap.
2. Apply the selected cheaper similarity stage and LLM comparison over complete claims, actual windows, roles and conditions.
3. Reuse an Idea only under the approved membership rule; keep distinct Expressions and evidence. Store membership decisions and versions.
4. Count distinct reports/expressions under named definitions. Multiple passages or paths do not multiply publications; known copies do not become independent confirmations.

**Tests:** paraphrase reuse; same direction/different reason; opposite direction; different actual period; changed condition; A≈B≈C non-transitivity; insertion order; later membership change; duplicated joins. AT-13–16/20.

**Deliverable:** an actual merged-meaning example with complete source trace and a near-match that remains separate.

### T9 — Read contracts, views and graph export

**Depends on:** T7/T8 and D2/D5 query/time contracts.

**Create:** complete query/eligibility/export files, `tests/acceptance/query_catalogue.cpp`, `tests/acceptance/historical_cutoffs.cpp`.

1. Implement Q1–Q7 with parameterized reads and explicit run/view selection. Q1 includes the accepted direct opinion view over a configured market/universe using prepared subject associations, without discovering opinions through subsidiary traversal. Preserve source/cutoff/grouping-run selection and distinct publication counts. Keep data separate from operational coverage; physical index choice is proposed.
2. Enforce supported source-version cutoffs on every substantive support input, dependency premise and confirmation. In labelled retrospective mode, allow a new membership computed only from eligible old inputs under a pinned run; retain its true creation time and do not universally filter it by `created_at <= source_cutoff`. Do not admit later substantive evidence through the membership. Reject unsupported operational replay claims.
3. Bound dependency depth, expansion work, time and returned paths as selected. Expose truncation and missing premises.
4. Preserve qualifications in program output; pair views retain per-stock judgments without inferring pair trades.
5. Export deterministic graph JSON/Cypher from validated records, with escaping and stable IDs. Add company/subsidiary/UP/DOWN display conventions without mutating business meaning.

**Tests:** all query reference results, direct universe opinions without subsidiary traversal, source-first Monday/Wednesday case, corrected content uncertainty, later confirmation and grouping, external-view conflicts, zero external calls, coverage-empty distinctions, path cycles and limits. AT-02–04/16/19/24–32/35.

**Deliverable:** useful native reads plus owner-reviewable graph. Export load/rerun claims require actual execution in the named graph engine.

### T10 — Later corpus expansion after the 20-article trial

**Depends on:** T9 and D4 corpus/access decisions.

**Create:** `docs/source-pilot.md`, `docs/corpus-manifest.md`, `tests/fixtures/real-reference/` where retention permits.

1. Reuse and review the owner-requested 20-article S0 trial; do not quietly replace it with a 20–50 article acquisition. Expand only after the source/processing findings are reviewed.
2. Badr reviews meanings, subjects, passages and useful queries. Preserve raw first responses and errors before scoring; keep the held-out portion separate.
3. Measure automatic submission/completion/retry behavior, provider limits, native processing time and source-body coverage. Confirm that the integration fits the intended later volume.
4. A full twelve-month collection is later work, requiring a separate source/access/cost and scope decision after the 20-article trial. Publish actual downloaded and processed coverage separately, including gaps and failed work.
5. Keep downloaded coverage and successfully processed coverage separate. Provider failure/limit handling must not fabricate completed output or silently grow the trial.

**Tests:** AT-33/36; real-source evidence quality and missing-version uncertainty, plus selected semantic contrasts. No predictive-performance conclusion.

**Deliverable:** transparent corpus coverage and reviewed real outputs; evidence of feasibility, not an exaggerated accuracy benchmark.

### T11 — Performance, compression and recovery

**Depends on:** T9/T10 and D5 frozen workload/targets.

**Create:** `benchmarks/query_workload.cpp`, `benchmarks/retrieval_workload.cpp`, `docs/benchmark-results.md`, complete `docs/runbook.md`.

1. Freeze hardware, corpus scale, query mixes, cold/warm protocol, memory/disk limits and success thresholds before measuring.
2. Measure acquisition, native preparation, embedding, model waiting and stored reads separately. Report latency distributions, throughput, peak memory and bytes with denominators.
3. Add only optimizations addressing a measured bottleneck: indexes/materialized subject lookups, prepared queries, lossless artifact compression or a vector index. Recheck result equality and evidence recovery after each.
4. Demonstrate restart, interruption and full restore on the target machine. Check missing/corrupt artifacts and historical manifests.

**Tests:** AT-34/35 plus retrieval recall and exact output comparisons. Compression ratio is measured; lossless round-trip is required. ANN/custom graph engine/compiler work is not automatic scope.

**Deliverable:** measured engineering report, bounded limitations and reproducible recovery procedure.

### T12 — Final acceptance and release documentation

**Depends on:** all required earlier gates.

**Create/update:** `README.md`, `docs/runbook.md`, `docs/acceptance-report.md`, `docs/decisions/accepted.md`, native package/build instructions.

1. Run the frozen accepted suite on the release candidate, including meaningful negative cases and real-source samples.
2. Review the investigator queries with Badr; record acceptance or remaining material failures.
3. Verify the package can rebuild, restore its data and reproduce retained query outputs. List exact dependency/prompt/model/configuration versions and unknown external metadata.
4. State what the application does, what was measured, corpus gaps and deferred work. Do not claim alpha, novelty or statistical reliability from the synthetic trial.

**Deliverable:** reviewed local V1 candidate. Integration with Qaedalus/Lexongine is a later separately specified project boundary.

## 4. Planned verification commands

These are **future commands**, not executed tests. T1 must implement the presets/test names before using them. Run from the selected repository root:

```sh
cmake --preset dev
cmake --build --preset dev
ctest --preset dev --output-on-failure --no-tests=error
```

For a task, run its focused registered test rather than repeatedly rerunning unrelated expensive checks, for example:

```sh
ctest --test-dir build/dev -R '^candidate_union$' --output-on-failure --no-tests=error
ctest --test-dir build/dev -R '^historical_cutoffs$' --output-on-failure --no-tests=error
ctest --test-dir build/dev -R '^publication_recovery$' --output-on-failure --no-tests=error
```

Expected result: the named test exists and passes the frozen assertions. An empty test selection is failure, not success. Real-provider/model exercises are explicit integration runs; deterministic tests replay retained artifacts. Never silently replace a failed real integration check with a fixture-only check.

## 5. Plan review and stopping rules

- Stop a dependent task for an unresolved **meaning or owner architecture choice**; continue independent authorized work. Routine file naming/build details within an accepted bundle do not require repeated permission.
- Do not mark a feature complete from a projected graph, supplied candidates or an output whose reference was changed after scoring.
- A test failure requires correcting behaviour or recording an explicit scope decision, not weakening an accepted invariant.
- Complete one reviewed implementation pass. Findings may require local corrections; they do not justify reopening the entire discovery process.
- At review, verify every AT family maps to a task, every task has a deliverable and the final accepted spec supersedes this draft clearly.

No effort estimate or performance promise is invented here. The dominant unknowns are source quality, complete-world extraction, embedding integration and automated-provider compatibility/throughput. The first real slice and frozen contract resolve those before a broad build becomes expensive.
