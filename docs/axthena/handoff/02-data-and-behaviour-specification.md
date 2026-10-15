# Axthena — data and behaviour specification

Review draft · 15 October 2026 · Owner: Badr

This document translates accepted meanings into a proposed implementation contract. **Required** means already accepted in AX/ENG decisions. **Proposed** means a concrete representation or default requiring review. It does not select a database or approve the implementation. The current decision map is in `01-scope-and-decisions.md`; full six-field records are in `sources/`.

## 1. What V1 must accomplish

An analyst configures Nvidia, Microsoft and relevant organisations, dependencies and topics. Axthena downloads a bounded source collection, retains the material, processes it separately and provides stock/date/source-filtered reads. A read can explain which organisation and domain an idea concerns, who expressed it, its supporting passage, any supported stock UP/DOWN judgment and its period, and how a surrounding event is relevant. Original evidence survives classification errors and retries.

The first application runs locally, primarily in C++. It prepares data before serving ordinary reads. It does not simulate future worlds, trade, train predictors, infer motives or manufacture historical information. The immediate first OpenCode source trial is 20 articles (ENG-048), using automated OpenCode-style LLM communication (ENG-047). The later historical target is twelve consecutive months; exact dates, sources and numerical performance targets remain unselected. See AX-001/011–014/018/041/049–052 and ENG-004/009–016/042.

The graph reviewed on 15 October is a **fictional diagnostic projection**, not this complete implementation. It exposes 36 Reports, 38 Expressions, 38 singleton Ideas and 14 Judgments. It does not yet implement collection, real candidate retrieval, shared-Idea insertion, structured Event/Fact/Confirmation/dependency extraction or historical runtime replay.

## 2. Common record rules

Required: stable identities; source identity and retained content version; distinct source assertions, confirmed facts, interpretations and model inferences; dated derivation and configuration; exact supporting evidence; no silent overwriting of historical output.

Proposed common envelope:

- `id`: stable opaque identifier. Human names, URLs and tickers are searchable attributes, not universal primary keys.
- `record_version` and `schema_version`: distinguish a changed interpretation from a changed format.
- `provenance`: originating source/record IDs, extraction run, supplied configuration and supporting passages.
- `created_at`: actual creation time. This is not the source's publication or information-availability date.
- `status` and explicit absence reason where meaningful. Unknown, omitted, unsupported, excluded, failed and configured fallback must not collapse into zero or an empty string.
- `supersedes` or versioned membership when a later interpretation replaces an earlier one. Old evidence and outputs remain reachable.

Do not copy every field onto every table or node. The envelope describes recoverable information; physical normalization belongs to the backend design.

## 3. Conceptual records and relationships

The names below are proposed interface names. The distinctions they preserve are required.

| Record | Meaning and minimum information | Relationships and invariants |
|---|---|---|
| `Source` | Publisher, channel or account; stable available identifier; source type and its provenance | May publish many Reports. An organisation publishing news is not automatically a confirming authority. A platform does not stand for a representative public view. |
| `Person` | Available named or anonymous individual/account identity | Expressions can be attributed to a Person. A mass person stays an anonymous individual; no invented legal identity or automatic cross-platform identity merge. |
| `PersonWeightVersion` | Separate credibility, influence and predictive-record components with origin, status and time | Global and domain-independent in V1. Missing stays missing; supplied dummy values are visibly dummy. No learning/scoring algorithm is implied. |
| `Report` | A publication identity, URL/provider reference, source, publication information | A report can contain several retained content snapshots and processing attempts. Retrying processing is not another publication. |
| `EvidenceSnapshot` | Exact acquired bytes/text, content hash, acquisition time, available source-version information | Retained independently of extraction success. Active edit discovery is V2; V1 must not mislabel a fetched revision as an unavailable earlier original. |
| `Passage` | Exact span in a particular snapshot, with a locator and quote | Must resolve to the retained material. Proposed locator: canonical-text offsets plus paragraph ID and content hash; normalization and original-byte mapping must be specified. |
| `Organisation` | A distinct company, subsidiary, government or institution | Stable ID, canonical name and aliases. Parent, subsidiary, supplier and stock are not interchangeable. Automatic creation does not prove a distinct real legal entity. |
| `Stock` | The tradable security/listing entry point and known identifiers | Separate issuer and corporate-group associations. A supplier is not a corporate member. Specific listing identifiers and temporal membership rules need review. |
| `Domain` / `OrganisationActivity` | Reusable activity vocabulary plus the organisation-specific activity | Sharing AI_CHIPS does not transfer a foundry dependency from one company to another. A subject identifies the organisation–domain pair, not two unrelated lists. |
| `Resource` / `Process` / `Dependency` | Broad input/output/value-creation relationships with scope and evidence | Keep direction, relevant activity, source basis and dates. No exhaustive component ontology or simulated production system in V1. Physical representation may combine these into typed records. |
| `Event` | A particular announcement, decision, disruption or development, with subject and time precision | Announcement and production start are different events. A predicted future occurrence is a report claim, not an occurred event. Event links do not by themselves prove causal impact. |
| `Assertion` | A scoped claim about an event, organisation or relationship | Proposed common carrier for reported and inferred statements. Separate content, claimant and provenance. It may be unconfirmed without becoming false. |
| `Fact` / `Confirmation` | A precise claim supported by a qualifying external confirmation process | Confirmation has claim scope, authority/process, evidence and time. Company announcement confirms that announcement; it does not confirm that a promised outcome happened. A conflict creates a hold requiring dated personal resolution. |
| `Idea` | A shared complete meaning potentially expressed by several sources | Direct subject links to organisations/subsidiaries and their domains. Different actual forecast windows, materially different reasons, conditions or conclusions remain distinct. |
| `Expression` | One report/source's expression of an Idea | Links Report, Idea, passages and available speaker/source. Agreement belongs here. Every source expression survives deduplication of meaning. |
| `Judgment` | A supported absolute stock-price UP or DOWN claim attached through its Expression | Target Stock, horizon wording/origin and any resolved window; evidence and complete meaning remain available. Different stocks can have distinct judgments within one joint Idea. |
| `ViewVersion` | Selected sources and named interpretations over shared evidence | Versioned definition and explicit coverage. It does not create national consensus or neutral platform representation. |

Required relationship information includes who represents whom when supported, who said what, what an event concerns, and whether a reported effect or derived relevance is asserted or inferred. Game roles are excluded from V1; the investigator's world of organisations, actors, events, resources and observable claims remains.

**Proposed simplification:** use a small set of versioned typed relationships for corporate membership, activities and dependencies, with provenance, instead of inventing a separate software class for every business noun. Keep Event and Confirmation first-class enough to query; do not hide accepted concepts only in summary text. Choose the exact record layout in review decision D2.

## 4. Collection and processing contracts

Required sequence: configure → collect/retain → process → query stored results. Model requests and answers are exchanged automatically; retained versioned files serve provenance/replay rather than manual copy/paste. Collection is API-first and source-specific; ChatGPT is a separate extraction/decision transport. Ordinary reads never fetch or process missing data.

Proposed operational records, stored logically apart from domain records:

| Record | Required purpose | Proposed outcomes |
|---|---|---|
| `CollectionRun` | Record requested sources, targets, dates, result counts and failures | `COMPLETE`, `PARTIAL`, `FAILED`; completeness is relative to configured provider requests, not the entire world's news |
| `AcquisitionItem` | Resolve provider item, downloaded snapshot or failure without inventing news | `RETAINED`, `UNAVAILABLE`, `FAILED`, with reason |
| `ProcessingRun` | Pin inputs, instructions, model identity when known, configuration and raw response | `COMPLETE`, `PARTIAL`, `INSUFFICIENT_INFORMATION`, `FAILED`; these are proposed names |
| `ResolutionAttempt` | Record retrieval candidates, AI decision and application result | Separate retrieval failure from completed no-match/uncertainty |
| `QueryExecution` | Explain selection, cutoff, view/configuration, coverage and truncation | Separate data results from operational coverage/error information |

Insufficient information means the retained content cannot support the required extraction safely. It is not the same as a model timeout, no stock forecast, an empty query, or conflicting confirmations. The exact adequacy rules must be frozen with examples.

Partial processing publishes supported successful ideas while exposing incomplete work. The two-Idea cap is intentional selection, not partial failure. Failed work retains originals and raw attempts; retry reuses those originals. Applying the same successful response twice must not duplicate publications, Expressions, memberships or created organisation identities.

**Proposed application rule:** validate a response into an immutable pending result, then apply it with an idempotency key in a transaction. Keep previous successful data visible in later reads until a replacement is fully applied. A versioned replacement is different from silently mutating the old output. Recovery must handle a crash between evidence storage and metadata commit; exact transaction/file protocol depends on D1.

## 5. Identity, retrieval and shared meaning

### Organisation identity — accepted mechanism

1. Preserve original mention and normalize names consistently for retrieval.
2. Run name-similarity retrieval and vector retrieval separately against existing organisation IDs.
3. Form the ID-deduplicated **union** for V1. Retain both candidate sets, rankings/scores/configurations and intersection membership for later benchmarks. Scores from different methods are not directly comparable without calibration.
4. AI chooses an existing identity or completes with no selected identity.
5. Reuse the selected identity; otherwise create automatically, including completed uncertainty. Record the uncertainty and alternatives.

Retrieval/transport failure is not a completed decision to create. Proposed failure behaviour is stop/retry that resolution while retaining evidence; both retrieval methods are required for a claimed complete V1 attempt. A retry must reuse its prior successfully created ID. Same-name unrelated organisations remain a V2 disambiguation problem; do not implement a global uniqueness constraint that falsely proves legal identity.

An alias learned from a successful resolution can speed later lookup, but the exact bypass policy is not yet accepted. A normalized exact match must not bypass known ambiguity silently. Embedding model, normalization, candidate limits, thresholds and index are unselected.

### Idea grouping — accepted aim, proposed bounded policy

The first filter retains candidates sharing at least one organisation ID. That is candidate reduction, not proof of meaning. A cheaper similarity stage then shortlists; the LLM makes the final same-meaning decision using full scope, stock direction, actual forecast window and material qualifications. Retain all Expressions and original reports even when one Idea is reused.

Proposed V1 policy: compare an incoming Expression against the canonical meaning and retained material variants of a candidate Idea; reuse only after a completed SAME decision with no known contradiction. Otherwise keep a separate Idea and record the comparison. Do not take transitive closure of approximate similarity: A≈B and B≈C does not prove A=C. Do not automatically merge existing clusters as a side effect of inserting one report. This conservative membership policy and the borderline HM03/HM13 examples need owner approval in D3.

The same retrieve → decide → apply software pattern may be reused for stock/domain/Idea resolution, but its identity rules are not interchangeable. Automatic organisation creation does not automatically authorize arbitrary stock creation or vocabulary invention.

## 6. Extraction, forecasts and qualifications

Required extraction behaviour:

- Select at most two most articulated, separately developed ideas; one joint claim about two stocks can remain one Idea.
- Retain a short faithful summary and exact passages. Preserve negation, attribution, uncertainty, conditions and source reasons in the complete meaning.
- News may be confirmed or rumoured; personal opinion stays separate. Confidential-source news remains rumoured until qualifying confirmation.
- Extract only supported absolute stock-price UP/DOWN judgments. Rising profits, relative outperformance and flat-price expectations do not automatically become UP/DOWN.
- Exclude other people's quoted judgments and their expressed-agreement scoring in V1; retain the original material. Detailed quotation attribution is V2.
- Agreement is weak/moderate/strong on the Expression. Missing or excluded agreement is not weak or zero. It is not model confidence or person credibility.
- Different actual windows mean different Ideas. Explicit period first; wording-supported inference second; configured near-term fallback last. Preserve which route supplied it. The fallback duration is still unselected.
- Relative periods use publication time unless the source specifies another reference. An unqualified week is seven calendar days. Market-session mapping is separate.

**Proposed safe read envelope:** every Judgment result includes `idea_summary`, exact evidence references, `qualification_status` and the material qualification text when present. A numeric-only projection must be explicitly requested and described as incomplete unless it carries these fields or a reviewed equivalent. No automatic condition evaluation or dedicated reason graph is introduced.

**Proposed forecast absence distinctions:** `NO_SUPPORTED_UP_DOWN`, `DIRECTION_WITH_UNSTATED_HORIZON`, `SOURCE_HORIZON_UNRESOLVED`, `RESOLVED_WINDOW`. A flat-price claim remains discoverable in prose; no new price-direction class is implied. Exact names and inferred-horizon policy require D2.

## 7. Confirmation and holds

The confirmation policy must identify accepted sources/processes and the scope they can establish. A provider category or model confidence is not that policy. For example, a company's dated release can confirm an announced partnership; it does not automatically confirm every journalist's claim about its consequences.

Proposed representation keeps the claim separate from each qualifying confirmation and from the current status derived under a policy version. Two qualifying confirmations disagreeing on the same scoped claim create `ON_HOLD`; only personal review resolves that hold. Original evidence, the disagreement and the time/basis of resolution remain.

Proposed read behaviour for review: show a held claim with an obvious status and both supporting records; exclude it from a caller's `confirmed_only` result while returning an operational explanation/count of held exclusions. A later resolution must not change an earlier as-of result. Owner must approve visibility and possible resolution outcomes; the accepted invariant does not select these UI/API details.

Do not promise comprehensive automated conflict detection over arbitrary financial statements. Scope matching, units and accounting periods need bounded rules. Unsupported comparison remains unresolved rather than guessed. Any explicit reduction of accepted V1 confirmation scope requires an owner decision.

## 8. Time and reproducibility

Keep these clocks distinct:

| Time | Meaning |
|---|---|
| `published_at` | Stated publication time, with timezone/precision/provenance |
| `source_available_at` | Earliest supported availability of this exact information/version; may be uncertain |
| `collected_at` | When Axthena actually acquired the retained material |
| `processed_at` | When a particular extraction/resolution was executed |
| event/effective time | When the reported event or relationship occurred/applied, with precision |
| forecast window | What interval a stock-price claim refers to, with origin and boundary convention |
| review/configuration time | When a human decision, classification, membership or view version became available |

Required source-aligned example: an unchanged Monday source item collected Wednesday remains Monday information if Monday availability of that content is supported. Wednesday collection is still retained. A Wednesday correction under a Monday page date is not proven Monday information. Missing availability is not silently replaced with an optimistic timestamp.

Proposed query modes distinguish **source-aligned retrospective analysis** from **operational as-of replay**. A historical source-aligned result produced today can use a declared present-day extractor but must be labelled retrospective and retain its method version; it is not proof that the output existed then. Operational replay additionally requires that stored derivations/classifications/configurations were available at the cutoff. Detailed historical readiness simulation is V2; V1 must refuse or label an unsupported operational replay rather than falsely promise it.

Every substantive supporting source, dependency premise and confirmation needs temporal eligibility. An old report does not make today's derived relationship historically known. For the proposed labelled retrospective mode, a new grouping/interpretation over only eligible historical source inputs may be selected as current analysis under a pinned run; `membership.created_at <= source_cutoff` is not a universal filter. Its actual creation time and later context remain visible, and a membership built using later substantive evidence cannot silently enter the earlier source picture. Operational-as-of output additionally requires the derivation/classification to have existed at the cutoff. Later fitted classifications cannot enter an earlier backtest as though fitted then. Price-model training and quant integration remain outside this handoff.

Proposed persistence strategy stores immutable runs and versioned memberships plus a query manifest pinning source snapshots, view/configuration, method versions, cutoff and result format. Replaying stored outputs is reproducible; rerunning a remote LLM is not promised to reproduce its prior answer.

Unselected: interval inclusivity, missing-day/time handling, market timezone/calendar, open/close cutoffs, unsupported availability policy and horizon fallback duration. D2/D5 resolve these before relevant tests are scored.

## 9. Supported reads and explanations

Proposed first query catalogue, implementing accepted use cases:

| Query | Returns | Critical behaviour |
|---|---|---|
| Q1 Stock or universe evidence | Stock or configured market/universe + date interval + source/view/kind selection → relevant evidence, including direct opinion reads | Prepared subject lookup returns universe opinions without rediscovering them through subsidiary traversal; correct organisation/domain, complete meaning and coverage remain visible. Physical indexing is unselected. |
| Q2 Company neighbourhood | Issuer, subsidiaries, relevant broad dependencies and stock-linked judgments | Corporate links differ from supplier links; direct subject remains the actual subsidiary |
| Q3 Shared meaning | One Idea and all retained source Expressions | Publication counts are deduplicated by Report, not inflated by spans or joins |
| Q4 Two-stock evidence | Evidence concerning either or both selected stocks | One joint Idea can carry distinct per-stock judgments; no inferred long/short trade |
| Q5 Claim history | Claim, confirmations, holds and dated reviews | No later resolution backdated; precise confirmation scope |
| Q6 Evidence/run trace | Returned item → retained source and derivation | Exact passage resolution and immutable run/configuration lineage |
| Q7 Coverage | Collection/processing scope and failures for a query | Empty data does not imply no events occurred; no fabricated news records |

Traversal depth, result limits, paging and caches are query configuration choices, not new world facts. A truncated answer exposes its bound. Cached/materialized shortcuts retain lineage and can be rebuilt from authoritative data; they must not conceal a missing/ineligible dependency premise.

The accepted visual convention is company orange, subsidiary yellow, UP green and DOWN red. Colour means a source's forecast direction, not observed market movement. Show source reasons through Idea summary and passages; do not add the deferred reason subsystem. Roles of parent/subsidiary are relative to this selected view.

## 10. Scope boundaries and completion

No V1 actor-role classifier, simulator, automatic worldwide knowledge discovery, live collection during reads, paid-model integration assumption, dedicated reason graph, active edit monitor, training pipeline, predictive edge claim or strategy integration.

V1 is complete only after the selected contracts are implemented, the frozen tests and recovery checks pass, real-source useful reads are reviewed, and agreed performance/coverage targets are measured. Satisfaction with the fictional graph is the review milestone that authorizes this handoff; it is not evidence that those implementation gates have already passed.
