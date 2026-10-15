# Axthena — architecture proposal

Review draft, 15 October 2026; not an accepted specification and not permission to implement. The owner's current statement that the graph results are satisfactory advances the review sequence. It does not select a physical schema, database, model, library, interface, extraction rule, or numerical limit. C++ remains the accepted main application language. All newly supplied mechanisms and values below are **PROPOSED / UNSELECTED**.

## 1. Changes the handoff must make to the 14 October plan

The current engineering decisions take precedence over the dated proposal. Do not copy the old plan unchanged.

| Earlier proposal or stale wording | Required reconciliation |
|---|---|
| Ladybug 0.21.2, C++20 and a CLI appear as the proposed stack | Only C++ is accepted. Database, version, standard, libraries and interface remain unselected. Do not imply that the graph review selected Ladybug or Neo4j. |
| Task 3 says to begin with no embeddings | ENG-020/024 requires actual lexical/name and semantic/vector candidate retrieval and their union for organisation identity in V1. A fixture may test the plumbing, but cannot satisfy actual retrieval. |
| An exact paid model endpoint and dollar-reservation ledger are mandatory early inputs | ENG-039 selects the existing ChatGPT subscription for the first experiment. The initial proposed transport should be retained manual task/answer packets. Automated generation APIs and their paid-call accounting are later choices. Unknown usage is not zero usage. |
| Two-Idea cap is merely proposed; partial extraction policy is unsettled | ENG-035 accepts at most two most-articulated Ideas. ENG-036 accepts readable valid partial output with unfinished work recorded separately. Truncated/unparseable JSON still is not a valid partial artifact. |
| Uncertain identity waits for review | ENG-026: a completed AI comparison selecting no existing organisation creates a separate organisation automatically, including uncertainty. A retrieval/model/tool failure is not a completed no-selection decision. |
| Exact calendar period or current rolling year is assumed | ENG-042 accepts any continuous twelve-month interval, common to both stocks, with precise dates still unselected. |
| Forecast anchors and overlap are unresolved | ENG-028/029/033: publication-date anchor absent another source reference; unqualified week = seven calendar days; unequal anchored windows remain separate. Boundary convention and fallback duration remain unselected. |
| Organisation/domain links may be independent lists | ENG-032 requires organisation-specific activity/dependency scope. A joint Idea must retain which activity belongs to which organisation; avoid a Cartesian-product interpretation. |
| Graph projection implies Events, Confirmations and Dependencies were extracted | The reviewed projection does not emit those separate structured concepts. They remain intended V1 concepts and require explicit contracts/tests; satisfaction with the projection is not evidence that the omitted structures already work. |

Preserve the accepted source-first historical requirement, separate collection/preparation/reading, one-computer runtime, API-first news acquisition, original evidence after failures, a clean domain/operations distinction, explicit views, automatic new organisation creation, per-source Expressions, and V2 deferrals. Do not re-open these as fresh architecture questions.

## 2. Recommended minimal track: typed C++ application, relational store, graph projection

**Recommendation, unselected:** one local C++ application with a narrow domain model, one SQLite structured store and an immutable evidence directory. Store typed records and explicit relationship tables; expose the same conceptual property graph through deterministic exports. Implement a few parameterised reads and an explicitly bounded dependency walk. There is no need for a custom graph engine, generic query compiler, agent framework, second authoritative database or service mesh.

This recommendation differs from the older Ladybug-first proposal. The argument is the actual workload: fixed, evidence-qualified reads, strict record identities/provenance, local sequential preparation, and graph inspection/export. It is not a performance conclusion and does not claim that SQL is intrinsically better than Cypher. SQLite's documented in-process operation, C/C++ interface, transactions and backup interface make it a plausible small local baseline [S1–S5]. The graph relationships remain first-class domain concepts even when rows store them.

| Responsibility | Proposed candidate | Why / gate |
|---|---|---|
| Main application | C++20; CMake; CTest | C++ accepted; standard and tools unselected. Confirm target compiler/platform, then pin versions. CTest runs native tests; no Python orchestration layer [S10]. |
| Structured data | SQLite native C API behind a thin RAII adapter | One authoritative store; prepared statements, explicit transactions, IDs and foreign keys. Enable and verify foreign-key enforcement on every applicable connection [S2–S4]. |
| Exact evidence and model artifacts | Immutable files addressed by content digest; metadata in SQLite | Persist acquired bytes independently of extraction; digest identifies bytes, not publications or semantic entities. Uncompressed files are an adequate initial codec. Optional Zstandard is a later measured storage choice, not a prerequisite [S11]. |
| JSON | nlohmann/json candidate | Convenient C++ JSON transport; explicit typed decoding and semantic validation remain application responsibilities. Do not equate parsing with schema validation or factual support [S9]. |
| News acquisition | One selected news API via libcurl candidate | API-first acquisition is accepted, provider not selected. libcurl supplies C transfer APIs; provider pagination, source quality and retention semantics still require the actual sample [S8]. |
| First model transport | Manual request/answer packet exchange with existing ChatGPT access | No paid generation endpoint or browser automation assumed. Packet correlation, validation and retained answers are application responsibilities. This is a proposed later implementation of the accepted experimental access choice. |
| Semantic embeddings | Separately approved local CPU encoder; ONNX Runtime C++ is a candidate | This is an additional unselected inference arrangement, not supplied by a normal ChatGPT text answer. Select weights, tokenizer, pooling, normalization and language coverage together. Native C++ inference is documented [S12]. |
| Lexical retrieval | Case-aware original name + versioned normalised name/aliases; small-directory edit/trigram score in C++ | Simple reference implementation; bound scanned identities and returned candidates. FTS5 can be evaluated if indexing is justified, but its trigram tokenizer is substring matching, not a complete typo-resolution algorithm [S6]. |
| Vector retrieval | Exact cosine scan over retained vectors, then bounded top-k | Avoid an ANN index until measurement establishes need. Record vector/model versions and scan-work limit. This is a proposed baseline, not an accuracy/performance claim. |
| Human/program access | Small CLI candidate with JSON results and readable text | No CLI or API has been selected. Proposed command names belong in the specification as examples. No web service is needed to satisfy one-machine access. |
| Graph inspection | Deterministic nodes/edges JSON plus one Cypher review exporter | IDs, provenance and distinctions preserved. An export format is not the production storage schema. Only promise execution in a named engine after its exported fixture has actually run there. |

A candidate multilingual encoder to evaluate is `intfloat/multilingual-e5-small`, not a selected model. The author's model card identifies it as multilingual and documents a 384-dimensional model [S14]. That fact does not establish Axthena name-match quality. ONNX Runtime alone is not a complete text-embedding pipeline: tokenizer compatibility and pooling/normalization need an explicit reproducible package and parity test. Sentence Transformers documents that its ONNX export can leave pooling/normalization to the caller [S13]. ONNX Runtime Extensions is a candidate preprocessing route, but its C ABI is expressly experimental; documentation does not prove parity with this particular encoder [S15]. Do not ship a handwritten approximate tokenizer to make the dependency list appear smaller.

The smallest first executable slice can retain and replay manual ChatGPT answers before this embedding choice is settled. It must say **retrieval fixture only** until an actual encoder and both retrieval branches run. If Badr wants no additional inference arrangement yet, stop at that honest milestone; do not label a lexical-only implementation complete V1.

### Alternative: embedded property graph with Ladybug

**Alternative, unselected:** use Ladybug as the sole structured store, retain the same immutable evidence archive and typed C++ records, and implement reviewed Cypher queries. Its official documentation describes an embedded engine and native C++ API [S7]. This more directly matches graph-shaped query authoring and the current review artifact. It also makes engine version/dialect, storage recovery and native-library compatibility part of the first target-machine gate. No claim of lower or higher Axthena latency is established.

The Ladybug API documentation warns that `getNext()` reuses its tuple object; materialize owned Axthena values before advancing and test lifetime/error paths [S7]. SQLite has its own statement/result lifetimes, so that gate is not unique to graph storage [S2]. Choose one store after the small gate; do not implement both or maintain dual authoritative copies. Retaining a portable domain export is sufficient to avoid locking the logical model to either engine.

## 3. Physical records without losing the graph meanings

The following is a proposed responsibility map, not final DDL or accepted node vocabulary. Keep fields with their natural owner instead of giving every attribute an auxiliary graph node.

| Logical responsibility | Minimal proposed representation |
|---|---|
| Stock, organisation, recognised name, shared activity category | Stable-ID tables; alias records; explicit stock/issuer/corporate links. Original names retained. Shared category does not share suppliers. |
| Report and actual acquired material | Report/publication record separate from artifact/acquisition record. Two reports may share identical bytes without becoming one originating publication. |
| Exact passage | Text-version ID, UTF-8 byte start/end proposal, exact quote and original-byte lineage. Software calculates/validates offsets; repeated text needs paragraph/occurrence disambiguation. |
| Per-source Expression | Report ID, voice/source identity, summary, passage links, status and processing attempt. Every source keeps its Expression even when it shares an Idea. |
| Shared Idea | Stable Idea identity plus selected immutable definition/membership decision version. No equivalence from common topic/direction alone. |
| Concerned subject | Association carrying Expression/Idea, organisation, optional activity, and supported role together. Avoid separate unpaired organisation and activity arrays. |
| Judgment | Expression + target stock + UP/DOWN + window/origin/absence information + qualification passage reference. Conditions remain visible with the direction; no condition evaluator or reason subsystem. |
| Event and relationship assertion | Explicit typed record only where supported, with subject/object, scope/modality/interval and evidence. Announcement and completion remain distinct. Dependency assertions are organisation-specific. |
| Claim, confirmation and hold/review | Scoped claim key, externally qualifying support and dated review decisions. Display/search classification cannot create external confirmation. |
| View | Versioned selected sources/universe plus selected interpretation versions. No claim that a view represents universal consensus. |
| Operational records | Collection scope/status, task/attempt, validation issues, unfinished work, embeddings/candidate sets, run manifest and publication state. These are not domain events or news. |

SQL foreign keys can enforce existence, but they do not enforce evidence support, semantic equivalence, temporal eligibility or scope correctly by themselves. Those require typed application checks and reviewed cases. A property-graph store also requires those checks.

## 4. Batch workflow and model boundary

Proposed separate operations:

1. **Collect:** the configured source adapter requests news pages; persist actual response bytes and sanitized metadata before parsing. Record requested stock/topic/date scope, pagination and collection outcome. Keep an acquisition failure different from a successful empty response.
2. **Prepare deterministic inputs:** normalize text into a versioned representation; retain original bytes; identify missing/insufficient material; create exact task packets. An article without UP/DOWN is not inherently insufficient.
3. **Execute model tasks:** manually exchange a retained packet with ChatGPT first. Import the actual unedited answer with task/attempt correlation and hash. Each additional answer is a new attempt. Full exact conversation context actually supplied must be retained; hidden settings/model snapshot remain unknown.
4. **Validate and link:** validate structure, spans and support, resolve organisations, select at most two Ideas, compare meaning, record memberships, and assess externally supported claims. Valid components may proceed while failed components stay operationally visible.
5. **Publish a coherent run:** validate all selected references, evidence availability and policy versions; select a manifest in a transaction. The manifest can describe incomplete extraction while remaining internally consistent.
6. **Read/export:** select one published run and view; read only retained prepared data; return provenance/coverage and explicit limits. Reads never fetch news, embed new text or call a model.

Manual transport is not source acquisition. It does not undo ENG-010's accepted requirement that Axthena download from a configured news API. It also does not promise practical manual processing of twelve months of articles; that throughput is unknown until a small real packet is tried. Automated generation can later replace the transport without changing validation/domain meanings, but requires a separately chosen provider/model/access/budget. A future API implementation should retain exact translated requests, raw responses, refusal/truncation/error states and uncertain retry outcomes. None is assumed available now.

Do not require one synchronous `execute()` function to pretend a human exchange has completed. A narrow proposed boundary is `prepare task → pending external answer → import answer → validate`. A later API adapter may produce the same answer artifact automatically. The interface is an Axthena task transport, not a generic agent execution framework.

## 5. Organisation resolution and Idea matching

**Accepted organisation logic:** stable identities; lexical/name branch and semantic/vector branch; deduplicated union; record both outputs and intersection membership; AI selects an existing identity or a separate organisation is created automatically, including uncertain no-selection. Retrieval/model failure must not become `CREATE`.

**Proposed bounded implementation:** each branch returns at most eight distinct organisation IDs, so the AI receives at most sixteen. These numbers are unselected. Keep independent scores/ranks and model/configuration versions. Do not silently truncate the union to eight and discard candidates supplied by one branch. Exact recognised-name hits should enter the candidate packet; the policy for treating them as authoritative must be explicit, since ENG-020 assigns the identity decision to AI. Preserve source spelling and the supporting context. Candidate scan timeout/exhaustion is an incomplete retrieval state, not evidence that no match exists.

Store new identities and reusable lookup/embedding state before resolving the next input mention, or have the read path combine the persistent index with pending newly created identities. For the minimal exact-scan proposal, use one writer and deterministic input order. Reapplying the same selected decision ID reuses its created identity. New fresh inference is a new decision version; it must not silently replace earlier published identities or memberships.

**Accepted Idea filter:** retain existing Ideas sharing at least one resolved concerned organisation. **Proposed later narrowing:** a bounded shortlist of compatible scopes/windows, then an LLM semantic check over complete source-grounded claims. The organisation-union rule is not automatically an accepted requirement to use the same two retrieval methods for Idea candidates. Reuse the mechanism only if the owner accepts that extension.

Meaning admission must preserve direction, organisation roles, scope, conditions and actual anchored forecast window; materially different complete opinions remain separate even though dedicated reason extraction is V2. A successful pairwise `SAME` decision is not permission to merge a whole similarity-connected component. Retain the decision basis and member references. On unresolved equivalence, propose a separate Idea with uncertainty recorded; do not silently generalize organisation-creation policy to every domain concept.

The reviewed graph's 38 report-local singleton Ideas and independent comparison diagnostic cases cannot substitute for testing this sequential process. Required end-to-end evidence includes actual retrieval, a later mention reusing a newly created identity, a paraphrase joining an existing Idea, and a near-match correctly staying separate.

## 6. Durability, historical reads and reproducibility

**Proposed simplest publication design:** a single database with immutable versioned domain/decision rows and a `prepared_run` manifest selecting exact record versions. Stage new rows under a not-yet-published run. Complete durable artifact writes and verify their digests before committing a published-run pointer in SQLite. If the process fails before publication, the earlier published run remains selected. Unreferenced completed files can be reported as abandoned staging artifacts; no automatic deletion policy is needed initially. This is simpler than a full database copy per run, but requires strict immutability and every read joining through its selected run.

Do not describe a database transaction as making filesystem writes atomic. Files must be completed durably before the database references them; target-OS interruption tests establish the actual guarantee. Use one preparation process and reject overlapping supported preparation/read operations explicitly. Immutable full database snapshots remain a valid alternative if append-only selection proves too error-prone; that is a storage-policy choice, not an accepted requirement.

Backups must contain a consistent structured snapshot, every referenced raw/normalized/model artifact, configuration/prompt/schema/validator versions, decisions and a manifest. SQLite documents a backup API [S5]; it does not back up external evidence automatically. Restore into a clean directory and compare reference results. A native database file alone is not an Axthena backup.

Retain source publication, supported first availability with basis/precision, collection, generation and validation times separately. Strict source-cutoff reads test the full substantive support chain, including later confirmations and dependencies. Unknown captured-version availability cannot silently satisfy an earlier cutoff. **Proposed policy:** strict reads exclude unsupported/unknown version availability and report exclusions; a separately selected exploratory declared-date mode may include declared dates with visible limitations. Owner choice of that default remains necessary. No active edit crawler or operational-as-of simulator is introduced.

Reproduction means replaying retained answer bytes through retained validator/decision/query versions and selecting the same run manifest. A fresh ChatGPT answer is a fresh experiment. The presence of an old publication date does not make current extraction/model knowledge historically available. Raw output hashes, not only logical request hashes, must contribute to downstream artifact identities.

## 7. Reads and exports that demonstrate the implementation

Propose a small parameterised C++ read API, with an optional CLI wrapper; not a new query language. The existing first stock/date evidence read is the initial vertical slice. Then add direct opinions for the configured universe/view, the accepted manually chosen two-stock view, Idea expressions/spread, and evidence-qualified relationship/confirmation inspection. More query types are not needed merely to fill an architecture diagram.

Every result should identify the selected run/view, stable source IDs, exact support, date basis, qualification text, processing coverage, and evaluation/display completeness. Deduplicate by the unit being counted: report count, expression count, known-origin count and path count are different measurements. Empty matches with successful collection differ from uncollected scope and failed preparation. Numerical export must not detach UP/DOWN from its target, horizon basis or material condition.

For bounded dependency reads, propose explicit hop, expansion and output limits, each independently recorded. The earlier three hops / 1,000 expansions / 100 paths are unselected starting values, not measured service guarantees. A display cap cannot hide a conflicting confirmation and still label the claim unqualifiedly confirmed. SQL/Cypher execution time is an additional measured budget; output `LIMIT` alone is not a work bound.

Export records deterministically, using stable IDs and escaping rather than LLM-generated executable Cypher. Produce one portable typed JSON representation and one review projection. The projection should omit no retained evidence/processing lineage necessary to interpret its nodes. Do not add another graph database solely to draw the export.

## 8. Decision groups and staged blockers

The handoff can be compiled now. Production code remains paused. The groups below explain dependencies. The canonical owner review sheet is `06-review-decisions-and-v2.md` (D1–D6); this section is not a second checklist. Details covered by an accepted bundle need not generate further micro-questions.

1. **Local implementation bundle.** Confirm target OS/compiler, RAM/disk and choose the proposed SQLite/C++20/CMake/CTest/JSON/HTTP/CLI bundle or Ladybug alternative. Accept a bounded target-machine conformance gate before pinning exact compatible versions. This blocks the native foundation, not the present documentation.
2. **First real source packet.** Choose a news provider/access path, exact common twelve-month interval, languages and source budget scope after usable-body sample evidence. The acquisition client can be specified now, but its adapter/pagination and full-year run cannot be executable without these inputs. No purchase follows from accepting a budget preference.
3. **Model and retrieval milestones.** Confirm manual ChatGPT task/answer transport for the first implemented slice, then either select a local embedding package/gate or explicitly postpone real vector retrieval. There is no paid generation API prerequisite. Full V1 retrieval cannot be marked complete before both actual branches run. Automated year-scale model processing remains a later explicit access/budget decision.
4. **Small semantic default bundle.** Approve the concrete proposed gap closures and tests: scoped confirmation/hold visibility; source-version availability policy; paired organisation/activity subject associations; quoted-judgment exclusion; distinction between qualitative/missing horizon plus exact date boundary/fallback convention; completed no-selection versus failed retrieval. Include readable partial results and condition-preserving exports. Existing accepted decisions within that bundle are reaffirmed, not reopened.

Suggested within-bundle defaults, all unselected: UTF-8 byte span offsets; date-only windows `[start,end)`; no fabricated time-of-day; one unqualified week = accepted seven calendar days; configured fallback must be explicitly set and marked rather than silently importing the trial's tentative seven-day value; hold visible to investigator but excluded from an unqualified confirmed subset; malformed/truncated container quarantined, independently well-formed validated components publishable; no-match returns normal empty records plus typed coverage/status rather than being universally treated as an error.

Machine-specific version pinning, a fixed hash/ID library, exact module file names, ANN selection, compression level and detailed performance targets are implementation-gate outputs, not reasons to stop compiling this handoff. Conversely, unselected source access, tokenizer/model parity and unresolved semantic conventions should not be hidden inside a falsely unconditional plan.

## 9. Architecture gates to include in the test plan

- Native target-machine gate: build, parameter binding, owned multirow values, read-only write rejection, foreign-key/integrity checks, restart persistence and typed export/reload equality.
- Evidence gate: exact original bytes survive failed normalization/extraction; source-response artifact remains distinct from extracted article text; corruption/missing artifact blocks publishing its dependant result.
- Model-boundary gate: wrong task ID, duplicate import, malformed/truncated answer, refusal/unknown outcome, changed prompt/source and fresh-response hash are distinguishable; replay performs no external model call.
- Retrieval gate: lexical-only candidate and vector-only candidate both reach the AI; intersection flag correct; union not silently shortened; encoder/tokenizer parity; failed vector retrieval never creates an organisation; uncertain completed no-selection creates a separate provisional identity; new identity visible to next mention; repeat import causes no duplicate creation.
- Meaning gate: paraphrases share an Idea with separate Expressions; direction, role, condition, scope or anchored-window differences prevent damaging merges; a similarity chain does not create automatic transitive membership; candidate filter uses stable organisation IDs.
- Publication gate: valid one-of-two extraction readable with incomplete work; deliberate cap different from failure; crash before/during publication leaves previous run usable; new aliases/memberships do not mutate old selected runs.
- Read gate: source cutoff covers all supporting links; conditions accompany numerical directions; pair view keeps per-stock effects; category sharing does not transfer another organisation's dependency; counts ignore duplicate paths; empty coverage states differ; no network or model calls.
- Restore gate: complete backup restored into clean directory produces the same stable IDs, evidence bytes and selected query records. Benchmark CPU/memory/database time separately from network and manual model waiting. Do not claim comparative performance before measurement.

## Primary technology sources checked on 15 October 2026

These document capabilities and integration constraints; none is an Axthena benchmark or selected dependency.

- **S1** SQLite, serverless operation: https://www.sqlite.org/serverless.html
- **S2** SQLite, C/C++ interface and statement lifetime: https://www.sqlite.org/cintro.html
- **S3** SQLite, foreign-key support/enabling: https://www.sqlite.org/foreignkeys.html
- **S4** SQLite, transactions: https://www.sqlite.org/lang_transaction.html
- **S5** SQLite, backup API: https://www.sqlite.org/backup.html
- **S6** SQLite, FTS5 trigram behavior/limits: https://www.sqlite.org/fts5.html#the_trigram_tokenizer
- **S7** Ladybug, native C++ API / reused tuples: https://docs.ladybugdb.com/client-apis/cpp/ ; embedded/concurrency model: https://docs.ladybugdb.com/concurrency/
- **S8** libcurl API: https://curl.se/libcurl/c/
- **S9** JSON for Modern C++: https://json.nlohmann.me/
- **S10** CTest manual: https://cmake.org/cmake/help/latest/manual/ctest.1.html
- **S11** Zstandard project documentation: https://facebook.github.io/zstd/
- **S12** ONNX Runtime C++ support: https://onnxruntime.ai/docs/get-started/with-cpp ; C/C++ API: https://onnxruntime.ai/docs/api/c/
- **S13** Sentence Transformers, ONNX pooling/normalization caveat: https://sbert.net/docs/sentence_transformer/usage/efficiency.html
- **S14** Author model card (search-indexed content inspected; direct full-page fetch exceeded tool size limit): https://huggingface.co/intfloat/multilingual-e5-small
- **S15** Microsoft ONNX Runtime Extensions C ABI, experimental status and tokenizer limitations: https://github.com/microsoft/onnxruntime-extensions/blob/main/docs/c_api.md ; native registration: https://onnxruntime.ai/docs/extensions/

Local source precedence: `Axthena-engineering-context.md` (through ENG-043 and P-020), `Axthena-context.md` (AX-001–054), then the 14-Oct implementation plan, three-round review and LLM-boundary proposal as dated advisory documents. The new user statement about graph satisfaction supersedes stale claims that owner graph inspection is still the next prerequisite; it does not erase the documented representation gaps or accept proposed defaults.
