# Axthena — model stress test and revised candidate

13 October 2026. Discovery review. **All new choices below are proposals awaiting Badr’s decision.**

The proposed model has a sound core. Its business structure, evidence requirements and historical constraints survive the difficult examples. Most weaknesses are handling rules that remain unspecified, rather than contradictions in the accepted model.

This review compares the latest owner model with a revised candidate. It includes 30 fictional counterexamples, a combined five-trading-day walkthrough, proposed decision records and a recommended first useful result. These are manual conceptual checks. No product was implemented, no extraction system was benchmarked, and no predictive performance was established.

The baseline is Axthena-context.md, including AX-001–AX-023. AX-016 is withdrawn. The owner’s corrections take precedence over earlier assistant interpretations.

## What the owner got right

**Business meaning comes before price.** Organisations, their domains of execution and broad value creation explain why a report might matter. This is stronger than treating every article as an isolated positive or negative headline.

**Evidence stays inspectable.** Keeping the original report, choosing one developed idea and linking the summary to its exact passage gives an investigator something concrete to challenge.

**The concepts remain separable.** Confirmation, judgment, attribution, indirect relevance and person weighting answer different questions. The accepted requirements already prohibit turning an inferred connection into a confirmed effect.

**Historical knowledge matters.** Information discovered later cannot be used in an earlier decision. This requirement applies to relationships and person vectors as well as news.

**The first pass has boundaries.** Broad dependencies, one main idea, no role taxonomy, no projected future world and no domain-dependent person vector are useful scope decisions.

The weak points arise when these concepts are compressed too aggressively. An article-wide fact label, a bare supplier link, a ticker used as company identity, or an unexplained numerical vector would erase distinctions that the owner already wants to preserve.

The earlier expected-future layer was an assistant mistake. It is excluded from this candidate.

## Original model compared with the candidate

The left column describes the owner’s concepts, including their open questions. It does not claim that an unimplemented system already behaves incorrectly.

| Owner model | Risk if the open rule stays unresolved | Revised candidate |
| --- | --- | --- |
| Events organise the information. | Every statement might be forced into an event; several reports might become several copies of one incident. | Events remain important anchors. A statement can concern an organisation or domain without an event. Several reports can concern the same incident; meaningful later developments remain dated. |
| Confirmed information is fact, through external processes. | Confirmation might spread from an announcement to every claim inside it. | Confirmation identifies the exact information, evidence, process and time. Announcing a result and independently establishing its general validity remain distinguishable. This tightens AX-003. |
| News comes from organisations; opinion from personally speaking individuals. Judgment attaches to the report and person. | Publisher, writer and quoted speaker might be mistaken for one another. Unsigned judgments might receive invented people. | Preserve those parties separately when known. Retain indirect quotation as reported. Permit unresolved personal attribution. The exact label for representative speech still needs an owner decision. |
| One most articulated idea per article, selected by an LLM. | A valid passage link might support only part of an invented summary. Reprocessing might rewrite history. | At most one applicable selected idea per article at a decision time. Freeze the output and its source version. Check wording support separately from link validity. Tie or support failures remain unresolved for review. |
| Organisation, domains, processes, inputs, resources, outputs and broad dependencies. | “Supplies” might mean materials, installed equipment, an upgrade or a replaceable service. All might imply the same effect. | Each link says what it supports and which domain is involved. Unknown dependence strength stays unknown. Shared resources, alternatives, demand and competition can be described where supported. |
| A stock represents an organisation. | Company history, ticker history and particular traded instruments might be merged. | Distinguish organisation, security and listing. A company can exist before its IPO and have several instruments or listings. Names and tickers have dated mappings. |
| Opening and closing pictures follow the selected price intervals. | Event time, publication, collection and extraction readiness might be treated as one timestamp. | Preserve these times separately where applicable. Declare the historical-use policy. Every supporting link and derived result obeys the same decision cutoff. |
| One overall credibility/influence/predictive-record vector per person. | Undefined numbers might masquerade as measured reliability or market power. | Retain the three components, without domain input. Record definitions, basis, missing values, calculation time and historical applicability before use. |
| A mass person is an anonymous individual. | Reused handles or completely unnamed sources might be merged into one history. | Preserve source-scoped account identity when available. Unknown attribution remains tied to its passage. Cross-account identity requires evidence and a date. |
| Views retain source selections and interpretations. | Copied coverage might look like independent agreement or a national consensus. | Views have explicit versions and shared evidence references. Coverage, independent origin and interpretation remain distinguishable. |

The candidate preserves the game around stocks: people, organisations, events, resources, relationships, perspectives and observable responses. It adds precision to those connections.

## The compact candidate

These are conceptual records, not a proposed number of database tables.

| Concept | What it means | Minimum information to preserve |
| --- | --- | --- |
| **Organisation and domain** | The business or supporting institution, and the broad area of work being studied. | Stable identity, dated names, entity kind, domain descriptions and their evidence. Supporting suppliers or government bodies need no stock. A country name does not identify a particular ministry. |
| **Value creation and dependency** | How a domain produces value, and what it relies on or supplies. | Broad process, input/resource/output descriptions; directed relationship meaning; relevant domain or need; supporting evidence; described period and knowledge time. |
| **Stock/security and listing** | The particular asset and market quotation used in a price comparison. | Its organisation link, identity, listing market, currency, dated ticker mappings and applicable trading history. The first slice can use one listing. |
| **Person and account** | An identifiable or anonymous individual, with available source references. | Person reference when justified, platform/account references, dated aliases and supported identity links. Account continuity is evidence of a recurring account, not proof of uninterrupted human control. |
| **Source report and retained version** | The article, announcement, transcript or post actually obtained. | Original content, source reference, publisher, available author, language, version, source-release evidence and collection time. Copy, correction and withdrawal links when supported. |
| **Selected idea and optional judgment** | The article’s one most developed idea and any assessment contained in it. | Short summary, exact supporting passage, source version, attribution, subject, organisation/domain pairs, optional event links and extraction record. Judgment stays attached to the report. |
| **Confirmation and review history** | The basis for treating exact information as fact, or leaving it unconfirmed or on hold. | Exact information and material definitions, external process, evidence, conclusion and time; conflicts; dated personal review and its basis. |
| **Event and subject/relevance links** | An occurrence described in evidence, plus why the evidence relates to a subject. | Event scope and time, reported/confirmed basis, related developments; direct source subject links; separately labelled inferred relevance paths. A proposed future outcome stays in the report. |
| **View** | A defined perspective over shared evidence. | Name, selected sources and rules, version, interpretations and their basis. Overlapping views do not create additional independent evidence. |
| **Person vector and later evaluation** | Defined assessments and observations that quant may use. | Three domain-independent components, definitions, provenance and applicable time. Later evaluations identify the statement, target, outcome rule, observation period and data version. |

Inputs, resources and outputs describe an item’s use in a particular business process. MachineCo’s equipment can be its output and a factory’s resource. No exclusive global category is required.

A broad supplier relationship does not automatically supply exposure percentages, spare capacity or delivery deadlines. Missing details remain unknown.

Automatic article processing stays limited to one main idea and its necessary attribution and subject links. Initial organisation descriptions and dependency paths can be supplied and reviewed separately with evidence. This avoids quietly expanding the article pass into complete extraction of every business claim.

### Meaning of fact, news, opinion and judgment

Keep the owner’s words, while recording the questions separately:

- Where does the information originate: organisational expression, personal expression, or unresolved attribution?
- Who published it, and to whom does the selected passage attribute the statement?
- What exact information is confirmed, through which process?
- Does the selected idea contain a judgment, and what is its subject?

For example, an outlet reports Mira’s doubts about a partnership. The outlet is the publisher. Mira is the attributed speaker of the judgment. The evidence may be the outlet’s quotation rather than Mira’s original statement. Recording it does not establish that the outlet agrees.

An official technology announcement can establish that NovaChip made a particular claim. Confirmation of a measured result must retain the test conditions that the qualifying process establishes. A broader conclusion about all workloads or future profitability needs its own basis.

An unsigned editorial can contain a judgment while its responsible individual remains unidentified. The report stays usable; no personal vector is invented.

### Meaning of the person vector

The three components are preserved. Their exact measurements remain unselected.

| Component | Defensible intended meaning | What cannot establish it alone |
| --- | --- | --- |
| **Credibility** | Reliability under a stated criterion, supported by attributable evidence and a defined history or explicit assessment. | A subsequent stock rise, an impressive job title, or an unexplained manual number. |
| **Influence** | A clearly stated influence assessment. Observable attention, reach or responses can support a labelled proxy if the owner chooses one. | A post preceding a price movement does not prove market causation. Attention and causal market power are different quantities. |
| **Predictive record** | Performance of eligible statements against a specified target, period and outcome rule. | An unspecific judgment cannot automatically become a price forecast. Predicting a real delivery delay is not the same task as predicting the share price. |

Unknown is distinguishable from a measured zero. A manual starting assessment is identified as manual. Its date and reasoning are retained.

One applicable vector remains the same across this person’s opinions on different domains at the same historical time. Domain information stays on the opinion and does not enter the first-pass weighting rule.

A history built from selected main ideas is a record of the retained sample. It is not the person’s complete public record.

An inverse pattern found later is a research result with a calculation date. It cannot be applied to earlier decisions that preceded its discovery. A useful assessment needs subsequent evaluation under an agreed rule; no inverse-person formula is selected here.

Multiple organisation/domain links preserve one underlying idea. They do not automatically multiply independent opinions or scoring observations. Any later comparison involving several stocks needs an explicit evaluation unit.

A view’s interpretation does not overwrite the underlying report, attribution or recorded external conclusions. Filtering one conflicting source out of a displayed view does not resolve the known conflict. The displayed status must retain its evidence basis, including relevant material outside the selected view when necessary.

### Meaning of historical availability

Four questions can have different answers:

1. When did the event occur, or which period does the statement describe?
2. When was the exact source version released to its relevant audience?
3. When did Axthena obtain it?
4. When was the derived summary, relationship, review or score ready?

A printed publication date alone may not establish the availability of the exact retained wording. Date-only and uncertain timestamps remain uncertain.

For a replay of Axthena’s actual operation, a derived result is usable only after its required evidence, processing and approvals were ready. Every dependency in a relevance path must also have been known by that cutoff.

Historical imports processed now are separately labelled retrospective research. They can help explore old evidence. They do not establish that Axthena or its current classifications existed then.

A modern LLM may have encountered later developments in training. Restricting the supplied article and preserving exact quotations does not prove that its selection of the main idea is free of hindsight. A historically valid predictive experiment therefore needs a declared model and data eligibility policy. Training a special historical model is not proposed for this MVP.

Opening and closing pictures are readings of one retained timeline. They do not require copying the entire database every five days. The timeline retains changes between the boundaries.

## Thirty counterexamples and expected results

All scenarios are fictional. The expected results express the candidate’s rules, not observed software behaviour.

| Test | Counterexample | Required result under the candidate |
| --- | --- | --- |
| **T01** | NovaChip operates for years before going public. | Preserve organisation history. Record the IPO/listing separately. Do not invent earlier publicly traded price data. |
| **T02** | Two share classes, two listings, or a reused ticker exist. | Resolve the particular security/listing and dated organisation mapping. Do not merge prices or duplicate company evidence. |
| **T03** | A manufacturer acquisition is announced and later cancelled. | Retain both dated announcements. Create no anticipated ownership or supplier relationship. Preserve the earlier report. |
| **T04** | A deal later completes. | Add only the evidenced completed relationship and its scope at the appropriate knowledge time. Preserve earlier identities and information. |
| **T05** | Three articles describe one earthquake; a later report describes an aftershock. | Several reports can concern one incident. Preserve a meaningful later occurrence separately. Event grouping itself has evidence or an inference basis. |
| **T06** | A judgment says the software business is undervalued without mentioning an event. | Link the judgment to organisation/domain. An event reference is optional. Do not fabricate an event. |
| **T07** | A quake closes NorthPort; MachineCo uses SouthPort. | Country co-location does not establish disruption. Require the relevant route, facility or resource connection. |
| **T08** | New machines cannot be shipped, but installed machines keep operating. | Distinguish shipment/upgrade exposure from current production. No automatic factory shutdown. |
| **T09** | NovaChip uses two manufacturers, but substitute capacity is unknown. | Preserve both links and known coverage. Do not assume equal exposure or immediate replacement. |
| **T10** | Chip and software domains share a platform. | Preserve the shared resource and separate use links. Shared ownership does not establish identical impact. |
| **T11** | A customer cuts orders; a competitor presents new technology. | Permit evidenced demand/customer and competitive connections. A claimed opportunity does not become realised revenue. |
| **T12** | Suppliers form cycles and share generic logistics providers. | Use directed, meaningful, bounded paths without repeated subjects within a path. Preserve paths while deduplicating targets. Unexamined reach is not zero exposure. |
| **T13** | A January supplier relationship is first disclosed in June. | Retain January as the described start, June as knowledge availability. Exclude the relationship from March decision pictures. |
| **T14** | A release reports earnings, rumours and an analyst judgment. | Select at most one developed idea. Confirmation is scoped to exact information; it does not classify the whole article’s contents. |
| **T15** | A publisher quotes a CEO or analyst. | Preserve publisher, available author, speaker and expressed organisational capacity separately. Do not transfer the quotation to the writer’s personal history. |
| **T16** | “An unnamed engineer says Director Kim told her the plant closed.” | Preserve indirect attribution. Do not create a direct verified statement by Kim or reuse a generic anonymous person. |
| **T17** | NovaChip presents a chip and claims lower energy use. | Distinguish presentation, stated claim, any confirmed conditional measurement and broader interpretation. No unrestricted performance fact. |
| **T18** | Two official EPS figures use different accounting bases. | Compare period, units and material definitions before declaring a conflict. Distinct measurements can coexist. Genuine conflicting confirmations enter on hold. |
| **T19** | Earnings are restated and a later personal review accepts one conclusion. | Preserve both disclosures, claimed correction links, any continuing conflict and dated review. Neither later figure nor review rewrites earlier outputs. |
| **T20** | A passage says production may stop if talks fail. | A summary cannot say production stopped. Check support, uncertainty, condition and attribution separately from passage-link validity. |
| **T21** | Two ideas are equally developed; a brief secondary point is financially important. | Do not change the prominence rule to trading importance. Hold the tie for review under the proposed rule. Preserve secondary content in the original. |
| **T22** | An article changes at the same URL; the extractor later changes its choice. | Retain source and extraction versions. Select one applicable main-idea output at each cutoff. Do not treat revisions as independent reports. |
| **T23** | Twenty outlets reproduce one story; the original is then withdrawn. | Preserve distribution and withdrawal. Copies do not become independent confirmation. Withdrawal is loss of source support, not proof of the opposite proposition. |
| **T24** | An anonymous account changes handle; another takes its former handle. | Preserve platform/account reference and dated aliases. Do not transfer the old history or vector to the new account. |
| **T25** | Similar handles appear on two platforms; another article just says “sources.” | Do not merge accounts without evidence. Unresolved attribution remains attached to the passage and receives no invented reusable vector. |
| **T26** | A new person has no history; a five-day forecast has only two days of outcomes. | Missing vector components remain unknown. Unfinished outcome periods cannot update a completed predictive record. |
| **T27** | A person predicts a real delivery delay but the stock rises; another posts before a rally. | Reliability about delivery, price prediction and causal influence remain separate. No automatic motive, insider or market-power conclusion. |
| **T28** | A report arrives around opening, a weekend, an early close, or exactly at an uncertain boundary. | Use actual selected market boundaries and an explicit inclusion policy. Defer uncertain ordering conservatively in operational replay. Do not alter source timestamps. |
| **T29** | A daily price row is stamped at its start; a later download contains revisions or split adjustments. | Its full-day observations are not opening inputs. Retain the dataset and adjustment policy used. Distinguish later measured outcomes from then-available observations. |
| **T30** | A modern model processes an old article; overlapping views later change their source lists. | Keep retrospective extraction and view versions explicit. Do not treat later interpretations as then-ready classifications or overlapping coverage as independent evidence. |

If foreign-language evidence enters the selected packet, original wording and translated wording must remain distinguishable. The translation has its own version and processing time. No language or translation pipeline is selected by this review.

## Rechecking the six linked events

The original chain remains useful. The following shows what the candidate records without turning proposed effects into established facts.

| Event in the owner’s fictional chronology | Connection to the business world | Boundary preserved |
| --- | --- | --- |
| **War closes a shipping route.** | Relevant route/resource connections may link the report to a manufacturer or equipment supplier. | War occurrence, route closure, company exposure and actual company impact each need the appropriate evidence. |
| **Earthquake disrupts Dutch transport.** | A supported MachineCo transport dependency may concern equipment deliveries to the factory. | The path does not establish interruption of existing chip production or all activities in the Netherlands. |
| **Technology announcement.** | The chip domain describes an output and the company’s performance claim. | Preserve the announcement and any qualifying measurements. Do not create forecast demand or profitability states. |
| **IPO.** | A listing connects a traded asset to an already-existing organisation. The prospectus can describe business dependencies. | Intended use of funds remains a dated statement; proposed diversification does not become a supplier relationship. |
| **Acquisition announcement.** | Its source explanation may relate the proposal to earlier disruption concerns. | Announcement is an occurrence. Proposed ownership or operational benefit remains source content until supported completion or observation. |
| **Earnings announcement.** | Reported results and company statements about delays can link to earlier developments. | “The company attributes expenses to the quake” is distinguishable from an independently established causal explanation and from stock-price causation. |

The events do not need one universal “caused” relationship. “Mentions,” “responds to,” “reports an effect,” “supplies equipment” and “Axthena infers relevance” have different meanings. Retain the meaning and basis of each link.

### Combined five-trading-day check

Assume a fictional selected market opens at 09:30 and closes at 16:00 on these five ordinary trading days. This is a walkthrough, not selection of a market, calendar or permanent interval.

Before Day 1, reviewed evidence establishes:

- NovaChip’s chip domain uses NovaFab manufacturing.
- NovaFab uses MachineCo equipment; the evidence distinguishes new equipment delivery from installed production equipment.
- NovaChip also has a software domain. The packet contains no supported connection from this transport route to that domain.

| Time | Information received or derived | Picture at that time |
| --- | --- | --- |
| **Day 1, 02:00** | A quake occurs, but Axthena has no report yet. | The occurrence time alone provides no usable evidence. |
| **09:25 / 09:28 / 09:31** | An outlet releases a shipment-delay article, Axthena collects it, and its selected idea becomes ready respectively. | At 09:30 the raw report can be inspectable, with processing pending. Its later derived idea is unavailable. A processed-information query must show the coverage gap. |
| **10:00** | A reviewed inference links that idea through the known equipment/manufacturing path to NovaChip’s chip domain. | The indirect link is now available. It concerns shipment/upgrade exposure; it does not claim a chip-production halt. |
| **Day 1 close** | The article and inferred relevance are ready. | The closing picture includes both, with different attribution and basis. No supported software connection has been established; this is not proof the software domain is unaffected. |
| **Day 2** | The article is revised. A company statement says installed production continues. | Preserve both article versions. Continued production does not contradict delayed new equipment. Apply confirmations only within their established scope. |
| **Day 3** | A proposed acquisition is announced. Two qualifying processes genuinely disagree about one separately identified earnings figure. | Keep the acquisition as announcement content. Put the conflicting earnings information on hold; other evidence remains queryable. |
| **Day 4** | An anonymous account changes handle. A new five-trading-day prediction begins its observation period. | Preserve account continuity where supported. This prediction remains unfinished at Day 5. Do not use a reused handle or unfinished outcome to change earlier vectors. |
| **Day 5, 15:00** | The owner reviews the held figure and records a decision and basis. | The closing picture includes the dated review. Reopening the Day 3 picture still shows on hold. |
| **After the relevant measurement period** | The selected price observations become available for an agreed comparison. The Day 4 prediction needs its own completed five-trading-day period, beyond this example block. | Link completed observations as outcomes under the selected measurement rule. They do not confirm a causal explanation. A later score update cannot appear in Day 1’s vector. |

This combined case checks that the fixes work together. The idea count remains bounded; evidence is retained; the person stays anonymous; domains stay separate; no future world is created; and historical dependencies, reviews and vectors use one consistent cutoff.

## Proposed decision records

These records are intentionally **pending**. They may be copied into the accepted log only after Badr accepts them.

### R1 — Scope meaning and attribution

**Decision proposed:** Keep origin, speaker attribution, confirmation and judgment separately recorded for the selected idea. Permit unresolved personal attribution.

**Reason:** Mixed articles and quotations cannot be represented faithfully by one article-wide label or invented individual.

**Invariant:** Confirmation applies only to the exact information established. Judgment retains its report, subject and responsible person where identifiable.

**Trade-offs:** More explicit information; some outputs remain unresolved. Representative speech and review/supersession label rules still need agreement.

**Implementation scope:** Selected-idea records, relevant attribution links and confirmation/review history; no exhaustive claim extraction.

**Required tests:** T14–T19, including unsigned editorial and indirect quotation variants.

### R2 — Retain versions and accept supported extraction

**Decision proposed:** Preserve each source revision and selected output. Check exact passage membership and full summary support separately. Tie or support failures produce a review item.

**Reason:** A live URL or citation alone cannot guarantee the meaning of the generated summary.

**Invariant:** At most one applicable selected idea per article at a given cutoff; unchanged prominence criterion; no unsupported completion of a claim.

**Trade-offs:** Some articles lack a ready idea until review. Several supporting passages for one idea remain an optional clarification, not permission to add ideas.

**Implementation scope:** Evidence retention, extraction provenance and a minimal unresolved/review state.

**Required tests:** T20–T23 and the opening-time pending-output case.

### R3 — Preserve business identity and relationship meaning

**Decision proposed:** Distinguish organisation, security/listing, event scope and domain-specific dependency use. Allow judgments without event references.

**Reason:** IPOs, ticker changes and equipment delays expose otherwise ambiguous joins and effects.

**Invariant:** Broad descriptions stay broad; dependencies do not prove impacts; planned changes do not create future states.

**Trade-offs:** Requires explicit references and reviewed relationship descriptions. Missing exposure strength and substitution remain unknown.

**Implementation scope:** One selected stock/listing and its small supporting world. No industrial or geopolitical simulator.

**Required tests:** T01–T11 and all six linked events.

### R4 — Bound indirect relevance

**Decision proposed:** Use a small reviewed set of meaningful directed paths, with a configurable maximum depth, no repeated subject within a path and deduplicated targets.

**Reason:** Cycles and generic providers can otherwise make nearly every event appear related to every stock.

**Invariant:** Every path edge and inference is eligible at the decision time; inferred relevance remains distinct from source claims and realised effects.

**Trade-offs:** Bounded search misses some connections. Report “not assessed beyond this scope,” not “no exposure.”

**Implementation scope:** Manually reviewed paths initially; no worldwide automatic dependency discovery. The concrete depth remains to be chosen.

**Required tests:** T07–T13, including alternative routes and several paths to the same target.

### R5 — Declare historical-use policy

**Decision proposed:** Preserve described time, source-version availability, collection time and derived readiness where applicable. Separate actual-operation replay from retrospective research.

**Reason:** Publication dates alone do not show that Axthena’s summary, path or vector existed at the decision time.

**Invariant:** No later evidence, fitted classification, review or derived output becomes an earlier decision input. All supporting records obey the declared cutoff policy.

**Trade-offs:** Strict replay cannot honestly use all modern archive processing as old operational input. Some old availability and model-eligibility questions remain uncertain.

**Implementation scope:** Historical eligibility, retained processing records and market-boundary mapping; no special historical-model training.

**Required tests:** T13, T19, T22 and T26–T30; the combined five-day walkthrough.

### R6 — Preserve anonymous identity and interpretable vectors

**Decision proposed:** Keep source-scoped identity and unknown attribution explicit. Use the existing three-component vector only under defined, dated meanings; permit missing components.

**Reason:** Reused handles, absent history and unexplained numbers otherwise manufacture continuity or certainty.

**Invariant:** An anonymous individual stays anonymous. Unsupported identity merges are prohibited. The person vector has no domain input or domain-specific variant in this pass.

**Trade-offs:** Some material has no reusable person history. Reach proxies require explicit labels; a predictive record cannot be computed without an outcome rule.

**Implementation scope:** Available account identity, dated vector assessments and their evidence. Training, numeric scales and formula remain open.

**Required tests:** T15–T16 and T24–T27; the same applicable vector across two domains.

### R7 — Preserve views, copying and later measurement

**Decision proposed:** Retain view definitions and interpretations, shared-origin links and evaluation definitions/data versions.

**Reason:** Copies can inflate apparent agreement; later view or outcome changes can silently alter historical results.

**Invariant:** Shared evidence remains shared. Source disagreement alone does not trigger the external-confirmation hold. Price outcomes do not establish motives or causal power.

**Trade-offs:** Hidden coordination and copying may remain unknown. The selected evidence packet cannot represent every opinion or a whole country.

**Implementation scope:** A small selected set of views and explicit later-evaluation references; no full market-data platform or universal influence model.

**Required tests:** T23, T27, T29 and T30.

## First useful result proposed

The first investigator question should be:

**“At this trading boundary, what did we know about this stock, and why was each item relevant?”**

A complete first slice would use one selected stock/listing, one episode, a small reviewed source packet, one or two domains and a limited dependency chain.

Its output would show the selected ideas, confirmation or hold status, optional judgments, attributed people or unresolved attribution, exact passages, direct subjects, inferred relevance paths, view selection and applicable time. Pending processing and omitted secondary ideas remain visible limitations.

The next process would pair these dated outputs with price observations under one agreed measurement rule for Quadeplus and Lexongine. Numerical encoding, price period, prediction scoring and ownership of market-data storage remain unselected.

Useful initial measures can describe evidence coverage, processing delays, attribution gaps, held confirmations and direct versus inferred links. Each still needs a defined denominator and counting rule before implementation. Predictive usefulness is a separate question.

Sources, company universe, historical period, language, database, query interface and performance targets remain owner decisions. Once they are chosen, the specification can define the allowed queries, persistence/recovery behaviour and measurable speed targets. The conceptual review cannot establish those performance properties.

## Research basis and limits

The following primary documentation and original papers informed safeguards. Their use does not select a database, model, provider or scoring formula.

- **[W3C PROV-DM](https://www.w3.org/TR/prov-dm/)** distinguishes attribution, derivation, quotation and revision. It supports retaining who produced information separately from how another record was derived. Axthena’s compact records are a project proposal; adopting W3C’s full model is not proposed.
- **[Gao et al., Enabling Large Language Models to Generate Text with Citations, 2023](https://aclanthology.org/2023.emnlp-main.398.pdf)** evaluates whether cited passages support generated statements. This supports a separate summary-support check. The paper’s benchmark results do not measure Axthena’s proposed extractor.
- **[Pearl, Causal inference in statistics: An overview, 2009](https://ftp.cs.ucla.edu/pub/stat_ser/r350.pdf)** explains why association alone does not establish causal effects. Applying this to statement/price histories supports the limit on market-influence claims.
- **[Gneiting and Raftery, Strictly Proper Scoring Rules, Prediction, and Estimation, 2007](https://sites.stat.washington.edu/people/raftery/Research/PDF/Gneiting2007jasa.pdf)** evaluates probabilistic forecasts against realised outcomes. It supports explicit evaluation meaning. It does not justify inventing forecast probabilities from ordinary judgments or choosing a person-score formula.
- **[SEC EDGAR API documentation](https://www.sec.gov/search-filings/edgar-application-programming-interfaces)** describes dissemination/update timing and a frames endpoint that selects last-filed facts for a requested period. My inference: a current response for an old reporting period is not automatically the information known at an earlier decision time.
- **[NYSE trading hours and calendars](https://www.nyse.com/trade/hours-calendars)** specifies sessions, holidays and early closes. It supports using the selected market’s actual boundaries. NYSE is an example, not the selected market.
- **[Massive custom-bar documentation](https://massive.com/docs/rest/stocks/aggregates/custom-bars)** identifies bar timestamps as interval starts and documents split-adjustment choices. It illustrates why provider conventions and dataset versions must be explicit. No provider is recommended here.
- **[X handle documentation](https://help.x.com/en/managing-your-account/change-x-handle)** says a relinquished username can be reused. It supports avoiding handles as permanent anonymous-person identity.
- **[Yan et al., DatedGPT, 2026 preprint](https://arxiv.org/html/2603.11838v1)** discusses later knowledge in LLM training and temporally restricted model training. Applying that concern to main-idea selection is an inference, not a demonstrated Axthena failure. The paper and its model are not selected solutions.

The candidate has defined expected results for the counterexamples without changing the protected owner requirements. Its remaining limits are missing evidence, uncertain historical availability, potentially incorrect extraction or attribution, incomplete dependency coverage and unselected measurement definitions.

A retained, accurately quoted report can still be false. A coherent conceptual model does not establish predictive value. Those questions require the reviewed real source packet and later empirical checks.
