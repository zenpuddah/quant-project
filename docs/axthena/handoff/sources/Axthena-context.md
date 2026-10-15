# Axthena — dedicated project context

Updated: 2026-10-15
Stage: positive owner review of the populated fictional graph received; consolidated design, behaviour, tests and implementation plan compiled for review. No product implementation has started.

## Project identity and boundaries

The project is called **Axthena** (previously referred to as Athena).

Axthena has its own context, requirements, discovery questions, accepted decisions, hypotheses and eventual specification and execution plan.

It is a separate project from **Qaedalus**, the quant/backtesting project, and **Lexongine**, the composable strategy engine previously referred to as Legongine. This document records Axthena's context; it does not import architecture decisions from those projects. The intended connection is that Axthena provides dated evidence and metrics which quant research can use to evaluate predictive usefulness. The exact interface remains undecided.

Badr makes the final architecture decisions. The assistant acts as an architecture advisor and tutor.

## Purpose

Collect, organize and query stock-related information. Let an investigator explore actors, events, relationships, perspectives and observable responses; inspect supporting evidence; and obtain understandable metrics. AI agents and learning models should also be able to query the information.

The first scope is stock-related information, initially technology stocks:
- Company and stock news, announcements and statements.
- Relevant energy, oil and business dependencies.
- New technologies and competitive developments, including Chinese companies.
- Political events, conflicts and disasters when relevant to the stocks being studied.

AX-050/AX-051 select Nvidia and Microsoft as the two primary stock targets, with relevant suppliers, dependencies and competitors. Exact source lists, historical period and supporting-world coverage remain unselected.

## Organizing idea: the game around stocks

Preserve the game model during MVP discovery. A game here means the actors, relationships, events, perspectives and observable responses surrounding stocks. It does not imply a simulator or a particular database.

Original player categories — omitted from the first pass under AX-019, retained here only as prior exploratory concepts:
- **Firm representatives:** people communicating a company's position and interests.
- **Referees:** experienced or authoritative voices whose opinions carry credibility.
- **Clowns:** social-media influencers attracting attention and influencing the crowd.
- **Crowd:** ordinary people receiving, interpreting, spreading and acting on information.
- **Spies:** voices that may be classified after analysis because their statements tend to point opposite to subsequent market movements.
- **Double agents:** affiliated voices potentially encouraging actions that benefit their own side or set up the audience.

Original exploratory dimensions — not selected as first-pass classifications:
- **Angels:** sincerely trying to help.
- **Devils:** pursuing hidden agendas.
- **Gods:** voices hypothesized to have a strong, direct effect on market outcomes.

Categories may overlap. Keep **role, affiliation, inferred intention, influence and measured predictive behavior** distinguishable. Preserve these as exploratory concepts. Price movements alone do not establish motives or causal power. Role classifications are excluded from the first pass (AX-019). The vector contains credibility, influence and predictive record, initially permitted as clearly dummy inputs under AX-040/AX-041. Empirical calculation and ML are deferred. It is independent of domain in the first pass (AX-020).

The surrounding world includes:
- **Organizations:** companies, countries, governments and institutions.
- **Kings:** leaders and decision-makers of those organizations.
- **Events:** announcements, decisions, disruptions and developments.
- **Resources and assets:** stocks and relevant inputs or dependencies.
- **Relationships:** who represents whom; who said what; which event concerns which entity; what impact is reported or inferred.

## Views

Views are different perspectives over shared underlying evidence. Examples include selected US-media sources, Russian-media sources and mixed sources such as X/Twitter.

A view should retain its source selection and interpretations. Publishers within a country can disagree. Platform feeds must not be assumed neutral or representative. These examples do not select the initial sources or settle how views will be implemented.

## Required properties supplied by the user

- Efficient ingestion and processing, persistent storage, and fast, reliable queries.
- Retained original evidence and traceable derived records, relationships, views and metrics.
- Explicit entity identities, sources, versions and time information.
- Distinguishable source assertions, observed facts, interpretations and model inferences.
- Reproducible historical outputs. Backtests must use information and fitted classifications available at the relevant time.
- Configurable behavior and understandable outputs for humans and programs.

Concrete performance targets and technical mechanisms remain open.

## Discovery and review workflow

- Use short numbered question batches for the current discovery/design discussion, as requested by Badr on 2026-10-14 (engineering ENG-030). Keep questions concise and distinguish recommended defaults from accepted decisions.
- Use concise phrases, plain language and a mature tone. Avoid jargon and technical detail during this discussion.
- Begin with business meaning and concrete examples.
- Define unfamiliar terms.
- Research primary documentation, original papers or experienced authors' books when proposing concrete solutions.
- Distinguish evidence, hypotheses, proposals and accepted decisions.
- When Badr accepts a decision, record: **Decision / Reason / Invariant / Trade-offs / Implementation scope / Required tests.**
- Aim for one focused implementation pass after discovery, a reviewed specification and an execution plan.
- Do not implement during discovery.

## Current accepted baseline — read before the chronological log

This section reconciles AX-001–AX-054 together with the accepted engineering refinements linked below. The second review's proposed repairs remain unaccepted. No product implementation has started.

- **Scope:** data collection, sound modelling, persistent evidence, compression/efficient processing and fast reliable human/program queries. Two primary stocks: **Nvidia and Microsoft**, with relevant corporate organisations, suppliers, broad dependencies and competitors (AX-041/AX-050/AX-051). Source lists, period, access methods, languages and data volume remain unselected.
- **Business world:** distinct stock, organisation, person/account, event and domain concepts. Domains have broad processes, inputs/resources, outputs and dependencies. Stock lookup may lead to multiple organisations; suppliers are not group members solely because they supply it. Grouping/router/DNS remains a proposal. Share-issuing company versus subsidiary detail remains unselected.
- **Evidence:** original reports and source versions remain retained. Facts are distinct from reports and confirmed through scoped external processes. Company/representative statements and recognised institutional evidence can be origins. Known statements and confirmed contents remain distinguishable.
- **News/opinion:** news can be confirmed or rumoured; confidential-source reports remain rumoured until qualifying confirmation. Personal opinions remain separate from this news-status distinction. Genuine conflicting external confirmations require on hold and dated personal review.
- **Ideas and expressions:** use LLMs for supported, articulated ideas and short summaries with exact passages. AX-038 revises the strict one-idea limit for two separately developed ideas; ENG-035 now caps V1 at the two most articulated per article, retaining the complete original. Equivalent meanings can be shared while every report/person expression remains traceable. Different explicit periods or opposing judgments remain distinct; dedicated reasons/thought-process extraction is deferred to V2 under AX-054. Detailed equivalence mechanics remain open.
- **Judgments:** optional expected stock-price UP/DOWN only; no supported direction means no directional judgment. Business growth alone does not force stock UP. Periods are source-stated, inferred from wording, or supplied by a configurable near-term default; retain which and its basis/version.
- **Agreement and weights:** source-expression agreement is weak/moderate/strong. The global person vector is domain-independent [credibility, influence, predictive record], and may initially use clearly dummy inputs. Person identity and supplied-value provenance remain traceable. Empirical scoring, DS and ML are deferred.
- **Relationships:** inferred relevance is labelled as Axthena interpretation with a dated evidence path. A potential company effect is separate from event confirmation and realised effect. No projected future organisation state. Announcement and later production start are different events.
- **Spread:** keep collected publication mentions and supported origins distinguishable; copied reports are not independent confirmations. Shared meaning does not establish copying. Reprocessing the same report does not make an additional publication.
- **Views/reads:** explicit selected sources and retained interpretations over shared evidence, with versions. Read mechanics and configurable query details go to technical design. The accepted initial example retrieves relevant stock/date-range events, facts, news and opinions with evidence and organisation/domain links (AX-048/AX-049).
- **Time:** source-date reference and daily-OHLCV focus are accepted in AX-047; fine-grained derived readiness is deferred to V2. Source date, event date, collection and actual processing history remain distinguishable. **AX-052 clarifies this use:** seek first source availability; later collection does not shift the supported original source information to the collection day. Retain original-version availability evidence and actual processing/collection history. This is source-aligned retrospective information, not a claim of contemporaneous operational possession.
- **Deferred:** role classifications, detailed quoted-judgment attribution, external-event forecast modelling, refined agreement measurement, empirical person scoring/ML and detailed real-time readiness. Original source material remains retained.

Latest refinements: C++ is selected as the main application language under engineering ENG-016; technology choices remain unselected. Organisation matching is discussed in ENG-019/ENG-020. AX-053 preserves a possible later research path; AX-054/ENG-022 defer dedicated reason/thought-process work to V2. See [Axthena-engineering-context.md](Axthena-engineering-context.md).

Accepted batch refinements (2026-10-14): ENG-031 keeps first-filter Ideas sharing at least one concerned organisation, without deciding equivalence. ENG-032 reuses activity categories while keeping each organisation's activities and dependencies scoped to it. ENG-033 interprets two unqualified weeks as fourteen calendar days, separate from trading-bar mapping and anchored according to ENG-029. ENG-034 records explicit missing forecast information and period origin: no supported stock forecast means no UP/DOWN judgment; an unstated forecast period can be inferred or use the existing configurable fallback. The suggested seven-calendar-day fallback remains tentative. ENG-035 caps V1 extraction at two most-articulated Ideas. ENG-036 makes valid partial extraction readable with incomplete processing recorded separately. Items ENG-035/ENG-036 also require further V2 investigation; no product implementation or fixture changes are authorised by these refinements.

Latest preparation request: ENG-037 researches extraction methods, relevant model benchmarks and promising directions before AI instructions. ENG-038 requires a separate LLM communication boundary before implementation. The detailed [extraction research](Axthena-extraction-research-2026-10-14.md) and [boundary proposal](Axthena-LLM-boundary-proposal-2026-10-14.md) preserve accepted semantics; models/providers, interface fields, output contracts and evaluation thresholds remain proposals. No model, simulation or product code was executed/built by this research step.

## Second review — findings and subsequent clarification

Review: [Axthena-second-review-2026-10-13.md](Axthena-second-review-2026-10-13.md). Advisor review, not a newly accepted architecture decision or frozen specification.

The full context, original review and visible conversation were reconciled; 30 original scenarios were rechecked and 12 additional theoretical cases were considered. No software, extractor, performance or predictive benchmark was run.

**Assessment:** ready to begin technical design without a new broad discovery round. Not ready for implementation until written specification and execution plan are reviewed.

**Subsequent owner clarification (AX-052, 2026-10-14):** seek the first source information/availability rather than shift it to the later collection date. V1 source-aligned evidence reads may therefore use an earlier supported source version gathered later. Collection and actual processing provenance remain retained. This selects the retrospective source-information goal for this use, rather than the review's proposed collection eligibility. Exact version availability and derived-output/backtesting contracts still require technical specification. The dated second review remains unchanged as a record of the question before this clarification.

**Technical specification tasks:** qualifying confirmation scopes/origins; hold/correction reads; more-than-two ideas and extraction failure rules; uncertain speaker/subject identity; sharing and counting; source-version/date/configuration semantics; view/read contracts; query reach/cycles; evidence packet/period/access; recoverable compression; measurable ingestion/query targets. No supplier depth, graph database, issuer hierarchy, classifier threshold or numeric formula is chosen by the review.

Chronological decisions remain below with later-refinement notes. They preserve history rather than silently pretending the model never changed.

## Accepted decision log

### AX-001 — Name and dedicated context

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** The project is called Axthena and has its own dedicated context.

**Reason:** Preserve a clear identity and a separate record of this project's discovery and decisions.

**Invariant:** Axthena-specific requirements, proposals and accepted decisions remain distinguishable from Qaedalus and Lexongine context. A proposal is not promoted to an accepted architecture decision without Badr's acceptance.

**Trade-offs:** Separate context records require keeping explicitly shared interface decisions consistent. This decision does not select a repository layout or software architecture.

**Implementation scope:** Update project naming and maintain this context record. No product implementation, dependencies, storage technology or query interface is selected.

**Required tests:** Documentation checks: the active name is Axthena; project boundaries are explicit; the game model and historical evidence requirements are retained; no unselected technical choice is presented as accepted. No runtime tests are required for this naming/context decision.

### AX-002 — Start with initial evidence

Status: accepted discovery direction, 2026-10-12.

**Decision:** Start with concrete input information and develop the data model from what needs to be represented. The first complete flow must serve a specific useful goal, still to be selected.

**Reason:** Ground the design in actual material and investigator needs.

**Invariant:** Original evidence remains distinguishable from derived interpretations.

**Trade-offs:** Early examples may omit important cases; further examples are needed before finalizing the model.

**Implementation scope:** Discovery and eventual specification only. No source, final model or product implementation is selected.

**Required tests:** Once the slice is specified, trace its outputs back to original evidence and verify that the required distinctions survive processing.

### AX-003 — Confirmation through external processes

Status: accepted direction from explicit user statements, 2026-10-12.

**Decision:** Confirmed information belongs under facts. Confirmation should come from identifiable external systems and their processes, rather than Axthena inventing its own notion of truth. The user cited company announcements, legal accountability and reputation as considerations.

**Reason:** Rely on external confirmation processes that can be examined.

**Invariant:** Retain the precise claim, evidence, external confirming system, process and relevant time. The fact that a statement was made remains distinguishable from confirmation of its contents.

**Trade-offs:** External conclusions can be incomplete, conflict or later change. Which systems and processes qualify remains to be determined.

**Implementation scope:** A discovery requirement for evidence and confirmation records. No automatic confirmation mechanism or trusted-system list is selected.

**Required tests:** Trace a confirmed claim to its evidence and confirmation process; distinguish a verified statement from its unverified contents; retain dated changes without using later confirmations in earlier historical outputs.

### AX-004 — Conflicting confirmations require personal review

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** When external systems disagree about the same claim, Axthena classifies the conflicting conclusions as **on hold** and waits for personal confirmation from the user.

**Reason:** Leave resolution of the disagreement to the user.

**Invariant:** No automatic resolution of this disagreement. Preserve the conflicting conclusions and their evidence. A later user decision must not replace what was available before that decision.

**Trade-offs:** Manual review creates a waiting queue. Availability of held information to queries and quant research, and the exact outcomes of review, remain open.

**Implementation scope:** Specify the hold and personal-review behavior. No review interface or code is implemented during discovery.

**Required tests:** Conflicting confirmations trigger on hold; automatic processing cannot resolve the disagreement; the user's later decision retains its time and supporting basis; historical outputs before review retain the earlier status.

### AX-005 — News and opinion distinguished by who speaks

**Later-refinement note:** Later refinement: AX-033 permits confirmed and rumoured news; the earlier unconfirmed-only wording is historical. Opinions remain separate.

Status: accepted conceptual direction, 2026-10-12. These are Axthena's working meanings, not a claim about universal usage of these words.

**Decision:** News is unconfirmed information coming from organisations. Opinion is information or views from individuals speaking personally. The user accepted that an independent influencer's personal report falls on the opinion side.

**Reason:** Preserve the user's distinction between organisational reporting and personal expression.

**Invariant:** Retain who speaks and the original evidence. Confirmation remains a separate question and follows AX-003 and AX-004.

**Trade-offs:** These broad groupings differ from ordinary usage. How to treat a person speaking on behalf of an organisation remains to be examined.

**Implementation scope:** Describe the working categories and test them against examples during discovery. No final schema or automated classifier has been chosen.

**Required tests:** Compare equivalent unconfirmed statements from an organisation and an independent individual; preserve their distinct sources and categories; do not treat either source category alone as confirmation.

### AX-006 — Judgment is optional within news or opinion

Status: accepted conceptual direction, 2026-10-12.

**Decision:** News and opinions may each contain a judgment, but neither requires one. A judgment assesses a subject rather than merely relaying information. Predictions and expectations can be judgments.

**Reason:** Preserve both who speaks and whether something is being assessed.

**Invariant:** Do not require a judgment in every news item or opinion. When a judgment is recorded, preserve what is being judged and its supporting statement.

**Trade-offs:** One source item may mix descriptions and assessments. How to keep those parts distinguishable remains to be decided. Specific forms of judgment are deliberately deferred.

**Implementation scope:** Establish the conceptual distinction using concrete examples. No judgment categories, extraction model or implementation is selected.

**Required tests:** Cover news and opinions with and without judgments; retain the subject of an assessment; do not infer that a judgment exists solely from the source category.

### AX-007 — Judgment attached to its report

**Later-refinement note:** Later refinement: AX-038 permits two separately developed ideas from one report. Preserve report attachment for each applicable idea/judgment.

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** A judgment is attached to the report that contains it. Reports may have no judgment.

**Reason:** Preserve the connection between an assessment and the report in which it was communicated.

**Invariant:** Retain the report, its original evidence and the subject of the attached judgment.

**Trade-offs:** Reports can mix descriptions and assessments. For the first pass, only one main idea will be selected from each article (AX-008). How that choice interacts with the attached judgment remains to be clarified.

**Implementation scope:** A conceptual relationship for the eventual model. No storage layout or extraction method is selected.

**Required tests:** Cover reports without a judgment and reports with an attached judgment; trace the judgment to its original report and wording; retain what is being judged.

### AX-008 — One main idea per article in the first pass

**Later-refinement note:** Later refinement: AX-038 revises the strict one-idea cap for two separately developed ideas. Earlier at-most-one test wording is superseded for that case.

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** In the first pass, take only one idea from each article: the idea that is most present.

**Reason:** Keep the initial interpretation of each article focused and limited.

**Invariant:** At most one selected idea per article in this first pass. Preserve the full original article as evidence; secondary content remains in that evidence.

**Trade-offs:** The initial output will omit secondary ideas that may also be useful. "Most present" means the idea articulated the most (AX-009). How to handle equally prominent ideas remains open.

**Implementation scope:** Limit the first-pass article output to one main idea. LLM-based selection and the prominence criterion are now accepted (AX-009). The specific model, prompt, tie handling and article sources remain open.

**Required tests:** Each processed article yields at most one selected idea; the full evidence remains retrievable; the selection follows the agreed prominence rule once defined; the chosen idea remains traceable to the article.

### AX-009 — LLM selects the most articulated idea

**Later-refinement note:** Later refinement: AX-038 permits the separately developed two-idea case. Model/provenance and the articulation criterion remain.

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** Use LLMs to select the article's one main idea in the first pass. Choose the idea articulated the most in the article, including when it differs from the headline.

**Reason:** Follow the most developed idea in the article's content.

**Invariant:** Selection remains traceable to original evidence and does not itself confirm the truth of the selected idea. Preserve the model inference separately from the source's statement.

**Trade-offs:** LLM selections can be incorrect or vary. Retained outputs and the processing version are needed to support reproducible historical use. Tie and failure handling remain open.

**Implementation scope:** LLM-based main-idea selection is an accepted direction. Model, provider, prompt, output format, processing budget and other automated tasks remain unselected.

**Required tests:** Use reviewed articles where the headline and most developed idea differ; cover mixed subjects; require at most one selected idea and traceability to the article; verify that main-idea selection does not promote an unconfirmed claim to fact; reproduce historical outputs from retained evidence and processing records.

### AX-010 — Short summary linked to the exact passage

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** Express the selected article idea as a short summary and link it to the exact supporting passage.

**Reason:** Make the idea easy to understand while keeping its wording and evidence inspectable.

**Invariant:** The summary stays traceable to the exact passage in the retained original evidence. Preserve uncertainty and qualifications from the source.

**Trade-offs:** A short summary can omit nuance. How a passage is located and linked, and whether several passages can support one idea, remain open.

**Implementation scope:** Specify a short summary and an exact supporting-passage link for the first-pass article output. No link mechanism, summary length, output format or extraction implementation is selected.

**Required tests:** The link resolves to the intended passage in the correct retained article version; the summary is supported by that passage and preserves material qualifications; readers can inspect the original evidence.

### AX-011 — Broad organisational dependencies in the first pass

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** The first pass should capture the organisation associated with a stock, how it creates value through processes, inputs, resources and outputs, and its broad dependencies. Use broad descriptions for technology companies; finer materials, component and production details can come in later iterations.

**Reason:** Capture the discussed business relationships without expanding the first pass into detailed industrial modelling.

**Invariant:** Preserve what each dependency means and its supporting evidence. A dependency does not itself prove that an event affected the dependent organisation. Reported and inferred effects remain distinguishable.

**Trade-offs:** Broad descriptions omit details that may matter for particular disruptions. The initial company universe, dependency depth, and discovery/maintenance method remain unselected.

**Implementation scope:** Include these business concepts in the first-pass data-model discussion. No database, detailed industrial schema, automated effect propagation or integration is selected.

**Required tests:** Represent the hypothetical NovaChip–TSMC–Dutch equipment supplier chain and its distinct manufacturing/equipment relationships; link disruptions to the broad dependency concerned; trace each relationship and reported or inferred effect to its basis; avoid turning a possible effect into a confirmed fact.

### AX-012 — Gathering first, mathematical representation second

Status: accepted by explicit user instruction, 2026-10-12.

**Decision:** Treat gathering information as the first process and expressing it mathematically for Quadeplus as the second process.

**Reason:** Build meaningful, supported information that can subsequently be used in quantitative research.

**Invariant:** A mathematical representation retains a defined meaning, relevant time and a traceable connection to the gathered evidence. Mathematical conversion must preserve the distinction between confirmed facts, unconfirmed information and judgments.

**Trade-offs:** Mathematical representations can omit nuance and require explicit choices about what to measure or express. Their exact form and the allocation of conversion work between projects remain open.

**Implementation scope:** Maintain the two-process distinction in discovery. Finish the current event/information and broad organisation/dependency model before choosing mathematical representations, measures or calculations. No mathematical encoding or integration is implemented.

**Required tests:** Each eventual mathematical output has a defined interpretation and an evidence trail; the same retained processing version can support reproducible historical outputs; later evidence, confirmations or fitted classifications are unavailable to earlier backtest times.

### AX-013 — Organisation has domains of execution

Status: accepted by explicit user description, 2026-10-13.

**Decision:** An organisation can have multiple domains of execution. In the hypothetical NovaChip example these are AI chip manufacturing and software manufacturing. Domains may be related or unrelated.

**Reason:** Represent distinct areas of the organisation's work so their relationships and exposure can be examined separately.

**Invariant:** Keep the domains distinguishable. Do not assume they are independent, connected, or equally affected by an event without a recorded basis.

**Trade-offs:** The broad areas need clear descriptions. Processes, inputs, resources, outputs and dependencies are described for each domain (AX-014). The detailed relationship descriptions remain open.

**Implementation scope:** Add this business concept to the discovery model. No execution-runtime mechanism, database structure or product implementation is selected.

**Required tests:** Represent both NovaChip domains; support a stated relationship when evidence is supplied and retain an unknown relationship when none is known; avoid automatically applying a chip-production disruption to the software domain.

### AX-014 — Describe value creation within each domain

Status: accepted direction ("I think yes"), 2026-10-13.

**Decision:** Each domain has its own processes, inputs, resources, outputs and dependencies.
**Reason:** Describe the part of an organisation's work that a dependency supports.
**Invariant:** Keep these descriptions associated with the relevant domain; preserve evidence and uncertainty. Shared or connected domains remain possible.
**Trade-offs:** Requires maintaining descriptions for each domain. First-pass descriptions remain broad.
**Implementation scope:** Refine the conceptual business model. No detailed industrial decomposition or software implementation.
**Required tests:** Represent the distinct NovaChip domains and their associated dependencies; preserve any evidenced shared resources or links; do not apply an impact to every domain solely because they share an organisation.

### AX-015 — Opening and closing decision data for five-day periods

**Later-refinement note:** Later timing context: AX-017 maps to OHLCV intervals; AX-047 states a source-date reference and daily focus. The source-date/collection eligibility interaction remains pending in the second review.

Status: accepted by explicit user instruction, 2026-10-13.

**Decision:** States reflect a timeline. The user initially described five-day state for the whole database, with opening/closing decision data. AX-017 refines this: use the trading intervals selected for OHLCV; five trading days is the worked example.
**Reason:** Provide a consistent picture of information an analyst can use at each decision boundary.
**Invariant:** Opening data contains only information available at the opening time. Closing data contains only information available by closing. News or confirmations first available on Day 2 cannot be used in a Day 1 decision. Preserve earlier dependencies and dated changes.
**Trade-offs:** Opening and closing pictures alone do not describe every change during a period. Original dated evidence and changes remain retained. The user clarified stock-market trading days for the example and then chose mapping to the selected OHLCV intervals (AX-017). Exact boundaries, timezone, availability rules and within-period queries remain open.
**Implementation scope:** A global historical-state requirement with opening/closing decision data. No physical database-copy scheme, storage implementation or price-return calculation is selected.
**Required tests:** Day 2 information is absent from opening data and available in closing data when within the period; January analysis uses the January-known dependency rather than a June update; later confirmations and fitted classifications do not appear in earlier decision data; all linked records use the same decision time.

### AX-016 — Withdrawn: expected-future representation

Status: withdrawn on 2026-10-13. This was an assistant interpretation incorrectly recorded as an accepted user decision. The user explicitly rejected representing an expected future. AX-018 is authoritative.

The former note must not be used to require future-state records, anticipated dependencies, forecast-world pictures or automatic projected changes. Source news and judgments about future subjects remain ordinary dated reports; they do not constitute a separate expected-future model.

### AX-017 — Map decision pictures to the chosen OHLCV intervals

**Later-refinement note:** Later timing context: AX-047 states mainly daily-OHLCV use and defers fine-grained summary readiness. Exact cutoff semantics still require specification.

Status: accepted by explicit user direction, 2026-10-13; refines AX-015.

**Decision:** Map the information timeline to the trading intervals used for OHLCV price data. Five stock-market trading days is the example discussed; the eventual interval follows the chosen OHLCV intervals, rather than assuming five calendar days or permanently fixing all information to five-day blocks.
**Reason:** Align the opening and closing decision pictures with the price intervals used in the research.
**Invariant:** Preserve actual event and information-availability times. Only information available by the relevant decision boundary enters that picture. Information can arrive outside trading hours. Mapping must not move later information into an earlier opening or closing picture.
**Trade-offs:** Trading calendars, holidays, sessions, timezones, source bar conventions and exact boundary inclusion need to be specified for the selected price data. The actual first-run OHLCV interval remains unselected.
**Implementation scope:** A conceptual alignment requirement. No OHLCV provider, market calendar, concrete interval, mathematical encoding or integration is selected.
**Required tests:** News arriving between two decision boundaries affects only appropriate later pictures; weekend news is absent from the earlier pre-weekend close and present at a later opening when available; use the selected market calendar and interval boundaries once chosen; preserve original timestamps across mappings.

### AX-018 — Information at decision time, without an expected-future state

Status: accepted by explicit user correction, 2026-10-13.

**Decision:** Do not represent an expected future. Model the gathered events, facts, news, opinions, attached judgments, organisations, domains and broad dependencies as information available at the relevant time. News discussing a possible future development remains a dated source report.
**Reason:** Preserve the user's information model instead of introducing an unselected forecast-world layer.
**Invariant:** A source's future-oriented claim or judgment does not create a projected future organisation state, event outcome or dependency. Retain its original evidence and status. Opening/closing pictures include only information available by their respective times.
**Trade-offs:** This pass does not maintain predicted future versions of the world. Future-oriented statements can still be inspected and later represented mathematically as research inputs.
**Implementation scope:** Correct the discovery context and remove the expected-future interpretation. No new future-state model or product implementation.
**Required tests:** Retain a possible-supplier-change report as news with its source and evidence; retain an assessment as an attached judgment where present; do not create an anticipated supplier dependency from it; later cancellation remains a new dated report and does not remove the earlier report; opening data excludes later reports.

### AX-019 — Organisations, people and weights; omit roles from the first pass

Status: accepted first-pass scope by explicit user instruction, 2026-10-13.

**Decision:** Organisations are the businesses whose stocks are studied and potentially traded. Events relate to organisations. Opinions and judgments are attributed to people. Omit the game-role categories from the first pass. Use some form of person weighting as the preferred direction; its meaning and computation remain undecided.
**Reason:** Retain the relevant organisations, people and information while simplifying the first pass.
**Invariant:** Preserve the person responsible for an opinion or judgment and the report/evidence in which it appears. A person link complements the report attachment, rather than losing that evidence connection. Do not substitute role labels for weights or treat a weight as proof of truth, motive or causal power.
**Trade-offs:** Explicit game-role classification is omitted. A weight needs a defined meaning before it can be used. The user subsequently chose a vector preserving credibility, influence and predictive record as separate components (AX-020). Precomputed weights and later training-based adjustments were suggested tentatively, not selected as concrete methods.
**Implementation scope:** Describe organisations, people, events, their relevant links and prospective weights in the conceptual first-pass model. No role classification, weight formula, training pipeline, prediction model or implementation is selected.
**Required tests:** Link an event to its relevant organisation/domain; attribute a person's opinion or judgment while retaining its report and exact evidence; operate without role categories; after a weight meaning is selected, retain its definition, time and version and avoid using later fitted weights in earlier backtests.

### AX-020 — Person vector independent of domain; opinion carries its subject

Status: accepted by explicit user direction, 2026-10-13.

**Decision:** Use one overall vector per person with separate credibility, influence and predictive-record components. The opinion itself is mapped to the relevant organisation and its domain. The person vector must not incorporate or vary by domain in the first pass.
**Reason:** Keep subject context on the opinion and simplify person weighting.
**Invariant:** Organisation/domain information is retained on the opinion but does not determine the first-pass person vector. Preserve the person, evidence and relevant times. Do not create domain-specific person vectors or domain-conditioned scoring in this pass.
**Trade-offs:** An overall assessment cannot express different expertise or performance across domains. Using domain information in a later training phase was mentioned as a possibility only; no such training approach is selected.
**Implementation scope:** Describe the vector's three components, its attachment to a person, and the opinion's organisation/domain links. Scales, formulas, initialization, estimation, training and how weights are used remain open.
**Required tests:** One person retains the same applicable vector across opinions on different domains at the same historical time; each opinion preserves its own organisation/domain association; later vector changes do not appear in earlier decision pictures; no first-pass weighting rule consumes domain information.

### AX-021 — One opinion may concern several organisations and domains

Status: accepted direction ("I think yes"), 2026-10-13.

**Decision:** An opinion can link to several organisations, with the relevant domain associated with each organisation. Preserve it as one opinion and one main idea.
**Reason:** Represent comparisons, partnerships and acquisitions without losing the shared statement.
**Invariant:** Retain the original comparison or relationship, the attributed person and exact evidence. Multiple organisation links do not create extra independent opinions or domain-specific person vectors.
**Trade-offs:** Requires correct pairing of organisation and domain. How to handle unspecified domains and indirectly relevant organisations remains open.
**Implementation scope:** A conceptual association in the first-pass model. No extraction format, automatic linking rule or numerical aggregation is selected.
**Required tests:** Preserve an AI-chip comparison as one opinion linked to both companies and their respective AI-chip domains; retain one supporting statement and person vector; do not generate additional article ideas solely because several organisations are mentioned.

### AX-022 — Indirect relevance links supported by dependencies

Status: accepted by explicit user response, 2026-10-13.

**Decision:** Axthena may link an opinion or report to an indirectly relevant organisation through a known dependency path, even when the source does not name that organisation. Mark the link as Axthena's interpretation and retain the supporting path.
**Reason:** Connect information about disruptions to relevant organisations and domains without falsely attributing that connection to the source.
**Invariant:** Preserve source statements separately from the inferred relevance link. Each path and its evidence must be available at the applicable historical time. Relevance does not establish an actual impact, market causation or an expected-future organisation state.
**Trade-offs:** Indirect relevance may be too broad or uncertain. Allowed path depth, review rules and linking methods remain open.
**Implementation scope:** A conceptual first-pass relevance relationship. No automatic linking algorithm, effect score or projected-world model is selected.
**Required tests:** Link a transport-disruption opinion to NovaChip through an evidenced supplier path while retaining the original source wording; label the relevance as inferred; reject paths relying on relationships only learned later; do not confirm a business or price effect merely because a path exists.

### AX-023 — Mass person is an anonymous individual

Status: accepted by explicit user clarification, 2026-10-13.

**Decision:** A mass person remains an anonymous individual. It is not one combined crowd record. Preserve any available identifying reference, such as a Reddit or X account, so repeated statements can be associated with that anonymous voice.
**Reason:** Retain anonymous statements and a usable history without requiring a real name.
**Invariant:** Preserve anonymity and available source identity. Do not merge distinct anonymous individuals without evidence, and do not invent an identity for an unattributed statement. Historical source statements remain traceable.
**Trade-offs:** Some anonymous voices have a recurring account identifier; others have no reliable identifying reference. Handling completely unattributed voices and linking accounts across sources remain open.
**Implementation scope:** Describe anonymous individuals and available source-account references in the first-pass person model. The user also suggested later comparison with financial outcomes, including inverse patterns and highlighting a voice; scoring, training and flagging methods remain undecided.
**Required tests:** Keep repeated statements from an identifiable anonymous account associated with that account; distinguish different anonymous accounts; retain source evidence without asserting a real identity; do not equate historical price associations with proven influence, intent or insider knowledge.

### AX-024 — Shared judgment with traceable source expressions

**Later-refinement note:** Later refinements: AX-027/AX-037 preserve distinct periods/reasons, AX-038 allows the two-idea case, AX-039 selects qualitative agreement strength.

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** Reports expressing the same judgment about the same subject may point to one shared opinion/judgment record. Preserve the individual reports and traceable links to their sources, outlets and available responsible people. Opposing judgments about a shared subject remain distinct. The user confirmed this direction to reduce repeated extracted content.

**Reason:** Reduce duplication of the extracted meaning while retaining who expressed it and the evidence for each expression.

**Invariant:** Sharing a judgment does not erase an original report, its version, exact passage, source attribution or relevant time. The selected judgment remains attached to each supporting report and its responsible person where identified. Shared meaning alone establishes neither copying nor independent confirmation. Confirmation status remains governed by AX-003 and AX-004. Each article still has at most one selected main idea under AX-008–AX-010. Preserve dated grouping changes without rewriting earlier historical outputs.

**Trade-offs:** Repeated extracted content can be shared, while original evidence and per-source links still occupy storage. Incorrect grouping can collapse materially different judgments. Exact equivalence rules, uncertain-match handling and whether grouping is automated remain open.

**Implementation scope:** Add a shared opinion/judgment and traceable report/source-expression links to the conceptual model. NLP or AI-assisted grouping was suggested as a possibility; no grouping model, method, threshold, database or implementation is selected. AX-025 subsequently selects the support metric's meaning as expressed agreement. Its scale and calculation remain open, and it is not added to the person vector.

**Required tests:** Two reports expressing the same judgment about the same subject can point to one shared record while each retains its evidence and source/person references; an opposing judgment remains separate while sharing the subject; retrieve every source expression from the shared record; grouping alone does not promote information to fact or manufacture independent confirmations; retain the one-main-idea constraint and earlier historical grouping state.

### AX-025 — Support means expressed agreement with the shared idea

Status: accepted by explicit user clarification, 2026-10-13.

**Decision:** The support measure describes how strongly the source expresses agreement with the particular shared idea, opinion or judgment. Associate it with the source's expression in a report and its traceable link to that idea, rather than treating it as one fixed assessment of the source.

**Reason:** Preserve differing degrees of expressed support while sharing the judgment's meaning across sources. The user chose expressed agreement when asked to distinguish it from the amount of supporting evidence.

**Invariant:** Retain the precise shared idea being supported, the attributed source/person, report version, exact passage and relevant time. Support is agreement expressed in that evidence; it does not establish the source's private belief, sincerity, motives, factual reliability or causal influence. Strong support for a negative judgment means agreement with that negative judgment. It does not mean a positive assessment of the underlying partnership. This measure is separate from the domain-independent credibility/influence/predictive-record person vector (AX-020), and does not confirm the shared idea as fact.

**Trade-offs:** Expressed agreement can be difficult to interpret when a report quotes another voice, uses qualifications or does not state its own position. Numeric scale, treatment of uncertain or absent agreement, classification method and review rules remain open.

**Implementation scope:** Add the meaning of this measure to the conceptual source-expression/shared-idea relationship. No scale, formula, automatic classifier, NLP/AI model or implementation is selected. AX-026 subsequently excludes quoted judgments from the first MVP and defers detailed quotation handling.

**Required tests:** Retain the passage supporting an attributed expression of agreement; preserve qualifications; distinguish support for a negative judgment from positive sentiment about its subject; do not transfer a quoted person's position to the publisher without evidence; allow the same person to express different support toward different ideas while retaining the same applicable AX-020 vector; preserve earlier source-expression assessments when later expressions differ.

### AX-026 — Defer quoted judgments beyond the first MVP

**Later-refinement note:** Later refinement: quotation exclusion remains, while AX-038 revises the single-idea cap for two separately developed ideas.

Status: accepted by explicit user scope instruction, 2026-10-13.

**Decision:** Omit other people's judgments quoted within a report from the first MVP's judgment extraction and expressed-agreement scoring. Preserve the original report, including its quoted material. Record quotation handling and separate attribution of the quoted speaker and reporting outlet as a future improvement.

**Reason:** Keep the first MVP simple and avoid introducing detailed quotation and speaker-attribution handling now.

**Invariant:** An omitted quoted judgment does not become the publisher's own judgment or agreement. Retain the original evidence and its version/time for inspection and possible later processing. Missing support caused by this scope exclusion is not a measured absence of agreement. Preserve the at-most-one-main-idea constraint and prominence rule; this exclusion does not authorise replacing the most articulated idea with a less articulated idea merely to obtain a judgment score. This scope decision concerns relayed quoted judgments, not the general exclusion of first-party company announcements, facts, entire articles or original evidence.

**Trade-offs:** Some prominent assessments communicated through reporting will have no extracted judgment/support result in this MVP. Original information remains inspectable. Later quotation processing will require additional attribution and historical-version checks.

**Implementation scope:** Limit the first-pass judgment/support flow to the source's own attributable expressions. Keep any quotation-based judgment/support result outside the MVP. Detailed quoted-speaker records, reporting-only versus endorsed treatment and agreement measurements for quoted voices are deferred. No product implementation or classifier is selected during discovery.

**Required tests:** A report quoting an analyst's judgment does not receive publisher-agreement or quoted-judgment/support records from that quotation in the MVP; a source's own non-quoted judgment remains eligible under the existing main-idea rule; original quoted text remains retrievable; a quotation-dominated main idea does not force a fabricated publisher position, a zero support measurement or a secondary replacement idea; later processing does not rewrite earlier historical outputs.

### AX-027 — Different stated periods keep judgments separate

**Later-refinement note:** Later refinements: AX-029 narrows V1 judgments to stock-price UP/DOWN, so the profit example is historical; AX-038 revises the strict one-idea cap.

Status: accepted conceptual direction from the user's response "I think separate," 2026-10-13.

**Decision:** Keep the two judgments separate when one expects the partnership to hurt profits this quarter and another expects it to hurt profits next year. An explicit difference in the period being assessed is a meaningful difference for shared-judgment grouping.

**Reason:** The same organisation, partnership and adverse assessment can concern different periods and therefore different possible outcomes.

**Invariant:** Preserve the source's stated period and exact wording. A common subject and assessment direction alone do not justify merging these time-distinct judgments. The period described by the judgment remains distinguishable from when the report was published or became available. A future-oriented source judgment stays a dated report under AX-018 and creates no projected organisation/dependency state. Sharing a subject does not require sharing a judgment.

**Trade-offs:** Fewer judgments will be merged than with grouping based only on subject and broad direction. Exact period interpretation, overlapping periods, absent periods, qualifications and equivalence rules remain open.

**Implementation scope:** Tighten the conceptual grouping boundary for explicitly different stated periods. No automatic time-extraction method, period-normalisation rule, default horizon, classifier or implementation is selected.

**Required tests:** Keep this-quarter and next-year profit judgments separate while allowing their common partnership subject; preserve source wording and supporting passages; distinguish the period being assessed from information-availability time; retain no expected-future organisation state; preserve the at-most-one-main-idea rule and historical grouping versions.

### AX-028 — Retain the basis and history of AI interpretations

**Later-refinement note:** Later refinements: classification targets and support scale are now partly selected (AX-029–AX-031/AX-039), and AX-038 revises the strict single-idea cap.

Status: accepted evidence/traceability direction from explicit user instruction, 2026-10-13. Concrete classification targets and methods remain open.

**Decision:** Retain an inspectable history of what an AI interpretation was based on: original source/report version, exact supporting passages, supplied inputs or context, processing instructions/version, model/version when available, output and processing time. Include a short explanation grounded in the wording. The user suggests AI-assisted interpretation of expressed meaning; this decision establishes its evidence/history requirement without selecting its exact categories or targets.

**Reason:** Let an investigator inspect why a direction, time-period, support or grouping interpretation was proposed, and track how the output changes when evidence or processing changes.

**Invariant:** Preserve the source's statement separately from the AI's interpretation. Distinguish directly stated information from inferred meaning; do not treat an AI estimate as proof of the person's private intention or as external confirmation. An explanation is a recorded rationale grounded in evidence, not guaranteed access to the model's internal causes. Retain old inputs and outputs rather than overwriting them with later interpretations. Historical availability, the one-main-idea constraint and the quoted-judgment exclusion remain in force.

**Trade-offs:** Trace records add storage and processing overhead. A plausible explanation or a valid passage reference can still accompany an incorrect interpretation. Retaining versions supports inspection and recovery of the stored result, but does not guarantee that rerunning an external model yields an identical output.

**Implementation scope:** Specify evidence and processing history for AI-derived records. No model/provider, prompt, score scale, classification algorithm or product implementation is selected. AX-029 subsequently fixes the UP/DOWN target as stock-price movement. Accepted source-explicit versus model-inferred tasks, time-window lookup and review rules remain open.

**Required tests:** Inspect a retained interpretation and recover its source version, supporting passage, relevant processing version and time; distinguish an explicit source statement from an inferred label; preserve earlier outputs after a source or processing change; recover the stored historical output without silently rerunning today's model; detect a classification unsupported by its cited wording using reviewed cases; retain no anticipated organisation state and no quoted-judgment/support output in the MVP.

### AX-029 — First-pass predictions and judgments concern stock-price UP or DOWN only

**Later-refinement note:** Later refinement: AX-038 allows two separately developed ideas from one report. Preserve each judgment's own subject/evidence.

Status: accepted by explicit user scope instruction, 2026-10-13.

**Decision:** For the first MVP, prediction/judgment classification concerns expected stock-price movement only, with directional labels UP or DOWN. Do not use this classification for increasing/decreasing profits, demand or other business measures. This narrows the earlier broad judgment examples for the first pass.

**Reason:** Keep the initial judgment output focused on the stock movement that subsequent quantitative evaluation will study.

**Invariant:** Every UP/DOWN judgment identifies the relevant stock subject and preserves its report, responsible source/person, supporting passage, relevant time and any stated period. It remains a source judgment or clearly identified model interpretation, not an observed price outcome or externally confirmed fact. A rise in profits alone is not automatically a stock-price UP judgment. Preserve the broader original stock-related evidence, organisations, domains and dependencies. The classification creates no expected-future organisation state and does not change the domain-independent person vector.

**Trade-offs:** Non-directional assessments and predictions about business results are outside this first-pass judgment classification. Useful information can remain in the retained source and selected idea without receiving a directional judgment. AX-030 subsequently selects no UP/DOWN judgment when stock-price direction is unclear. Exact clarity and conditional-statement rules remain open.

**Implementation scope:** Narrow the conceptual first-pass prediction/judgment target and its allowed directional labels. The exact UP/DOWN extraction policy, permitted AI inference, abstention handling, time-period categories, lookup windows, movement-measurement rule and classifier remain open. No product implementation is selected.

**Required tests:** Expressed expectations of a stock rise/fall map to the correct directional label and stock subject; rising-profit or rising-demand statements do not automatically become stock-price UP; retain exact evidence and distinguish source-explicit from any permitted inferred direction; preserve broader original business information; maintain optional judgments, one main idea per article, quotation exclusion and historical output provenance.

### AX-030 — No directional judgment when stock-price direction is unclear

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** If a report gives no clear stock-price direction, it receives no UP/DOWN judgment in the first MVP. Retain the original report and its supported selected idea under the existing evidence rules.

**Reason:** Avoid manufacturing a directional prediction from information that does not support one.

**Invariant:** Do not force every report into UP or DOWN. No directional judgment does not mean a prediction of a flat price, disagreement, a measured zero, or absence of useful information. Preserve original evidence, source attribution, processing history and relevant times. This follows AX-029's stock-price-only target and preserves optional judgments under AX-006. A missing direction does not authorise selecting a less-articulated secondary idea.

**Trade-offs:** Some business information and ambiguous assessments will not contribute a directional judgment. Coverage may be lower, while raw evidence remains inspectable.

**Implementation scope:** Add withholding of the directional judgment to the conceptual MVP flow. Exact clarity criteria, conditional statements, allowed AI inference, review rules and implementation remain open. No extra directional class or score scale is selected.

**Required tests:** A report with no supported stock-price direction retains its evidence without an UP/DOWN judgment; business growth does not force UP; an ambiguous or mixed direction does not force a label; an absent judgment is not encoded as a flat-price prediction or zero support; retain the main-idea prominence rule and historical interpretation record.

### AX-031 — Inferred periods and a configurable near-term default

Status: accepted through user clarification and explicit confirmation, 2026-10-13.

**Decision:** For a supported UP/DOWN stock-price judgment, retain a period stated by the source; where it is not stated, try inferring the period from the wording. Where the wording supplies no usable period, use a near-term default. The user clarified that “close” means close in time, and accepted making this default duration configurable so different intervals can be tested.

**Reason:** Keep useful directional judgments when a source does not give an exact period, while allowing the first pass to test its period assumptions.

**Invariant:** Distinguish source-stated periods, periods inferred from language, and periods assigned by the default. Keep the original wording, supporting passage and AI processing history. A default is Axthena's assumption, not something the source said. Preserve the configuration used for each historical output; later configuration changes must not silently alter past results. A missing period does not authorise inventing an unsupported stock-price direction, and no future organisation state is created.

**Trade-offs:** Inference and the near-term fallback can misrepresent the period a source intended. A configurable fallback enables comparison but introduces an assumption whose effect must remain visible. No exact duration, reference time, calendar convention or evaluation window has been chosen.

**Implementation scope:** First-pass period interpretation and configurable fallback, at the conceptual level only. Exact categories, inference criteria, configuration values, boundaries and price-comparison rules remain for discovery and the reviewed specification.

**Required tests:** Preserve an explicit source period; trace an inferred period to wording and stored interpretation; distinguish the default from an inferred or explicit period; changing the default produces a separately identifiable result without rewriting previous outputs; no usable direction still produces no UP/DOWN judgment; different explicit periods remain separate under AX-027.

### AX-032 — Retain repeated mentions as evidence of spread

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** When twenty outlets copy one original report, retain twenty mentions and one original information source for that copied information. The user wants repeated coverage to give an idea of how widely the news has spread.

**Reason:** Sharing a common idea should reduce duplicated derived meaning without losing evidence of its circulation.

**Invariant:** Keep each report, outlet, available person attribution, passage, version and time traceable. Repeated copies do not become independent confirmations. Shared meaning alone does not prove copying or identify an original source; origin relationships need evidence and unresolved origins remain unresolved. Counted mentions represent observed coverage within Axthena's selected sources, not a measured audience or the whole world's exposure. Spread remains distinguishable from expressed agreement, credibility, influence and predictive record.

**Trade-offs:** Retaining mention links requires more records than retaining the shared idea alone, but enables inspection of circulation. Missing coverage and uncertain origins limit the measure; repetition can show attention without establishing truth.

**Implementation scope:** Preserve original-source links where supported and separate mention counts from distinct information origins. Exact counting windows, duplicate-ingestion treatment, origin-identification method and spread formulas remain open. No audience estimate or causal influence metric is selected.

**Required tests:** Twenty copied reports retain twenty distinct report mentions and one supported origin; copies do not count as twenty independent confirmations; all mentions remain traceable and dated; the same report ingested twice does not create an additional publication mention; reports with similar meaning are not automatically marked copied; unknown origin remains distinguishable from a known shared origin; historical spread uses only mentions available at the query cutoff.

### AX-033 — News status, distinct reports and company-origin facts

Status: accepted through explicit user statements, 2026-10-13.

**Decision:** News can be confirmed or rumoured. Opinions remain separate and outside this news-status distinction. Keep a report distinct from the fact it reports: in the company-related examples, facts originate from the company or its representative itself.

**Reason:** Separate the organisation's originating information from subsequent reports about it, and distinguish confirmed news from rumours without applying that distinction to personal opinions.

**Invariant:** Preserve each original report, originating company statement or representative statement, exact supported information, attribution and dates. A publisher is distinct from the origin of the information. Retain the previously accepted external-confirmation process and its scope: the fact that a statement was made does not automatically establish every claim within it. News repetition does not supply independent confirmation under AX-032. Opinions and their optional judgments remain in scope; “outside” refers to this news-status distinction, not their exclusion from Axthena.

**Trade-offs:** This revises the earlier working description of news as only unconfirmed information. Distinct reports and facts require explicit links but preserve originating evidence. Company-origin examples do not yet resolve confirmation authorities for wars, disasters or other non-company events, or how confidential sources are classified.

**Implementation scope:** Conceptual confirmed/rumoured news statuses and distinct report/fact records for company information. Exact qualification rules, representative authority, statement scope, confidential-source treatment and confirmation authorities for other event types remain open. Do not select a database, classifier or automatic promotion mechanism.

**Required tests:** A company announcement and an outlet's report remain distinct and linked; retain originating evidence and the outlet's own report; rumour repetition alone does not create a confirmed fact; opinions remain available without these news statuses; distinguish a confirmed statement being made from an unsupported claim within it; preserve earlier rumoured reports and the time of any later confirmation; existing conflicting confirmations retain the personal-review hold.

### AX-034 — Confidential-source news remains rumoured pending confirmation

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** An outlet's partnership report citing “people familiar with the talks” remains rumoured news until qualifying confirmation appears. An unnamed or confidential information source does not by itself qualify the news as confirmed.

**Reason:** Keep a reported possibility distinct from information confirmed through the originating authority or accepted external process.

**Invariant:** Retain the known publisher and exact source description without inventing the confidential person's identity. Rumoured does not mean false, and a named publisher does not make the originating information source identified. Repetition does not establish confirmation or copying. Preserve the original report and its rumoured status at earlier decision times; later confirmation must retain its evidence and availability time. Opinions remain outside this news-status distinction.

**Trade-offs:** Some accurate early reports remain rumoured before an accepted confirmation becomes available. The distinction preserves usable early evidence without treating it as an established fact.

**Implementation scope:** Apply the conceptual rumoured status to the confidential-source example, preserving reported origin descriptions. Exact qualifying-confirmation rules and promotion/linking mechanics remain unselected. Do not turn this example into a global claim that all unnamed voices are false or that every named voice confirms its claims.

**Required tests:** “People familiar with the talks” remains rumoured without qualifying confirmation; publisher attribution and the source's wording stay inspectable; known copies retain mention counts without independent confirmation; a later company confirmation is distinct evidence with its own time; an earlier historical query retains the earlier rumoured state; confidential-source identity is not fabricated.

### AX-035 — Institutional event confirmation and potential company effects

Status: accepted through user confirmation and elaboration, 2026-10-13.

**Decision:** A recognised earthquake-monitoring institution can confirm that an earthquake occurred. Its potential effect on NovaChip remains a separate claim with its own evidence and may be marked as a potential effect. Company statements are therefore not the only possible originating confirmation evidence for every event type.

**Reason:** Represent relevant external events without confusing their occurrence with a demonstrated effect on the organisation being studied.

**Invariant:** Confirmation applies only to the supported event or claim. A confirmed earthquake does not automatically confirm transport disruption, supplier damage, a NovaChip business impact or stock-price movement. Preserve the source assertion versus Axthena's inferred relevance, with the dated dependency path where used. Potential effect is not an observed outcome or an expected-future organisation state. Person-vector and stock-price-only judgment rules remain unchanged.

**Trade-offs:** Potential links keep relevant uncertainty visible, but require separate evidence and scope from the event's confirmation. Recognised institutions and qualification criteria remain to be selected; the example does not establish the reliability of earthquake prediction.

**Implementation scope:** Conceptual institutional confirmation for non-company events and potential-effect links. Exact institution selection, effect-status rules, automation and measured effects remain open. The user's additional example of an institution predicting an earthquake is recorded as a scenario for clarification below, not a confirmed occurrence or selected forecasting capability.

**Required tests:** Institutional evidence can confirm earthquake occurrence; a confirmed occurrence alone does not establish a company effect; potential effect retains its evidence, attribution and historical relevance path; observed effects require separate support; later outcome information does not replace an earlier potential status; retained forecasts cannot be presented as confirmed occurrences or silently create future world state.

### AX-036 — Defer external-event forecast modelling

Status: accepted by explicit user instruction, 2026-10-13.

**Decision:** Note the institution-predicts-an-earthquake example for later brainstorming and move on. Its representation would introduce additional model concepts and is not selected now.

**Reason:** Keep discovery focused without prematurely deciding how possible future external events should be represented.

**Invariant:** This deferral does not approve a new forecast/event type or future world state. Retain original source evidence under existing rules. AX-035's confirmed-event versus potential-company-effect distinction remains accepted. The first-pass stock-price judgment target remains UP/DOWN.

**Trade-offs:** Structured querying of forecasts about external-event occurrence remains unresolved; the source material can still be retained.

**Implementation scope:** A deferred design note only. No external-event forecast modelling or implementation is authorised by this decision.

**Required tests:** The reviewed first-pass specification does not silently introduce the deferred representation; retained forecast language is not treated as confirmed occurrence; accepted event and potential-effect records remain unaffected.

### AX-037 — Different reasoning separates ideas and is retained for later modelling

**Later-refinement note:** Later refinement: AX-038 revises this record's one-main-idea wording for two separately developed ideas.

Status: accepted by explicit user confirmation and instruction, 2026-10-13.

**Decision:** Two people expecting NovaChip's stock UP next month remain attached to separate ideas when one bases the expectation on a partnership and the other on a new chip. Retain the expressed reasoning for possible later modelling or ML use, as requested by the user.

**Reason:** Matching stock, direction and period does not capture the full meaning of an idea; its stated basis may be useful in later analysis.

**Invariant:** Preserve each person's identity or available anonymous account identity, report, exact supporting passage and dates. Distinct reasoning must not be erased by grouping solely on stock/direction/period. This refines AX-024 rather than removing its permission to share the same meaning across different speakers: source/person links stay distinct even when genuinely equivalent ideas are shared. Source-expressed reasoning remains distinguishable from an AI's explanation or inferred reasoning. No private motive or causal market effect is established by the stated reasoning.

**Trade-offs:** More distinct ideas than a direction-only grouping, and additional retained meaning for inspection. Exact equivalence boundaries and representation of reasons remain unselected.

**Implementation scope:** Preserve the source's expressed basis alongside the selected idea and evidence; keep materially different reasons separate in grouping. Later ML use is a noted possibility, not a selected training method, feature scheme or current implementation requirement. Maintain at most one selected main idea per article.

**Required tests:** Partnership-based UP and chip-based UP remain distinct despite matching stock and period; each source/person remains traceable; matching meaning from different people may still share an idea with separate source links; quoted reasoning remains subject to the MVP quotation exclusion; a model's inferred explanation is not presented as a reason explicitly given by the source; historical queries retain only reasoning and interpretations available at their cutoff.

### AX-038 — Split two separately developed ideas within an article

Status: accepted by explicit user instruction, 2026-10-13.

**Decision:** When an article separately develops two distinct ideas, extract them as two ideas. The user chose this response to the example of two equally developed ideas instead of arbitrary selection or mandatory personal review.

**Reason:** Preserve the article's separately articulated meanings rather than forcing them into a single idea.

**Invariant:** This explicitly revises the earlier strict one-main-idea-per-article rule for this case. Both ideas remain linked to the same original report and version, with their own supporting passages, short summaries, subject links and applicable judgments. Do not confuse two ideas with two independently published reports or two independent information origins. Existing quote exclusion, source-versus-inference distinction, optional stock-price direction, period provenance and historical traceability remain in force.

**Trade-offs:** Multiple derived ideas can increase volume and complicate article-level counts, but avoid losing a separately developed idea. Detecting the boundary between a distinct developed idea and incidental supporting detail remains to be specified.

**Implementation scope:** Allow two separately developed ideas from the same article in the first pass. The user's instruction does not select unlimited exhaustive extraction or a numerical maximum for articles containing more than two developed ideas. Ordinary single-dominant-idea handling remains the baseline outside this refinement.

**Required tests:** An article separately developing two ideas yields two traceable idea records with separate evidence; a passing mention or supporting detail does not automatically become another developed idea; two extracted ideas retain one report identity and do not inflate publication-mention counts; judgments and periods attach to the appropriate idea; no arbitrary discard solely to enforce the previous one-idea cap; omitted quoted judgments remain omitted.

### AX-039 — Three levels of expressed agreement for the first pass

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** Use weak, moderate and strong to describe how strongly a source expresses agreement with an idea in the first pass. Note this simple scale for future improvement.

**Reason:** Provide an understandable initial description of the wording, consistent with the source-support meaning selected in AX-025.

**Invariant:** Measure expressed agreement on the source's expression/report-to-idea link, with supporting wording. It does not measure source credibility, truth, predictive success, causal influence, private sincerity or the AI's own confidence. Strong agreement with a DOWN idea still means strong agreement, not a positive price direction. Missing, excluded or unclear agreement is not automatically weak or zero. Keep speaker/report attribution, source evidence and historical processing versions.

**Trade-offs:** Three levels are easy to inspect but coarse and potentially sensitive to interpretation and language. Examples discussed were tentative leaning toward a rise, expecting a rise, and firmly expecting a rise; these are illustrative wording examples, not an empirically validated classifier or exhaustive rules.

**Implementation scope:** First-pass qualitative labels only. Numeric encoding, extraction criteria, language handling, uncertainty and evaluation method remain to be specified. Future refinement is noted without selecting a richer scale or learning method.

**Required tests:** Tentative versus firm agreement is classified consistently against reviewed examples; positive and negative stock-price judgments use the same agreement-strength meaning; credibility and outcomes do not alter the wording classification; each level retains supporting evidence; absent or excluded agreement is distinguishable from weak agreement; historical outputs retain their original interpretation and scale version.

### AX-040 — Available provisional person weights may be dummy values

Status: accepted through explicit user instruction, 2026-10-13.

**Decision:** The user does not want to be required to supply initial credibility and influence values manually. For trying the MVP, available values may be used even if inaccurate, with their dummy/provisional nature clearly recorded.

**Reason:** Enable exploration of the flow using existing data without making accurate person-weight estimation a prerequisite for the first pass.

**Invariant:** Dummy or provisional credibility/influence values are not validated measurements, established causal influence or learned predictive evidence. Retain their supplied origin, status, version and relevant time; distinguish them from later measured or fitted values. The person vector remains global and domain-independent. Dummy values do not establish predictive usefulness. The discussion concerned credibility and influence; whether predictive record also uses dummy values remains to be clarified.

**Trade-offs:** The MVP can exercise processing and downstream use, but results using dummy weights cannot validate actual source quality or market influence. Initial data source, numeric scale, missing-value policy and mapping remain unselected.

**Implementation scope:** Permit available provisional credibility/influence inputs, labelled as dummy for first-pass experimentation. No mandatory manual user-entry workflow, automated estimator, model training or provider is selected.

**Required tests:** Provisional weights retain their dummy label and input origin in human and program outputs; values are not represented as validated estimates; later measured versions do not overwrite historical dummy versions; no domain enters the first-pass person vector; unavailable values are not silently fabricated under this permission to use available data.

### AX-041 — Data-focused MVP, dummy predictive record and no data-science/ML work

Status: accepted by explicit user confirmation and scope instruction, 2026-10-13.

**Decision:** The predictive-record component may also start as a clearly marked dummy value. Axthena's current scope is having the data, modelled well, with fast access, compression and efficient storage/processing. Data science and ML are not the target of this pass.

**Reason:** Establish a useful, reliable information foundation before undertaking statistical evaluation or learning.

**Invariant:** All three global person-vector components may be dummy/provisional; none constitutes an empirically validated result. Preserve their status and provenance. This scope boundary does not erase original evidence, dates, distinctions, source links, views, domain-independent weights or reproducible historical records. Already discussed LLM-assisted reading/extraction remains distinct from developing/training predictive models; this instruction does not cancel that accepted extraction direction. Keep source judgments distinct from observed outcomes. Do not claim predictive usefulness from placeholder weights.

**Trade-offs:** The MVP can validate collection, organisation, evidence inspection and access, but it will not validate predictive quality or learn person classifications. Compression must preserve required evidence and traceability; the exact technique and performance targets remain unselected.

**Implementation scope:** Discovery/specification should prioritise ingestion, persistent storage, compression, identities, relationships, time/version records, query access and understandable human/program outputs. Store model-ready information and labelled placeholder weights; defer data-science analysis, training and empirical predictive-record calculation. Any later price-movement exercise is separate future evaluation/integration work, not an automatically required ML task for this MVP.

**Required tests:** Ingestion and queries preserve exact evidence and relationships; compression preserves recoverable required content; historical cutoffs and versions remain correct; placeholder weights remain labelled in human/program outputs; queries meet performance targets once those targets are agreed; the execution plan contains no unapproved data-science or ML training work.

### AX-042 — Stock entry point can point to multiple organisations

Status: accepted through explicit user correction, 2026-10-13.

**Decision:** A traded stock is distinct from an organisation and may point to multiple organisations. The user used Amazon and its sub-companies as the motivating example: the stock code is an entry point to the organisations, rather than the identity of one company.

**Reason:** Organisational groups contain several activities and entities whose information can matter when studying a traded stock.

**Invariant:** Keep stock and organisation identities distinguishable; multiple stock-to-organisation associations do not merge the organisations. Preserve the meaning, evidence and historical time of each association. A subsidiary relationship must not silently imply identical exposure, interchangeable prices or that every associated organisation issues the traded shares. No specific Amazon subsidiary mapping is established by this discussion.

**Trade-offs:** More associations than a single company pointer, but better coverage of group activities. Exact relationship types, direct versus through-parent associations and issuer/listing/ticker handling remain open.

**Implementation scope:** Allow multiple organisational associations for a stock in the conceptual first pass. Exact schema and lookup mechanism remain unselected; “points to” expresses the conceptual relationship, not a selected programming pointer or database design.

**Required tests:** One stock can resolve several distinct organisations without merging their identities; each association remains traceable and dated; a query can inspect why an organisation is associated; supplier relevance is distinguishable from membership in the corporate group; later group changes do not silently rewrite earlier associations.

### AX-043 — Corporate grouping remains distinct from supplier dependencies

Status: accepted by explicit user confirmation, 2026-10-13.

**Decision:** Suppliers stay outside the stock's corporate group and connect through dependency relationships instead. Preserve separate organisation identities. The preceding router/DNS-style grouping or lookup idea is retained as a proposal for resolving a stock to its associated group organisations; its implementation and precise structure are not selected.

**Reason:** Support stock-centred discovery without confusing organisations belonging to the business group with external organisations supplying it.

**Invariant:** A supply relationship alone does not establish corporate membership. Keep corporate associations and supplier dependencies distinguishable, supported and dated. Separate identities are retained under AX-042. If an organisation also belongs to the group, any membership requires its own evidence rather than being inferred from supplying it. The distinction between the organisation whose shares trade and subsidiaries remains unselected; the user considered both approaches viable, then proposed grouping. No router, DNS service or graph database is selected by the analogy.

**Trade-offs:** Separate relationship meanings require more explicit links but make relevance understandable. Detailed corporate hierarchy, ownership percentages and lookup design remain open.

**Implementation scope:** Conceptual boundary between corporate-group membership and supplier dependencies; document the grouping/lookup proposal for technical review. No implementation begins during discovery.

**Required tests:** An external supplier remains reachable through a dependency without becoming a corporate member; stock lookup retains separate organisation identities; supported corporate membership and supplier relationships can coexist without conflation; queries expose the relationship/path behind relevance; historical queries use group and dependency evidence available at the cutoff.

### AX-044 — Announcement and production start are distinct events

Status: accepted through explicit user correction, 2026-10-13.

**Decision:** NovaChip's March partnership announcement and the June start of production under that partnership are different events. Keep their identities separate.

**Reason:** They describe distinct things happening at different times; treating the later development as the same occurrence would lose that distinction.

**Invariant:** Each event retains its own supporting reports, evidence and time. A common company or partnership subject does not merge event identities. The announcement does not establish that production has started or create future operational state. Linking events through a shared subject remains possible under the broader relationship model, but this answer does not select a required direct event-to-event relation.

**Trade-offs:** More event records, with clearer chronology. Exact grouping of multiple reports about the same occurrence and direct inter-event link types remain unselected.

**Implementation scope:** Conceptual event-identity boundary for distinct announcements and operational developments. No event-detection algorithm or database structure is chosen.

**Required tests:** The announcement and production start have distinct identities and dates; reports about one are not silently assigned to the other; a query before the production-start information is available does not show production as started; common subjects remain traceable without merging occurrences.

### AX-045 — Defer dependency-query limits to technical design

Status: accepted through explicit user direction, 2026-10-13.

**Decision:** Whether and how to limit dependency links followed in a query depends on the data model and technology selected. Do not decide a configurable link-count limit now.

**Reason:** Assess query behaviour against the actual representation, technology and performance requirements.

**Invariant:** This does not select unlimited traversal, a fixed depth, a graph database or a specific configuration mechanism. Existing broad dependencies, dated evidence and explainable relevance paths remain required.

**Trade-offs:** A concrete query bound is deferred; technical specification must resolve reliable, efficient query behaviour before implementation.

**Implementation scope:** Carry dependency-query limits into technical design, alongside the eventual model, query contracts and performance targets.

**Required tests:** Once a policy is selected, verify bounded/reliable query behaviour, cycles and repeated paths, required relevance coverage and preservation of evidence and historical cutoffs. Exact tests and targets follow that selected policy.

### AX-046 — Historical queries use collection availability by default

**Subsequent clarification:** AX-052 resolves the source-aligned information use: seek first source availability, without shifting earlier supported source information to its later collection day. Retain actual collection and processing history; exact query/backtesting contracts remain technical-design work.

**Later-refinement note:** Second-review clarification pending: AX-047 introduces source-date alignment; whether this changes collection-based historical eligibility is not explicitly settled.

Status: accepted through explicit user instruction, 2026-10-13.

**Decision:** Use only information Axthena had collected by the historical query time. An article published Monday but collected Wednesday is excluded from a Tuesday query. The user additionally proposed that queries might control this behaviour through configuration; alternative modes and their details are not yet selected.

**Reason:** Reflect the information actually held by Axthena at the time being inspected.

**Invariant:** Preserve source publication time separately from collection time; earlier publication does not backdate collection. Versions, originating evidence and linked records must retain their own availability. Collection eligibility for original evidence does not automatically imply an extraction, classification or relationship was already ready. Later corrections, user reviews and fitted classifications cannot silently enter earlier outputs. Any eventual alternative mode must be explicit and distinguishable from actual collection-based history.

**Trade-offs:** Publicly available information missed or collected late is absent from the earlier system view. Possible query configuration could support other research uses but requires clear semantics.

**Implementation scope:** Collection-based historical evidence eligibility as the first-pass default. Retain the query-configuration proposal for technical design; derived-readiness handling remains to be clarified. No retrospective-public-availability mode is accepted by the tentative proposal.

**Required tests:** Monday publication/Wednesday collection is excluded Tuesday and eligible after Wednesday collection; publication and collection remain separate; later versions cannot substitute for earlier ones; query metadata exposes the selected availability policy once specified; later collection or configuration changes do not silently rewrite stored historical outputs.

### AX-047 — Source-date reference, daily OHLCV focus and V2 readiness detail

**Subsequent clarification:** AX-052 resolves the source-aligned information use: seek first source availability, without shifting earlier supported source information to its later collection day. Retain actual collection and processing history; exact query/backtesting contracts remain technical-design work.

**Later-refinement note:** Second-review clarification pending: source-date reference, daily focus and readiness deferral are explicit. The statement below that this replaces AX-046's default is the assistant's interpretation; it must not be treated as a resolved eligibility choice until Badr clarifies it.

Status: accepted through explicit user instruction, 2026-10-13.

**Decision:** Use the source's date as the time reference for this pass. The user expects AI summaries and related processing to occur in real time, and their main strategies will focus on daily OHLCV-related use. Note detailed distinction between original collection at 10:00 and summary readiness at 10:05 for V2.

**Reason:** Keep first-pass timing aligned with the source information and the user's principal daily trading-data use, without expanding current discovery into detailed real-time readiness behaviour.

**Invariant:** This later choice revises AX-046's collection-based default for first-pass historical alignment. Keep publication/source date, event date, collection time and processing history distinguishable; do not relabel a newly generated summary as one actually produced at the source date. Source-date alignment is not proof that Axthena operationally held the result at that time. Preserve source versions and the requirement that historical evidence does not contain later corrections or later fitted classifications. Daily OHLCV focus does not establish a market calendar, within-day cutoff, one-day forecast horizon or guarantee that processing finishes before a decision.

**Trade-offs:** Source-date alignment supports retrospective information organisation, while exact operational replay of processing delays is deferred. Actual real-time processing latency is an expectation to validate, not an observed capability. The earlier 10:02 summary-availability case is not resolved by a proven zero-delay assumption.

**Implementation scope:** First-pass source-date reference and daily-OHLCV use focus. Preserve processing provenance; carry derived-readiness eligibility, delays and explicit operational-versus-source-aligned query modes into V2 discussion. Exact timestamp precision, historical alignment contract and daily query cutoffs still require technical specification.

**Required tests:** Source-date alignment retains separate collection and processing times; summary provenance identifies its actual processing version/time; original historical versions are not replaced by later corrections; missing source-time precision is not fabricated; daily queries follow the eventual agreed cutoff contract; output does not claim an operational 10:02 summary existed when generated at 10:05.

### AX-048 — Explicit view source selection; read behaviour deferred to technical design

Status: accepted through explicit user confirmation and instruction, 2026-10-13.

**Decision:** A view uses explicitly selected sources: “US-media view” refers to the outlets chosen, not all US media. Address views' reading/query behaviour and implementation in technical design, because they depend on how the data will be read.

**Reason:** Preserve the perspective's actual source scope while selecting query mechanics in the context of the eventual reading requirements.

**Invariant:** Views operate over shared underlying evidence and retain their source selection and interpretations. Country labels do not establish agreement among publishers, and selected platform feeds are not assumed representative or neutral. Preserve historical view versions and evidence traceability. This deferral does not discard views or select a database view, duplicated corpus or particular query interface.

**Trade-offs:** The meaning of source scope is explicit, while filtering, interpretation attachment, configuration and read contracts await technical design.

**Implementation scope:** Retain explicit source-selection requirements and the existing interpretation/version requirements in the conceptual model; resolve concrete view representation and reads in the technical specification. Specific outlets, source lists and supported query formats remain unselected.

**Required tests:** Once specified, a view includes only its declared source selection; disagreements within a selected country view remain visible; shared evidence stays traceable across views; earlier queries retain the appropriate selection/interpretation version; view names do not imply complete or representative coverage.

### AX-049 — Customisable queries with a first stock/date evidence output

Status: accepted through explicit user confirmation and clarification, 2026-10-13.

**Decision:** Axthena supports customisable queries. For finishing V1, accept as a first useful query example: for a stock and date range, return relevant events, facts, news and opinions, each linked to evidence and the relevant organisation/domain. Technical design will expose concrete query behaviour.

**Reason:** Provide an inspectable first output while retaining flexibility in how humans and programs read the model.

**Invariant:** This example does not restrict all queries to one fixed report format or remove judgments, source statuses, attribution, versions, views or dependency-path evidence. Returned records remain traceable and respect the eventual explicit time/query contract. Customisation does not imply unconstrained arbitrary execution or a selected query language.

**Trade-offs:** A concrete query example gives V1 a reviewable use case, while exact supported filters, shape, interface and performance need specification. The user would ideally also turn the information into numerical values; this remains a goal to explore, not a selected formula or empirical scoring task.

**Implementation scope:** Carry the accepted stock/date-range query example and configurable-reading requirement into technical design. Preserve the prior data-focused scope: no ML/data-science work is selected by the numerical-output aspiration. Exact numeric representation, output schema, configuration and supported query operations remain open.

**Required tests:** The first query returns relevant records with evidence and organisation/domain links; direct and indirect relevance retain their meanings; caller-selected stock and date scope is respected; status, attribution and version details remain inspectable; eventual custom query contracts validate supported parameters and historical semantics; numeric encodings, if later selected, retain definitions and source traceability.

### AX-050 — Initial slice: two technology stocks and their business surroundings

Status: accepted through explicit user selection, 2026-10-13.

**Decision:** Validate the initial V1 slice on two technology stocks, including their suppliers, dependencies and competition.

**Reason:** Exercise the model on more than one stock and retain the surrounding business relationships central to the user's idea.

**Invariant:** Two primary stock targets do not restrict all supporting organisations to those two companies. Preserve distinct organisations, domains, corporate groups, suppliers and competitors with dated evidence and explicit relationship meanings. Competition does not become supply, corporate membership or proven stock-price effect. Broad dependencies remain the first-pass scope; no exhaustive global supply-chain crawl is selected.

**Trade-offs:** Wider coverage than a single-stock fixture, allowing shared dependencies and competitive relationships, with more data collection and identity work. Exact relationship coverage and query limits remain for specification.

**Implementation scope:** Two primary technology stocks with relevant suppliers, broad dependencies and competitors as the initial dataset boundary. Specific stocks, source lists, historical period, record volume and collection methods remain unselected. No implementation begins before specification and plan review.

**Required tests:** Queries distinguish the two stocks and their relevant organisations; shared suppliers or competitors are not duplicated or conflated with the primary stocks; relationship meanings and evidence remain inspectable; supported external-event relevance retains its path and time; the initial test dataset covers suppliers, dependencies and competition for the two chosen stock targets.

### AX-051 — Nvidia and Microsoft as the initial stock targets

Status: accepted by user acknowledgement following the explicit selection proposal, 2026-10-13.

**Decision:** Select Nvidia and Microsoft as the two primary technology-stock targets for the initial V1 slice under AX-050.

**Reason:** The pair exercises chip technology/manufacturing and software/cloud domains, suppliers, energy dependencies, competition and domain-specific relationships. This is a model-coverage rationale, not a trading-return claim.

**Invariant:** Primary stock targets remain distinct from supporting supplier, competitor and group organisations. Source evidence must establish each actual relationship and its relevant historical time; a current filing does not automatically prove an earlier relationship. No complete market coverage is claimed.

**Trade-offs:** Broad coverage across related technology businesses, with relevance filtering needed to keep supporting data bounded.

**Implementation scope:** Initial targets only. Exact security/listing identifiers, sources, historical period, access methods, relationship coverage and volume remain for specification. No implementation begins now.

**Required tests:** Cover both chosen stocks with traceable evidence; retain distinct domains and relationship meanings; preserve separate supporting-organisation identities; validate relationship evidence for the selected historical period.

Primary evidence consulted for the selection proposal:
- Nvidia fiscal 2026 Form 10-K: https://www.sec.gov/Archives/edgar/data/1045810/000104581026000021/nvda-20260125.htm
- Microsoft 2025 Annual Report: https://www.microsoft.com/investor/reports/ar25/index.html

### AX-052 — Recover first source availability rather than shift history to collection

Status: accepted through user clarification following the second review, 2026-10-14.

**Decision:** Seek the first availability of the information at its source as the historical information reference. The user clarified that “the first information should be what we search for” in the example of an article dated Monday but collected Wednesday. For V1 source-aligned information reads, later collection does not move the original source information into Wednesday's history.

**Reason:** Reconstruct when the information became available in the source evidence rather than when Axthena happened to gather it.

**Invariant:** Retain actual collection and processing times separately. Use the source version and wording supported as available at the historical time; a Wednesday correction at a Monday-dated URL must not become Monday evidence. Source date is distinct from an earlier event date or reporting period. Seeking first information does not prove that the collected packet includes the globally earliest report; uncertain availability remains uncertain. Later-generated interpretations retain their actual processing provenance and are not represented as outputs Axthena operationally produced on Monday. No later confirmation, review, world change or fitted classification is silently backdated.

**Trade-offs:** Supports retrospective exploration of source information gathered later; it is different from replaying the information physically held by Axthena at that time. Establishing the availability of an exact original version may require evidence beyond a page's current printed date.

**Implementation scope:** Clarify V1's source-aligned historical evidence goal and supersede AX-046's collection-only inclusion rule for this use. AX-047's detailed real-time readiness deferral remains. Exact earliest-source discovery, availability evidence, uncertainty handling, query configuration and backtesting/derived-output contracts remain for technical design.

**Required tests:** A supported Monday original collected Wednesday remains Monday source information in a source-aligned read; a later corrected version is excluded from earlier source history; described event/reporting-period dates do not substitute for source availability; collection and processing provenance remain inspectable; uncertain or missing original-version availability is not fabricated; outputs do not claim historical operational possession or computation merely from source-date alignment.

### AX-053 — Preserve Axthena as a promising future research direction

Status: Badr requests saving the assessment and future path in general context, 2026-10-14. No new algorithm or performance claim is accepted.

**Decision:** Continue the focused Axthena MVP and retain a possible later V2 research direction: reducing processing effort/cost while preserving reliable identities, shared meanings and traceable evidence. Evaluate this as an early research direction, not solely as a CV exercise and not as an already demonstrated competitive advantage.

**Reason:** Badr is assessing the promise of a project about two days old and wants to return to the ideas in a later phase of life. Existing components do not by themselves disqualify the direction; a meaningful problem, plausible approach and testable improvement justify a bounded next iteration.

**Invariant:** Keep promise, hypotheses, accepted requirements and measured results distinguishable. Current hybrid retrieval and LLM graph extraction combine established methods. No novelty, superiority, trading usefulness or business moat is established. V1 remains the configured stock-information MVP; adaptive policies and predictive ML are not silently added to its scope.

**Trade-offs:** Research can discover useful improvements, but premature generalisation and prolonged optimisation can delay a working system. A simple baseline may already satisfy V1; that result would reduce the need for custom machinery.

**Implementation scope:** Preserve the research path and references for future return. Candidate V2 experiments include selecting checks and candidate budgets according to difficulty, escalating expensive verification selectively, and correcting shared records while retaining their evidence/history. These are hypotheses, not selected technologies or an execution plan. Keep one focused experiment per iteration.

**Required tests:** Before claiming an advantage, compare a specified method with an existing/simple baseline on the same reviewed cases. Separate candidate coverage, damaging identity/meaning merges, supported query correctness, processing cost and latency. Retain workload, method/configuration versions and evidence. Novelty requires its own prior-art assessment; predictive usefulness remains a separate quant evaluation.

### AX-054 — V1 judgments; dedicated reasons and thought processes deferred to V2

Status: explicit user correction recorded in engineering ENG-022 and reconciled here, 2026-10-14.

**Decision:** Keep supported stock-price UP/DOWN judgments in V1. Defer dedicated extraction, modelling, matching and reuse of judgment reasons/thought processes to V2. Preserve the shared-reason concept of ENG-021 for that iteration.

**Reason:** Keep the first pass focused while the value of additional machinery is evaluated.

**Invariant:** Retain original source wording, judgments, periods, source/person attribution, agreement and AI-processing provenance. Source text can contain reasoning; deferral does not erase it or equate materially different complete opinions. This does not permit inferring private thought processes or treating interpretations as facts.

**Trade-offs:** Lower V1 complexity, with dedicated argument comparison and shared reason exploration postponed.

**Implementation scope:** Documentation and discovery only. No reason-processing subsystem is required for V1. Existing fixture and evidence remain unchanged; exact future representation is unselected.

**Required tests:** Supported V1 judgments remain usable without a separate reason record; original passages remain recoverable; no dedicated reason/thought-process extraction or matching is required by the V1 specification; processing provenance remains available.

## Working descriptions under discussion

The user proposed an event as the central thing to describe:
- A company announcement is an event.
- A news article describes an event.
- An opinion speaks about the event.
- A judgment is made about the event.
- There are facts about the event.

Current working meanings:
- **Fact:** information confirmed through a recognised external process. Starting examples are earnings figures reported by a company, technology presented at an official conference, and officially announced partnerships. Preserve what the process actually confirms.
- **News:** reports from organisations, now distinguished as confirmed or rumoured under AX-033. This revises the earlier definition that treated all news as unconfirmed. Keep the report separate from the fact and its originating confirmation evidence.
- **Opinion:** information or views from people speaking personally.
- **Judgment:** in the current V1, an optional supported expectation of stock-price UP/DOWN within news or opinion (AX-029/AX-030). Other assessments remain in original evidence but do not receive this classification.

Under AX-033, the confirmed/rumoured distinction applies to news; opinions stay separate. The user's company examples locate facts in company or representative statements, while retaining the earlier external-confirmation scope. AX-034 keeps confidential-source news rumoured pending qualifying confirmation; AX-035 permits recognised institutional confirmation of an earthquake's occurrence, while qualifying institutions and other event types remain open. A single source item may contain different kinds of information. The user has decided that the judgment will be attached to its report. Further details remain open.

The event abstraction is being examined; a final data model is not approved. The user has now distinguished organisations, which are associated with the stocks studied, from people, to whom opinions and judgments are attributed (AX-019). Detailed affiliation and attribution handling remain open.

## Latest organisation and dependency discussion

Latest stock/group refinement (AX-042/AX-043): the stock is separate from organisations and can resolve to several corporate-group organisations, each retaining its identity. The user suggested grouping like a router or DNS; record that as a possible lookup design. External suppliers connect through dependencies, not membership solely on the basis of supply. Detailed share-issuing organisation/subsidiary association types remain undecided.

On resuming discovery, the user introduced **domains of execution** within an organisation: NovaChip has AI chip manufacturing and software manufacturing, which may or may not be related (AX-013).

The user introduced the stock as the entry point to the organisation being studied. An organisation creates value through a process that requires inputs and resources and produces outputs. The first pass uses broad dependencies.

In the hypothetical example, NovaChip designs and sells chips, TSMC manufactures them, and a Dutch equipment supplier provides machines needed for production. The likely real company intended is ASML. Its role and TSMC's manufacturing role were checked against official company sources:
- ASML company description: https://www.asml.com/en/company
- ASML headquarters and role: https://www.asml.com/
- TSMC customer manufacturing model: https://www.tsmc.com/english/dedicatedFoundry

The NovaChip relationships and disruption scenario remain fictional; checking the real companies' general roles does not establish those fictional dependencies or effects as real-world facts.

The user's example has war potentially affecting TSMC, and an earthquake disrupting transport needed by the Dutch supplier, potentially delaying new equipment for TSMC and affecting NovaChip's plans. Partnership information can establish further business relationships. Mechanisms and their evidence must remain explicit.

## Hypothetical stress-test scenario

A connected fictional chronology was presented and the user accepted it as a useful exercise:
1. March 1: war closes a major shipping route and affects journeys taken by NovaChip's suppliers.
2. March 12: an earthquake shuts a manufacturing facility used for NovaChip's production.
3. April 3: NovaChip announces a chip claimed to use less electricity.
4. May 15: NovaChip goes public; its prospectus describes intended funding for the chip and manufacturing diversification.
5. June 10: NovaChip announces a proposed manufacturer acquisition and says it aims to reduce exposure to production disruption.
6. July 30: NovaChip reports earnings, delivery delays and expenses; it attributes some expenses to disruptions.

A later user variation places the earthquake's transport disruption around the Dutch equipment supplier. These are discussion examples, not an approved historical dataset or a claim about actual wars or disasters.

An earlier fictional article test selected the partnership's doubtful near-term earnings prospects as the main idea, with an attached judgment and an exact supporting passage. The user said the test was good so far. This was an illustrative ChatGPT reading, not an empirical validation of an extraction model.

## Current session objective

**Latest update — ENG-044/045, 2026-10-15:** Badr is happy with the current graph results and requests the consolidated implementation handoff. The next step is review of the written specification and execution plan, not another generic discovery loop. Company orange, subsidiary yellow, UP green and DOWN red are accepted display conventions; source explanations stay in summaries and evidence. No backend or final production contract is selected by graph satisfaction.

[Repository implementation handoff](../README.md) contains the current decision/supersession map, data and behaviour specification, proposed architecture, 36 test-scenario families, ordered tasks, pending decision bundles, V2 backlog and retained references. [Implementation plan](../05-implementation-plan.md) is the proposed task sequence. The recommendation of C++ with SQLite/file artifacts is advisory; Ladybug remains an alternative. Actual vector retrieval, full Event/Fact/Confirmation/dependency extraction, historical contracts, real sources and measurable targets remain explicit work. Full six-field latest decisions are recorded in the engineering context.

The paragraphs below preserve the sequence and limits of the earlier experiments; statements about review being outstanding describe their production stage, superseded for the graph milestone by ENG-044. They do not become runtime or accuracy claims after the positive review.

The second discovery review is complete enough to enter technical design. The extraction/model research and proposed LLM communication boundary have been prepared. On 2026-10-15 Badr selected the existing ChatGPT subscription for the first iteration and explicitly requested three combinations of researched rules, a sample, execution and benchmarking (ENG-039/ENG-040). This authorises the bounded instruction experiment; the earlier capability question alone did not. No external model API or other provider is selected. The experimental schema and exact runtime are not an accepted production interface/model configuration.

The first pilot uses 17 fictional short reports, five supplied organisation candidate-list tasks and 14 meaning comparisons. Three fresh in-session assistant contexts compare rules alone, added examples, and an added evidence check. All three match the assistant-authored frozen reference on the tested structured records and comparisons; each returns 17 valid quotations. The tie does not establish stable reliability, real-news performance or a model/provider ranking. See [Axthena-ChatGPT-trial-2026-10-15.md](Axthena-ChatGPT-trial-2026-10-15.md) and [Axthena-ChatGPT-trial-2026-10-15.zip](Axthena-ChatGPT-trial-2026-10-15.zip). The original pilot remains preserved.

Badr then requested harder, more application-like samples (ENG-041). The expanded diagnostic adds 36 fictional reports, 12 supplied identity tasks and 36 meaning comparisons, including conditional views, corrected metrics, subsidiary scope, separate dates, French/Chinese text, misleading headlines and partial downloads. Nine fresh assistant runs compare unchanged A/B/C prompts across three matched batches. All three match the tested structured reference on 36/36 reports, 12/12 identity tasks and 36/36 comparisons; each retains 38 Ideas and 14 stock judgments. Separate assistant reviews find no definite material semantic errors, with minor ambiguity/citation observations retained. A targeted post-score A-only check also matches 36/36 shuffled comparisons with 18 reversed pairs. These are the same meanings, not additional independent examples. Details and original inputs/outputs are in [Axthena-hard-trial-results-2026-10-15.md](Axthena-hard-trial-results-2026-10-15.md), [Axthena-hard-samples-2026-10-15.md](Axthena-hard-samples-2026-10-15.md) and [Axthena-hard-trial-2026-10-15.zip](Axthena-hard-trial-2026-10-15.zip).

This is still a controlled assistant-authored diagnostic, not proof of real-news reliability. Candidate lists, source types, confirmation scopes and supported availability are supplied. Two borderline SAME labels need owner review: conditional versus causal wording, and shared transaction meaning versus differences in explicit ownership/announcement attribution. Six unscored scenarios require review of the experimental output/rules: conflicting confirmations/on-hold state, the existing quoted-judgment exclusion, vague versus absent horizons, organisation/domain pairings, retrieval failure versus completed no-match, and captured-version availability uncertainty. Conditional forecasts currently retain their conditions in prose only, which a direction-only numerical consumer would miss. Proposed remedies and a provisional preference for the simpler A instructions are advisory (P-019); no new architecture decision is implied. Badr's output/query validation and real-source evaluation remain outstanding. Existing Cypher fixtures and the live graph are unchanged.

Current source-selection clarification (ENG-042, 2026-10-15): target twelve consecutive months, with flexible calendar dates. The latest twelve months, a prior year or another twelve-month period is acceptable; exact bounds and provider remain unselected. Choose the interval using usable source coverage and cost, without claiming complete news coverage from the length alone. The API-first acquisition decision remains in force; public datasets are under consideration as test material, not yet selected as a replacement route.

Next validation milestone (ENG-043, 2026-10-15): produce an inspectable graph from source material using the draft instructions, stress-test its records and relationships, and let Badr explore it with queries to decide whether it matches the intended world. Source selection and exact sample details remain open. Research into representations, abstraction layers and query optimisation follows that review and should address the actual observed queries and defects. Synthetic scoring alone is not graph acceptance, and this order does not select a production database or resolve the recorded model gaps.

Produced review material (P-020, 2026-10-15): [Axthena-graph-review-2026-10-15.zip](Axthena-graph-review-2026-10-15.zip) and [Axthena-graph-review-guide-2026-10-15.md](Axthena-graph-review-guide-2026-10-15.md) now project the saved fictional A results into an inspectable graph: 36 Reports, 38 distinct report-local Ideas/Expressions, 14 UP/DOWN judgments, 42 exact evidence passages, with direct organisation/domain links. Full source paragraphs, dates, source identities and processing/run provenance are retained. Independent diagnostic comparison results do not merge extracted Ideas. Offline fidelity checks pass; Neo4j execution and Badr's review are outstanding. This exposes an extraction-contract gap: separate Event, Fact/Confirmation and dependency records are not emitted yet, although those concepts remain in Axthena's intended model. No production representation is selected, and the separate twelve-month real-news acquisition remains open.

Review the written specification and execution plan before production implementation. Earlier discussion envisaged a later price-movement exercise with Qaedalus (also called Quadeplus in prior messages) and Lexongine; no integration is implemented, and DS/ML remain outside current V1.

## Current discovery focus

The core has progressed into a consolidated specification and implementation-plan review under ENG-044. AX-052 now clarifies the first source-information goal; resolve the written-spec contracts listed above, including evidence of original-version availability and derived-output/backtesting semantics. The latest accepted baseline is at the top of this document; the original review remains a historical proposal artifact. Do not restart role, forecast-world, empirical person-scoring or ML discovery.

## Direction-and-period classification

Status: stock-price UP/DOWN target accepted under AX-029; broad period inference and configurable near-term fallback accepted under AX-031. ENG-028 keeps different actual forecast windows separate; ENG-029 anchors relative wording to publication date when no different explicit reference is given; ENG-033 selects calendar weeks; ENG-034 retains explicit absence/origin information. Seven days as the fallback duration remains tentative. Other exact period categories, inference criteria, boundaries and lookup mappings remain unselected.

The user proposes reading the judgment's language to classify an expected direction and the period being discussed. Illustrative forms are **UP / next weeks**, **UP / next months**, and **UP / next years**.

The proposed purpose is to look up which interval to process or examine. Do not treat these examples as selected durations, trading-bar sizes, fixed calendar boundaries, or an automatic judgment-expiry rule. The report's availability time, the period its judgment concerns, and the observation window chosen for evaluation remain distinguishable.

For the first pass, UP/DOWN refers to expected stock-price movement under AX-029. A positive business assessment does not automatically constitute an explicit stock-price prediction. A source-explicit direction must remain distinguishable from any model-inferred market interpretation, under the existing evidence requirements. Scales, lookup mappings and extraction methodology are still open. AI-assisted interpretation is the user's proposed mechanism; AX-028 requires its evidence and processing history. The directional target is now selected under AX-029; precise extraction and inference rules remain open.

## External-event forecast example — deferred

The user proposed that an institution might predict an earthquake and that a possible company effect could be retained. Preserve this as a source forecast about a possible external event, distinguishable from confirmed occurrence and from a supported potential effect. AX-036 explicitly defers its representation for later brainstorming. This does not expand the first-pass stock-price judgment labels beyond UP/DOWN or assert that earthquake predictions are reliable.

## Deferred improvements

- **Two-Idea cap (ENG-035):** Investigate in V2 how many developed claims V1 omits, whether articulation ranking selects useful claims, and whether the cap should change. The accepted V1 cap remains two; retain complete originals and extraction history.

- **Partial extraction (ENG-036):** Investigate in V2 the usefulness of incomplete article results, recovery and effects on coverage/metrics. V1 still makes successful supported results readable with incomplete processing recorded separately; this does not imply complete coverage.

- **Real-time derived readiness (AX-047):** Revisit original evidence collected at 10:00 versus a summary ready at 10:05, actual processing delays and operational historical query semantics in V2. First-pass source-date alignment retains provenance and must not be described as proof of contemporaneous computation. Daily OHLCV focus is motivation, not a guarantee of zero latency.

- **Agreement-strength refinement (AX-039):** Revisit the initial weak/moderate/strong scale after inspecting first-pass results. Consider richer wording criteria or measurement only with evidence and review; no replacement scale or training method is selected now.

- **Reasoning in later models (AX-037):** Explore whether source-expressed reasons can inform later modelling or ML. Retain evidence now; no learning method, representation, training target or performance claim is selected.

- **External-event forecasts (AX-036):** Brainstorm how an institution's forecast of a possible external event should be represented and linked to potential company effects. No new representation is selected for the current pass; preserve original evidence and do not mark predicted occurrence as confirmed.

- **Quotation handling (AX-026):** Revisit judgments quoted within another source's report. Preserve the distinction between the reporting outlet/author and the quoted speaker; define reporting-only versus expressed endorsement; decide how the quoted voice links to a shared judgment and support measure. Use the retained original passages and versions. Later extraction or attribution changes must preserve their processing time and must not be silently backdated into historical decision outputs.

## Future research direction — return when ready

Saved at Badr's request on 2026-10-14 under AX-053. No reminder, schedule or implementation is requested.

**Assessment:** The direction is promising enough for staged investigation beyond CV value. At roughly two days, a demonstrated edge is not required to justify another bounded iteration. The current design is a coherent combination of known techniques; a distinct technical contribution still needs to be defined and tested.

**Problem to investigate:** How much computation and expensive AI comparison is necessary to create reliable, reusable knowledge as information arrives? The developing mechanism preserves originals, searches existing records before creating duplicates, combines inexpensive retrieval signals, uses AI for the identity/meaning decision, and retains supporting evidence and decision history. Generalisation across fields remains subject to each field's equality rules.

**Candidate V2 question:** Can an adaptive policy reduce processing cost while keeping damaging merges below a chosen limit? It might select checks, candidate counts or additional verification according to difficulty rather than always run a fixed three-stage sequence. Exact mechanisms, stopping criteria and error/cost targets remain unselected. This does not override ENG-020's current AI identity-decision responsibility.

**Research evidence, not Axthena results:**
- [FrugalGPT, Chen/Zaharia/Zou (2023)](https://arxiv.org/abs/2305.05176) investigates learned model cascades for cost/quality trade-offs.
- [Adaptive-RAG, Jeong and colleagues (NAACL 2024)](https://aclanthology.org/2024.naacl-long.389/) investigates choosing retrieval strategy based on query complexity.
- [Qdrant hybrid/multi-stage queries](https://qdrant.tech/documentation/search/hybrid-queries/) and [Microsoft GraphRAG indexing](https://microsoft.github.io/graphrag/index/overview/) establish existing building blocks. They neither prove Axthena's exact requirements are solved nor justify claiming its approach is novel.

**Return path:** Finish a useful V1, collect specific failures and cost measurements, then select one V2 hypothesis and compare against the simplest adequate baseline. A new policy, useful evaluation dataset or convincing method improvement could be a contribution; none is promised. Do not turn a possible future path into an open-ended current commitment or a prediction about the QRT outcome.

Engineering decisions and proposals are recorded in [Axthena-engineering-context.md](Axthena-engineering-context.md). C++ is selected there under ENG-016; the standard/libraries/backend remain unselected. ENG-019/ENG-020 record organisation identity, separate name/vector retrieval and AI identity decisions. ENG-024 selects their union as the V1 organisation shortlist, while retaining each method's candidates and intersection membership for V2 comparison. This is comparison data, not an already validated accuracy benchmark; concrete methods, limits and no-match handling remain open. Dedicated reasons/thought processes remain V2 under AX-054/ENG-022.

## Opening episode — historical illustration

The assistant introduced this hypothetical episode as a discussion aid, not a real historical claim or accepted MVP scope:

A Chinese company announces an AI technology claiming to require much less computing power. Nvidia representatives respond, experienced analysts assess the claim, influencers amplify competing narratives, and the crowd reacts. Selected US-media, Russian-media and X sources offer different interpretations. Subsequent Nvidia price and trading volume are observable, without assuming what caused those changes.

This was an earlier discovery prompt. AX-049 now accepts a stock/date-range evidence query example; this episode itself remains unselected.

Illustrative possibilities: who spread the claim first; how views differed; which statements preceded a measurable market response. These remain examples, not chosen features or metrics.

## Decision-recording practice

The user reiterated on 2026-10-13: update the dedicated context each time a decision is made. Continue using **Decision / Reason / Invariant / Trade-offs / Implementation scope / Required tests**. Keep tentative ideas and analogies clearly labelled as proposals; do not promote them to accepted architecture merely because they were discussed. AX-031 through AX-051 record the decisions from this resumed discussion, including explicit revisions of earlier rules.

## Next round — technical specification

Do not treat the earlier eight-topic discovery agenda as a fresh checklist requiring all accepted concepts to be reconsidered. The second review provides the handoff: carry AX-052's source-information goal into explicit time contracts; bound source data/period; select identity, extraction/status, storage/compression and query contracts; define performance targets and acceptance checks; review the resulting written specification and then the execution plan.

Mechanisms explicitly deferred to technical design (views, query customisation, dependency-query limits) remain there. V2 deferrals stay deferred. A specific unresolved business interpretation can be raised one question at a time during specification; no blanket renewed discovery round is proposed.

## Still unselected

- Exact source packet/period/volume and full investigator workflow; the two primary stocks and the first query example are selected.
- Concrete stock episode.
- Initial sources and access methods.
- Exact historical dates and concrete security/listing identifiers; ENG-042 selects twelve consecutive months with flexible dates, and AX-050/AX-051 select Nvidia and Microsoft with relevant suppliers, dependencies and competitors.
- Concrete extraction/grouping rules and providers; qualitative agreement and stock-price direction targets are partly selected. Empirical predictive scoring and ML are deferred.
- Database and storage layout.
- C++ standard, libraries and integration details; the main language is selected under engineering ENG-016.
- Query interface.
- Performance targets.
- Integration contracts with Qaedalus or Lexongine.
