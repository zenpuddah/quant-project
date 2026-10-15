# Axthena — second discovery review

13 October 2026. Reviewed against Axthena-context.md version 46, decisions AX-001–AX-051, the visible Axthena conversation and the original model review.

**Assessment: ready to begin technical design, with one historical-query meaning to clarify at its start. A new broad discovery round is unnecessary. The model is not yet a frozen specification or an implementation plan.**

This review reconciles later decisions, rechecks the original 30 scenarios and adds 12 focused checks. These are manual theoretical checks, not software tests, an extraction benchmark, a speed benchmark or evidence of trading performance. Proposed repairs below remain proposals. No product implementation was started.

## What V1 is now

Axthena is an information foundation for two primary stocks, **Nvidia and Microsoft**, and their relevant group organisations, suppliers, broad dependencies and competitors.

It collects and retains evidence, extracts supported ideas, records who expressed them, describes relevant business relationships, and serves customisable queries. A first accepted query is:

> For this stock and date range, show relevant events, facts, news and opinions, linked to evidence and the relevant organisation/domain.

Human inspection and program access are both requirements. Persistent storage, compression, efficient processing and fast reliable reads are priorities. Their concrete targets and mechanisms belong to technical design.

The game remains: people and organisations speak and act; events concern organisations, resources and business activities; evidence describes those events; people judge stocks; views select perspectives; later observations can be connected. A role taxonomy, simulator and particular graph database are not required.

Data science, empirical person scoring, predictive training and a trading strategy are outside this V1. LLM-assisted extraction remains in scope. Credibility, influence and predictive-record values may be clearly marked dummy inputs. An eventual numerical representation is an aspiration; no formula or mandatory numerical score has been selected.

## Changes since the first review

| Earlier position | Current owner decision | Effect on the reviewed model |
| --- | --- | --- |
| Strictly one most articulated idea per article. | Extract two separately developed ideas when that case occurs, AX-038. | A report can support multiple selected ideas. Do not hard-code a one-to-one relationship. More-than-two handling still needs a specification rule. |
| News described as unconfirmed organisational information. | Confirmed or rumoured news; opinions remain separate, AX-033–AX-034. | Keep the report distinct from its originating fact and confirmation evidence. |
| One shared judgment was not yet selected. | Share the same meaning, retain each source expression; different periods/reasons remain separate, AX-024/AX-027/AX-037. | Shared meaning must not erase attribution, wording, reasoning, time or confirmation status. |
| Broad judgments included assessments of profits. | Derived V1 judgment labels concern expected stock-price UP/DOWN only, AX-029–AX-030. | Business assessments remain useful source content; profits UP does not automatically produce stock UP. |
| Period handling open. | Stated period, otherwise inference from wording, otherwise configurable near-term default, AX-031. | Preserve which of these supplied the period. No exact duration is chosen. |
| Expressed agreement scale open. | Weak/moderate/strong initially, AX-039. | Qualitative wording labels, distinct from credibility and prediction accuracy. |
| Person components might require meaningful estimates first. | Dummy values permitted; empirical estimation deferred, AX-040–AX-041. | Test data flow without claiming validated person quality. |
| Stock informally associated with one company. | Stock is distinct and can point to several organisations, AX-042–AX-043. | Corporate grouping and supplier dependency remain different relationships. Router/DNS is a lookup analogy, not selected infrastructure. |
| One stock proposed for the slice. | Two stocks and their business surroundings; Nvidia/Microsoft selected, AX-050–AX-051. | Supporting entities may be numerous without becoming additional primary stock targets. |
| Detailed operational readiness proposed. | Source-date reference and daily-OHLCV focus; fine-grained readiness deferred, AX-047. | Do not restore an intraday replay requirement through the old review. Clarify source-date alignment versus collection eligibility separately. |
| Configurable dependency depth proposed in the first review. | Resolve limits against the chosen model/technology, AX-045. | Depth, traversal and cycle handling belong to technical design; no configurable depth is accepted yet. |
| Quotation treatment open. | Quoted judgments omitted from extraction/support in V1, AX-026. | Original quoted evidence remains. First-party announcements and facts are not globally excluded. |

The original review remains a dated proposal document. Its strict single-idea rule, quote-processing examples, non-dummy score prerequisites, single-stock slice and proposed traversal policy must not be treated as the current specification.

## What you got right, and where the design needs care

The strongest choice is making the organisation's business the explanation for relevance. A factory disruption matters through a supported relationship to an activity; a negative headline alone is insufficient. Domains keep chip, software, cloud and other activities distinguishable.

Keeping facts, reports and optional judgments apart is also strong. The company announcement is evidence; an outlet's account of it is another record. A potential impact is not an observed impact. An earthquake's occurrence and a company's transport disruption need separate support.

Sharing meaning while retaining each expression is a useful answer to repeated coverage. Twenty copies can show circulation without becoming twenty independent confirmations. This does not establish a compression ratio: originals, passages and source-expression records still need storage.

Dropping role classifications and empirical scoring gives V1 a clearer boundary. A dummy vector can exercise an interface; it does not validate credibility, influence or prediction ability.

The fragile points are boundaries, not the game itself: article versus idea, shared meaning versus individual expression, an event versus reports of it, a corporate group versus a supplier chain, and source date versus what the system had obtained. These need explicit contracts. They do not justify replacing your model.

The context also accumulated stale prose. “No company universe selected,” “news is only unconfirmed,” broad profit judgments and strict one-idea instructions cannot all remain active. I corrected working summaries and added supersession notes while preserving the chronological decision log.

## Current conceptual picture

These are meanings to preserve, not a number of tables or a database recommendation.

| Concept | Business meaning and accepted boundaries |
| --- | --- |
| **Stock target** | A separately identified traded stock through which the investigator explores associated organisations. Its symbol is a reference, not the organisation's identity. Specific security/listing mapping remains technical work. |
| **Organisation and grouping** | Companies and supporting institutions remain distinct. A stock can lead to several group organisations. Exact grouping and issuing-company/subsidiary detail are still open. |
| **Domain and value creation** | A broad area of work, with processes, inputs, resources, outputs and dependencies. A domain is an activity description, not automatically a subsidiary. |
| **Business relationship** | What one organisation supplies, depends on or competes in, with relevant domain, evidence and dates. Corporate membership is not inferred from supply. |
| **Person/account** | Known people and anonymous individuals with available source references. No invented identity or unsupported merging of anonymous accounts. |
| **Original report/version** | The obtained announcement, article or post, its publisher/source and original content. Retain revisions and source/collection/processing information. |
| **Selected idea and shared meaning** | A short supported meaning extracted from a report. Different developed ideas, reasons, periods and opposing judgments are not collapsed solely because they name the same stock. |
| **Source expression** | This report/person's expression of that idea, including exact wording, attribution, time and applicable agreement strength. It remains distinct even when meaning is shared. |
| **Fact/confirmation/review** | Exact information established through an accepted external process. Conflicting qualifying confirmations require personal review, with a dated hold and decision. |
| **Event** | A distinct described occurrence such as an announcement, quake or production start, with its evidence and confirmation scope. Several reports can concern it; shared subjects do not merge different occurrences. |
| **Optional stock judgment** | Supported expected stock-price UP/DOWN, with period and basis. Absence is not flat-price prediction, zero support or absence of useful evidence. |
| **Potential effect/relevance** | A source-reported or clearly marked inferred connection to an organisation/domain. The supporting dependency path does not establish realised damage or price causation. |
| **View** | Explicit selected sources and retained interpretations over shared evidence. Read mechanics are deferred; a country label is not representative coverage. |
| **Person vector** | Global, domain-independent credibility/influence/predictive record, initially permitted as dummy inputs. Trace their supplied origin and version. |

The idea is what can be shared. The source expression is what keeps people and reports separate. This conceptual distinction follows your decisions; its exact schema is a technical choice.

A claim of a possible partnership can share a subject with a later announcement. That does not make its uncertain wording equivalent to the confirmed announcement. Likewise, identical UP labels do not make two differently reasoned judgments equivalent.

## One owner clarification before historical-query contracts are frozen

The chronology contains two explicit instructions:

1. AX-046: an article published Monday but collected Wednesday does not appear in a Tuesday collection-based historical query.
2. AX-047: point to the source date; main strategies use daily OHLCV; detailed summary-readiness treatment goes to V2.

My later AX-047 note interpreted the second as replacing the first. The user's wording did not explicitly distinguish an ordering/date reference from an eligibility rule. That interpretation therefore needs clarification; it must not silently become the architecture.

An article can be **dated Monday** and **usable by Axthena only from Wednesday**. These are compatible meanings. Alternatively, a retrospective query can intentionally explore Monday's published evidence after collecting it Wednesday. That is a different promise from replaying what Axthena held on Tuesday.

**Recommendation, awaiting Badr:** keep source date for dating/alignment and collection time for the historical “what Axthena held” boundary. Leave exact extraction-delay simulation deferred as requested. If V1 instead uses source-date retrospective reads, explicitly label that mode and retain collection and processing history.

This is a meaning decision. It is not a demand to build an intraday latency simulator.

Daily bars do not remove the issue. A Monday 18:00 report cannot enter a Monday opening decision just because the query groups data by day. The later filing that describes an earlier quarter also cannot replace the version actually available earlier. Preserve source-version dates separately from the period being described.

Recording source text and storing an AI output now supports repeatable retrieval of that output. It does not prove that the model, its selection or the result existed historically. Predictive-model validation remains outside V1; technical design should describe V1's historical output honestly.

## Rules to finish in the technical specification

These are concrete tasks for the next round, not a new broad discovery interview.

| Contract to specify | Example that exposes the gap | Proposed minimal handling, not yet accepted |
| --- | --- | --- |
| **Confirmation scope and recognised origins** | A company announcement contains both measured results and a superlative. An earthquake authority confirms occurrence but not factory damage. | Explicitly tie confirmation to supported information; enumerate the initial accepted processes/sources. Do not apply one verified sentence to the whole article. |
| **Hold and correction reads** | Two valid processes genuinely disagree; an outlet later corrects its report. | Make held/conflicted material inspectable with status; keep it out of silently “settled” outputs. Corrections link to retained versions. Ordinary commentary disagreement is not the personal-review hold. |
| **Extraction boundaries and failures** | Three developed ideas; a broken passage; a conditional stock prediction; an unsigned editorial. | Define count/budget, evidence support checks and omission/review behaviour. Permit unresolved person attribution rather than fabricate a person. Only qualifying-confirmation conflicts already mandate personal review. |
| **Sharing and counting** | Same meaning across copies; same article ingested twice; two ideas from one report; an overlapping view. | Distinct report, version, idea, source expression and supported origin counts. Store uncertain origin/equivalence explicitly. Do not require a new learned grouping system to finish V1. |
| **Business identity and relevance** | Azure is treated as a legal subsidiary; a supplier has a reused name; one provider appears on multiple paths. | Distinguish activities from organisations, use stable references, record link meanings and evidence. Decide supported query reach and cycles against the chosen technology. |
| **Time and configuration versions** | “Next month” appears in articles published in different months; a default horizon changes. | Retain original wording, date anchors and configuration versions. Do not merge periods only because the same broad category was assigned. |
| **Views and reads** | Two selected outlets disagree; a filter hides one side of a known confirmation conflict. | Version source selection and interpretations; a filter changes display selection, not established evidence history or conflict resolution. |
| **Storage and operations** | Storage is compressed; a process stops after saving evidence but before interpretation; the same input is retried. | Recover required original content, preserve trace links, prevent duplicate publication mentions on retries, and define completeness/errors. Specify supported queries and measurable targets before performance claims. |

A rejected summary and a disagreeing source are different problems. A failed extraction should not produce a rumour classification merely because processing failed. Similarly, a provisional identity or missing weight is not “on hold” unless the owner separately chooses such workflow.

The first dataset must also specify a historical period, concrete source access, a manageable evidence packet, languages and volume. Choosing two primary stocks does not bound a crawl of every supplier and competitor. Those are scope parameters to settle before the execution plan.

## Recheck of the original 30 scenarios

“Covered” means the accepted concepts describe the expected result. “Specify” means the concrete rule must be selected in technical design. “Clarify” marks the owner time-meaning question above. No row is a passing runtime test.

| Case | Revisited result under the latest decisions | Status |
| --- | --- | --- |
| T01 — organisation before IPO | Keep the organisation before it has a traded stock; no invented pre-IPO prices. | Covered; identity contract to specify. |
| T02 — classes, listings, reused symbol | Resolve the particular stock reference and dated organisation links; do not mix prices. Full listing design remains open. | Specify. |
| T03 — proposed acquisition cancelled | Retain dated reports; no projected ownership; no erasure of the proposal. | Covered. |
| T04 — acquisition completed later | Completed membership needs separate supported evidence and time; preserve previous identities. | Covered; change contract to specify. |
| T05 — many quake reports and an aftershock | Repeated coverage can concern one occurrence; aftershock remains another occurrence. | Covered; same-occurrence grouping to specify. |
| T06 — stock judgment without named event | Preserve the stock/org/domain subject; do not fabricate an event. Optional event attachment is a proposed handling rule. | Specify. |
| T07 — wrong affected port | A country's name alone does not link the affected route to the supplier. | Covered; relationship evidence needed. |
| T08 — new equipment delayed, installed machines run | An upgrade/shipment dependency does not prove existing production stopped. | Covered. |
| T09 — alternative manufacturers | Retain known suppliers without inventing exposure shares or spare capacity. | Covered. |
| T10 — chip/software domains share a resource | Keep separate domains and evidenced resource uses; no automatic equal effect. | Covered. |
| T11 — demand change or competitive technology | Retain relevant business information and competition; no automatic stock-direction label. | Covered. |
| T12 — cycles and generic suppliers | Meaningful paths remain; exact traversal limits/cycle policy belong to technical design under AX-045. | Specify. |
| T13 — January relationship disclosed in June | January described start is not January knowledge. Do not put June disclosure into March evidence. | Covered requirement; time contract must be explicit. |
| T14 — mixed earnings/rumour/judgment article | Separately developed ideas may split. Confirmation is scoped; optional price judgment is separate. | Covered; extraction boundaries to specify. |
| T15 — quoted analyst/CEO judgment | Preserve raw quotation; omit relayed quoted judgment/support in V1. Facts/first-party announcements remain eligible within their evidence scope. | Covered; quote-detection boundaries to specify. |
| T16 — unnamed engineer relays another person's claim | No fabricated direct statement or recurring anonymous identity; confidential-source news remains rumoured pending confirmation. | Covered; unresolved attribution to specify. |
| T17 — claimed lower chip power | Presentation, stated claim, test conditions and general superiority remain distinguishable. | Covered; confirmation qualification to specify. |
| T18 — two EPS numbers with different bases | Different definitions are not automatically conflicting confirmation of the same claim. | Covered; comparison criteria to specify. |
| T19 — restatement and later user review | Keep earlier versions/hold and later review separately; do not rewrite old outputs. | Covered; query status defaults to specify. |
| T20 — “may stop if talks fail” | Preserve uncertainty and condition; summary must not assert a stoppage. | Covered; support checks to specify. |
| T21 — two equally developed ideas | Split the separately developed ideas under AX-038. The old mandatory tie-review/single-idea proposal is superseded. | Covered; more-than-two rule open. |
| T22 — same URL revised, model later changes output | Keep source/processing versions; no silent overwrite or extra publication mention for an extraction rerun. | Covered; version selection to specify. |
| T23 — twenty copies, original withdrawn | Retain spread and supported origin; withdrawal is a dated change, not independent proof of the opposite claim. | Covered; withdrawal semantics to specify. |
| T24 — anonymous handle changed/reused | Available stable source identity and dated aliases prevent unsupported history transfers. | Covered; identifier design to specify. |
| T25 — similar accounts or entirely unnamed source | Retain evidence without unsupported merging or invented real identity/vector ownership. | Covered; unresolved records to specify. |
| T26 — no person history or unfinished prediction | Dummy components may exist, clearly labelled. No empirical prediction calculation is required in V1. | Covered; scoring deferred. |
| T27 — right business prediction, opposite stock move | Source content and price judgment stay distinct; no causal influence or motive conclusion. | Covered; empirical evaluation deferred. |
| T28 — late/after-hours report or uncertain date | Day-level use does not authorise earlier opening inclusion. Select boundaries and uncertain-date handling. | Specify; collection/source interaction to clarify. |
| T29 — full daily bar, revision or adjustment | Price data contracts belong to Qaedalus/integration; V1 evidence reads must not claim the day's completed observations were opening inputs. | Scope preserved; integration deferred. |
| T30 — modern processing, changed/overlapping views | Freeze source/output/view versions. Source-aligned research is not proof of operational historical readiness. | Clarify time meaning; operational detail deferred. |

## Twelve additional checks from the later discussion

| Case | Stress scenario | Reviewed result |
| --- | --- | --- |
| N01 | Two authors give the same UP/month judgment for different reasons. | Keep ideas separate, retain each reason and person. Matching labels are insufficient for equivalence. |
| N02 | Two authors express equivalent reasoning with different emphasis. | Shared meaning is possible; each source expression and agreement level remains distinct. |
| N03 | “UP next month” is published in January and in March. | Same phrase/category does not establish the same actual period. Date anchors are needed before merging. |
| N04 | A source gives no period; the configured default changes later. | Preserve the default assumption/version; do not revise old periods silently or present the default as source wording. |
| N05 | An article says profits rose and stock fell yesterday. | Retain factual/business content. Neither statement alone is a source expectation of future stock UP/DOWN. |
| N06 | Two developed ideas come from one report that is downloaded twice. | Preserve two idea links, one report identity and separate processing history. No extra publication mention solely from extraction count or retry. |
| N07 | Unnamed source says a partnership exists; later company confirms it. | Preserve rumoured evidence and the later originating fact separately. Earlier status does not become retroactively confirmed. |
| N08 | Institution confirms quake occurrence; company damage is only inferred. | Confirm occurrence within scope; potential effect remains separate and labelled with its path. |
| N09 | An institution predicts a future quake. | Preserve original source material. Structured external-event forecast representation stays deferred; do not invent occurred quake or future world state. |
| N10 | One organisation is both an evidenced subsidiary and a supplier. | Supply alone does not prove group membership. Independently supported relationship meanings may coexist. |
| N11 | A view includes both the original report and a known copy. | Both can show circulation within selected coverage; they do not become independent confirmations or extra evidence when views overlap. |
| N12 | Sharing ideas and compressing originals reduces storage. | Preserve all required originals and expression links. Meaning sharing is not proof of byte-level recoverability or a speed/compression ratio. |

## Two combined walkthroughs

### Report becomes confirmed, then is corrected

All names and dates in this example are fictional.

On Monday an outlet reports a possible NovaChip partnership, citing unnamed sources. Its two selected ideas are a possible partnership and a clearly expressed stock-UP expectation. Tuesday several outlets copy the first report. Wednesday the company issues a partnership announcement. Thursday it clarifies that the agreement covers research only, rather than commercial chip production.

The records must preserve the Monday uncertainty, Tuesday spread, Wednesday originating evidence and Thursday scope correction. Two extracted ideas do not double the publication count. Copies do not independently establish the partnership. The UP expression remains a judgment, even if the partnership is confirmed. Its agreement label and period belong to its own expression, not the external fact.

A Monday query must not incorporate Wednesday confirmation or Thursday terms. If Monday's source wording was only collected Wednesday, whether it appears in an earlier Monday/Tuesday query is exactly the remaining source-date versus collection-time decision. Retaining versions solves later-content substitution; it does not decide that eligibility question.

### Disruption affects a domain through a group and supplier path

NovaGroup has NovaChips and NovaSoftware, kept as distinct organisations with relevant domains. NovaChips relies on NovaFab, which depends on equipment deliveries from MachineCo. MachineCo also supplies a competing chip firm.

An earthquake occurrence is confirmed. A separate report describes a transport route closure. Evidence connects MachineCo's new equipment shipments to that route. A retained inference can connect the disruption to NovaChips' upgrade plans, while the effect on installed production remains unknown. Nothing in the packet establishes a software-domain exposure.

A stock query can show why the information matters through group association and dependencies. It must not move NovaFab into the corporate group merely because it supplies NovaChips, treat the competitor as the primary stock's subsidiary, or announce that every chip factory has stopped. Several paths to the same stock do not create several independent reports. Query-depth policy remains technical design; missing deeper analysis is not evidence of no deeper exposure.

## Research supporting the checks

The primary sources inform safeguards, not implementation choices:

- [W3C PROV-DM](https://www.w3.org/TR/prov-dm/) distinguishes produced information, responsible parties, derivations, revisions and source relations. This supports retaining lineage separately from shared meaning. No full W3C model, RDF representation or graph database is selected.
- [Gao et al., 2023, Enabling Large Language Models to Generate Text with Citations](https://aclanthology.org/2023.emnlp-main.398/) evaluates generated correctness and citation quality separately. The application here is that a passage link and a supported summary need separate inspection. Its benchmark results are not Axthena accuracy results.
- [SEC EDGAR API documentation](https://www.sec.gov/search-filings/edgar-application-programming-interfaces) describes update timing and frames selecting last-filed facts for periods. Inference for Axthena: a current response describing an old period is not automatically the old information version.
- [NYSE hours/calendars](https://www.nyse.com/trade/hours-calendars) distinguishes market sessions and exceptional closes. It illustrates why day labels alone do not define an opening/closing information boundary. No market-calendar implementation is selected.

The original review's bibliography remains available for later causal/predictive work. This review does not resume it as a required V1 scoring task.

## Handoff to technical design

Proceed with the data-foundation design. Start by clarifying the time promise, then resolve the specification contracts above while selecting concrete alternatives.

A focused technical round should produce: a bounded evidence packet for Nvidia and Microsoft; exact conceptual identities/relationships; source and interpretation version rules; allowed reads and time semantics; ingestion/extraction failure handling; storage/compression choices; query and ingestion performance targets with a test volume; and reviewable acceptance tests.

The initial exact sources, historical period, languages, source access and supporting-world breadth must be selected before the implementation plan is executable. “Fast” is not a target until we specify which query, how much data and acceptable latency. “Compressed” is not complete until required originals and passage references remain recoverable.

A sensible proposed acceptance flow is: collect the packet, recover originals, derive supported ideas, preserve statuses and links, repeat without duplicate mentions, inspect dated changes, query both stocks, and measure reads at the agreed scale. This is a proposal for specification, not an accepted automated workflow.

Then review the written specification, produce and review the execution plan, and make the focused implementation pass. No DB, language, provider, interface or numeric encoding is chosen by this report.

**Readiness result:** the revised concepts are adequate for entering technical design. Historical-query meaning needs one focused owner clarification; other open items are normal specification decisions. Actual correctness, compression and speed remain to be validated after implementation. The original game model and project boundaries remain intact.
