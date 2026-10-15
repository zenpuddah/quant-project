# Axthena MVP — proposed implementation plan

> **For agentic workers:** After owner approval, use `superpowers:subagent-driven-development` or `superpowers:executing-plans` to implement this plan task by task. Checkboxes track future execution; none is completed by this research report.

**Goal:** Collect stock-related evidence for Nvidia and Microsoft, preserve and organise it, then provide dated, inspectable graph queries and simple numerical exports.

**Architecture:** Separate acquisition from repeatable processing and reading. Retain immutable source/model artifacts; publish one complete local graph generation with pinned decisions and views; open it read-only for fixed parameterised queries. Originals and structured records have different responsibilities and form one recoverable generation package.

**Accepted language:** C++ (ENG-016), for CV value and performance. **Proposed stack:** C++20; CMake/CTest; Ladybug 0.21.2 through its native C++ API as the candidate graph backend; explicit typed structures and semantic validation; native JSON/HTTP adapters; Zstandard for original/attempt artifacts. C++20, build/test tooling and individual libraries remain recommendations; only C++ is accepted. Pin exact compatible versions after the target-machine conformance check. No Neo4j, SQLite or DuckDB second authoritative store. No paid subscription or LLM provider is selected by this plan.

**Spec:** [Axthena-three-round-design-review-2026-10-14.md](Axthena-three-round-design-review-2026-10-14.md), proposed V1 specification and R-01–R-06. [Research](Axthena-research-catalogue-2026-10-14.md). New signatures, paths, policies and limits below are proposals awaiting review.

## Global constraints

- Axthena has its own project and repository; do not implement inside Qaedalus or Lexongine.
- No execution until Badr reviews the written specification, resolves its blocking choices, reviews this plan and selects an execution method.
- V1 runs on the analyst’s computer, prepares before reading, and does not promise concurrent live reads.
- Reads initiate no acquisition, model inference, classification training or mutation.
- Facts require precise external confirmation; model output cannot resolve a confirmation hold.
- Preserve original evidence and exact passage links, source/processing times, decision versions, explicit uncertainty and clean domain/operational separation.
- Only UP/DOWN stock judgments; optional absence is valid. Third-party judgment extraction/scoring, active edits and operational historical readiness remain deferred.
- The person vector is domain-independent; dummy values remain labelled and do not establish confirmation or probability.
- Proposed defaults from the spec: two selected ideas maximum; three dependency hops; 1,000 explicit traversal expansions; 100 returned paths. These are reviewed configuration values, not accepted discovery constants.
- Record USD 20 preferred, USD 50 acceptable and USD 100 tolerable as budget preferences. A concrete total budget and stop policy must be approved before paid processing.
- A published generation is complete in its internal records/references; it may explicitly describe partial collection or omitted extraction. It never implies complete information-world coverage.

## Inputs to freeze before execution

| Input | Required outcome |
|---|---|
| Owner’s architecture review | Accepted specification version with R-01–R-06 revisions recorded in the six-field decision format |
| Local machine | OS, C++ compiler/toolchain, RAM and usable disk; no inferred platform-wide support promise |
| Backend | Ladybug candidate approved for its bounded conformance gate; Neo4j alternative requires an amended storage/publication plan if selected |
| Collection scope | Exact year/date interval, source/provider, native security identifiers, supplier/resource/topic list and publication languages |
| Source access | Existing configured credentials if required; sample confirms usable bodies, actual dates, pagination and permitted retention |
| Policy configuration | Confirmation process list, hold visibility, availability handling, grouping/multi-idea rule, horizon default and empty-result presentation |
| Model and spending | Exact endpoint/model identifier, permitted context, usage prices, total cap, retry allowance and treatment of uncertain charges |
| Acceptance environment | Approved performance envelope and reproducible small reference dataset |

These are inputs for one coherent implementation pass, not a demand to restart business discovery. Provider credentials and any purchase remain separate from design approval.

## Review focus

1. A current confirmation or dependency attached to older material must not bypass the source cutoff — Tasks 4 and 6.
2. Indirectly reported third-party forecasts must not become the author’s own judgment — Task 3.
3. Interrupted publication or a missing archive object must preserve the earlier usable generation — Tasks 5 and 7.
4. Repeated reports, paths and model retries must not multiply publication/origin metrics — Tasks 2, 3 and 6.
5. A confirmed claim must not hide a conflicting confirmation beyond the display cap — Task 6.

## Proposed project files

Paths below are relative to a future dedicated Axthena repository. **These files have not been created.**

| File(s) | Responsibility |
|---|---|
| `CMakeLists.txt`, `README.md`, `config/example.json` | Installation, approved dependencies and documented sequential workflow |
| `include/axthena/contracts.hpp`, `src/axthena/contracts.cpp`, `config.cpp` | Typed records, configuration and semantic validation |
| `src/axthena/archive.cpp`, `operations.cpp` | Immutable bytes/artifact references; durable attempts, coverage and cost events |
| `src/axthena/collect.cpp`, `sources/eodhd.cpp` | Common acquisition boundary and initially approved news adapter; rename adapter if provider changes |
| `src/axthena/process.cpp`, `extract.cpp`, `validate.cpp` | Deterministic parsing, model attempt capture, grounding and insufficiency checks |
| `src/axthena/link.cpp`, `assess.cpp` | Conservative idea/entity decisions and scoped fact/hold assessments |
| `src/axthena/store.cpp`, `publish.cpp`, `schema.cypher` | Sole graph backend, graph-wide integrity, immutable generations and publication |
| `src/axthena/query.cpp`, `queries/*.cypher`, `cli.cpp` | Typed reads, bounded paths, metrics and human/JSON presentation |
| `src/axthena/backup.cpp` | Complete package export, integrity and clean restoration |
| `tests/fixtures/`, `tests/test_*.cpp` | Source-grounded/synthetic reference cases and recovery/invariant tests |

Keep these units small, but do not split them into services or invent a general plugin framework. Put public declarations in matching `include/axthena/<unit>.hpp` headers; `.cpp` files own implementations. Domain records own their text and IDs; borrowed buffers cannot outlive their documented scope.

## Contract vocabulary

Task 1 defines these exported C++ structs/enums and interfaces in namespace `axthena`; later tasks use the same names. Proposed conventions: `Path = std::filesystem::path`; `Id` is an application-owned identifier type; `Bytes` owns `std::vector<std::byte>`; optional values use `std::optional<T>`. Define an application `Result<T>` with a value or typed `Error` for recoverable boundary failures; do not require C++23 `std::expected` under the proposed C++20 baseline. RAII owns database, connection, HTTP/file and compression resources. `Money` uses checked integer monetary subunits with explicit currency/scale; reservation rounding is conservative and overflow fails explicitly.

| Type | Required information |
|---|---|
| `CollectionScope` | Target stock IDs, provider/source selection, interval, topics, pagination and limits |
| `RawPage` | Body bytes, sanitised request/response metadata, capture time, cursor and status |
| `EvidenceRef` | Stable artifact ID, uncompressed SHA-256, length, codec, archive location and media type |
| `NormalisedReport` | Report/publisher identities, evidence/text refs, exact versioned text and all source-time fields with basis/precision |
| `ExtractionRequest` | Exact input artifact/context hashes, complete prompt, schema, model/deployment/settings and request key |
| `AttemptArtifact` | Attempt ID, request identity, actual response ref/hash or failure, usage/cost status and times |
| `ValidationResult` | Validated expression candidates, explicit omission/insufficiency issues and artifact usability |
| `DomainBundle` | Immutable entity/statement/relationship versions, grouping/identity/confirmation decisions and artifact refs |
| `Manifest` | Generation ID, all selected inputs/outputs/decisions/views, schema/software versions, coverage summary and hashes |
| `QuerySpec` | Query type, generation, target/date/cutoff/view/status filters and work/display limits |
| `QueryResponse` | Selected records, support, counts/definitions, coverage, excluded availability and completeness/truncation metadata |

Represent uncertainty explicitly; do not coerce missing values into zeros. Currency/quantity values retain exact source text and precision. Public entity IDs are application-owned; display names, ticker strings and LLM summaries are not identity keys. Byte hashes identify artifacts, not people or semantic ideas.

## Task 1 — executable contracts and target-machine graph gate

**Files:** Create project files, `contracts.cpp`, `config.cpp`, initial `schema.cypher`; tests `test_contracts.cpp`, `test_backend_gate.cpp`.

**Interfaces:** `Result<AxthenaConfig> load_config(const Path& path)`; `std::vector<ContractIssue> validate_manifest(const Manifest& manifest)`. Define every contract type above, plus `AxthenaConfig` and `ContractIssue(code, record_id, detail)`.

- [ ] Write contract tests: unknown configuration fields rejected; missing optional judgment accepted; malformed required evidence reference rejected; date-only precision retained; dummy vector cannot be declared empirical.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_contracts)$"`; confirm the expected failures before implementation.
- [ ] Configure with `cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug` and build with `cmake --build build`. Register named native test executables in CTest. Before each subsequent CTest run, rebuild changed targets. Initial missing symbols/build failures establish the red phase; do not count an empty test suite as success.
- [ ] Implement strict typed configuration/records and explicit semantic checks. C++ types do not validate arbitrary JSON automatically: decode required fields, reject unknown/invalid values and apply separate semantic/grounding checks. These establish record validity, not evidence truth; date parsing retains the stated precision contract.
- [ ] Write the graph conformance tests using a tiny synthetic packet: required node/relationship tables, unique IDs, parameters, evidence-qualified joins, source-time filters, reopen persistence, enforced read-only writes, and export/reload equality. Verify multirow materialisation remains distinct after iterator advancement and result destruction; verify prepared-parameter reuse and resource destruction order.
- [ ] Implement the smallest Ladybug setup to satisfy those tests, then run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_contracts|test_backend_gate)$"`.
- [ ] Record exact OS/package/store-format versions and the gate result. If an essential gate fails, stop that backend path and review an amended spec; do not quietly add a second database.
- [ ] Commit this independently reviewable contract/backend foundation.

**Done when:** the approved local environment can persist and read the required model; unsupported inputs and writes fail explicitly. No annual collection is attempted.

## Task 2 — durable acquisition and independent evidence retention

**Files:** `archive.cpp`, `operations.cpp`, `collect.cpp`, selected source adapter; tests `test_archive.cpp`, `test_collect.cpp`.

**Interfaces:** `Result<EvidenceRef> Archive::put_bytes(std::span<const std::byte> data, std::string_view media_type)`; `Result<Bytes> Archive::get_bytes(const EvidenceRef& ref)`; `Result<RawPage> SourceAdapter::fetch_page(const CollectionScope& scope, const std::optional<std::string>& cursor)`; `Result<CollectionResult> collect(const CollectionScope& scope, SourceAdapter& adapter, Archive& archive, OperationLog& log)`. Define `OperationLog` and `CollectionResult` here; the latter contains acquired refs and source/window coverage statuses.

- [ ] Write tests: byte round trip; two acquisitions share one blob but retain separate envelopes; corruption detected; two API pages exhaust correctly; unsupported interval, HTTP failure and completed empty response remain different.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_archive|test_collect)$"`; observe expected failures.
- [ ] Implement content-addressed Zstandard storage, safe temporary-file completion and byte integrity; retained artifacts have no automatic expiry.
- [ ] Implement the selected adapter’s documented pagination/date/ticker mapping. Retain exact response bodies and source identifiers; exclude API secrets from request metadata. Respect actual provider limits and retain unsuccessful acquisition status.
- [ ] Implement sequential durable operational logging with request IDs so interrupted/resumed collection does not double-count pages or acquired publications.
- [ ] Run the tests and a bounded authenticated source sample after credentials/access are supplied: oldest/newest usable items for each stock and representative primary evidence. Record text/date/version limits and observed request counts.
- [ ] Commit acquisition and retention as a separate deliverable.

**Done when:** original evidence survives parsing/extraction failure and can be processed again without refetch. Sample adequacy is recorded; it does not establish comprehensive source coverage.

## Task 3 — repeatable extraction, explicit insufficiency and cost control

**Files:** `process.cpp`, `extract.cpp`, `validate.cpp`, operational-log additions; tests `test_extract.cpp`, `test_validation.cpp`, `test_costs.cpp`.

**Interfaces:** `Result<NormalisedReport> normalise(const EvidenceRef& ref, const SourceMetadata& metadata)`; `Result<ExtractionRequest> make_request(const NormalisedReport& report, const ExtractionConfig& config)`; `Result<AttemptArtifact> Extractor::run(const ExtractionRequest& request)`; `ValidationResult validate_attempt(const NormalisedReport& report, const AttemptArtifact& attempt, const ValidationRules& rules)`; `Result<Reservation> CostLedger::reserve(const Id& attempt_id, Money upper_cost)`; `Result<void> CostLedger::settle(const Id& attempt_id, const std::optional<Usage>& usage, ChargeState state)`. Define referenced configuration/source/cost types in contracts when added.

- [ ] Write tests with captured/stubbed responses: exact citation invalid; lost negation; business growth without stock direction; indirect analyst forecast excluded; one or two independently developed ideas; malformed second idea quarantines artifact; deliberate insufficiency/omission retained; optional absent direction remains valid.
- [ ] Write reuse tests: changed source metadata/prompt changes request key; same request with different response hashes produces different downstream validation/link keys; retry never adds a publication.
- [ ] Write cost tests: dispatch blocked before exceeding selected cap; finite retries; timeout retains uncertain charge reservation; empty successful output is distinct from invalid/failed output.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_extract|test_validation|test_costs)$"` and confirm expected failures.
- [ ] Implement normalisation with versioned text/span mapping; one-document bounded model requests; complete request/response/attempt capture; required-information and voice rules; serialized cost logging. Begin with one LLM worker and no embeddings.
- [ ] Run the automated tests and manually examine 30 representative cases: both stocks, short/long material, primary/secondary reports, numbers, modality, anonymous voices, duplicate origins and conflicts. Record corrections and measured tokens/retries by case type.
- [ ] Freeze candidate prompt/rules after the development pilot; keep later acceptance material separate. Commit.

**Done when:** failed extraction preserves input; selected outputs have inspectable support and provenance; paid calls are bounded. No extraction accuracy percentage or predictive usefulness is inferred from the small pilot.

## Task 4 — conservative linking and precise confirmation/hold

**Files:** `link.cpp`, `assess.cpp`; tests `test_linking.cpp`, `test_confirmation.cpp`, `test_time_lineage.cpp`.

**Interfaces:** `Result<DomainBundle> link(std::span<const ValidationResult> validated, const EntityMapVersion& mapping, std::span<const DecisionVersion> decisions)`; `FactAssessment assess_claim(const ScopedClaim& claim, std::span<const ConfirmationVersion> confirmations, const ConfirmationPolicy& policy)`; `EligibilityResult eligible_support(const Id& record_id, const SourceCutoff& cutoff, const DomainBundle& bundle, const AvailabilityPolicy& policy)`.

- [ ] Write tests: identical anonymous display names remain distinct; source identity differs from collector; two publishers share one idea with separate expressions; incompatible horizons/reasons do not merge; similarity chain does not force a group; multi-origin article retains per-expression lineage.
- [ ] Write confirmation tests: announcement occurrence differs from underlying product success; different revenue scopes do not cause hold; incompatible same-scope confirmations do; only dated owner review changes the held assessment.
- [ ] Write source-cutoff tests: later confirmation/dependency excluded; recorded decision date preserved; unsupported historical captured wording excluded under conservative policy; unknown availability never treated as an exact early timestamp.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_linking|test_confirmation|test_time_lineage)$"` before implementation.
- [ ] Implement bounded candidate grouping and explicit decision records. Unresolved matches remain separate; no model-generated truth-voting or auto-revocation. Manual grouping/review may enter via reviewed decision JSON, without building a new editing UI.
- [ ] Implement typed scoped relationship assertions; corporate contribution, supplier relation and process input remain different kinds. Include modality and supported interval/unknowns.
- [ ] Run the tests, inspect the real-report reference packet under the selected policies, and commit.

**Done when:** the game’s actors/events/relationships are faithful and auditable; confirmations and potential interpretations remain distinguishable.

## Task 5 — complete immutable generation publication

**Files:** `store.cpp`, `publish.cpp`, completed `schema.cypher`; tests `test_generation.cpp`, `test_publication.cpp`.

**Interfaces:** `Result<Manifest> build_generation(const DomainBundle& bundle, const AxthenaConfig& config, const Path& destination)`; `Result<std::vector<ContractIssue>> audit_generation(const Path& path)`; `Result<GenerationRef> publish_generation(const Path& root, const Manifest& manifest)`; `Result<std::unique_ptr<ReadStore>> open_generation(const Path& root, const Id& generation_id)`.

- [ ] Write tests: graph-wide dangling pointer blocks publication; missing archive blob blocks publication; interrupted staging leaves current generation unchanged; a new alias/grouping decision cannot change an old generation’s query; repeated publication is idempotent.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_generation|test_publication)$"`; confirm expected failures.
- [ ] Build a distinct structured database for the staged generation from retained validated inputs/decisions. Do not mutate or hard-link a writable copy of the previous published database.
- [ ] Validate required IDs, types, endpoints, support closure, decision predecessors and artifact integrity over the whole generation. Export all structured records/schema/decisions in a portable form.
- [ ] Close/checkpoint the writer through the tested database interface, complete the manifest and durably publish the current pointer on the same filesystem. Document the target OS’s durability semantics and test interruption points there.
- [ ] Implement a narrow native graph adapter: database lifetime outlives connections; prepared statements survive execution; reusable query tuples are copied into owned Axthena records before advancing. Open selected generations read-only; keep previous published generations queryable. Reject overlapping supported prepare/read operations explicitly under V1’s phase rule.
- [ ] Run tests including forced interruptions and commit.

**Done when:** readers bind to one complete old or new version, and retained results cannot change through a current mutable pointer.

## Task 6 — investigator queries, bounded paths and honest numerical export

**Files:** `query.cpp`, six reviewed query templates, `cli.cpp`; tests `test_queries.cpp`, `test_counts.cpp`, `test_bounds.cpp`, `test_cli.cpp`.

**Interfaces:** `Result<QueryResponse> query(const QuerySpec& spec, ReadStore& store)`; `Result<EdgeBatch> ReadStore::adjacent(const Id& subject_id, const EdgeSelection& selection, const EdgePage& page)`; `Result<std::vector<RecordVersion>> ReadStore::fetch_records(std::span<const Id> ids)`; `Result<ExportSummary> export_flat(const QueryResponse& response, const Path& destination)`.

- [ ] Write reference tests for all six query families in the spec. Assert exact stable IDs, distinct report/origin counts, passages, dates and flags rather than incidental database row order.
- [ ] Write high-fan-out/cycle tests: dependency hops count semantic edges; explicitly processed adjacency expansions stop at 1,000 and paths at 100; partial results identify truncation. Database scans/sorts are not counted as application traversal expansions, so separately measure/cap backend time using the tested cancellation/timeout mechanism.
- [ ] Write status tests: contradictory confirmation outside the first display page still yields hold; incomplete full-status evaluation yields `incomplete_evaluation`, not confirmed; zero UP matches differs from failed/uncollected scope.
- [ ] Write aggregate tests: two support paths do not duplicate a report or monetary value; unknown origin is not independent confirmation; null strength/weights stay null; dummy values retain origin labels.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_queries|test_counts|test_bounds|test_cli)$"` before implementation.
- [ ] Implement parameterised graph reads plus explicit counted traversal where hard expansion bounds are promised. Pin one generation and apply eligibility through every substantive support chain. Disable query-side provider/model functions and unreviewed procedures.
- [ ] Implement CLI `collect`, `process`, `publish`, `query` and `export` operations. Human output includes short summaries/passages; JSON output preserves contracts and coverage. No web UI, external service or natural-language execution planner.
- [ ] Run tests with network/model clients replaced by call-failing stubs during reads. Commit.

**Done when:** Badr and a program can inspect the same evidence and understandable metrics without hidden data collection or unsupported causal interpretation.

## Task 7 — recovery, independent acceptance and bounded full-run handoff

**Files:** `backup.cpp`, README/runbook; tests `test_restore.cpp`, `test_acceptance.cpp`, `test_performance.cpp`.

**Interfaces:** `Result<BackupManifest> backup_generation(const Path& root, const Id& generation_id, const Path& destination)`; `Result<GenerationRef> restore_generation(const Path& package, const Path& destination)`; `Result<std::vector<ContractIssue>> verify_backup(const Path& package)`.

- [ ] Write restoration tests: clean-directory restore includes all referenced original/model bytes and decision/schema versions; missing or corrupt object fails visibly; restored reference queries equal original JSON results apart from expressly operational timing fields.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error -R "^(test_restore)$"`; confirm expected failures, then implement complete package/verification/restore.
- [ ] Run `ctest --test-dir build --output-on-failure --no-tests=error` for the reviewed acceptance suite; review fresh extraction examples separate from the development pilot. Correct meaningful failures and repeat only the affected checks plus necessary full acceptance.
- [ ] Measure approved workloads on the target machine: proposed 10,000-report/20,000-expression envelope, first-page stock/date/view queries, bounded supplier paths, cold/warm latency, memory, disk, archive retrieval and repeat-processing costs. Proposed warm p95 targets are one second for first-page reads and two seconds for the stated path workload; do not report them as achieved before measurement.
- [ ] Run native lifetime/error-path checks under address/undefined-behaviour sanitizers on the supported compiler. Benchmark Release builds separately; report Axthena-owned CPU/throughput/memory, database latency and remote API/LLM waiting time separately. Do not infer a speedup from language choice alone.
- [ ] Verify portable export/rebuild and a schema migration round trip. Retain engine/version metadata; do not rely solely on a current native file format.
- [ ] Extrapolate annual collection/model costs from measured bodies/tokens/pagination/retries. If access quality, historical fidelity or approved spend cannot support the full year, report the concrete limitation before expanding.
- [ ] Commit the validated MVP and runbook. Perform a fresh whole-change review before integration. Then carry out only the separately authorised bounded collection/processing run; no automatic purchase or trading integration.

**Done when:** one end-to-end prepared dataset is recoverable, reference queries are reproducible, performance/cost results are reported honestly, and remaining provider/version limitations are visible.

## Acceptance map

| Spec requirement | Owning tasks / evidence |
|---|---|
| Own context, typed clean model and config | 1, 4; contract tests and accepted decisions |
| Durable originals and independent download/process | 2–3; failure/retry tests |
| Grounded ideas, voice, judgment, horizon and insufficiency | 3–4; manual source review plus deterministic negative cases |
| Reversible identities/grouping and scoped external confirmation | 4; grouping/hold/reference cases |
| Source-first historical information with no future support leak | 4, 6; lineage-cutoff cases and explicit retrospective labels |
| Published-generation reproducibility | 5–7; mutation isolation, replay and restore |
| Views, dependency paths and numerical counts | 6; six query families and count/bound tests |
| Compression, query speed, cost controls and recovery | 2–3, 5, 7; measured targets and package validation |

Self-review: task interfaces use the shared type names; every substantive requirement has an owner; review-focus cases have tests; new mechanisms remain proposed; active edits, full third-party judgments, operational historical readiness and predictive ML remain outside V1. The plan is deliberately conditional until the written design and its inputs are accepted. No task has been executed.

Implementation documentation inspected for this amendment: [Ladybug C++ API](https://docs.ladybugdb.com/client-apis/cpp/), [read-only/concurrency](https://docs.ladybugdb.com/concurrency/), [CTest](https://cmake.org/cmake/help/latest/manual/ctest.1.html). [libcurl](https://curl.se/libcurl/c/) and [JSON for Modern C++](https://json.nlohmann.me/) are implementation candidates, not accepted dependencies; version/licensing/toolchain checks precede adoption. Some database source-build tooling may use Python; the Axthena application remains C++. These references do not replace target-machine verification.
