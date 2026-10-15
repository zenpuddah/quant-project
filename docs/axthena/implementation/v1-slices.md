# Axthena first V1 — implementation plan with owner-reviewed slices

> **For agentic workers:** Execute one slice at a time. Use `superpowers:executing-plans` if available; optional subagents may investigate or review within the active slice. The owner's explicit instruction is to test each slice and obtain his confirmation before beginning the next. One launch prompt carries the full plan; it does not authorize running through the checkpoints unattended. Track steps with checkboxes and use `progress.md` to resume.

**Goal:** Deliver an inspectable first local C++ Axthena V1 candidate validated on the retained 20-article trial, with automatic LLM communication, preserved evidence, stable identities, shared meanings, the required stock-related world and useful queries.

**Architecture:** Separate collection, preparation and reads. Retain exact originals and versioned automatic model requests/responses; publish validated records with provenance. The logical graph remains organisations, people, events, claims, dependencies, views and observable stock judgments; ordinary reads use prepared data.

**Tech stack:** C++ is accepted; automated OpenCode-style model communication is accepted. Recommended implementation bundle remains C++20, CMake/CTest, SQLite plus immutable evidence files, nlohmann/json, libcurl and a tested local embedding package. A pinned headless OpenCode runtime is the recommended first model adapter. These concrete dependencies/backend/defaults require the applicable owner choice before production implementation; this plan does not claim they were already accepted.

**Spec:** `../handoff/02-data-and-behaviour-specification.md`, current accepted decision map, ENG-046–049 in `../repository-handoff.md`, and `../automated-llm-and-20-article-pilot.md`. The detailed AT-01–AT-36 matrix remains the acceptance reference. This plan supersedes the older S0/T0–T12 execution order for the first V1; it preserves its requirements rather than adding a second mandatory project.

## Global constraints

- Repository: `zenpuddah/quant-project`; branch: `implementation/axthena-v1`. Read the actual current branch and preserve user/concurrent changes.
- Primary targets: Nvidia and Microsoft, with broad relevant surroundings. The first live source trial targets 20 unique retained articles and is capped at 20; no year-scale acquisition in this execution.
- Use `projects/axthena/` as the proposed isolated component root; record it in the reviewed technical contract before production files. All code paths below start there. Trial utilities may precede the native foundation in a labelled `trials/` directory.
- Automatic model exchange; no per-article copy/paste. Existing account access is not an invented API credential or entitlement. Credentials stay with the configured client/provider and outside retained artifacts.
- Keep original evidence, supported time precision, immutable versions and operational status from the first slice; never bolt these on only at release.
- At most two separately developed, most articulated Ideas per article. Every source Expression survives grouping. Optional judgments are supported absolute stock UP/DOWN with periods and material qualifications.
- Keep stock/issuer/group/subsidiary/supplier and organisation/domain pairings distinct. Keep source assertions, scoped confirmations and model interpretations distinguishable.
- Completed uncertain organisation no-selection creates automatically; retrieval/model failure does not. Genuine confirmation conflicts require dated owner resolution.
- Person/account attribution, expression agreement and supplied global dummy-weight history are in V1; empirical scoring, training and domain-conditioned weights are not.
- No ordinary read triggers collection, embedding or generation. No simulator, live trading, actor-role classifier, dedicated reason graph, edit crawler or quant integration.
- The owner confirms each slice, not individual automated identity decisions or LLM calls. Tests passing, an assistant review, a commit, elapsed time or the agent's confidence do not substitute for that confirmation.

## Review focus

1. **Incomplete/duplicate source material:** preserve actual bodies and failures; publication identity is separate from byte identity. Owned by slices 1 and 3.
2. **Unicode or repeated passages:** declare exact locator units, retain original versions and reject fabricated/mislocated support. Owned by slices 2 and 3.
3. **Retrieval failure and uncertain identity:** both branch outcomes are explicit; uncertainty after completed comparison differs from failed work. Owned by slices 2 and 4.
4. **Conditions, scope and history lost in grouping:** same topic/direction/overlap never establishes full meaning; later evidence cannot become earlier support. Owned by slices 5–7, with provenance captured in slices 1–3.
5. **Retries/crashes inflating or replacing data:** repeated application is idempotent, completed runs remain usable and backup includes referenced evidence. Owned by slices 3, 6 and 7.

**Coverage limit:** this first candidate is validated on the 20-article pilot. The larger twelve-month target and AT-33 full-year coverage remain later acceptance work; no smaller sample silently satisfies them.

## 1. How this works with Badr

Give one concrete example before explaining a mechanism. For the active slice, explain the input, explicit state, invariant, state transition and observable output in a few lines. State what is observed, what is an assumption and what remains untested. Explain technical terms only when useful.

Keep attention on the current slice and its evidence. Avoid generic tutorials, repeating discovery, speculative optimisation and unrelated refactoring. Make it easy for the owner to challenge an invariant or inspect a counterexample. Preserve his corrections in decisions and tests; do not silently revise reference answers after scoring.

The project is intended to provide understandable C++ engineering/CV evidence: explicit ownership and failure handling, persistent provenance, meaningful tests, bounded queries and measured behaviour. Do not add infrastructure simply to name more technologies. Claims about novelty, statistical reliability or predictive usefulness need separate evidence.

## 2. Working paths and common interfaces

The plan specifies responsibilities and public seams, not a framework. Before implementing a slice, inspect actual files and reuse earlier types. Declare any necessary interface refinement in that slice's contract.

| Area | Proposed paths under `projects/axthena/` |
|---|---|
| Source trial | `trials/source_probe/`, `artifacts/pilot/` (local data, not automatically committed) |
| Native build | `CMakeLists.txt`, `CMakePresets.json`, `src/cli/main.cpp` |
| Domain | `include/axthena/domain/types.hpp`, `include/axthena/domain/time.hpp` |
| Evidence/persistence | `include/axthena/storage/store.hpp`, `src/storage/artifact_store.cpp`, `src/storage/sqlite_store.cpp`, `migrations/001_initial.sql` |
| Automated model transport | `include/axthena/model/task_exchange.hpp`, `src/model/opencode_transport.cpp`, `src/model/answer_validator.cpp`, `schemas/task.json`, `schemas/answer.json` |
| Collection | `include/axthena/collection/source.hpp`, `src/collection/news_api_source.cpp` |
| Identity | `src/retrieval/name_candidates.cpp`, `src/retrieval/vector_candidates.cpp`, `src/retrieval/candidate_union.cpp`, `src/resolution/organisation_resolver.cpp` |
| World and shared meaning | `src/world/relationships.cpp`, `src/world/confirmation.cpp`, `src/grouping/idea_matcher.cpp`, `src/processing/publication.cpp` |
| Reads/export | `include/axthena/query/query_service.hpp`, `src/query/eligibility.cpp`, `src/query/query_service.cpp`, `src/export/graph_export.cpp` |
| Checks | `tests/unit/`, `tests/integration/`, `tests/acceptance/`, `tests/fixtures/` |
| Owner review | `docs/axthena/implementation/reviews/slice-N/` at repository root; progress and decisions alongside this plan |

`ArtifactRef`, `TaskId`, `AttemptId`, `RunId`, `OrganisationId` and `ApplyKey` are distinct stable identifiers. `Result<T>` is a typed success/error contract, not a selected library or C++23 requirement. Define concrete fields in the reviewed schema, including explicit missing/error meanings.

```text
SourceAdapter.fetch(CollectionRequest, Cursor) -> Result<SourcePage>
ArtifactStore.retain(bytes, EvidenceMetadata) -> Result<ArtifactRef>
TaskExchange.submit(TaskEnvelope) -> Result<AttemptId>
TaskExchange.await_result(AttemptId) -> Result<AnswerArtifact>
AnswerValidator.validate(TaskEnvelope, AnswerArtifact) -> ValidationReport
CandidateRetriever.retrieve(Mention, CatalogueVersion) -> CandidateBatch
OrganisationResolver.apply(ValidatedIdentityDecision, ApplyKey) -> IdentityResult
Preparer.apply(ValidatedOutput, ApplyKey) -> PreparationResult
Publication.publish(PreparedManifest) -> Result<RunId>
QueryService.read(QuerySpec, RunId, ViewVersion) -> QueryResult
```

Slices 1–2 may demonstrate these logical boundaries with labelled trial utilities. Slice 3 establishes the native interfaces. A successful prototype is not automatically the final implementation.

## 3. Testing methodology for every slice

Use deterministic retained inputs for ordinary regression tests. Live source/model calls are explicit demonstrations and produce new immutable attempts; they are not repeated on every test run. Replay an old answer to test application logic; request a new answer only when evaluating a changed prompt/model or unresolved semantic issue.

For each meaningful guarantee, first write a small failing regression or frozen expected case, show the failure, implement the minimum behaviour, then show it passing. Prefer contrast pairs: one input that should work and a nearly identical one that should fail or remain separate. Do not add tests merely mirroring private implementation details.

Separate three kinds of evidence:

- **Mechanical:** schema, IDs, exact spans, timestamps, count units, application idempotence and persistence. These can be checked deterministically.
- **Semantic:** does the summary/identity/equivalence/confirmation preserve the source's meaning? Use a frozen reference with explicit accepted alternatives or owner review. Exact quote existence alone is insufficient.
- **Operational:** actual provider/model completion, unavailable text, rate limit, timeout and restart/restore. A fixture cannot prove that live integration works.

At each checkpoint, provide the real commands, actual outcomes and stable input/run/commit IDs. Name denominators precisely: reports, Ideas, stock judgments, passages, identity decisions and meaning comparisons are different units. Do not turn 20 articles into a general accuracy claim.

Native test commands are proposed and must be implemented as part of slice 3:

```sh
cmake --preset axthena-dev
cmake --build --preset axthena-dev
ctest --preset axthena-dev --output-on-failure --no-tests=error
```

Run from `projects/axthena/`. The build directory is `build/dev`. Focused slice commands below assume these registered CTest names. A missing selected test is an error; commands in this document have not run. For trial scripts, record their actual commands once chosen instead of pretending the future CTest suite already exists.

## 4. Slice sequence

### Slice 1 — Obtain and inspect the 20 source articles

**User outcome:** “I can see exactly which material Axthena collected and whether it is usable.” This is the first task, corresponding to accepted S0 acquisition. No broad application build is needed.

**Files:** create labelled utilities under `trials/source_probe/`; local `artifacts/pilot/collection-manifest.json` and exact response/body artifacts; review record `reviews/slice-1/README.md`. An actual source adapter may be factored into native code later.

**Interfaces:** consumes configured source access and a short date window; produces retained evidence plus a manifest usable by slices 2–3. Record Report/provider identity separately from content digest; include publication/collection clocks and unknown availability.

- [ ] Inspect actual provider access. EODHD is the first candidate, not a guaranteed entitlement. Select a short documented window and aim to cover Nvidia/Microsoft and relevant surroundings.
- [ ] Write replay checks for a duplicate provider item, repeated identical bytes from distinct publications, missing/truncated body, unsuccessful page and the 20-item cap.
- [ ] Run those checks against deliberately defective handling and verify they catch the defect; preserve expected outcomes.
- [ ] Collect at most 20 unique retained article bodies. Record actual counts and gaps; do not fabricate missing content, collect a year or silently enlarge the set.
- [ ] Inspect body fidelity/identity/date fields and run the replay checks. Keep request secrets out of metadata.
- [ ] Commit only appropriate utilities/configuration/docs and permitted small fixtures. Keep credentials and unapproved bulk source material out of Git; local artifacts remain persistent and referenced by hashes.
- [ ] Prepare review and pause.

**Expected checks:** requested=20; actual unique count ≤20; duplicate reprocessing does not inflate publications; acquisition failure differs from successful empty coverage; original bytes reconstruct; no missing source time is invented. AT-01/02/05/06/08/33 supply contrasts.

**Badr's demo:** an inventory with ID/source/date/body status/link; open three retained articles, including a troublesome one if present, against the collected text. Explain actual coverage of both stocks. If access blocks collection, report the specific missing access and partial work; do not claim the slice passed.

**Approval:** source usefulness and the retained sample. Tests plus owner confirmation are required before slice 2.

### Slice 2 — Automatic model execution and evidence-grounded output

**User outcome:** “A retained article goes through the model automatically, and I can inspect exactly why each result is present.” Keep requests/answers automatic.

**Files:** trial transport under `trials/model_probe/`; draft `schemas/task.json`, `schemas/answer.json` and versioned extraction instructions; transport/validator test fixtures; review record `reviews/slice-2/README.md`.

**Interfaces:** consumes slice 1 snapshots; produces `TaskEnvelope`, `AnswerArtifact`, `ValidationReport` and proposed typed output, preserving supplied mention strings before final organisation resolution.

- [ ] Pin the available OpenCode version/provider/model and inspect supported CLI or local `/doc` interface. Use its supported authentication; never copy token files into evidence. An unavailable account connection is a specific blocker, not a reason to revert to manual per-article exchange.
- [ ] Freeze one self-contained task and response schema using accepted rules; list unresolved schema/policy choices explicitly. Present any material new semantic default to Badr before relying on it. Keep the current reviewed prompt as a baseline, not immutable truth.
- [ ] Write cases for wrong task/candidate ID, fabricated and repeated spans, Chinese/emoji offsets, malformed/truncated output, provider refusal/timeout, source prompt injection and duplicate completion.
- [ ] Verify those cases fail under the corresponding deliberately broken validation/handling, then implement minimum capture/validation.
- [ ] Run one automatic request, then process the rest of the retained set once the path works. Preserve raw events and completed answer; CLI event JSON is not proof of valid extraction JSON. Use fresh extraction sessions and bounded capabilities.
- [ ] Validate max-two Ideas, exact passages, optional UP/DOWN, period origin, conditions, quote exclusion and readable partials. Missing direction is not insufficiency. Unknown values remain explicit.
- [ ] Compare retained first responses with the frozen expectations; inspect semantic support separately. Record every failure without repairing an answer before scoring.
- [ ] Prepare review and pause.

**Expected checks:** zero per-article copy/paste; exact task/attempt and source linkage; failed model calls never become facts or identity no-match; only validated components proceed; rerunning validators uses retained artifacts. AT-03–05/07/09/17–23/36 apply. A labelled dummy Person vector is not a measured score.

**Badr's demo:** side-by-side source → short summary → exact passages → subjects → stock judgment/window/condition. Include no-price-forecast, conditional forecast and partial/insufficient contrasts from the retained sample or clearly labelled existing fixtures. Show the actual automated call record.

**Approval:** extraction meaning, instruction/schema version and usable automation. Before slice 3, present the concrete C++/storage/interface bundle once for selection. Do not silently promote prior recommendations into accepted architecture.

### Slice 3 — Native evidence store and the first useful read

**User outcome:** “I can restart the C++ application, retrieve an article's result and trace it back to the same original.” Establish durable temporal/version foundations now.

**Entry:** slices 1–2 approved; applicable native/backend/format contract selected. Recommended bundle: isolated C++20/CMake/CTest component, SQLite and immutable artifact files, JSON CLI. Record the owner's actual choice.

**Files:** native build; `domain/types.hpp`, `domain/time.hpp`, storage files/migration, minimal `query_service.hpp/.cpp`, CLI; `tests/integration/evidence_store.cpp`, `tests/acceptance/first_read.cpp`.

**Interfaces:** implements `ArtifactStore.retain`, `Preparer.apply`, `Publication.publish` and minimal `QueryService.read`; consumes the retained slice 1–2 manifests and responses. Define owned native values, stable ID wrappers and typed failures; avoid exposing database row-buffer pointers.

- [ ] Freeze schema/version/span/absence and time-field contracts, with input-to-record examples. Add selected configuration versions and immutable run manifests. If an artifact compression codec is selected, record its version, prove exact decompression and reject an unsupported codec; an uncompressed baseline must be identified honestly.
- [ ] Write failing `evidence_store`/`first_read` tests: byte round-trip, Unicode/repeated spans, same bytes/different Reports, selected-codec round-trip/unknown-codec rejection, restart, malformed references, unknown schema, duplicate apply, valid one-of-two partial and interruption before publication.
- [ ] Add the isolated native build and minimal implementation. Enable/verifiably enforce referential integrity if SQLite is selected; preserve incomplete attempts as operational records.
- [ ] Import the same retained evidence and outputs without source/model calls. Keep actual publication/collection/processing times distinct.
- [ ] Implement one stock/date evidence CLI read including exact support, meaning, qualification and coverage. Assert zero external calls during the read.
- [ ] Run focused tests and a normal restart demo. A fresh inference is a new attempt; reapplying an identical completed attempt is idempotent.
- [ ] Prepare review and pause.

**Run:** `ctest --test-dir build/dev -R '^(evidence_store|first_read)$' --output-on-failure --no-tests=error`.

**Expected checks:** exact evidence recovered; one publication remains one after retry; invalid references/unknown formats do not publish; a failed pending write leaves the prior selected run usable. AT-01–09/19/34 apply. Replay is stored-output reuse, not a promised deterministic remote model.

**Badr's demo:** query one stock, open one returned passage, close/restart and repeat; process the same stored response again and show unchanged publication counts. Show an intentionally failed candidate remains inspectable without becoming clean domain data.

**Approval:** persistence, first-read behaviour and explanation. Timing foundations are required here even though full historical filtering is reviewed in slice 7.

### Slice 4 — Real organisation identity and the retrieval union

**User outcome:** “NovaChips/novachips can resolve to the same organisation, while subsidiaries and uncertain new identities remain traceable.” Real retrieval replaces supplied candidate scaffolding.

**Files:** name/vector candidate, union and resolver files; selected encoder manifest/configuration; `tests/unit/candidate_union.cpp`, `tests/integration/organisation_resolution.cpp`.

**Interfaces:** `CandidateRetriever.retrieve` returns branch-specific candidates/ranks/status and ID-deduplicated union; `OrganisationResolver.apply` consumes a validated AI selection and `ApplyKey`. New identities must be visible to the next mention.

- [ ] Select/pin the embedding package and tokenizer/pooling/normalization contract after the owner accepts the implementation bundle. The multilingual E5/ONNX proposal requires parity/name-retrieval tests, not a highest-benchmark claim.
- [ ] Freeze alias/near-name examples, including name-only, vector-only, overlap, parent/subsidiary, completed empty and failed retrieval cases. Record reviewed expected candidate/identity outcomes before executing the new test.
- [ ] Write failing `candidate_union` and `organisation_resolution` tests; verify they detect dropped branch candidates, wrong overlap and duplicate creation.
- [ ] Implement both actual branches. An exact scan is the proposed small-catalogue baseline. Proposed eight-per-branch limits remain configurable and need selection; do not silently shorten the union.
- [ ] Run AI final identity decisions automatically. Completed no-selection, including uncertainty, creates; failed retrieval/invalid response does not. Make creation application idempotent and index/catalogue updates visible sequentially.
- [ ] Measure candidate recall separately from AI decision results and show supplied original spelling/uncertainty. Retain person/account identity without inventing real-world anonymous identities.
- [ ] Prepare review and pause.

**Run:** `ctest --test-dir build/dev -R '^(candidate_union|organisation_resolution)$' --output-on-failure --no-tests=error`.

**Expected checks:** both unique branch candidates reach AI; intersection flag correct; failed branch is not no-match; uncertain completed decision creates exactly once; the next mention can reuse it. AT-10–13/16 apply. Same-name unrelated legal-entity disambiguation stays a declared V2 limit.

**Badr's demo:** inspect a mention, both shortlists, their union, the final decision and the reused/created organisation. Repeat the application; then process a later alias and show sequential reuse. Include a near-match that stays distinct.

**Approval:** identity semantics and actual retrieval behaviour, not just a visually tidy catalogue.

### Slice 5 — Complete the stock-related world and scoped confirmations

**User outcome:** “I can follow an article to the correct organisation/subsidiary/domain, event, dependency and precisely confirmed claim.”

**Files:** world relationship/confirmation files and typed schema refinements; `tests/acceptance/world_scope.cpp`, `tests/acceptance/confirmation_history.cpp`, `tests/acceptance/attribution_weights.cpp`; graph export begins here.

**Interfaces:** extends validated output/application with Event, scoped claim/confirmation, relationship support, paired organisation/activity subject and dated personal review. Preserve the earlier IDs/run/history contract.

- [ ] Review the full-world contract and a small explicit qualifying-authority/process configuration. Freeze hold visibility/resolution outcomes and source-grounded case expectations with Badr before applying a disputed policy.
- [ ] Write failing cases for direct subsidiary subjects, shared domain without shared suppliers, corporate membership versus supply, announcement versus production, earthquake without proven factory impact, confidential-source news and conflicting qualifying confirmations.
- [ ] Implement broad supported world records and their evidence. Potential relevance retains a complete dated dependency path; co-mention is not proof of dependency or price impact.
- [ ] Add attribution and expression-specific weak/moderate/strong agreement with support/absence reasons. Retain supplied global credibility/influence/predictive-record vector versions/status/origin; missing/dummy values are explicit and domain-independent. Do not implement empirical scoring.
- [ ] Implement dated owner resolution of holds without an automatic truth winner. Keep the historical hold/evidence recoverable.
- [ ] Run the focused cases and generate an inspectable graph projection with correct direct subjects. Current sample gaps use labelled retained synthetic contrasts, not invented real-world facts.
- [ ] Prepare review and pause.

**Run:** `ctest --test-dir build/dev -R '^(world_scope|confirmation_history|attribution_weights)$' --output-on-failure --no-tests=error`.

**Expected checks:** no Cartesian product of organisation/domain arrays; no dependency leakage between companies; confirmation scope/time does not spread to unrelated claims; strong DOWN agreement is strong agreement; later dummy weight/review does not overwrite its earlier version. AT-22/24–31 apply.

**Badr's demo:** company orange, subsidiary yellow, UP green, DOWN red; inspect the stock-linked judgment's explanation and source. Walk one real supported dependency when the retained sample contains one, plus one deliberately unsupported path. If the real sample has none, use a clearly labelled retained synthetic dependency contrast and report real-source dependency extraction as unverified; do not enlarge the sample or invent a relationship. Inspect an on-hold contrast with both confirmations and its dated resolution. Colour denotes the source forecast, not an observed return.

**Approval:** the connected world, scope/confirmation semantics and visible evidence. Structured Event/Fact/Confirmation/dependencies are required outputs, not silently replaced by summary text.

### Slice 6 — Shared meanings, separate expressions and honest spread counts

**User outcome:** “Two equivalent reports can point to one Idea, and I can still inspect each source and how strongly it expressed agreement.”

**Files:** `src/grouping/idea_matcher.cpp`, versioned comparison prompt, membership application; `tests/integration/idea_membership.cpp`, `tests/acceptance/spread_counts.cpp`.

**Interfaces:** consumes stable organisation/stock/domain IDs and full Expressions. Produces versioned Idea membership decisions; counting reads choose a named unit and selected run/view.

- [ ] Freeze the equivalence boundary, including HM03/HM13, with concrete source comparisons reviewed by Badr. Different actual windows/material conditions/reasons/roles remain distinct; dedicated reason records stay V2.
- [ ] Write failing cases for paraphrases, opposite directions, same direction/different reason, overlapping but unequal windows, changed condition, a multi-organisation Idea, and A≈B≈C where A and C differ materially.
- [ ] Implement shared-organisation candidate filtering, selected cheaper similarity shortlist and automated final LLM comparison. A filter hit is not an equivalence decision.
- [ ] Apply conservative membership without automatic similarity-component merging. Retain every Expression, passage and membership decision version. Unknown equivalence does not erase information.
- [ ] Add publication/expression counts deduplicated by the correct IDs. Copies are observed mentions, not independent confirmations; multiple spans/paths do not multiply publications.
- [ ] Run insertion and replay tests, including changed insertion order and later membership revision. Distinguish deterministic application from a new stochastic comparison.
- [ ] Prepare review and pause.

**Run:** `ctest --test-dir build/dev -R '^(idea_membership|spread_counts)$' --output-on-failure --no-tests=error`.

**Expected checks:** genuine paraphrase shares meaning with distinct sources; damaging near-match stays separate; repeated application does not change counts; prior membership remains inspectable. AT-13–16/18/20 apply.

**Badr's demo:** query one shared Idea and open both original Expressions; compare an otherwise similar claim that remains separate. Show the publication count before/after reprocessing one report. Explain which unit each number counts.

**Approval:** complete-meaning boundary and usefulness of shared representation. Supplied pair labels alone cannot demonstrate insertion/grouping correctness.

### Slice 7 — Useful views, historical eligibility, recovery and release review

**User outcome:** “I can investigate the two stocks, understand missing/held results, select dates/sources and restore the same evidence.”

**Files:** eligibility/query/export files, CLI query contracts, recovery/backup utilities, `tests/acceptance/query_catalogue.cpp`, `tests/acceptance/historical_cutoffs.cpp`, `tests/integration/restore.cpp`, runbook and final review.

**Interfaces:** completes `QueryService.read(QuerySpec, RunId, ViewVersion) -> QueryResult`. The result carries meaning/evidence plus separate coverage/limits/configuration; restore reconstructs the selected run and its referenced artifacts.

- [ ] Freeze relevant time/read defaults: supported versus declared/unknown exact-version availability, interval boundaries, qualitative/missing/fallback horizons, view/hold output and bounded traversal. Recommend defaults once; record the owner's actual choices. A proposed seven-day fallback is not the source's own statement.
- [ ] Write failing historical/view cases: Monday original collected Wednesday, corrected wording under an older header, later confirmation/dependency/review, current retrospective grouping over eligible old inputs, withheld availability and outside-view conflict handling.
- [ ] Implement Q1–Q7, including direct market/universe opinions, company neighbourhood, shared Expressions, two-stock evidence, claim history, source/run trace and coverage. Preserve qualifications in program output; a relative pair claim does not invent absolute directions.
- [ ] Bound traversals and expose truncation; dates and source selection apply to every substantive support premise. Source-aligned retrospective output is labelled; do not claim unsupported operational-as-of replay or leakage-free backtesting.
- [ ] Demonstrate backup/restore including all referenced evidence/configuration/responses. Interrupt preparation/publication and verify old completed reads survive. Missing/corrupt evidence blocks the affected result.
- [ ] Run focused native tests, then the complete frozen suite once. Record measured query latency, workload size, memory/storage where available and provider/model waiting separately. Do not optimise or invent a scale promise from 20 reports.
- [ ] Prepare final review, runbook and limitations. Pause for owner acceptance. Later corpus expansion is a new step, not automatic continuation from this release checkpoint.

**Run:** `ctest --test-dir build/dev -R '^(query_catalogue|historical_cutoffs|restore)$' --output-on-failure --no-tests=error`, then the full registered suite.

**Expected checks:** no side effects during reads; explicit empty/partial/failed coverage; no backdating later substantive evidence; preserved target/horizon/conditions; unique count units; restore yields the same stable IDs, bytes and selected query records. AT-01–04/16/19/24–36 apply.

**Badr's demo:** use the seven queries in `acceptance-guide.md`; restore into a clean directory and repeat one source/Idea/history query. Inspect the final graph and review unresolved limitations. Observed market-price data/integration remains outside this first release.

**Approval:** the useful bounded V1 and honest verification report. No part may be called owner-approved until that confirmation is recorded. Full-year coverage and scale acceptance remain explicitly pending.

## 5. Review packet and approval protocol

At every pause, create `reviews/slice-N/README.md` and update `progress.md`. Keep the human-facing review small; put raw artifacts and exact logs behind links.

```text
Slice N — READY_FOR_REVIEW / TEST_FAILED / BLOCKED
Business result: one sentence.
Example: original input → resulting meaning/graph/query.
State / invariant / transition: brief, concrete explanation.
Changed paths and commit/run/input identifiers.
Tests: exact commands, actual results and what they establish.
Try it: 1–3 commands/queries with expected visible output.
Known gaps and proposals needing a decision.
Next slice: its scope, for orientation only.
Owner decision: pending.
```

The agent may mark `READY_FOR_REVIEW` only when its required checks pass and material contract blockers are resolved. Owner review may still reject semantically incorrect output. `TEST_FAILED`/`BLOCKED` is not a successful slice.

When Badr approves, record the exact message and date/session reference and mark that slice `APPROVED`. Proceed to the next approved-scope slice without asking whether to start again. Questions, new examples, silence, a status request or ambiguous feedback are not approval. If corrections are requested, fix the active slice, rerun affected checks and resubmit; do not continue dependent work meanwhile.

The owner asked for checkpoints, so the agent must end its turn at each ready-for-review boundary. Optional subagents stay inside the active slice; they cannot run later implementation slices before the owner confirms the current one. Read-only investigation of a blocker is allowed.

## 6. Initial choices and stopping rules

Proceed with accepted source trial/automation without reopening those decisions. Before their first dependent production task, present a short choice bundle for unselected technologies and material semantics: native/backend/access surface; embeddings and candidate budgets; exact spans/time/defaults; confirmation/hold policy; grouping edge cases. Routine file/function mechanics within an accepted contract are implementation decisions.

No repeating three research rounds, rewriting the retained benchmark or collecting a fresh corpus at every slice. Stop and ask only for a concrete missing access/major owner choice, a failed test requiring scope change, or the requested owner checkpoint. Identify why the question matters and continue independent work within the active slice where possible.

The old 36-family test matrix remains a completeness checklist. A case whose required mechanism has not run is pending even if another slice's graph looks correct. Keep V2 deferrals intact. This planning change itself executes no source download, model call or C++ application test.
