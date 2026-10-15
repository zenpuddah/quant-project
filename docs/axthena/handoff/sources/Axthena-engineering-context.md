# Axthena — engineering decisions context

**Latest owner correction — ENG-047/048 (2026-10-15):** use automated LLM communication patterned after OpenCode; manual per-article request/answer exchange is rejected. The first OpenCode source task is a small 20-article trial. Larger acquisition is later work. Read `../../automated-llm-and-20-article-pilot.md` and the full six-field records in `../../repository-handoff.md`; older proposals are historical.

Updated: 2026-10-15
Stage: Badr has expressed satisfaction with the populated fictional graph and requested a consolidated implementation handoff (ENG-044). The design, behaviour specification, acceptance tests and execution plan are now compiled for review. Real-source validation and documented contract gaps remain open. Production implementation awaits review of the specification and plan. C++ is accepted; standard, libraries, backend and other technologies remain unselected.

Historical advisory research (the new handoff reconciles later changes): [Axthena-research-catalogue-2026-10-14.md](Axthena-research-catalogue-2026-10-14.md), [Axthena-three-round-design-review-2026-10-14.md](Axthena-three-round-design-review-2026-10-14.md), and [Axthena-proposed-implementation-plan-2026-10-14.md](Axthena-proposed-implementation-plan-2026-10-14.md). They retain the accepted C++ language decision explicitly; the remaining design/technology recommendations and execution plan await Badr's review.

## Authoritative inputs

- [Axthena-context.md](Axthena-context.md): business decisions AX-001–AX-054; current content is authoritative.
- [Axthena-second-review-2026-10-13.md](Axthena-second-review-2026-10-13.md): dated review and proposed specification tasks. Its time question was subsequently resolved by AX-052.

Axthena remains separate from Qaedalus and Lexongine. Shared integration contracts must be explicit; do not import their architecture choices automatically.

## Accepted V1 boundaries carried into design

Two primary stocks, Nvidia and Microsoft, with relevant corporate organisations, suppliers, broad dependencies and competitors. Retain the game of actors, events, relationships, perspectives and observable responses.

Collect, preserve, organise, compress and query information efficiently. Use LLM-assisted supported extraction with exact evidence passages and retained processing history. Data science, predictive-model training and empirical person scoring are deferred; person vectors may use clearly labelled dummy values.

Preserve reports separately from facts and events; news can be confirmed or rumoured; opinions remain distinct; optional stock judgments are UP/DOWN. Two separately developed ideas can be extracted from a report. Shared meaning retains per-source/person expressions and reasoning. Agreement starts weak/moderate/strong.

Seek first source availability for historical source-information reads under AX-052. Retain original versions and separate collection and processing dates; later corrections and confirmations must not become earlier source content.

Views retain selected sources, interpretations and versions. Custom query mechanics, grouping, identity mappings, dependency-query limits, provider details, storage, compression, C++ standard/libraries, performance targets and numerical representation remain technical choices; API-first acquisition and the main language are already accepted.

## Accepted engineering discussion decisions

### ENG-001 — Peer design and recorded reasoning

**Later communication preference:** ENG-030 selects short numbered question batches for the current discussion, superseding the earlier one-question preference below.

Status: accepted by explicit user instruction, 2026-10-14. This is a working-method decision, not a product architecture choice.

**Decision:** Design as peers. The assistant presents concrete problems and focused questions; Badr can propose solutions and arguments. The assistant examines assumptions, counterexamples and trade-offs, and records decisions and their reasoning in this dedicated engineering context. Badr makes the final architecture decisions.

**Reason:** Develop coherent, defensible engineering choices grounded in Axthena's intended V1.

**Invariant:** Keep accepted decisions, proposals, evidence and unresolved questions distinguishable. Challenge a proposal with concrete failure cases and acknowledge when its argument holds. Do not turn an exploratory suggestion into an accepted choice. Preserve the business model and explicit V2 deferrals. Ask one focused question at a time unless the user changes that preference.

**Trade-offs:** Exploring alternatives requires discussion time; scope and first-pass usefulness must remain visible so refinement does not become endless redesign.

**Implementation scope:** Technical-design discussion and documentation only. Produce a reviewed written specification and execution plan before product implementation.

**Required tests:** Documentation checks: accepted choices have an explicit rationale, preserved requirement, trade-offs, scope and appropriate validation; pending alternatives remain labelled; choices trace back to user acceptance; no unapproved product implementation or deferred ML scope is introduced.

### ENG-002 — Article edits are separate linked evidence

**Later scope refinement:** ENG-003 explicitly defers edit handling/tracking to V2. Keep this conceptual revision idea for that iteration; its earlier V1 implementation wording below is historical.

Status: accepted by explicit user instruction, 2026-10-14. Tracking mechanism remains a proposal.

**Decision:** Treat an article's edit as separate evidence rather than overwrite the previously retained evidence. Keep the edited evidence linked to the article and preceding known version. The user also proposes a mechanism to keep track of changes; its design is not yet selected.

**Reason:** Preserve the information and changes an investigator may need to inspect over time.

**Invariant:** Old source content and its supporting passage links remain recoverable. A revised article does not become an independent originating source merely because its wording changed. Keep source-reported edit/availability times distinct from the time Axthena observes or collects the revision. Unknown earlier versions and unobserved intermediate edits must not be fabricated. Later wording must not be placed into earlier source history solely because the URL retains its original publication date.

**Trade-offs:** Additional evidence versions require storage and version selection in queries. Recording detected versions alone does not guarantee complete edit history between collections or recover an original version never obtained.

**Implementation scope:** Separate linked evidence for revisions in V1's conceptual ingestion/evidence contract. Exact article identity, change criteria, periodic rechecking, archive access, representation and compression remain open. No tracking service or product implementation is selected.

**Required tests:** After an observed edit, both known versions remain retrievable and linked; passages and derived records resolve to their own version; later wording is excluded from earlier source-version reads when its availability is unsupported; repeated unchanged input does not inflate independent publication/origin counts; source-reported change time and observation time remain distinguishable; missing original/intermediate versions are not invented.

Primary design reference: [W3C PROV-DM, revision relation](https://www.w3.org/TR/prov-dm/#term-Revision). The standard supports a relation between a revision and its predecessor; it does not select Axthena's storage or detection mechanism.

### ENG-003 — Defer edit handling to V2; explore source querying with caching

Status: edit-handling deferral accepted by explicit user instruction, 2026-10-14. Source query/cache mechanics remain a proposal.

**Decision:** V1 does not target article-edit handling or active edit tracking. Note it for V2 improvement. The user proposes that queries across sources may retrieve information and use a cache; concrete query-driven acquisition and cache behaviour are not selected yet.

**Reason:** Keep the first working version focused and allow repeated access to reuse available data without building an edit-monitoring subsystem.

**Invariant:** This later instruction defers ENG-002's edit-specific V1 scope. Its separate-evidence/revision idea remains for V2, not an unapproved V1 implementation requirement. Retain original evidence actually used for extraction, passage references, collection/source dates and processing provenance under the existing business requirements. A disposable cache alone must not erase the retained evidence behind an output. V1 does not claim a complete source-edit history or verified original wording never obtained.

**Trade-offs:** Lower collection/monitoring scope, with edits and refreshed-page historical uncertainty left for later improvement. Caching can reuse existing data, but freshness, persistence, misses and invalidation need explicit rules.

**Implementation scope:** Defer active rechecking, revision discovery and detailed edit-history handling. Discuss a source-query/cache access approach next; whether a user query triggers collection, how cache misses behave, TTL/freshness, and source-specific retrieval remain open. No cache product, API framework, crawler, automatic freshness promise or query side effect is selected.

**Required tests:** V1 retains the exact evidence used by its outputs; original passage links do not depend solely on a live URL or disposable cache entry; the reviewed specification does not introduce active edit tracking; incomplete edit history is not presented as complete; once cache/query rules are selected, test reuse, misses and retained-evidence availability against those rules.

### ENG-004 — Separate collection from read queries in V1

Status: accepted by explicit user instruction, 2026-10-14.

**Decision:** V1 performs collection and reading separately. Read queries access retained data; they do not trigger acquisition or extraction of missing source information. A combined “collect and read” operation is not the V1 query flow.

**Reason:** Establish an explicit boundary between preparing the evidence/model and inspecting stored information.

**Invariant:** An ordinary read does not silently contact external information sources or run missing-data extraction. Missing coverage must not be treated as a proven absence of events or opinions. Retained evidence, processing provenance and applicable source/time semantics remain inspectable. This boundary does not choose a database, collector technology, transport, deployment or requirement that no reads may run while collection is in progress.

**Trade-offs:** Reads avoid collection/extraction work, while a caller must perform collection separately to obtain missing coverage. Read speed and consistent publication of prepared data still need concrete contracts.

**Implementation scope:** Separate V1 collection/preparation operations from stored-data query operations. Exact collector inputs, internal processing stages, readiness/completeness reporting, cache behaviour and scheduling remain open. The user's preceding suggestion that behaviour can depend on query type remains a possible later extension, not a combined V1 query.

**Required tests:** A read over an uncollected stock/date range triggers no external acquisition or extraction; reads over retained data return the supported stored records; missing coverage remains distinguishable from a collected empty result under the eventual response contract; repeated reads do not duplicate source mentions or processing work; collection can subsequently supply data for a separate read.

### ENG-005 — Keep a collection marker to explain empty reads

Status: accepted design direction, 2026-10-14. Exact marker fields, granularity and response policy remain open.

**Decision:** Keep a record or marker of collection so a read can be interpreted against what collection actually did. The user suggested “we may mark the collection or something like this.” This accepts the collection-marker direction without selecting its representation.

**Reason:** An empty read alone does not explain whether the requested information was collected, collection failed, or the retained information simply does not match the query.

**Invariant:** Collection outcome and query match outcome remain distinguishable. A marker reports only the collection work and coverage it can substantiate; it does not prove that no relevant information exists outside that coverage. Do not infer collection success or failure solely from a filtered read returning zero matches. The user's earlier statement that nothing found means something went wrong has not yet been resolved into a universal error policy.

**Trade-offs:** A collection record adds bookkeeping and needs scope and status rules. A single broad success marker could hide failures affecting individual sources or periods.

**Implementation scope:** V1 collection bookkeeping and its visibility to reads. Exact source/time scope, completion, partial failure, processing readiness, counts and empty-result response behaviour remain to be designed. No product implementation or technology is selected.

**Required tests:** Once the marker contract is selected, distinguish a successfully collected packet with no matching UP judgments from a collection failure and a range never collected. Do not mark missing source coverage as successful merely because another source succeeded. Confirm that reads remain separate from collection under ENG-004.

Discussion evidence: ten successfully collected articles can all contain DOWN judgments; a read filtering for UP then has no matches. This is a counterexample to inferring collection failure from every empty filtered result. It does not settle the user's preferred response policy.

### ENG-006 — Separate operational metadata from the stock-information model

Status: accepted by explicit user clarification, 2026-10-14. Physical storage and readiness rules remain open.

**Decision:** Keep news and the other stock-information concepts cleanly represented in the domain data model. Collection bookkeeping belongs in separate operational metadata. Query planning/execution may consult or expose that metadata; its precise role there remains a proposal.

**Reason:** Information about an article, event or opinion has a different meaning from information about an operation that collected or processed it.

**Invariant:** Collection failure, missing coverage and execution status must not be represented as invented news, events, facts or opinions. Keep each retained information record faithful to its evidence and preserve the already accepted source, identity, time, passage and derivation traceability. Operational separation does not remove evidence provenance. Reads still do not trigger collection under ENG-004. “Representative” is understood here as faithful representation of the collected evidence; statistical representativeness of the wider information world is neither established nor promised.

**Trade-offs:** Readers may need to consult separate operational metadata to interpret missing results. Clean domain records alone do not establish complete collection coverage or successful processing of every source.

**Implementation scope:** Logical separation of the V1 stock-information model and operational collection/processing/query metadata. This refines ENG-005's collection-marker location, without choosing separate databases, tables, services or a metadata format. Exact response policy, granularity and conditions for publishing processed records remain open.

**Required tests:** A collection failure does not create or alter a news/event/opinion record to express that failure; retained news keeps its evidence and time links; a read can distinguish supported records from operational coverage information under the eventual response contract; metadata separation does not silently claim full source coverage or remove traceability; reads remain separate from collection.

### ENG-007 — Retain acquired evidence when extraction fails

Status: accepted by explicit user agreement, 2026-10-14.

**Decision:** If article acquisition succeeds but AI extraction fails, retain the original acquired evidence. Keep unfinished extraction outside the structured news model. A later extraction attempt can reuse the retained evidence rather than acquire the article again.

**Reason:** Avoid repeating scraping or source API calls just because downstream extraction failed. Preserve useful acquired evidence independently of processing success.

**Invariant:** Acquisition success and extraction success remain distinguishable. Failed or unfinished extraction must not appear as a successfully prepared news record. Retained source evidence remains recoverable with its source and time information; later successful extraction points to that evidence and its own processing history. Retrying extraction does not create a new originating publication. This decision reduces avoidable source acquisition work; it does not make repeated LLM calls free or guarantee their cost.

**Trade-offs:** Retaining evidence requires storage and tracking of processing attempts. Reusing it saves unnecessary source requests but repeats extraction work when retried. Automatic retry schedules, limits and readiness validation still require design.

**Implementation scope:** V1 acquisition retains reusable original evidence independently from successful publication of structured extraction. Failure bookkeeping stays in operational metadata under ENG-006. Storage, cache lifetime, retry mechanism, extraction validation and treatment of a partially successful multi-idea extraction are unselected. No product implementation is started.

**Required tests:** An extraction failure leaves acquired evidence intact and produces no completed structured news record from that failed attempt; a later successful extraction can use the same retained evidence without another source request; derivations resolve to their exact evidence and processing attempt; retries do not inflate publication counts; source acquisition and LLM processing costs remain distinguishable in any eventual accounting.

### ENG-008 — Prefer a very low acquisition budget for one year of evidence

Status: budget preference accepted by explicit user instruction, 2026-10-14. Provider, exact dates and budget scope remain open.

**Decision:** Explore collecting one year of relevant evidence at zero or minimal cost. Prefer spending less than USD 20; USD 50 is acceptable, and the user may tolerate USD 100 if justified. These are acquisition-budget preferences, not authorisation to purchase a subscription. Whether the amounts also include LLM extraction, compute and storage remains to be clarified.

**Reason:** Obtain a useful first historical dataset without unnecessary subscription or collection expense.

**Invariant:** Price alone does not establish adequate source coverage, full original article text or historical version fidelity. Preserve evidence and traceability requirements. No provider or source packet is accepted merely because documentation advertises affordable access. Do not confuse one year of historical data with twelve months of paid access, or imply a recurring spending commitment.

**Trade-offs:** Free access can impose throughput, coverage and historical limits; paid access may reduce acquisition effort but still needs evidence-quality checks. A source-selection view remains explicit and does not claim to represent all news or social discussion.

**Implementation scope:** Source feasibility and budget comparison during design only. Specific historical dates, acquisition path and providers remain unselected. No acquisition pipeline, account creation, subscription purchase or implementation is authorised by this budget discussion.

**Required tests:** Before provider selection, inspect a bounded sample for the selected stocks and period; verify actual text, dates, original links and suitable retained-evidence references; estimate pagination/request allowance and costs; identify what the budget includes; check that the intended retention and use fit the provider's terms. These checks have not yet been run against authenticated provider data.

### ENG-009 — Analyst prepares the initial surrounding-world configuration

Status: accepted by explicit user agreement, 2026-10-14.

**Decision:** For V1, let the analyst prepare the initial collection configuration for the companies' relevant suppliers, resources and topics. The analyst may use AI or other research assistance to obtain that information. V1 is a useful MVP and need not provide a fully automated process that discovers and maintains this configuration.

**Reason:** Keep collection relevant to the selected stocks without making automatic discovery of their entire surrounding world a prerequisite for the first useful version.

**Invariant:** Preserve relevant conflicts, disasters, energy/material inputs, suppliers and competitors in the intended stock-related scope. An analyst-prepared list bounds collection; it does not establish completeness or prove every proposed dependency. AI-assisted suggestions are not automatically confirmed facts. Keep source assertions, supported relationships and interpretations distinguishable under the business model. Reads and collection remain separate. This decision does not remove LLM-assisted extraction or prohibit automated fetching and processing within an explicitly configured run.

**Trade-offs:** Analyst work is required to initialise and adjust coverage; omissions and outdated choices can miss relevant evidence. A smaller explicit configuration makes the first pass more manageable and understandable.

**Implementation scope:** V1 consumes an analyst-prepared initial configuration. Automatic discovery, expansion and maintenance of suppliers/resources/topics are not V1 requirements. The exact format, fields, relationship evidence, source selection and whether articles are fetched by Axthena or imported remain open. No implementation is started.

**Required tests:** A configured supplier/topic can provide relevant evidence even when the report does not name the primary stock; the selected configuration and its changes remain traceable under the eventual version contract; AI suggestions do not silently become confirmed relationships; a bounded first run can operate without automatic configuration discovery; coverage is described relative to the analyst's configuration rather than as the whole information world.

### ENG-010 — Axthena downloads first; processing can be iterated independently

Status: accepted by explicit user agreement, 2026-10-14.

**Decision:** V1 Axthena acquires articles from configured sources itself, beginning with a news API, rather than require the analyst to download every article externally. Download and retained evidence come first; processing is a separate stage that can be improved and rerun against that retained material.

**Reason:** The user wants to iterate on processing even when initial download results are imperfect, while avoiding unnecessary repeated acquisition.

**Invariant:** Keep the exact acquired evidence independently of derived results and preserve processing history under existing requirements. Failed or unfinished extraction stays outside the completed structured model under ENG-007. Acquisition quality and extraction quality are separate concerns: repeated processing can improve interpretation but cannot establish source text or evidence that was never obtained. “Bad download results” is not yet defined as a specific quality or failure policy. Ordinary read queries remain separate from these stages.

**Trade-offs:** Direct acquisition requires a source-specific client and operational failure handling. Retained imperfect material supports processing experiments but may constrain useful extraction. Independent reruns require traceable attempts and a later rule for which successful output a read selects.

**Implementation scope:** V1 configured API acquisition, persistent retained evidence and separately invocable processing. Exact API/provider, article acceptance criteria, retries, rerun controls, output selection and processing validation remain unselected. Beginning with one API does not establish that it covers all relevant surrounding-world information; supplementary sources remain a later scope/design choice. External-file import is no longer the selected first entry path, and is not required by this decision. No implementation begins before reviewed specification and plan.

**Required tests:** A configured acquisition obtains and retains its source response/evidence; processing can rerun against it without another source request; changing processing produces traceable derived output without changing original evidence; acquisition failure and processing failure remain distinguishable; incomplete source material is not silently presented as a verified full original article; reads do not invoke acquisition or missing-data processing.

### ENG-011 — Encode explicit rules for insufficient information

Status: accepted by explicit user correction, 2026-10-14. Required-information rules and their granularity remain open.

**Decision:** Encode explicit rules that recognise when information is insufficient for the intended processing result. Use this general adequacy contract rather than a special case centred on headline-only downloads.

**Reason:** Keep retained evidence useful for iteration while preventing unsupported or incomplete processing from entering the clean structured model as a completed result.

**Invariant:** Preserve acquired evidence under ENG-007/ENG-010. Missing required evidence must not be replaced by invented information. Keep an understandable reason for an insufficiency finding, distinguish it from acquisition/processing failure and from ordinary query no-matches, and keep operational quality status separate from invented domain records under ENG-006. Optional information remains optional: absence of an explicit UP/DOWN judgment alone does not invalidate a usable report. Already accepted marked dummy values/default horizons are not silently prohibited by this rule. Insufficient information is not automatically rumoured news, an externally confirmed fact, or a conflicting-confirmation hold.

**Trade-offs:** Explicit criteria improve consistency but need definitions for the intended output; criteria that are too strict discard usable evidence, while criteria that are too loose admit unsupported results.

**Implementation scope:** V1 explicit insufficiency recognition and reason recording within the processing/validation contract. Exact required fields, evidence checks, representation, review/retry behaviour and whether decisions apply to an entire report, extracted idea or individual derived record remain unselected. No particular parser, validation library, LLM self-score or threshold is chosen. No implementation starts.

**Required tests:** Missing required evidence produces an insufficiency finding with a reason instead of fabricated completed output; original evidence remains retrievable; a report without a stock-direction judgment can still be valid; already permitted labelled dummy/default values retain their accepted meaning; insufficiency is distinguishable from operational failure and confirmation conflict. Once granularity is selected, test a report containing one supported idea and one idea lacking required information.

Discussion correction: the user rejected the assistant's headline-specific framing and requested general encoded insufficiency rules. The previous headline-only question is superseded; no headline-only acceptance policy was decided.

### ENG-012 — V1 runs on the analyst's own computer

Status: accepted by explicit user instruction, 2026-10-14.

**Decision:** Run V1 on the user's own computer. Access from other machines is not required for this iteration.

**Reason:** Keep the first useful MVP focused on the analyst's local use.

**Invariant:** Persistent evidence, structured stock-information records, separate operational metadata, configurable behaviour and human/program access remain required. A local application can still call external source APIs and hosted LLMs; “on my computer” does not establish offline-only operation or a local-only model requirement. Do not import cloud or remote-user requirements into V1.

**Trade-offs:** Local hardware and disk capacity constrain throughput and dataset size. Local operation removes the need for a remote deployment for V1 but does not itself provide backup/recovery or choose the query interface.

**Implementation scope:** Local V1 runtime and local persistent storage. No required remote deployment or cross-machine serving. Exact operating-system targets, database, language, interface, process layout, concurrent use and recovery mechanism remain unselected. No product implementation starts.

**Required tests:** The eventual V1 installation and collection/processing/read workflow operate on the user's machine; retained evidence and model data survive application restart; ordinary stored-data reads need no remote Axthena service; source and model network calls follow their separately configured roles. Verify backup/recovery and hardware/performance against the eventual selected contracts.

### ENG-013 — Defer concurrent reads during collection/processing to V2

Status: accepted by explicit user instruction, 2026-10-14.

**Decision:** V1 does not require querying existing data concurrently with collection or processing. Defer that concurrent-use requirement to V2.

**Reason:** Reduce first-pass runtime coordination and storage requirements for the local MVP.

**Invariant:** Preserve the separate collection, processing and read operations already accepted. V1 does not promise concurrent read/write behaviour or a consistent live view while preparation is running. The deferral does not itself choose a database, locking mechanism, transaction mode, crash-recovery policy or internal extraction concurrency. Do not interpret it as requiring existing stored data to be erased before a new run.

**Trade-offs:** The analyst may need to wait for preparation to finish before using the supported read workflow. V2 will need a deliberate contract for reading while data is being prepared.

**Implementation scope:** V1 supported workflow prepares data and then reads it. Concurrent querying during collection/processing is outside required V1 behaviour. Exact operational handling of an attempted overlapping read remains to be specified. No product implementation starts.

**Required tests:** The sequential acquisition/processing/read workflow works on retained data; reviewed V1 requirements do not promise concurrent live reads; interruption/recovery still preserve earlier retained evidence and completed records under the eventual recovery contract. V2 concurrent-read tests are deferred.

### ENG-014 — Note collection decisions for future consumer integration

Status: present workflow reaffirmed; future integration scenario noted by explicit user instruction, 2026-10-14. Trigger and mechanism are unselected.

**Decision:** For now, collect/prepare first and query when done. Record a future design consideration: when Qaedalus and Lexongine consume Axthena, they may need to decide whether another collection is useful because newer information could help.

**Reason:** The current local MVP can use prepared data; later integrated consumers may need to refresh their information rather than rely indefinitely on the same collected packet.

**Invariant:** This does not introduce concurrent live reads or query-triggered acquisition into V1. A future collection request is distinguishable from an ordinary read. New evidence and derived outputs retain their real source and processing times; a refresh does not retroactively change what was available for a historical decision. New information being potentially useful is a motivation to investigate, not proof of predictive improvement. Keep Axthena separate from the consumers' architecture.

**Trade-offs:** Future refresh decisions will balance freshness, relevant coverage, acquisition/LLM cost and reproducibility. Refreshing on every read could add avoidable cost; indefinitely reusing stored information could leave consumers with missing newer evidence.

**Implementation scope:** Record the future consumer-driven collection scenario for later integration design. No refresh trigger, cadence, cost rule, automatic discovery, orchestrator, concurrent-read protocol or consumer integration is implemented or chosen in V1. Whether the future consumer requests a run or advises the analyst remains open.

**Required tests:** V1 preparation completes before its supported read workflow; ordinary reads do not initiate source collection. Later integration tests must cover the selected refresh decision rule, separate collection/read actions, retained earlier outputs, accurate new-evidence timestamps and observable costs/coverage. Those integration tests are deferred.

### ENG-015 — Three autonomous research and design iterations

**Repository editorial notice:** This record is an abridgment of the accepted historical instruction. Non-technical personal-study wording is omitted; technical substance is retained. This is not a newly accepted decision. The original wording is preserved outside this repository edition and identified by the original manifest.

Status: accepted by explicit user instruction, 2026-10-14. Working-method decision; technical recommendations remain unaccepted.

**Decision:** Reduce slow micro-questioning by researching similar open-source systems first, then authoritative CS/ML/statistics work, graph theory, computation optimisation, compilation and creative scientific analogies. Compile reusable referenced summaries; reconcile all current Axthena context; use explicit engineering principles and the owner's preferred reasoning method; carry out three successive loose-idea, plausible-combination and evidence-grounded design iterations. Give confident recommendations with reasons and a detailed proposed plan; isolate uncertainty for owner review.

**Reason:** Progress faster while retaining depth, coherent arguments and inspectable engineering reasoning.

**Invariant:** Evidence, analogies, hypotheses, proposals and accepted decisions remain distinguishable. Badr makes the final architecture decisions. Do not import another project's architecture or start product implementation before reviewed specification and plan. The latest research request permits coherent autonomous design/reporting rather than a question after every small point; focused owner questions resume for unresolved decisions.

**Trade-offs:** Independent research can produce competing recommendations; reconciliation and counterexamples are necessary. Literature cannot establish provider sample quality, Axthena extraction accuracy or comparative runtime performance. Scientific analogies suggest structures, not software proofs.

**Implementation scope:** Research and documentation only. The catalogue has 45 entries: 40 reviewed public research/documentation entries with stated depth, three bibliographic leads, and two personal reasoning inputs. Three design rounds and independent final critiques produced R-01–R-06 and a conditional seven-task implementation plan. No database was installed, source subscription bought, product code written or runtime benchmark run.

**Required tests:** Documentation verification: all proposal IDs resolve; accepted AX/ENG scope and V2 deferrals remain intact; reference links and review-depth limits are present; [non-technical study-source check omitted]; no proposed backend/language/limits are labelled accepted. Eventual implementation tests are listed by R-01–R-06 and the plan, not claimed executed here.

### ENG-016 — C++ for CV value and performance

Status: accepted by explicit user instruction, 2026-10-14. Supersedes the assistant's Python implementation-language proposal; does not accept the database or the rest of the proposed plan.

**Decision:** Use C++ as Axthena's main application language. Badr's stated motivations are CV value and performance.

**Reason:** Make the project's substantive engineering visible in C++ and support efficient local processing and query-result handling. Performance is a goal to measure, not an established speedup from the language choice.

**Invariant:** The main collection, processing, validation, storage-integration and query application is implemented in C++. Preserve the evidence/game model, historical semantics, separate preparation/read workflow and no-implementation-before-review rule. Do not reduce the project to a token C++ wrapper around a Python application. Do not import Qaedalus/Lexongine architecture choices. Language acceptance does not establish database selection or reduced hosted API/LLM latency.

**Trade-offs:** More explicit parsing, validation, resource ownership, linking and error handling than the previous Python/Pydantic proposal. Hosted service waiting time and the already-native database engine may dominate some workloads; benchmark stages separately. Native-library build/packaging compatibility requires a target-machine check.

**Implementation scope:** Revise the proposed specification and implementation plan for a C++ main application, typed domain structures, native graph adapter and C++ tests. C++20, CMake/CTest, particular JSON/HTTP/compression libraries and Ladybug remain recommendations rather than newly accepted technologies. A database dependency may need auxiliary build tooling; this does not make Python the application language. No product code or dependencies are created/installed during this decision.

**Required tests:** Native C++ build and contract/provenance replay; resource-lifetime and owned multirow query-result checks; read-only enforcement; graph/archive recovery; local CPU/throughput/memory and cold/warm query benchmarks, reported separately from source/model network waiting time. No performance result is claimed yet.

### ENG-017 — Review a populated Cypher model before proceeding

Status: accepted by explicit user instruction, 2026-10-14. Establishes the immediate sequence; does not accept the proposed graph schema or a database.

**Decision:** Provide a Cypher representation with populated data and review queries to test Axthena's data model before doing or considering subsequent design/implementation work.

**Reason:** Badr wants to inspect concrete entities, ideas, source statements, evidence and links before trusting further architecture reasoning. A populated scenario exposes ambiguities that a list of abstractions can hide.

**Invariant:** Preserve the accepted business distinctions and evidence/time semantics. The fixture is a review artifact, not product implementation, production database selection or permission to execute the previously proposed implementation plan. C++ remains the main application language. All invented data must be explicitly marked; model-specific auxiliary nodes and query choices remain proposals.

**Trade-offs:** A fictional scenario can deliberately exercise opposing opinions, conflicts and delayed dependency knowledge, but cannot establish real source coverage, extraction accuracy, runtime performance or predictive usefulness. Static fixture validation does not replace running Cypher in an actual engine.

**Implementation scope:** Create the standalone `AxLab` fixture loader, read-only review queries and walkthrough. Use the fictional NovaChip world alongside the earlier separate real-report example; do not change the accepted NVDA/MSFT target universe. No collector, application, product schema migration, new database installation or benchmark work.

**Required tests:** Check explicit identities, all relationship endpoints, exact passage offsets and original-text hashes; shared ideas with independent source/person expressions; issuer/subsidiary/supplier distinctions; separate announcement/production occurrences; scoped confirmations and conflicts; anonymous-account identities; explicit UP/DOWN judgments and missing timing; source-cutoff eligibility for all dependency/confirmation supports; selected-source views and noncausal dummy prices. Runtime loader/query acceptance and Badr's semantic review remain outstanding until the lab is run and inspected.

### ENG-018 — Clarified creation-time shared meaning and direct opinion views

Status: desired behaviour clarified explicitly by Badr, 2026-10-14; technique, identity rules, model, thresholds, time window and physical index remain unselected.

**Decision:** Retain original data and each source Expression. During processing, seek an existing shared Idea for equivalent meaning rather than create redundant meaning records automatically. Support an opinion view over the configured market/universe through prepared direct lookups rather than repeatedly discover it through subsidiaries. This carries forward AX-024/AX-032/AX-049 and clarifies when grouping should occur.

**Reason:** Reduce repeated derived meaning and repeated query traversal while preserving who expressed each statement, its precise evidence, agreement and dates. Badr proposes time proximity and other metrics/factors for candidate matching and requests benchmark-backed research.

**Invariant:** Original statements and per-source identities remain recoverable. Shared topic/time/direction alone does not establish equal opinions; accepted differences in reason, stated period, scope and direction remain distinguishable. Grouping belongs to preparation; ordinary reading stays separate under ENG-004. Market views retain configured source/universe selection and historical eligibility. A classifier cannot confer external fact confirmation. C++ remains the main application language.

**Trade-offs:** Candidate lookup can reduce expensive comparisons, while missed candidates fragment shared meaning and false matches contaminate groups/metrics. Index/model/verification cost must be measured separately. Published story/claim/retrieval benchmark scores do not establish Axthena opinion-equivalence precision.

**Implementation scope:** Research and reviewed mechanism proposal only. Preserve the existing fixture and live graph. Candidate retrieval plus a stricter admission check, singleton fallback, versioned memberships and direct opinion postings are proposals; no backend, model, threshold or index is adopted.

**Required tests:** Equivalent paraphrases reuse one meaning while retaining separate expressions/publications/accounts; opposite directions, different reasons/scopes/stated periods stay separate; candidate time proximity does not erase forecast anchors; uncertain or insufficient meaning is handled explicitly; repeated acquisition is idempotent; direct market reads count eligible source identities and respect view/cutoff/grouping revisions; later merges/centroids/counts are not backdated; model/index/verification quality and cost are evaluated separately.

### ENG-019 — Consistent organisation identity before idea classification

Status: V1 requirement and V2 deferral stated explicitly by Badr, 2026-10-14; matching mechanism and broader name-variation rules remain unselected.

**Decision:** Resolve case variants such as "NovaChips" and "novachips" to the same organisation identity before organisation-based candidate filtering and idea classification. Distinguishing unrelated organisations with the same name is deferred to V2.

**Reason:** Organisation-based narrowing reduces the search space, but duplicated organisation identities would split related opinions and undermine that filter.

**Invariant:** Preserve original article wording. Organisation identity does not establish equivalent opinions. Organisations, subsidiaries and stocks remain distinct. The V2 deferral does not establish globally unique legal-entity names.

**Trade-offs:** V1 uses a simpler configured universe. Case normalisation alone does not resolve spacing variations, abbreviations, translations or misspellings.

**Implementation scope:** Discovery and documentation only. A stable organisation record with recognised-name lookup is a proposal, not a selected schema or automatic entity-merging algorithm. Same-name disambiguation is noted for V2; fixture and application remain unchanged.

**Required tests:** Case variants resolve to one configured organisation and candidate lookup; retain original spellings; repeated processing creates no case-only duplicates; parents and subsidiaries stay distinct; unrecognised/ambiguous names follow the eventual explicit handling rule.

### ENG-020 — Separate organisation candidate retrieval from AI identity decisions

**Later selection:** ENG-024 chooses union for the V1 organisation shortlist and retains both method outputs/intersection membership for V2 evaluation. The initial unselected combination below is historical.

Status: separation and V2 evaluation direction explicitly selected by Badr, 2026-10-14. Initial set-combination rule and concrete retrieval technologies remain unselected.

**Decision:** Given an AI-proposed organisation name, run name-similarity and vector/semantic retrieval separately against the existing organisation base. Combine their candidate identity sets using union or intersection under a rule still to be chosen. The AI makes the identity-match decision using the shortlist and supporting context. Maintain comparative benchmark results over time to choose or refine the mechanisms in V2; benchmark timing and corpus remain unselected.

**Reason:** Reduce the search space without supplying the full organisation/suborganisation directory to the AI. Use complementary retrieval signals and retain their separate outputs for comparison.

**Invariant:** Retrieval membership does not establish identity. Union/intersection operate on existing organisation IDs, retaining which methods retrieved each candidate. AI decisions remain source-traceable interpretations. Preserve original names/evidence and organisation/subsidiary distinctions. Automatic new-organisation creation and uncertain-match handling remain open; same-name disambiguation remains deferred under ENG-019.

**Trade-offs:** Union retains candidates found by either method and can increase AI work. Intersection is narrower but excludes a valid match missed by either method; it does not guarantee better identity precision. Quality depends on retrieval coverage and AI comparison. Maintaining benchmarks adds work; method refinement/selection is intended for V2.

**Implementation scope:** Discovery/documentation only. No index, embedding, model, shortlist size, threshold or initial union/intersection policy is selected. Fixture and application remain unchanged.

**Required tests:** Union includes both methods' candidates once per identity; intersection includes only shared identities; retain retrieval origins; AI reuses the chosen existing ID while preserving source wording; empty/uncertain candidates do not silently force a fabricated identity. V2 evaluation separates shortlist coverage, final identity errors, candidate counts, latency and cost.

### ENG-021 — Reusable source-expressed reasons for judgments

**Later scope refinement:** ENG-022 defers dedicated reason/thought-process modelling and reuse to V2. Preserve this concept for that iteration; it is not a V1 implementation requirement.

Status: accepted by Badr, 2026-10-14, conditional on equivalent expressed reasoning. Exact representation and treatment of AI-inferred reasons remain open.

**Decision:** Represent a judgment's reason as a separately reusable Idea when multiple source expressions articulate equivalent reasoning. Their individual judgments can refer to that shared reason. Keep what is reported as happening distinguishable from the reason offered for an UP/DOWN judgment.

**Reason:** Reduce repeated reasoning records and expose which judgments use the same argument while retaining their independent sources.

**Invariant:** Equivalence concerns articulated reasoning, not proof of identical private thought processes. Retain each person's/source's judgment, agreement, period, passage and dates. Shared reasoning does not establish equal complete opinions, truth, independent corroboration or causality. Materially different premises, conditions, conclusions or reasoning chains remain distinguishable.

**Trade-offs:** Shared reasons support compact storage and direct exploration, but overly broad grouping can erase important differences. Reason extraction and identity comparisons add processing work. Actual storage/performance effects remain unmeasured.

**Implementation scope:** Discovery/documentation only. Reason reuse is accepted; identifiers, links, matching thresholds and multi-premise representation remain unselected. Whether AI may infer an unstated reason is a separate open question. No fixture, database or application changes.

**Required tests:** Equivalent reason paraphrases reuse one reason while retaining separate judgments and exact source passages; different premises/conditions/reasoning remain separate; common organisation/domain/direction alone does not merge reasons; sharing a reason does not merge individual judgments or erase their periods/strengths; no absent reason is presented as source-expressed; retain processing and grouping history.

### ENG-022 — Keep stock judgments in V1; defer reason/thought-process modelling to V2

Status: explicit scope correction by Badr, 2026-10-14.

**Decision:** V1 keeps the UP/DOWN stock judgment. Dedicated modelling, extraction, matching and reuse of reasons/thought processes are deferred to V2. This refines ENG-021's scope.

**Reason:** Focus V1 on useful stock information and judgments while evaluating whether the proposed architecture adds enough value to justify its complexity.

**Invariant:** Preserve original evidence and source/person judgments, expressed timing, agreement and processing provenance. Source text may contain reasoning; the deferral does not require deleting or distorting it. It does not defer traceability of AI processing or turn AI interpretations into facts.

**Trade-offs:** Less V1 extraction/grouping complexity, with dedicated argument comparison and shared reason exploration unavailable until a later iteration.

**Implementation scope:** Discovery/documentation only. Remove dedicated reason/thought-process work from the intended V1 implementation scope. Retain ENG-021 as a V2 concept. Existing fixture and original evidence remain unchanged.

**Required tests:** V1 can retain/query supported UP/DOWN judgments and their passages without requiring a reason record; original wording remains recoverable; missing reasons do not invalidate otherwise supported judgments; no dedicated reasoning-chain extraction/matching is required by the V1 specification; AI-processing provenance remains available.

### ENG-023 — Preserve the early research direction for later return

Status: Badr requests recording the assessment and future path in general context, 2026-10-14; no product implementation or adaptive algorithm is selected.

**Decision:** Save Axthena's possible V2 research direction in the general context and continue focused V1 design. The relevant assessment is whether this very early direction warrants investigation, not whether the project already has a proven edge.

**Reason:** Badr likes the direction and may return to it in a later phase of life. Preserve the argument and sources so the conversation can resume without reconstructing them.

**Invariant:** Existing retrieval and LLM extraction techniques remain prior art. A credible problem and testable cost/quality hypothesis do not establish originality, performance superiority or predictive value. Reasons/thought processes remain V2 under ENG-022. No future research idea expands V1 automatically.

**Trade-offs:** A staged research path can reveal improvements; premature abstraction can delay useful delivery. A simple baseline may establish that some custom machinery is unnecessary.

**Implementation scope:** Save general-context AX-053/AX-054 and the future research note. Candidate adaptive checks/budgets/verification are hypotheses for later review. No reminder, schedule, new model, index, framework or execution plan is authorised by this note.

**Required tests:** Preserve accepted versus proposed status; future comparison uses the same reviewed workload/baselines and records quality, damaging merges, cost and latency; technical novelty receives separate prior-art review; V1 scope and evidence remain intact.

### ENG-024 — Use union in V1 and retain intersection membership for V2 evaluation

**Later selection:** ENG-025 chooses automatic organisation creation after a no-match AI decision. Uncertain-comparison handling remains open.

Status: explicitly selected by Badr, 2026-10-14; applies to the organisation shortlist currently under discussion.

**Decision:** Run both name-similarity and semantic/vector candidate retrieval. Supply their union to the AI for the V1 identity decision. Retain each method's candidate set and whether each candidate belongs to their intersection so later V2 evaluation can compare the methods and combination rules.

**Reason:** Preserve candidates found by either method while collecting comparison data rather than discarding information from the alternative intersection rule.

**Invariant:** Sets contain organisation identities, not only spelling strings. Deduplicate the union by stable identity; retain the separate retrieval signals. Intersection membership is not proof of identity, correctness or confirmation. AI decides the match. Evidence, matching configuration/model versions and actual processing history remain traceable. Automatic creation and uncertain/no-match handling remain open.

**Trade-offs:** The union can increase shortlist size and AI comparison work; intersection would be narrower and could miss matches retrieved by only one method. Stored retrieval overlap helps evaluate alternatives but is not itself a labelled accuracy benchmark.

**Implementation scope:** Discovery/documentation only. Select the V1 union rule and retain both method outputs/intersection indicators for later review. Concrete indexes, models, shortlist limits, score cutoffs, storage format and reviewed benchmark cases remain unselected. No fixture or application changes.

**Required tests:** Name-only and semantic-only candidates reach the AI; a shared candidate appears once with both-method membership; intersection equals the identities present in both sets; an empty method leaves the other method's candidates intact; both-empty and uncertain decisions follow the eventual explicit policy; V2 evaluation distinguishes candidate coverage, reviewed identity correctness, shortlist size, cost and latency.

### ENG-025 — Automatically create an organisation after AI finds no match

**Later clarification:** ENG-026 keeps creation automatic when AI selects no existing organisation, including uncertain identity comparisons, with uncertainty retained. The open uncertainty policy below is historical.

Status: explicitly selected by Badr, 2026-10-14. Handling uncertain comparisons remains open.

**Decision:** After candidate retrieval and AI comparison, if the AI finds no matching existing organisation, automatically create a new organisation record without requiring personal confirmation.

**Reason:** Let the preparation pipeline resolve incoming organisation mentions without a manual approval step for every new organisation.

**Invariant:** Preserve the original mention, supporting source passage, new identity and AI decision/provenance. A matched organisation reuses its existing identity. No-match concerns the examined candidates and is not proof that the entire base contains no equivalent organisation. Creating an organisation does not confirm source claims about it. Source/extraction failures and uncertain comparisons remain distinct from a no-match decision. Main stock universe and same-name V2 deferral remain unchanged.

**Trade-offs:** Removes routine manual work but can create duplicates when retrieval misses an existing organisation or AI comparison is wrong. Retained retrieval signals and decision history support later review/correction; a duplicate-free guarantee is not established.

**Implementation scope:** Discovery/documentation only. Select automatic creation for the no-match outcome and make the new record available to subsequent identity lookup. Concrete ID allocation, validation, index updates, retry consistency and uncertain-result handling remain to be designed. No fixture, database or application changes.

**Required tests:** A supported new organisation with no matching candidate is created without personal confirmation; subsequent equivalent mentions can reuse it; matched mentions create no second organisation; repeat processing does not duplicate the same successful creation; retain exact source and decision history; retrieval/extraction failure is not silently interpreted as no-match; uncertain comparisons follow a separately selected policy.

### ENG-026 — Automatic creation when no existing organisation is selected

Status: Badr reiterates automatic creation in response to the uncertainty/review question, 2026-10-14. This clarifies ENG-025 for organisation matching.

**Decision:** If AI selects a matching existing organisation, reuse its identity. Otherwise create a separate organisation record automatically, including when the identity comparison remains uncertain; do not require personal confirmation to continue this step.

**Reason:** Keep organisation preparation automatic rather than introduce a manual queue for ambiguous identity comparisons.

**Invariant:** Retain the source mention, candidate sets, matching decision and any uncertainty with the resulting record. Automatic creation does not establish a verified distinct real-world entity, confirm source claims, or erase possible alternative identities. Retrieval/extraction/tool failure remains distinct from a completed identity decision. Existing external fact-confirmation and conflicting-confirmation review rules are unaffected.

**Trade-offs:** Avoids forced merges and manual blocking, but can create provisional duplicate representations. Retained history supports later correction; automatic duplicate reconciliation is not selected as a V1 feature.

**Implementation scope:** Discovery/documentation only. Clarify organisation-creation behaviour; exact uncertainty metadata, IDs, validation, index updates and retry handling remain unselected. Do not generalise this into automatic factual confirmation or override the reasons/thought-process V2 deferral. No application or fixture changes.

**Required tests:** A selected existing identity is reused; no selected identity leads to automatic creation without personal confirmation; uncertain matching remains visibly uncertain after creation; exact source and alternative candidates remain recoverable; processing failure does not create an organisation as if comparison completed; retries do not duplicate the same successful creation.

### ENG-027 — Manually selected two-stock evidence view

Status: Badr agrees to the V1 proposal and manual selection, 2026-10-14. Concrete pair, representation and query interface remain unselected.

**Decision:** Let the investigator manually select two stocks and view their retained evidence together: information concerning either company and supported shared events, competition or dependencies connecting them. Preserve a joint source statement while keeping each stock's supported UP/DOWN judgment and period identifiable.

**Reason:** Investigate information that may matter to a relative-price/pairs hypothesis, including developments that could affect the two companies differently.

**Invariant:** A selected pair is a query choice, not proof of a suitable trading relationship or expected convergence. Source claims, supported world relationships and inferred relevance remain distinguishable and dated. Retain original author, passages, source selection and independent expressions. "A outperforms B" alone does not imply A UP and B DOWN. Axthena supplies evidence; Qaedalus evaluates prices/predictive usefulness and Lexongine handles strategy composition under future explicit integration contracts. Reasons/thought processes remain V2.

**Trade-offs:** Makes related evidence accessible with a small query extension, while pair suitability and spread interpretation require separate price analysis. Shared co-mention alone is not a supported business relationship or causal effect.

**Implementation scope:** Discovery/documentation only. Manual two-stock query over retained/configured coverage; ordinary reads remain separate from acquisition. No automatic pair discovery, spread/trading computation, new prediction label, Pair node, production schema or changed primary universe is selected. Existing fixture remains unchanged.

**Required tests:** First-only, second-only and genuinely shared evidence can be distinguished; shared reports are not duplicated solely because they concern both stocks; retain per-stock source-supported directions/periods, roles and exact passages; relative-only claims generate no fabricated absolute UP/DOWN judgments; respect view/source-cutoff eligibility and no collection side effects; selecting two stocks makes no trading/causality assertion.

### ENG-028 — Different anchored forecast windows keep Ideas separate

Status: explicitly selected by Badr, 2026-10-14; refines AX-027 and resolves the relative-horizon case discussed in P-011/P-015.

**Decision:** Forecasts with different actual forecast windows use separate Ideas, even if their wording and relative duration match. Thus Monday's "UP over the next two weeks" and Thursday's identical wording remain separate when their anchored windows differ.

**Reason:** They make predictions about different periods; grouping them as one forecast would erase a meaningful distinction.

**Invariant:** Retain source wording, publication/availability information, period anchor/bounds and actual processing provenance. Shared broad labels such as "weeks" or temporal overlap do not make different windows identical. Different publication dates alone do not separate otherwise equivalent forecasts explicitly concerning the same fixed window. The rule concerns forecast meaning; underlying shared event evidence remains reusable. Missing or uncertain timing follows the eventual explicit policy rather than fabricated exact dates.

**Trade-offs:** More Idea records and less forecast deduplication, with clearer temporal meaning and later evaluation. Exact boundary/anchor conventions still require design.

**Implementation scope:** Discovery/documentation only. Resolve the previously open C19 relative-horizon review case to separate Ideas when anchored windows differ; the earlier research packet remains a dated proposal snapshot. No selected calendar/trading-day convention, time-zone rule, period-inference threshold, expiry policy, bar interval or revised fixture is introduced.

**Required tests:** Identical relative wording on different source dates yields separate forecast Ideas when windows differ; overlapping unequal windows remain separate; same fixed window and otherwise equivalent meaning can reuse one Idea across different publication dates; broad horizon labels alone never collapse distinct windows; preserve originals and traceable interpretation; unknown timing is not silently declared equal or assigned unsupported boundaries.

### ENG-029 — Publication-date anchor for relative forecast wording

Status: explicitly selected by Badr, 2026-10-14. Exact duration/boundary conventions remain unselected.

**Decision:** Count an article's relative forecast wording, such as "next two weeks", from its publication date when the wording supplies no different explicit reference.

**Reason:** Give relative wording a reproducible source-based reference rather than shift it to collection or processing time.

**Invariant:** Preserve source wording and publication date alongside the interpreted window and processing version. Explicit source dates/references remain visible. Publication, first availability, collection and processing dates are distinct; this choice does not change AX-052 historical inclusion semantics. Unknown publication dates are not fabricated.

**Trade-offs:** A simple reference for V1, with date precision, ambiguous phrases and missing/uncertain source dates still needing explicit rules.

**Implementation scope:** Discovery/documentation only. Select the relative-period reference date; calendar/trading-day units, exact boundaries and missing-date handling remain to be designed. No fixture or application changes.

**Required tests:** A Monday article collected Wednesday retains Monday as the relative-window reference; explicit fixed windows retain their dates; collection/processing times never silently substitute; differing interpreted windows remain separate under ENG-028; missing publication date is visible rather than invented.

### ENG-030 — Use short numbered question batches in discovery

Status: explicitly requested by Badr, 2026-10-14; revises the earlier one-question-at-a-time preference for the current discussion.

**Decision:** Batch the remaining discovery/design questions into short numbered groups, with concise examples and clearly labelled recommended defaults.

**Reason:** Reduce repeated interaction and let Badr resolve several remaining choices together.

**Invariant:** Badr makes final decisions. Suggestions remain unaccepted until his answer; distinguish each response and preserve unresolved items. Batch questioning does not authorise implementation or waive specification/plan review.

**Trade-offs:** Faster discussion, with more simultaneous choices to track. Keep batches manageable and avoid reopening settled decisions.

**Implementation scope:** Conversation and decision documentation only; update the general-context workflow preference.

**Required tests:** Questions correspond to open choices; replies map to their numbered items; accepted choices get the required decision record; unanswered items are not treated as acceptance.

### ENG-031 — Keep candidates sharing at least one concerned organisation

Status: explicitly selected by Badr in answer 1 of P-016, 2026-10-14.

**Decision:** For an incoming Idea concerning several organisations, the first filter keeps existing candidate Ideas concerning at least one of those organisations.

**Reason:** Narrow the search without requiring a complete organisation match before the later meaning comparison.

**Invariant:** Compare stable organisation identities, not spelling strings. Candidate inclusion is not a decision that two Ideas mean the same thing. Later comparison must consider the complete claim, including the organisations' roles, stock direction and applicable forecast window. Sharing a company does not establish a shared event or relationship.

**Trade-offs:** Keeps more potentially useful candidates, with more later comparison work and possible irrelevant matches. This rule alone cannot recover a match missed by organisation resolution.

**Implementation scope:** Discovery/documentation only. Select the logical first-filter rule; physical indexes, shortlist limits and handling of missing organisation extraction remain unselected. No fixture or application changes.

**Required tests:** First-organisation-only, second-organisation-only and both-organisation candidates survive; candidates with no concerned organisation in common do not survive this filter; one candidate appears once even with several overlaps; reversed partnership roles and opposing stock judgments are not merged merely because they survive; incomplete extraction is distinguishable from an established empty overlap.

### ENG-032 — Shared activity categories with organisation-specific dependencies

Status: explicitly selected by Badr in answer 2 of P-016, 2026-10-14.

**Decision:** Reuse a common domain/activity category, such as AI chips, across organisations while retaining each organisation's own activities, suppliers and dependencies.

**Reason:** Avoid duplicate category names without making companies with similar activities share the same business circumstances.

**Invariant:** Shared category membership does not merge organisations or propagate a company's supplier, subsidiary, resource or exposure to another company. An Idea's concerned organisation and relevant activity remain identifiable. Preserve the evidence and dates supporting each organisation-specific relationship; unknown dependencies remain unknown.

**Trade-offs:** Reusable categories simplify comparison, while queries and stored relationships must retain the organisation-specific scope. Broad categories can still hide differences that later iterations may need to represent.

**Implementation scope:** Discovery/documentation only. Select the scope principle; node-versus-relationship representation, category catalogue and production schema remain unselected. F-005's fixture defect is not repaired by documenting this decision.

**Required tests:** Two organisations can share AI chips while only one has the evidenced foundry dependency; the other does not inherit it; subsidiaries and suppliers are not added to a stock's corporate group solely through category membership; an Idea can identify its organisation and activity; missing dependencies are not invented; dated evidence remains traceable.

### ENG-033 — Calendar weeks before trading-interval mapping

Status: explicitly selected by Badr in answer 3 of P-016, 2026-10-14.

**Decision:** Interpret an unqualified week as seven calendar days, so two weeks means fourteen calendar days. Map the resulting period to trading/OHLCV intervals separately.

**Reason:** Give ordinary relative wording a simple, consistent duration without letting exchange holidays redefine what the source said.

**Invariant:** Use ENG-029's source-publication reference when no different explicit reference is supplied. Preserve source wording and explicit qualifications such as trading days; do not overwrite them with the unqualified calendar rule. Forecast meaning and evaluation-bar selection remain separate. Different actual windows remain separate under ENG-028.

**Trade-offs:** Straightforward duration interpretation, with exact start/end boundaries, time-zone rules and exchange-calendar mapping still requiring specification.

**Implementation scope:** Discovery/documentation only. Select the unit for unqualified weeks; this does not select a universal interpretation of months, years, trading weeks or ambiguous phrases. No trading-calendar library, bar interval or fixture change is selected.

**Required tests:** Two unqualified weeks resolve to fourteen calendar days across weekends and market holidays; later collection does not shift the publication reference; explicit source units remain visible; trading-bar mapping follows its own eventual contract; different anchored windows are not grouped as one merely because their durations match.

### ENG-034 — Explicit missing-forecast-information marker; fallback duration tentative

Status: Badr requires an identifier for absent forecast information in answer 4 of P-016, 2026-10-14. Because the question concerned a missing period, the working reading is a period-not-stated marker. The proposed seven-calendar-day value remains tentative, not a final accepted duration.

**Decision:** Retain an explicit indication when forecast information is not stated. Distinguish a source with no supported stock-price forecast from a supported UP/DOWN forecast whose period is unstated. For the latter, retain whether the working period came from source wording, AI inference or the previously accepted configurable fallback.

**Reason:** Let readers distinguish what the source expressed from assumptions supplied by Axthena.

**Invariant:** No stock-price forecast means no invented UP/DOWN judgment. A missing stated period does not erase a supported direction. An inferred/default period is never presented as a source-stated period. Retain the exact supporting passage, interpretation history and configuration/model version. The phrase no forecasting was mentioned is not treated as permission to fabricate a forecast.

**Trade-offs:** Adds a small amount of descriptive information while making incomplete source statements understandable. Whether Badr intended absence of the whole forecast rather than its period remains an explicit interpretation caveat; seven days is not fixed by this reply.

**Implementation scope:** Discovery/documentation only. Select explicit absence/origin information; exact field names and representation remain unselected. AX-031's configurable near-term fallback remains accepted, while its numerical starting duration remains open. No fixture or application changes.

**Required tests:** A report with no supported price forecast has no UP/DOWN judgment; an UP forecast with no stated period retains that absence marker and its inferred/default origin; an explicit period remains distinguishable; readers can recover the original passage and interpretation version; configuration changes cannot silently rewrite an earlier interpretation as a source statement.

### ENG-035 — At most two most-articulated Ideas per article in V1

Status: explicitly selected by Badr in answer 5 of P-016, with further investigation requested for V2, 2026-10-14.

**Decision:** When an article develops more than two separate Ideas, extract at most the two most articulated for V1. Retain the complete original article for later processing.

**Reason:** Bound first-pass extraction while extending the earlier one-Idea limit enough to preserve a second separately developed claim.

**Invariant:** Do not invent a second Idea when only one is supported. A joint claim about two stocks is not automatically two Ideas; its supported per-stock judgments remain identifiable. The two-Idea cap is not an extraction failure or a claim that the original contains no other ideas. Dedicated reasons/thought-process extraction remains V2.

**Trade-offs:** Lower processing and storage of derived material, with deliberate loss of first-pass coverage for additional developed claims. Ranking can be imperfect; originals allow later review without reacquisition.

**Implementation scope:** Discovery/documentation only. Select the V1 cap and preserve extraction/configuration provenance; ranking criteria and model remain unselected. Note V2 investigation of omitted coverage, articulation ranking and whether the cap should change. No fixture or application changes.

**Required tests:** A three-Idea article yields at most two selected Ideas while the complete original survives; a one-Idea article does not produce a fabricated second; a supported joint two-stock claim is not split solely by target count; selection remains traceable to exact passages and processing version; deliberate cap omission remains distinguishable from failed processing.

### ENG-036 — Make successful partial extraction readable

Status: explicitly selected by Badr in answer 6 of P-016, with further investigation requested for V2, 2026-10-14.

**Decision:** If one selected Idea is successfully extracted and another fails, make the valid result readable and record the incomplete processing separately.

**Reason:** Preserve useful supported data without requiring every selected extraction from a report to succeed first.

**Invariant:** Partial success does not establish complete article coverage. Processing failure is operational information, not an invented news, event or opinion record. Preserve the original report and provenance of the valid result; retain which processing remains unfinished. A retry must not duplicate an already successful result or create an additional publication mention.

**Trade-offs:** Useful data becomes available sooner, but readers must be able to recognise incompleteness and later revisions. Partial results can omit the most important failed claim, so completeness must not be implied.

**Implementation scope:** Discovery/documentation only. Select partial-result availability and separate processing-status information; retry, publication consistency and query-output details remain to be designed. Note V2 investigation of partial-result usefulness, recovery and effects on coverage/metrics. No fixture or application changes.

**Required tests:** One successful and one failed extraction retains the valid Idea with visible incomplete processing; retrying the failed work does not duplicate the valid Idea or its publication; all-failed extraction does not fabricate a complete result; successful capped extraction is distinguishable from failure; original evidence and each processing version remain recoverable.

### ENG-037 — Research extraction methods and model benchmarks before AI instructions

Status: explicitly requested by Badr, 2026-10-14. Earlier capability discussion did not authorise building the simulation; Badr corrected that distinction before this research request.

**Decision:** Research relevant top-benchmarked extraction methods, model comparisons and promising directions before drafting Axthena's AI instructions. Use that evidence to prepare the later extraction/third-filter experiment and data-model validation.

**Reason:** Base the instructions and experiment on demonstrated capabilities, relevant failure cases and explicit Axthena requirements.

**Invariant:** Preserve all accepted stock-information, identity, original-evidence, time and V2 boundaries. Distinguish primary-source reported results, documentary provider features, advisor proposals and actual Axthena measurements. Do not pool incompatible datasets/metrics, transfer results to untested model versions, or present research as a model-selection decision. No LLM-generated extraction or schema compliance establishes fact confirmation.

**Trade-offs:** Research adds preparation time but helps avoid misleading model choices and unsuitable evaluation. Public component benchmarks do not establish the complete Axthena task; its own reviewed sample remains necessary.

**Implementation scope:** Research and design documentation only. Create a source-referenced report, model comparison and proposed evaluation; no AI instructions, model calls, simulation code, adapter, fixture mutation or product implementation in this step.

**Required tests:** Each reported score identifies its source/task/metric/evaluation conditions; price/model features use dated official documentation; reported models remain distinguishable from current untested candidates; proposed evaluation checks exact evidence, identity, organisation/activity scope, Idea selection, forecast direction/window, missing states, grouping and query output; every chosen model remains subject to Badr's acceptance.

### ENG-038 — Abstract LLM communication before implementation

Status: explicitly requested by Badr, 2026-10-14. Detailed contract and provider/runtime selection remain proposals.

**Decision:** Design a separate LLM communication boundary before implementation, so model/provider communication can be replaced and benchmarked without changing Axthena's information meanings.

**Reason:** Keep extraction/grouping rules stable while allowing different hosted or local model options to be evaluated.

**Invariant:** Retain original evidence, exact request/response and model/configuration/processing provenance. Communication success is distinguishable from accepted extracted information. Provider-specific capabilities and unknowns must remain visible; API compatibility alone does not establish equivalent behavior. Badr retains final architecture decisions, and C++ remains the main application-language choice.

**Trade-offs:** A replaceable boundary requires some version/capability bookkeeping. Excessive framework scope would delay V1; the initial contract should cover the experiment's actual needs.

**Implementation scope:** Accept the separation requirement and prepare a conceptual boundary proposal. Exact types, APIs, SDKs, providers, runtime, output schema, retry/budget and storage policies remain unselected. A possible Python experiment does not change the production language decision. No implementation in this step.

**Required tests:** The eventual design can submit the same retained task through two selected providers while preserving input/output lineage and domain meanings; unsupported features and incomplete/invalid outputs remain distinguishable; saved response replay differs from fresh generation; changing provider does not silently alter entity/Idea/fact/time policy; retry/partial-result tests preserve original evidence and avoid duplicate publication records.

### ENG-039 — Use the current ChatGPT subscription for the first experiment

Status: explicitly selected by Badr, 2026-10-15.

**Decision:** Use ChatGPT through the existing subscription for the first iteration and test the extraction rules here. Defer other model/provider arrangements until a later iteration.

**Reason:** Test the information model and instructions with the access already available before introducing provider setup or broader model comparisons.

**Invariant:** No separate API subscription, paid model endpoint, local-model deployment or vendor selection is implied. Distinguish this session's assistant-worker execution from an independently verified model/settings configuration in the ordinary ChatGPT interface. Unknown model snapshot, sampling, token usage and cost remain unknown. C++ remains the production-language choice.

**Trade-offs:** Convenient low-setup experimentation, with less control over runtime settings and reproducibility than a pinned deployment. Results cannot rank providers or establish normal-ChatGPT-interface performance.

**Implementation scope:** Current-session experiment and copyable prompts only. The existing LLM-boundary proposal remains a proposal; the experiment retains input, prompt, response and execution provenance without building a production adapter.

**Required tests:** Retain exact inputs/outputs and prompt versions; record execution type and unknown settings; perform no external model API call or paid-provider setup; keep prototype scoring separate from production code; do not claim a model benchmark or dollar/latency result without measurements.

### ENG-040 — Authorise a bounded rules-and-extraction trial before production work

Status: explicitly requested by Badr, 2026-10-15. This supersedes the earlier research-only boundary for this experiment, not for product implementation.

**Decision:** Research prompting practices, compose three experimental instruction variants, create a sample, execute the extraction/comparison task and benchmark the retained outputs. The advisor interprets the requested three combinations as rules alone, rules plus examples, and rules plus examples plus an evidence audit.

**Reason:** Make the extraction and final meaning-comparison mechanism concrete so Badr can inspect records and challenge them with query scenarios.

**Invariant:** Preserve accepted business rules, original evidence, traceability, automatic organisation creation after no match, union shortlists, distinct forecast windows and V2 deferrals. Label the schema and unresolved conventions as experimental. Freeze reference labels before candidate execution; preserve failures and avoid silently repairing outputs or selecting only successful retries. Assistant-authored references are not owner-approved truth.

**Trade-offs:** A small synthetic diagnostic can expose instruction/model misunderstandings quickly but cannot establish real-news quality, stable prompt superiority, predictive value or retrieval/storage performance.

**Implementation scope:** Throwaway text/JSON fixtures, three in-session assistant runs, offline Python scoring and a reviewable results packet. No application, provider adapter, graph database mutation, existing Cypher rewrite, ML training or quant integration is authorised. Production specification and execution-plan review still precede implementation.

**Required tests:** Compare identical inputs under shared rules; withhold reference labels from fresh worker contexts; check report/Idea fields, organisation selection, complete time windows, exact evidence, missing/partial states and meaning matches; review semantic support separately from quote existence; test the scorer with deliberate defects; retain method limitations, temporary assumptions and raw outputs.

### ENG-041 — Extend the instruction trial with harder application-like cases

Status: explicitly requested by Badr, 2026-10-15.

**Decision:** Expand the ChatGPT-only experiment with more difficult samples that simulate real application inputs. Start by exercising the existing A/B/C instructions on the same new evidence rather than silently changing the rules between variants.

**Reason:** The first short, explicit synthetic packet saturated the checks and could not distinguish the prompts or expose realistic extraction and representation problems.

**Invariant:** Preserve the original pilot, accepted domain decisions and raw responses. Keep fictional evidence clearly labelled. Distinguish extraction errors, ambiguous reference labels, missing experimental contract fields and deliberately deferred V2 capabilities. Do not count impossible or unselected requirements as model failures, equate source quotations with full semantic support, or infer production/model superiority from a small constructed sample.

**Trade-offs:** Longer, independently authored and reviewed examples provide more useful failure cases but remain synthetic and subject to author/reviewer bias. More samples alone do not establish a representative real-news distribution or repeated-run stability.

**Implementation scope:** Expanded throwaway fixtures, fresh in-session assistant extraction runs, offline scoring, semantic review and design-gap scenarios. No external LLM API, additional subscription, persistent application, live graph mutation, production adapter or predictive-model training. C++ and the production specification/plan review boundary remain unchanged.

**Required tests:** Freeze input/reference and preserve byte-identical baseline prompts; exercise conditions, negation, relative returns, date boundaries, publication/availability/collection separation, corrected numbers, company/subsidiary/supplier scope, multilingual text and missing content; retain all submitted outputs; predeclare legitimate label alternatives; review semantic support separately; report full denominators, false merges and specific failures without hiding ambiguous cases.

### ENG-042 — Require twelve consecutive months with flexible calendar dates

Status: accepted through Badr's clarification, 2026-10-15: “latest twelve months or last year any 12 months periode.”

**Decision:** The initial historical evidence target is a continuous twelve-month period. It need not be the latest twelve months; a prior year or another twelve-month interval is acceptable. Exact start and end dates remain unselected.

**Reason:** Keep a year of history as the target while allowing source availability, usable article text and acquisition cost to guide the concrete interval.

**Invariant:** Twelve months is the requested coverage interval, not a guarantee that every relevant article exists in the chosen source. Report missing bodies and gaps honestly; preserve source, collection and processing times. The same selected interval should frame the Nvidia/Microsoft comparison, with unequal source coverage visible. Do not choose the period because of favorable subsequent prices or claim historical Axthena operation. A twelve-month acquisition target does not create a twelve-month subscription commitment.

**Trade-offs:** Flexible dates can make an affordable dataset more practical, while older evidence may differ from the current technology and media environment. Source coverage and historical text/version quality still require inspection.

**Implementation scope:** Source and historical-period selection during discovery. ENG-008's budget and ENG-010's API-first collection decision remain in force. A public dataset is a candidate for testing, not a silently selected replacement acquisition route. No source, exact dates, purchase or implementation is selected by this clarification.

**Required tests:** Once dates are chosen, verify that the requested bounds span twelve consecutive calendar months under the eventual inclusion convention; inspect usable article coverage for both target stocks across that interval; distinguish source gaps from no matching news; retain original passages and timestamps; document source and period selection before measuring any price-related outcomes.

### ENG-043 — Inspect the produced graph before representation and optimisation research

Status: explicitly requested by Badr, 2026-10-15, while selecting the real news source.

**Decision:** The next validation milestone is a populated graph produced by applying the draft extraction instructions to source material, which Badr can explore and challenge with queries. Stress-test the meaning and relationships represented. After Badr inspects the results, research candidate representations, abstraction layers and query optimisation, using the actual review findings and desired reads.

**Reason:** Numerical extraction scores and synthetic summaries alone do not show whether the connected world matches the user's intended model. Inspectable output makes missing links, mistaken grouping and evidence problems concrete before physical design decisions.

**Invariant:** Retain the report/expression/Idea distinction, directly concerned organisation and subsidiary/domain links, stock targets, source identities, evidence and applicable dates. Keep fictional and real-source results visibly distinguishable. Shared Ideas do not erase individual source expressions. Unsupported relations or missing distinctions remain visible; do not manufacture a complete graph. A Cypher review artifact or temporary graph test does not select the production database. The current model and instructions remain a working baseline, not a claim that all previously recorded gaps are resolved.

**Trade-offs:** Producing and reviewing a concrete graph adds a bounded validation step, while reducing the chance of optimising an unsuitable representation. Sample findings do not establish whole-year coverage or performance at scale.

**Implementation scope:** Source selection, bounded evidence acquisition/extraction experiments and inspectable graph/query output before production implementation. The initial source, exact dates and sample size remain unselected; the existing 50-article sample suggestion is a proposal. Preserve the twelve-month dataset target under ENG-042. Badr reviews results before subsequent representation/abstraction/optimisation choices; the reviewed specification and execution plan still precede production implementation.

**Required tests:** Each retained Idea is reachable from its source report/expression and exact supporting evidence; directly concerned organisations and relevant domains are correctly linked; stock forecasts retain their targets, dates and material qualifications; equal-meaning grouping preserves distinct expressions and materially different claims remain distinguishable; dated reads do not backdate later source information; missing or partial inputs remain identifiable. Provide concrete review queries and a defect list. Any later performance comparison must preserve the accepted query results and evidence traceability.

### ENG-044 — Positive graph review and consolidated implementation handoff

Status: explicitly requested by Badr, 2026-10-15, after inspecting the current graph results.

**Decision:** Badr expresses satisfaction with the current results and requests a consolidated handoff covering the documents, conversation changes, design, behaviours, tests and implementation plan.

**Reason:** Carry reviewed work into a coherent specification and ordered implementation plan without losing decisions or later refinements.

**Invariant:** Badr retains architecture authority. C++ remains accepted. Distinguish accepted requirements from proposed mechanisms and open gaps. The fictional projection does not remove Event, Fact/Confirmation, dependencies, qualifications or time guarantees from the intended model. Preserve evidence and V2 boundaries.

**Trade-offs:** The graph makes discussion concrete but does not establish real-source reliability, actual retrieval/grouping, performance or complete production-model correctness. Satisfaction with this review milestone is not comprehensive test execution.

**Implementation scope:** Compile the current decision map, specification, architecture recommendation, work packages, tests, unresolved choices and references. This request does not select a backend, authorize a provider purchase or approve production implementation.

**Required tests:** Trace every current requirement and known gap to specification/work/test items; identify superseded rules; preserve six-field decisions; distinguish prior experiments from future runtime tests; label unselected technologies and defaults.

### ENG-045 — Company and stock-judgment graph display conventions

Status: explicitly requested by Badr, 2026-10-15, immediately before the positive graph review.

**Decision:** Show a company, its subsidiaries and stock-linked judgments with their source-grounded explanation. Company is orange; subsidiary yellow; UP green; DOWN red.

**Reason:** Make corporate scope and opposing stock expectations easy to inspect in the graph.

**Invariant:** Display colour does not prove observed market movement or a company's inherent sentiment. The actual concerned organisation/subsidiary remains explicit. Why a source holds a view is shown through the Idea summary and exact evidence; dedicated reason modelling remains V2. Parent/subsidiary roles are relative to the selected view.

**Trade-offs:** A selected-company view is easier to read but is not the whole market or a single forecast interval. Display labels/styles are presentation metadata, not new business classes.

**Implementation scope:** Preserve the review query and colour guide; use these conventions in later graph exports or selected display tooling. No live database write or UI styling execution is claimed in this handoff.

**Required tests:** Correct stock/issuer/subsidiary links; correct direction-to-colour mapping; explanation reaches the source passage; no loss of period, condition or attribution; display labels do not change business interpretation.

## Discussion item P-001 — How the first evidence enters Axthena

Status: initial entry path resolved by ENG-010; source/provider and exact acquisition contract remain open.

Axthena itself downloads articles from configured sources, beginning with a news API, retains the acquired evidence, then processes it independently. Analyst-prepared surrounding-world configuration is accepted under ENG-009.

Importing a prepared external document packet was an earlier alternative; it is not the selected first V1 entry path. No API provider, client framework, format, database or deployment has been chosen. Public documentation makes EODHD a candidate, not an accepted source. Exact dates, actual coverage and text fidelity still need checking.

## Discussion item P-002 — Detecting edits

Status: deferred to V2 under ENG-003; no mechanism selected.

Proposed starting approach: retain each observed article version as separate evidence, link it to the same article and the preceding observed version, and keep its capture time and available source timestamps. Historical imports would need evidence of older versions when original wording is required.

Deferred V2 scope choice: whether to actively revisit articles or record revisions only when encountered again. Recheck frequency, temporary/unavailable sources, changes to article text versus page layout/advertising, unseen intermediate versions and any content-difference representation remain open. ENG-002 accepts separate evidence; it does not imply that all historical edits can be discovered.

## Discussion item P-003 — Source query/cache behaviour

Status: V1 read/collection boundary resolved by ENG-004; cache details remain open.

The user initially suggested queries across sources with caching, then considered behaviour depending on query type. The final V1 choice is separate collection and stored-data reading. A combined “collect and read” type was proposed by the assistant but was not selected.

Caching may still support source retrieval within collection and repeated reads of retained data. Cache keys, lifetime, persistence, freshness and invalidation remain unselected. Durable evidence retention remains required independently of disposable cache behaviour.

## Discussion item P-004 — What a collection request specifies

Status: analyst-prepared initial supplier/resource/topic configuration accepted under ENG-009; exact input contract remains open.

The analyst prepares the initial surrounding-world selection, with AI assistance if useful. Automatic discovery/maintenance is not required in V1. Exact fields for target stocks, source selection, historical period, organisation/dependency inputs and language/volume limits remain to be specified; neither a source provider nor configuration format has been selected.

## Discussion item P-005 — Low-cost source feasibility

Status: researched candidates and proposals, 2026-10-14; no source selected and no authenticated sample acquired.

- [SEC EDGAR access documentation](https://www.sec.gov/search-filings/edgar-search-assistance/accessing-edgar-data): historical filings are publicly downloadable without a data fee. Provides company evidence rather than a complete news/opinion archive.
- Original company releases are publicly accessible, demonstrated by [Nvidia's February 2025 earnings release](https://investor.nvidia.com/news/press-release-details/2025/NVIDIA-Announces-Financial-Results-for-Fourth-Quarter-and-Fiscal-2025/default.aspx) and [Microsoft's July 2025 release](https://www.microsoft.com/en-us/investor/earnings/fy-2025-q4/press-release-webcast). This establishes examples, not a verified complete collection for any selected year.
- [EODHD news documentation](https://eodhd.com/financial-apis/stock-market-financial-news-api) advertises a free personal-use tier with the past year of data, 20 API credits/day and a 500-credit welcome bonus. News supports date filters, ticker/topic filters, pagination up to 1,000 articles/request, and a content field described as the full article body, plus publication date and original link. [Current pricing](https://eodhd.com/pricing) includes news on the USD 19.99/month personal plan, with 100,000 credits/day; a news request costs five credits. These are documented offers, not independently verified coverage or text fidelity. The general price table's long time-series history must not be assumed to be news history.
- [EODHD terms](https://eodhd.com/financial-apis/terms-conditions) permit storage, manipulation and analysis for private non-commercial purposes and prohibit redistribution/display or granting access under the personal licence. They provide monthly cancellation. Do not promise post-cancellation retention rights beyond what is established or assume public demonstration/redistribution is covered.
- [Common Crawl access](https://commoncrawl.org/get-started) is free by HTTP; [CC-News documentation](https://commoncrawl.org/blog/news-dataset-available) describes historical archived news files organised by year/month. This is a possible archive fallback, with additional filtering/download/processing effort; no complete stock coverage, original-publication snapshot or zero infrastructure cost is established.

Proposed next path: inspect free official evidence and an EODHD sample before considering its USD 19.99 plan. No need for a USD 100 plan has been established. LLM extraction cost is a separate calculation unless the user chooses an all-inclusive budget.

## Discussion item P-006 — Main local database candidate

Status: assistant proposal challenged for insufficient graph-query evaluation, 2026-10-14; database not selected. Review the graph model and representative queries before choosing storage.

Earlier proposal: SQLite as V1's main local database: the current use is on one computer, with concurrent reads during preparation deferred. Represent organisations, stocks, people/accounts, events, ideas, source expressions and evidenced relationships in tables with explicit identifiers; preserve operational metadata separately in meaning and representation. Table storage can preserve the stock-related game without requiring a specialised graph database.

Primary documentation:
- [Appropriate uses](https://www.sqlite.org/whentouse.html): device-local application storage and desktop/data-analysis use; only one writer can write a database at a time.
- [Single-file database](https://www.sqlite.org/onefile.html): the main database is a portable disk file; transaction-control files can also exist, so live backup is not simply copying an active file indiscriminately.
- [Graph queries](https://www.sqlite.org/lang_with.html): recursive queries can follow stored tree/graph relationships. Query bounds/cycle handling remain Axthena's explicit design responsibility.

Rationale is a design inference from the accepted local/sequential scope, not a measured performance result. Exact schema, original-evidence storage and recoverable compression, indexes, migrations, backup/recovery, temporal selection and bounded dependency reads remain unselected. Dataset volume and representative query checks must establish practical suitability. No SQLite product code or schema has been created.

## Discussion item P-007 — Real-report Cypher model example

Status: requested by the user for iterative model review, 2026-10-14; representation is a proposal, not an accepted schema or database selection.

The user challenged choosing storage before confirming understanding of the graph-like model, then requested a Cypher example using retrieved news. See [Axthena-cypher-example-v1.md](Axthena-cypher-example-v1.md) and [Axthena-cypher-example-v1.cypher](Axthena-cypher-example-v1.cypher).

The packet uses five real public reports: Microsoft and Reuters on an investment announcement; TSMC on revenue and earthquake effects; NVIDIA on Blackwell and its stated manufacturing; later Reuters reporting on leases. It illustrates shared ideas with separate source expressions, organisation/domain dependencies and resource context, scoped company disclosures, source assertions and a separate relevance interpretation, explicit selected-source views and separate times.

Important limits: only short exact excerpts and metadata are retained in this design packet; full originals and original historical versions have not been archived/verified. Auxiliary graph records, grouping, confirmation application, one unresolved response classification and the query shapes are proposed for review. No directional judgment or personal opinion is invented. Some accepted concepts still need a later real-data case. Structural fixture checks were performed; the Cypher has not been run in Neo4j. No collector, product database, schema migration, service or implementation plan has been executed.

## Discussion item P-008 — Three-round proposed design

Status: assistant recommendations after research and independent critique, 2026-10-14; awaiting Badr's architecture review.

See the three-round review and catalogue linked above. R-01–R-06 propose source-grounded statement/relationship records, shared ideas with reversible membership and separate identity decisions, source-cutoff eligibility through substantive lineage, exact-response-aware processing reuse, one local graph store with complete immutable generations, bounded typed queries and stable versioned configuration.

The strongest architectural recommendation is one authoritative structured store plus a retained evidence/attempt archive. The leading physical candidate changed from Neo4j Community in round two to embedded Ladybug in round three because the local, prepare-then-read workflow does not require a separate service. This is medium-confidence selection advice, not a measured superiority claim or accepted choice. **Later owner decision ENG-016 selects C++ and supersedes the Python/Pydantic proposal.** C++20, CMake/CTest, specific native libraries, Zstandard, a two-idea cap, graph/query limits, generation publication mechanism and performance targets remain proposals. SQLite and Neo4j remain viable alternatives; a second live analytical database is not proposed for V1.

The review preserves AX-052 source-first retrospective information, with actual derivation/decision dates and no operational point-in-time/backtest guarantee. It proposes supported/declared/unknown captured-version availability states and conservative dated reads with explicit exploratory opt-in; Badr must review that exclusion policy. Later-source confirmations, world relationships and view interpretations cannot silently enter an earlier query through an eligible older article. Active edit discovery remains V2.

Initial confirmation-process qualification, hold-read policy, grouping/multi-idea rules, horizon boundaries/encodings, empty-result presentation, exact year/source packet, budget scope, local OS and accepted performance targets remain open. The plan specifies how to validate the proposed mechanisms after review rather than pretend research resolved them.

Research limits: no authenticated NVDA/MSFT historical API sample or complete annual corpus; no current database execution, performance measurement, model accuracy estimate or predictive test. EODHD documentation remains a candidate. The newly retrieved news page shows a USD starting price while its pricing page shows EUR; do not carry the earlier USD 19.99 note forward as a verified all-in cost or a purchase decision.

## Discussion item P-009 — Populated Cypher model lab

Status: requested model-review artifact under ENG-017, 2026-10-14; proposed representation awaiting owner inspection.

See [Axthena-model-lab.md](Axthena-model-lab.md), [Axthena-model-lab-load.cypher](Axthena-model-lab-load.cypher) and [Axthena-model-lab-queries.cypher](Axthena-model-lab-queries.cypher). The separate `AxLab` graph contains 174 nodes and 324 relationships: fictional source reports, retained full text and exact passages, shared ideas, per-source expressions, named/anonymous people, dummy global weights, scoped fact confirmations/conflict, broad processes/inputs/outputs, evidence-backed dependencies, a potential-effect interpretation, selected views and dummy daily prices.

The loader is one Neo4j Cypher 5-compatible statement without APOC; it does not choose Neo4j for production. Thirteen numbered review queries and five integrity checks expose concrete expected answers. Source-first retrospective selection is explicit: the fictional ForgeFoundry report is printed March 3 but first available March 5; later dependency and audit supports cannot enter an earlier eligible-source answer. All annotations were manually made in October 2026; this is not operational point-in-time/backtest history.

Structural, text/hash and expected-scenario checks were run locally and independently reviewed. No Cypher parser/database execution is claimed. Confirmation qualification and corpus-wide versus view-local conflict policy remain unresolved; illustrative fixture statuses do not accept those policies. The earlier real-news packet and previous research/plan remain separate reference material. Further architecture work is paused for this model review.

## Model-review flaws

### F-001 — Shared idea missing organisation/subsidiary subject links

Reported by Badr on 2026-10-14 during online graph inspection; he cites `fixtureV1` as an example. Status: open; recorded for correction review, not fixed.

**Problem:** The shared Idea does not point directly to the organisation or subsidiary it concerns. Subject links on Expressions or indirect routes through Events do not provide the idea-level connection Badr expects.

**Consequence:** Inspecting an Idea alone does not expose its subject organisation/subsidiary. Grouping must preserve the meaning's organisational subject as well as the separate sources and passages.

**Example:** A partnership idea concerns both NovaChip and ForgeFoundry. An idea specifically concerning NovaCloud must identify that subsidiary distinctly from NovaChip. The user's `fixtureV1` reference is retained verbatim; no particular Idea ID was supplied.

**Correction to review:** Explicit idea-to-subject organisation/subsidiary links, preserving source-specific evidence and availability. Relationship naming, authoritative versus derived links, domain attachment and propagation rules remain to be reviewed. Do not automatically attach every parent-company idea to all subsidiaries.

**Required checks:** Organisation/subsidiary idea lookup; multiple organisations on a partnership idea; retained source Expressions and exact passages; separate parent, subsidiary and supplier identities; no later-supported subject link leaking into an earlier dated answer.

**Scope:** Record this flaw only. The fixture and live graph remain unchanged. Continue model review before downstream architecture work under ENG-017.

### F-002 — Confirmation status lacks encoded claim scope

Open, identified by model stress review, 2026-10-14. Current fixture has 13 confirmed-news Expressions and nine scoped Fact/Confirmation pairs. North/South may relay the originating partnership confirmation; Forge/Litho have no associated process through that shared-Idea lineage. Publication versus claim-content scope is explained in prose but not encoded on the status fields. Review explicit confirmation scope/process; do not treat this as proof that first-party statements are invalid or require independent Fact creation for every copied report.

### F-003 — Quake-to-transport relevance has an unstated route premise

Open, current grounding gap. Quake evidence names nearby roads, not Route Seven. The graph uses a broad transport resource to connect that disruption to LithoWorks deliveries. Keep the potential-effect hypothesis but expose the unestablished route/geographic association. Dated supplier support alone does not establish that premise. No original evidence was edited.

### F-004 — Support/query cardinality counterexamples

Open, demonstrated with in-memory extensions; not an advertised baseline-answer failure or Neo4j execution result. Q8 can return opposing eligibility rows when alternative event evidence has different dates. Deleting a required-premise declaration makes its check easier to satisfy. Q9 can follow an orphaned/stale dependency shortcut despite missing or later support. Q11 repeats one judgment when it has several eligible passages. Q7 omits an unsupported requested cutoff. Review complete proof sets, one result per answer identity, shortcut consistency and explicit no-supported-answer output. These findings do not select a production query interface or dependency limit.

### F-005 — Organisation/domain and subject-association scope

Open extension risk. Reusing NovaChip's chip Domain for DragonLogic transfers NovaChip's ForgeFoundry dependency through a shared activity category. Preserve organisation-specific activity applicability or qualify every dependency accordingly. Event subject edges also lack their own source/date support; newly attached subjects can leak through an old eligible report. Apply this to F-001's proposed direct Idea links. Shared categories, subsidiaries and suppliers must not propagate subjects/exposure automatically.

### F-006 — Shared UP summary changes the expressed reason

Open minor current defect. `up-two-weeks` says N1 improves competition; passages say the N1 announcement improves NovaChip's competitive position. Review the summary to retain that subject and reason. No summary or fixture was changed during this review.

### F-007 — Exact-span unit is not declared

Open coverage/contract gap. Current ASCII source text conceals that Python string positions are code points while C++ string positions ordinarily count bytes. Specify evidence version, encoding and offset unit; add Chinese/emoji span checks. Any passage-vertex simplification must preserve reconstructible exact excerpts and citation identities.

## Discussion item P-010 — Model stress review and simplification proposals

Status: research, analysis and proposals completed at Badr's request, 2026-10-14; no proposed model correction or simplification accepted yet.

See [Axthena-model-stress-review-2026-10-14.md](Axthena-model-stress-review-2026-10-14.md) and [Axthena-model-stress-checks.cypher](Axthena-model-stress-checks.cypher). Three independent read-only critiques, baseline graph inspection and 14 in-memory/algebraic probes preserve the strong Report/Expression/Idea, identity, scoped confirmation and retrospective source-time distinctions while exposing F-001–F-007 and missing coverage cases. All findings remain distinguished as current gaps, extension counterexamples or untested scenarios. No Cypher engine, benchmark or predictive model was run.

Research consulted Codd's logical/stored redundancy distinction, Green/Karvounarakis/Tannen provenance alternatives versus joint inputs, Jensen/Snodgrass temporal semantics, W3C PROV derivation, Olteanu/Závodný factorised results, official Neo4j aggregation documentation and Wikidata statement qualifiers. The report links primary sources and states their application limits. Mathematics checks identity counts versus join multiplicity, complete-route eligibility using OR of ANDs, nontransitive similarity grouping, ordinal agreement and bounded traversal.

Preferred first proposal: correct supported subject/applicability and query semantics, remove duplicated payload and simplify read/display projections. The fixture repeats 2,876 bytes of passage text, 1,154 bytes of expression summaries and 129 bytes of identical source payload; 4,159 redundant payload bytes before replacement-reference/storage overhead. Conditional passage/judgment flattening gives 152 nodes/294 edges before missing links are added. More aggressive 149/291 and 131/273 options require cardinality/history contracts; the report does not recommend erasing weight history or evidence-version identities. Node counts are not performance or compression measurements.

The existing loader, query file and live Aura graph remain unchanged. One focused correction/retest round is proposed before downstream architecture work; Badr retains final decisions. C++ remains accepted; no backend, library, numerical scoring method, ML task or execution plan has been selected or executed.

## Discussion item P-011 — Earlier routing analogy and creation-time grouping research

Status: user clarification and benchmark research, 2026-10-14; proposed mechanism awaiting Badr's review under ENG-018.

The prior "plane" metaphor is not accepted as a containment architecture. Badr clarified that his target is preserving originals, grouping equivalent incoming source expressions into shared meaning at processing time and exposing direct market opinion views. A related August 11, 2025 COBOL region-routing conversation was recovered through personal context, but the app name "Pandea" and a repository were not verified. Library/Notion searches found no named project record. Do not pretend a separate app's architecture was recovered or import it into Axthena.

See [Axthena-creation-time-opinion-grouping-research-2026-10-14.md](Axthena-creation-time-opinion-grouping-research-2026-10-14.md), [Axthena-opinion-grouping-benchmark-snapshot.json](Axthena-opinion-grouping-benchmark-snapshot.json) and [Axthena-opinion-grouping-review-cases.json](Axthena-opinion-grouping-review-cases.json).

Three independent reviews examined primary online news clustering, multilingual claim clustering/matching, official claim retrieval, argument-facet similarity, current embedding scores and vector-index benchmarks. The official MTEB Multilingual v2 API was independently fetched; selected models have complete 131-task coverage. Harrier 27B has the highest observed mean-task score among complete rows, while model training exposure and metrics differ. No universal best opinion matcher is established. Closest 2026 Claim2Vec results are offline same-fact-check clustering; a 96.9% ClaimMatch classifier explicitly permits contradictory claims. Neither number proves equal stock-opinion precision.

Proposed mechanism: retain/extract source Expression, retrieve candidate Ideas with verified facets/lexical/embedding search and a soft time prior, check meaning contract, verify equal meaning, then reuse or create a singleton and update direct opinion lookups. Stable contracts and versioned membership decisions preserve grouping history; models/similarity scores are not fact confirmation. A candidate shortlist includes smaller embeddings for initial quality/cost comparison, with exact vector search as a reference before ANN is justified by scale. All remain proposals.

Twenty-four fictional review cases preserve accepted rules, mark relative-period identity as policy-open and separate quotation exclusion/insufficient extraction from pair matching. No model was run; these are not validated benchmark gold. Core unresolved question: whether nearby-day "next two weeks" statements share a recurring Idea while retaining anchored forecasts, or require separate forecast-episode Ideas. The user retains that decision.

No source subscription, product dependency, application implementation, new fixture or live graph mutation was performed. Market view coverage remains the configured initial universe rather than all-market representativeness.

## Discussion item P-012 — Filter cascade and organisation-name lookup

Status: Badr's mechanism under discussion, 2026-10-14; cascade implementation not selected.

Badr proposes three or potentially n stages: cheap narrowing from extracted information, similarity-index/ML comparison, then LLM comparison. The rationale is reducing search space before paying for more expensive precision. Early exclusion should preserve potential true matches; later stages cannot recover eliminated candidates. Speed, cost and LLM quality contribution need evaluation for selected mechanisms.

The fictional NOVA UP example illustrates narrowing, ranking and distinguishing competitive-position versus shipping-cost reasoning. It does not accept stock/direction exclusion as a complete first-filter contract.

ENG-019 records organisation identity and same-name V2 deferral. One stable organisation record with retained source spellings and recognised-name lookup is a proposal. Broader aliases such as "Nova Chips", abbreviations, translations and misspellings remain open. No automatic semantic entity merge or global-name uniqueness guarantee is adopted.

## Discussion item P-013 — Reuse the matching mechanism across extracted fields

Status: Badr's extension proposal, 2026-10-14. ENG-021 subsequently accepts separately reusable equivalent reasons; other field-specific representation and matching rules remain under discussion.

Badr proposes applying the same candidate-retrieval, set-combination and AI-selection mechanism to the concerned stock, domain, main idea, expressed period and reason for judgment, in addition to organisations. His condition for reasoning is that the judgment's reason can be separated from what is happening.

The shared process is proposed as extracted value plus evidence/context, retrieve candidates from that field's existing records, combine candidate sets, and let AI assess the match. Different fields require different equivalence rules: stock identity differs from activity category, source-backed meaning, or anchored temporal meaning. Exact stated periods should retain their wording, anchors and bounds; near dates or equal duration alone do not establish equality.

An organisation, domain or reason reused across expressions does not establish that the whole opinions are equivalent. Keep the reported development, source-expressed judgment reason and UP/DOWN judgment distinguishable. No absent reason is invented. ENG-021 accepts separately reusable equivalent reasons; concrete links and the treatment of AI-inferred reasons remain open. Union/intersection, index technologies, models and field-specific thresholds remain unselected. No fixture/application changes.

## Discussion item P-014 — Skeptical value assessment and baseline proposal

Status: assistant assessment requested by Badr, 2026-10-14; recommendation and proposed evaluation are not accepted architecture or execution decisions.

Judgment: keep Axthena as a tightly bounded stock-information preparation/query MVP and C++ engineering project; do not treat hybrid retrieval, shared nodes or LLM matching as a demonstrated competitive advantage. An LLM can supply parts of extraction/comparison; existing retrieval/storage/graph pipelines supply much of the surrounding machinery. Novelty, performance superiority and predictive usefulness are not established.

Primary evidence reviewed: [Qdrant hybrid/multi-stage queries](https://qdrant.tech/documentation/search/hybrid-queries/) documents dense/sparse retrieval, candidate prefetching, fusion and staged queries. [Microsoft GraphRAG indexing](https://microsoft.github.io/graphrag/index/overview/) documents LLM entity/relationship/claim extraction, graph processing, vector embeddings and persisted outputs. These establish existing building blocks, not equivalence to Axthena's exact requirements or adoption of those products.

Potential value: reliable dated stock-specific records with explicit identities, original passages, source selections, distinct expressions and reusable program queries. This is a domain/integration and measured-quality proposition, not proof that other tools lack these properties. No trading advantage follows from tidy graphs or consolidated opinions alone.

Main concern: premature optimisation and abstraction across every extracted field before a simple baseline shows a concrete cost/quality failure. C++ is an accepted CV/implementation choice, not evidence of lower end-to-end latency when model calls may dominate.

Proposed evaluation before adding machinery: use the same small reviewed packet and concrete investigator queries for a simple extraction-plus-retrieval/storage baseline and the proposed cascade. Compare supported answer correctness, organisation duplicates, damaging idea merges, repeated-processing behaviour, cost and latency. Add a custom mechanism only for a measured gap. Neither system was implemented or benchmarked in this review. Two-stock scope, existing original-evidence requirements and no-product-implementation boundary remain unchanged.

ENG-022 records Badr's explicit deferral of reason/thought-process work to V2. Final continuation and architecture choices remain his.

Subsequent clarification: Badr asks about early research promise beyond CV value rather than an already proven edge. ENG-023 and general AX-053 preserve that promising but unproven direction, the FrugalGPT/Adaptive-RAG references, and a bounded V2 return path. The assessment does not accept adaptive methods or a performance claim.

## Discussion item P-015 — Pairs-related news and time-sensitive grouping

Status: proposed pair-query behaviour accepted under ENG-027; remaining grouping/time rules open, 2026-10-14.

The fictional example reports a contract moving from DragonLogic to NovaChip and a source expecting NOVA UP and DRAGON DOWN over the next two weeks. Preserve the joint meaning, separate companies/stock judgments and original evidence; no first-class reason record is added to V1.

Research references: [Gatev/Goetzmann/Rouwenhorst, NBER working paper 7032](https://www.nber.org/papers/w7032) compares normalised historical price paths; [Engelberg/Gao/Jagannathan, September 2008 working-paper draft](https://www.smallake.kr/wp-content/uploads/2016/03/EngelbergGaoJag_31August2008.pdf) examines news/liquidity around divergence and reports greater persistence for company-specific-news divergence. These motivate inspecting dated evidence, not a selected strategy or promise of convergence. The FIRE financial-relation dataset was also reviewed as background; no model or dataset adoption is selected.

Subsequent owner decision ENG-028 resolves this question: different actual forecast windows use separate Ideas, even with identical relative wording. C19's former policy-open status in the dated research packet is superseded for this case. Evidence retention and AX-027 remain in force; exact temporal boundary/anchor conventions remain unselected.

## Discussion item P-016 — Proposed batch of remaining collection/grouping choices

Status: Badr answered the six questions on 2026-10-14. Items 1, 2, 3, 5 and 6 are accepted under ENG-031/ENG-032/ENG-033/ENG-035/ENG-036; items 5 and 6 also have V2 investigation notes. Item 4 selects explicit missing-information marking under ENG-034; the proposed seven-day value remains tentative. Publication anchoring and batch preference were already accepted under ENG-029/ENG-030. The original question wording follows for traceability.

1. Multi-organisation narrowing: keep candidate Ideas concerning at least one of the incoming Idea's concerned organisations; later comparison checks the complete meaning. Recommended yes.
2. Domain categories: reuse a common activity category such as "AI chips" while retaining each organisation's own activities, suppliers and dependencies. Recommended yes; no cross-company dependency propagation from a shared category.
3. Relative weeks: interpret "two weeks" as fourteen calendar days, then perform OHLCV/trading-interval mapping separately. Recommended yes; exact time boundaries still require specification.
4. Missing period: after attempting source-supported period inference, use seven calendar days as the initial configurable near-term default. Recommended starting value only; preserve that this is an Axthena assumption.
5. More than two separately developed ideas: retain at most the two most articulated in V1, with full original evidence kept for later processing. Recommended cap; not yet selected.
6. Partial extraction: if one selected idea succeeds and another fails, make the valid part readable and record incomplete processing separately. Recommended yes; no completeness claim or failed invented domain record.

The answers and accepted scope are recorded above; the original recommendations are not an implementation plan. The numerical fallback in item 4 remains open. Automatic organisation creation, union shortlists, retained intersection signals, original evidence and reason/thought-process V2 deferral remain unchanged.

## Discussion item P-017 — Extraction benchmark research and proposed LLM boundary

Status: research and design proposals prepared at Badr's request, 2026-10-14. No model, prompt, interface details, provider or runtime accepted yet.

See [Axthena-extraction-research-2026-10-14.md](Axthena-extraction-research-2026-10-14.md), [Axthena-LLM-boundary-proposal-2026-10-14.md](Axthena-LLM-boundary-proposal-2026-10-14.md), and [Axthena-extraction-reference-index-2026-10-14.json](Axthena-extraction-reference-index-2026-10-14.json).

Four independent research reviews covered source-grounded extraction/specialists, comparable model scores/current provider facts, third-filter semantic comparison, and communication/structured-output contracts. Root reviewed their evidence and primary sources. Comparable SOB and corrected financial-entity tables are retained separately from current unmeasured model candidates; specialist relation results disclose provided entities/coreference. Two unrelated ExtractBench papers, grounding versus value correctness, time-aware event/claim research, pair-order/cluster inconsistency and schema-decoder limitations are distinguished.

Advisor proposal: first compare a pinned GPT-5.4 reference with Qwen3.8 Flash and DeepSeek V4.1 Flash; GPT-6.1 Sol and local specialist/record routes remain optional challengers. No Axthena model execution or cost/latency measurement occurred. Published proxy scores are not exact timed-Idea benchmark results. Local feasibility and model/version/account access remain unselected.

The proposed boundary retains logical request, send-attempt, response and capability information; validation and graph application remain separately inspectable. All concrete field/API/retry/validator choices remain proposals. Detailed reasons/thought-process modelling and predictive training remain V2. The existing Cypher scripts, fixtures and live graph remain unchanged.

Historical next sequence at this research stage: review research/boundary choices, then draft instructions and an explicitly scoped experiment; inspect the populated output with Badr's query scenarios; review the production specification and execution plan before implementation. ENG-039/ENG-040 subsequently authorise the ChatGPT-only experiment on 2026-10-15. They do not authorise product implementation or accept the detailed proposed production interface.

## Discussion item P-018 — Three-variant ChatGPT instruction pilot

Status: authorised pilot executed, 2026-10-15; findings and recommendations are advisory. See [Axthena-ChatGPT-trial-2026-10-15.md](Axthena-ChatGPT-trial-2026-10-15.md) and [Axthena-ChatGPT-trial-2026-10-15.zip](Axthena-ChatGPT-trial-2026-10-15.zip).

Three fresh assistant-worker contexts each received the same 17 fictional short reports, five supplied organisation-shortlist tasks and 14 meaning-comparison tasks, with a shared experimental JSON contract. A adds direct rules; B adds four examples; C adds a source-based audit. No external LLM API, ordinary ChatGPT UI automation or provider configuration was used. Exact model snapshot/sampling, token billing and generation latency were not established.

All three retained outputs match the frozen reference on 17 report records, five identity tasks and 14 comparison labels; each supplies 17 exact source quotations. This is a ceiling result on a deliberately small, explicit diagnostic, not a calibrated accuracy claim. The reference and sample were assistant-authored and reviewed before execution, not yet validated by Badr. Quotation integrity and structured-field agreement do not prove semantic support. A separate assistant review inspected all 51 summaries and 42 comparison bases; it found one minor C/R06 wording ambiguity (absence of an absolute forecast could read as flat prices), with correct structured fields and evidence. Raw outputs remain unchanged; owner review is still outstanding.

The packet retains prompt/input hashes, raw response hashes, unknown runtime fields, an offline scorer and defect-detection checks. Suggested next baseline is A for its smaller instruction set, because the measured sample shows no incremental benefit from B/C; that recommendation is not an accepted permanent prompt. Repeated/harder real-article evaluation and Badr's query validation remain outstanding.

Temporary conventions are explicitly not production decisions: date-only end=start+calendar-duration with an excluded end; null numeric fallback while the duration is unselected; a diagnostic INSUFFICIENT comparison label without choosing a production uncertainty workflow; a narrow event-phase classification; trusted supplied confirmation scopes. Candidate retrieval is pre-supplied, not benchmarked. No reason nodes, predictive training, C++ application, existing Cypher fixture or live graph was changed.

## Discussion item P-019 — Harder application-like instruction diagnostic

Status: authorised expansion executed under ENG-041, 2026-10-15; findings and proposed remedies remain advisory. See [Axthena-hard-trial-results-2026-10-15.md](Axthena-hard-trial-results-2026-10-15.md), [Axthena-hard-samples-2026-10-15.md](Axthena-hard-samples-2026-10-15.md) and [Axthena-hard-trial-2026-10-15.zip](Axthena-hard-trial-2026-10-15.zip). The original pilot is preserved.

The expansion adds 36 fictional reports (68 paragraphs, including French and Chinese), 12 supplied organisation tasks and 36 meaning comparisons. It tests corrected metrics, subsidiary and supplier scope, conditional and joint stock views, distinct windows, negation, relative versus absolute movement, announcement versus execution, availability dates, embedded instructions and incomplete content. Seventeen reports have publication dates different from their supplied first-supported availability. Fictional future dates exercise calendar boundaries; they are not real events or forecasts.

Three independent assistant authors and pre-run reference reviewers prepared the cases. A/B/C prompts remained byte-identical to the pilot. The inputs, reference, accepted label alternatives and scoring scripts were frozen before nine fresh one-shot worker runs (three matched batches per variant). Outputs were not repaired. All variants match the tested structured reference on 36 reports, 12 identity tasks and 36 comparisons. Each retains 38 Ideas and 14 stock-price judgments across 13 Ideas. Exact quotations: A 42/42, B 48/48, C 52/52. Nine SAME, 24 DIFFERENT and three INSUFFICIENT comparison labels are matched; no incorrect SAME decisions are observed. Ten illustrative source-time reads over the saved JSON pass for each variant; these are not graph or application tests.

Separate assistant reviewers inspected all 114 summaries, 142 selected quotes and 108 comparison explanations, finding no definite material semantic errors while retaining minor ambiguity and citation-completeness observations. A final integrity review verified frozen hashes, raw-to-combined equality and saved scores, and found no artifact mismatch or direct reference contamination. It also identified a repeated comparison-label order. A separately frozen post-score A-only run shuffled all 36 existing comparisons, assigned new IDs and swapped 18 left/right pairs; all 36 labels match. This is a targeted ordering/side diagnostic on existing meanings, not a new held-out set or an A/B/C ranking.

The supplemental independent semantic review found no clear decision or material explanation defect across 36 pairs, but flagged two defensible borderline SAME labels: HM03/SQ14 (conditional prediction versus more explicit causal wording) and HM13/SQ35 (same transaction with differing explicit ownership/announcement attribution). These require owner review of the equivalence boundary. No reference was changed after execution and no label correction is claimed.

Important limits: references and reviews are assistant-authored, not owner-validated; each prompt/batch has one response; isolation is by instruction, not separate filesystem enforcement. Source type, qualifying confirmation scope, availability and candidate lists are supplied. Some comparison tasks restate report claims and resolved windows, potentially assisting extraction. Summary and comparison-explanation semantics are not mechanically scored. The 38 judgment-array checks include 25 empty arrays; they are not 38 forecasts. Quote counts differ by selection and are not independent equal-sized accuracy samples. No actual retrieval, clustering, real-news ingestion, historical operational replay, storage/compression performance or predictive quality is measured. Exact model, sampling, token usage, dollar cost and generation latency remain unknown.

Six separately documented unscored cases expose missing trial distinctions: (G01) conflicting qualifying confirmations and dated on-hold review; (G02) the accepted V1 exclusion of quoted judgments is absent from the experimental instructions; (G03) qualitative horizon versus missing horizon and inferred/configured timing; (G04) organisation-specific domains within a joint Idea; (G05) failed candidate retrieval versus completed no-match and uncertain automatic creation; (G06) snapshot-specific availability uncertainty beneath an older page date. Proposed fields/rules and tests are retained in `hard_contract_gaps.md`, not accepted. V2 quotation attribution and active edit discovery remain deferred.

The successful conditional examples preserve their conditions in summaries, while structured judgments carry only target, direction and dates. A consumer reading only numerical/directional fields would lose those conditions. Flat-price forecasts likewise remain in prose outside UP/DOWN. Review the read contract before claiming these outputs are sufficient for a numerical consumer; do not silently add condition evaluation, reason nodes or a simulator.

Recommendation: retain A as the provisional simplest baseline because B/C show no measured incremental benefit here, review the missing distinctions, and then use an owner-reviewed real-source packet to challenge the supplied upstream assumptions. This does not select a permanent prompt or production interface. Badr's output/query validation, specification and execution-plan review remain outstanding. No C++ application, original Cypher fixture, live graph, paid model endpoint or quant integration changed.

## Discussion item P-020 — Inspectable projection of the retained hard-trial output

Status: disposable review packet produced under ENG-043, 2026-10-15. Subsequent update: ENG-044 records Badr's satisfaction with the graph review and request for the implementation handoff; no production physical representation is accepted. See [Axthena-graph-review-2026-10-15.zip](Axthena-graph-review-2026-10-15.zip), [Axthena-graph-review-guide-2026-10-15.md](Axthena-graph-review-guide-2026-10-15.md), [Axthena-graph-review-load-2026-10-15.cypher](Axthena-graph-review-load-2026-10-15.cypher) and [Axthena-graph-review-queries-2026-10-15.cypher](Axthena-graph-review-queries-2026-10-15.cypher).

The packet deterministically projects the existing fictional A outputs from P-019; no new LLM execution or real-source acquisition is claimed. It retains 36 Reports, 38 Expressions, 38 report-local singleton Ideas, 14 stock-price Judgments, 42 exact evidence Passages and all 68 original Paragraphs. Direct Idea-to-Organisation and Idea-to-Domain links preserve the extracted subjects, including subsidiaries, joint views and unspecified domains. Catalogue ownership/issuance/domain links are explicitly supplied and undated, not reconstructed historical facts. Ten source-only Person identities remain traceable without reintroducing actor roles or inferring real-world identity.

The 12 identity decisions and 36 comparison decisions remain independent diagnostic cases. Candidate lists were supplied; their retrieval was not executed. Comparison cases have no extracted-Idea foreign keys, so SAME decisions do not merge the 38 Ideas. Repeated independent CREATE outcomes are not evidence of sequential duplicate prevention. Per-report processing records and all diagnostic cases trace to the three retained A runs, with original-file hashes and paths. The new AxHardReview export contains 373 nodes and 715 relationships; the original fixtures and live graph remain unchanged.

Offline checks reconstruct every retained report output exactly and verify all 42 quoted spans, original paragraphs, diagnostic fields, run provenance and file hashes. Independent read-only review found a missing diagnostic-to-run link, subsequently fixed. The Cypher loader and queries were inspected but not parsed or executed in Neo4j; no database performance, concurrent loading, rerun or accuracy claim follows from the checks. The packet includes checks the owner can run after loading.

Producing the graph makes the extraction boundary concrete: current outputs do not emit separate structured Event, Fact/Confirmation or dependency records. Their meaning appears in prose or expression classification; those concepts remain part of Axthena's intended world, not silently dropped. Conditions remain in summaries/evidence, and empty judgment lists mean no retained UP/DOWN claim, not no forecast. Availability queries use supplied source dates; historical derived/model-state replay remains unimplemented. Missing distinctions from P-019 still require review.

The twelve-month real-news target is unchanged and is not satisfied by this fictional packet. Real-source/provider/date selection remains open. Badr can inspect the produced records now, then use findings to guide representation, abstraction and query-optimisation research. No production backend, physical schema, new semantic rule, C++ implementation or quant integration is accepted by this projection.

## Discussion item P-021 — Consolidated implementation handoff

Status: produced for owner review under ENG-044, 2026-10-15. See [Repository implementation handoff](../README.md), [Implementation handoff index](../README.md), [Implementation plan](../05-implementation-plan.md) and [Review decisions](../06-review-decisions-and-v2.md).

The packet reconciles AX-001–054 and ENG-001–045, preserving the full decision records and historical evidence. It contains a current scope/supersession map, proposed data/behaviour contract, architecture recommendation, 36 acceptance-scenario families, 13 ordered tasks (T0–T12), six grouped review decisions, V2 backlog, implementer brief, research/artifact inventory and the latest company-view display conventions. Known F/G gaps and HM03/HM13 remain explicit. Existing trial inputs, outputs and scores are preserved; no new extraction benchmark is claimed.

The recommended minimal track is a local typed C++ application, one SQLite store, immutable evidence files, manual versioned ChatGPT task/answer exchange initially, actual name/vector union retrieval, and deterministic graph export. Ladybug is a documented alternative. This recommendation revises the older Ladybug-first advisory plan; neither backend, C++20, libraries, embedding package, interface, source provider, period, fallback duration nor numerical target is accepted. Manual generation exchange does not replace API-first source acquisition or prove full-year processing feasibility.

The owner can now review concrete design bundles instead of repeating discovery. Before implementation, resolve the applicable contracts and approve the specification and plan. Performance optimisation follows correct useful reads and a measured workload. No product code, subscription, live graph or quant integration was changed by preparing this handoff.

## Decision format

For each accepted engineering decision, record **Decision / Reason / Invariant / Trade-offs / Implementation scope / Required tests**.

Where useful, attach the alternatives considered, a concrete counterexample, source documentation, the user's argument and the resulting rationale. Record later revisions explicitly instead of silently replacing history. Do not assign an accepted ENG number to an unresolved product proposal.

## Technical-design work to resolve

1. Initial source packet, historical period, source access and ingestion contract.
2. Explicit identities, organisation/domain relationships and stock/group lookups.
3. Original evidence, versions, source availability and processing provenance.
4. Extraction, grouping, confirmation/hold and failure contracts.
5. Supported reads, views, configurable query scope and output shapes.
6. Storage, recoverable compression, recovery and repeat-ingestion behaviour.
7. Concrete data volume, query/ingestion performance targets and acceptance checks.
8. Reviewed specification and execution plan.

This sequence is a proposed discussion guide, not eight accepted architecture decisions or a fixed implementation plan.
