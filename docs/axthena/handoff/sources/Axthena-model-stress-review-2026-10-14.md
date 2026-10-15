# Axthena — model stress review

14 October 2026. Status: findings and proposals for Badr's review. No proposed correction is an accepted architecture decision, and the populated Cypher/live Aura graph has not been changed.

## Verdict

The organising model is useful. It preserves the stock-related game: organisations and their activities, people and publishers, events, dependencies, different source expressions, shared ideas, evidence, perspectives and observations. The important failures concern incomplete subject/scoping links and queries that silently assume one supporting record. They do not justify replacing the whole model.

**One focused correction-and-retest round is warranted before further architecture choices.** Correct meaning and support eligibility first. Remove duplicated payload and simplify the displayed graph next. Treat a reduction in vertex count as a proposal, not proof of faster queries.

## What was actually checked

Current authoritative business context: AX-001–AX-052, context version 48. Engineering context at review start: version 18, including C++ decision ENG-016, model-review-first ENG-017 and open flaw F-001. The apparent unselected-language entry in older business notes is superseded by ENG-016.

Baseline: 174 vertices, 324 relationships, 18 reports, 18 evidence versions, 18 source expressions, 15 shared ideas, nine scoped facts/confirmations, six dependencies, three views and five dummy daily bars. All model-lab claims, dates, people, confirmations and prices are fictional. The accepted initial real stock universe remains Nvidia/Microsoft; this fixture supplements it.

The review combined three independent read-only critiques, exact graph inspection and 14 in-memory/algebraic probes. More scenario coverage is described below. **No Cypher engine, benchmark, extraction model or predictive test was executed.** Counterexamples emulate the query structures; they establish why those structures can misbehave, not an observed Neo4j execution log. The previously advertised fixture answers still hold under their narrow conditions.

Loader SHA-256: `1dceb6006d1fb3633612ab9de03d255d0bd39e53c7a09554b5c6db3367e69668`.

Query-file SHA-256: `7af14768d91caee30573caa4eedb963bc3c9ef36fe9aa3047d0f9b73f588e55d`.

The companion `Axthena-model-stress-checks.cypher` contains read-only diagnostics for the current online fixture. It is also unexecuted here. No dependency installation or product implementation was performed.

## What your design gets right

- A stock is an entry point to corporate organisations, not their identity. Suppliers remain outside the corporate group; a proposed acquisition does not create ownership.
- An event, a report about it, a source's expression and a shared meaning remain distinguishable. This preserves disagreement and avoids confusing several publications with several events.
- A shared idea retains each author/account, report, passage and date. The partnership has three publications and one documented origin. Its publication count does not establish audience size or independent corroboration.
- Anonymous people retain distinct account identities. Agreement belongs to a particular expression, while the person vector is global and clearly dummy.
- Stock direction is optional and limited to UP/DOWN. Earnings growth and technology claims do not automatically become stock predictions.
- Announcement and production start are separate occurrences. Potential indirect effects remain hypotheses, without causal price edges.
- Source availability remains different from occurrence, printed publication, acquisition and derivation time. The manual 2026 annotations are not passed off as 2025 operational outputs.

## Concrete failures and edge cases

"Current" means present in the supplied fixture or its representation. "Extension" means demonstrated by an additional in-memory case. "Coverage" means the model allows a situation but the fixture does not test it.

| Case | Finding | Smallest proposed response |
|---|---|---|
| **Current: shared Idea subjects** | All 15 Ideas have zero outgoing links. F-001 therefore affects the whole fixture. A partnership Idea cannot directly reveal NovaChip and ForgeFoundry; domain subjects are also absent at Idea level. | Add explicit, supported Idea subject links where known. Preserve subsidiaries and multiple subjects. An unrelated war Idea may have an event/resource subject; do not force an unsupported company target. |
| **Current: confirmation scope** | 13 news expressions carry `confirmed`; nine have scoped Fact/Confirmation records. North/South can relay the original partnership confirmation. Forge/Litho lack an associated confirmation process through that shared-idea lineage. Guide prose explains publication versus contents, but the status fields do not encode the scope. | Identify what is established and the applicable process. Keep source-reported dependencies distinct from independently established contents. A report containing several claims cannot confer one blanket truth stamp. |
| **Current: quake relevance** | The quake passage says nearby roads were disrupted; it never names Route Seven. The graph combines these roads with the transport resource used for LithoWorks' Route Seven deliveries. Q8 dates the supplier chain but does not establish the route/geographic connection. | Retain the hypothesis, expose its missing geographic/route premise, and avoid treating a broad transport category as proof of a shared affected route. This does not require an exhaustive logistics model. |
| **Current: summary meaning** | The shared UP summary says "N1 improves competition". Its passages say the N1 announcement improves NovaChip's competitive position. Those are different reasons. | Preserve the announced subject and the competitive-position reason; compare summary meaning against its passage. |
| **Extension: company-domain scope** | Adding DragonLogic to the same global chip Domain lets it inherit the Domain's ForgeFoundry dependency, although the source describes NovaChip's business. The software Domain is already shared by parent/subsidiary; that happens to be harmless for this sample's power input. | Distinguish an organisation's activity instance from the broad activity name, or qualify every dependency with its owning organisation. Shared category membership alone must not transfer dependencies. |
| **Extension: alternative event reports** | Add an earlier and later supporting quake report. Q8 groups by source date and can return both true and false for one interpretation/cutoff. | Aggregate complete alternatives into one result per interpretation/cutoff, rather than treating each source date as a separate answer. |
| **Extension: orphaned shortcut** | Remove Forge→Litho evidence support, or move its availability later while leaving the shortcut date unchanged. Q8 excludes the interpretation, but Q9 still follows the `DEPENDS_ON` shortcut. | Resolve `assertion_id`, endpoints and eligible proof when using a shortcut. The shortcut is derived navigation, not a second authority. |
| **Extension: omitted requirement** | Deleting a `REQUIRES` link can make Q8 easier to satisfy: it evaluates only the requirements still listed. | Validate the complete declared premise set/route. For this lab, check the three expected dependency IDs, not merely the number of surviving edges. Do not turn three into a production traversal limit. |
| **Extension: several passages** | Give one of three judgments a second eligible supporting passage. Q11 collects four joined rows for three judgment identities. | Aggregate by judgment/attribution identity before collecting supports. Include stable IDs in output. Deduplicating only account/direction/text can erase distinct statements. |
| **Extension: several assertions per route** | Two separately supported Forge→Litho assertions produce two relationship paths but one organisation/resource chain. | Name the metric: proof routes, topology paths or source mentions. None is automatically independent evidence. |
| **Extension: confirmation not yet available** | At March 7 08:00, Q7 produces no cutoff row instead of a visible no-supported-answer result. | Preserve the requested cutoff in the result and distinguish no eligible confirmation from a confirmed value or conflict. This does not settle the wider empty-read policy. |
| **Extension: later subject membership** | Event→CONCERNS edges have no own support/date fields. Adding a subject later can make an old eligible report reach that new subject. Direct Idea links would face the same problem. | Qualify subject associations with their own evidence and source availability. Eligibility of one report does not qualify every current subject attached to its Event/Idea. |
| **Coverage: identical direction, different reason** | The fixture lacks an isolated UP/UP, same-period comparison where one reason is a chip and another a partnership. | Keep separate Ideas under AX-037. Add a third paraphrase of the chip reason to test a valid merge. |
| **Coverage: identical reason, different time** | The unspecified-period example also has a different reason, so it does not isolate the grouping rule. | Test the same reason for two weeks versus next year. Preserve relative-period anchors and stated/inferred/default distinctions. |
| **Coverage: two ideas in one article** | Each of the 18 reports currently has one expression. AX-038's two separately developed ideas are untested. | Use one report with two ideas, separate passages/subjects and different claim statuses. Publication count remains one. |
| **Coverage: quoted judgment** | No retained article tests the V1 quotation exclusion. | Preserve the quotation but do not turn it into the publisher's UP judgment or expressed agreement. |
| **Coverage: equivalent quantities** | Revenue 80 versus 82 has matching units. A new "80,000 thousand USD" record could look different from "80 million USD" if raw numbers are compared. | Compare compatible quantities after a recorded conversion. Preserve original values and accounting scope. Different currencies/periods/bases require their own rules; do not arbitrarily call them contradictions. |
| **Coverage: view-local conflict** | At 13:00 the company view sees 80; the retained corpus also has the audit's 82. | Keep selected-view values distinct from a corpus-wide conflict warning until Badr chooses the policy. Q10's existing counts are deliberately undated. |
| **Coverage: Unicode evidence** | Python string offsets and C++ byte offsets coincide on this all-ASCII fixture. They diverge for Chinese text or emoji. | Specify evidence version, encoding and offset unit, and test a non-ASCII passage before relying on excerpt reconstruction. |

## Mathematics that changes practical behaviour

### Count identities, not expanded rows

With three publications, two organisation subjects and two supporting passages per expression, a naive joined result has

\[
3\times2\times2=12\text{ rows},
\]

while spread still concerns three publication identities. Aggregate distinct report IDs, distinct statement IDs and documented origins separately. Return separate collections of subjects and supporting evidence instead of repeatedly expanding every combination. Neo4j's ordinary collection keeps duplicate rows, and nonaggregated fields determine grouping keys [R6].

Factorised query-result research studies keeping repeated combinations in a compact representation [R5]. Our proposal is simpler: grouped outputs and early identity aggregation. No specialised factorisation engine or Axthena speedup is established.

### A complete route requires all its premises; alternatives need only one complete route

Let \(A(e)\) be a known source-availability date for evidence \(e\). For a specified view/version and a declared set of complete supporting routes \(\mathcal R\):

\[
\operatorname{eligible}(t)=
\bigvee_{r\in\mathcal R}\;\bigwedge_{e\in r}[A(e)\le t].
\]

The earliest sufficient source date is therefore

\[
T=\min_{r\in\mathcal R}\max_{e\in r}A(e).
\]

For one complete route the latest required input controls its date. For two independently sufficient routes, the earlier complete route suffices. Example: input dates `(1,5,2)` and `(2,3,2)` yield route dates 5 and 3, and earliest sufficient support 3.

This adapts the alternative/joint-input distinction in provenance research [R2]. It does **not** calculate truth probability or confidence. It assumes the full premise set and exact source applicability are known. The quake's dated supplier inputs alone do not establish the missing affected-route premise. Unknown availability and incomplete premise declarations need explicit handling; they are not zero-cost evidence.

### Similarity is not equality

Take three values \(0,0.6,1.2\) and a closeness threshold \(0.8\). A is close to B, and B is close to C, but A is not close to C. Grouping all connected near-pairs would merge all three.

The same danger appears in paraphrase clustering. A shared stock, direction or event is not sufficient shared meaning. Check organisation/subsidiary scope, domain, direction, period, reasoning and conditions; retain grouping membership decisions and their versions. These are candidate safeguards, not an already selected classifier.

### Qualitative agreement is ordered, not calibrated arithmetic

Weak, moderate and strong have an order. Their distances are not established. Coding them as `1,2,3` makes weak+strong tie with moderate+moderate; coding them as `1,2,100` reverses that conclusion. Both encodings preserve the ordering.

For V1, counts by level and an unstated category are understandable. Any numerical combination needs an explicitly chosen meaning/configuration. Dummy person weights are likewise not measured probabilities or evidence of predictive usefulness. Do not multiply them into an invented confidence score.

### Bound traversal for the question being asked

If the chosen dependency graph has maximum outgoing degree \(\Delta\), walks from one start up to depth \(h\) are bounded by

\[
\sum_{k=1}^{h}\Delta^k.
\]

Here \(\Delta=2\) and \(h=3\) give an upper bound of 14 nonempty walks. Actual simple paths are fewer because cycles, dates and the target filter remove candidates. A bound controls work; it does not establish relevance. Do not traverse report/passages/people edges as though they were supplier links. Exact production limits remain unselected.

## Simplification options

Your volume-reduction intuition is right, but there are three separate opportunities: shared meaning, repeated bytes and query/display expansion. A shared idea should reduce duplicated derived meaning while keeping the original publications. Byte sharing should not merge source identities. A clearer display need not change stored information.

### Preferred first pass: retain the distinctions, remove redundant payload

In this fixture:

- All 18 Expression summaries repeat their corresponding Idea summary: 1,154 UTF-8 bytes of duplicated summary payload.
- All 18 Passage texts repeat the complete corresponding EvidenceVersion body: 2,876 bytes. Keep exact span/version references and reconstruct text; use one unambiguous offset contract.
- The 18 evidence versions contain 17 distinct bodies. Sharing the identical company/South payload can remove another 129 bytes while retaining both source-version identities.

The total of these redundant payload fields is **4,159 bytes before replacement-reference, serialisation, compression or database overhead**. This is a small illustrative corpus, not a benchmark or a forecast for a year's news. Summaries that actually differ must not be discarded. Hash/content sharing does not establish copying or independent origins.

Codd distinguishes logical redundancy from redundant stored representation and explains why derived convenience relations need consistency rules [R1]. Our application is to keep one source of authority for a relationship and validate any navigation projection. It does not prescribe a relational database.

### Conditional graph flattening

The following counts are isolated representations of the current fixture **before adding missing subject or proof links**. They are not final corrected-model sizes.

| Option | Change | Nodes | Relationships | Assessment |
|---|---|---:|---:|---|
| Preserve current identities | Remove repeated text/summary fields where reconstructible; display fewer layers | 174 | 324 | Lowest risk; recommended first. |
| Flatten passage vertices | Put stable span ID, evidence ID, start/end and offset unit on support records/links | 156 | 306 | Plausible if shared citations and several spans remain reconstructible. |
| Also inline the optional judgment | Keep one target/direction/period/reason annotation on each immutable Expression version | 152 | 294 | Plausible only when judgment provenance/version/cardinality is preserved. |
| Also inline person weights | Put the one current global vector on the Person | 149 | 291 | Do not recommend yet: historical weight versions may be lost or awkward. Domain-independent does not mean timeless. |
| Also fold EvidenceVersion into Report | Assume one immutable capture per report | 131 | 273 | Reject for now: the sample's one-to-one correspondence is not a guaranteed acquisition contract. Edit monitoring being V2 does not erase evidence identity. |

Removing vertices does not remove their information obligations. Keep stable citation/judgment IDs when callers or confirmations reference them. A separately revised judgment must retain its own derivation time; sharing the Expression's run is safe only when that correspondence actually holds. Several evidence spans must remain expressible. Repeated model outputs and old source versions stay traceable.

Do not collapse Report, Expression and Idea merely because this sample has one expression per report. One report can contain two ideas; many reports can express one idea. Do not delete Confirmation or evidenced Dependency records: their scope and proof are independent meanings.

Keep Person, publisher organisation, channel/source and original information origin distinct. A company can publish through several channels; a platform carries many anonymous people. Product and input resource could share one resource family with explicit kinds in a later simplification, but that changes neither their identity count nor the need for process input/output links.

## Proposed minimal correction order

1. **Subject and scope:** evidenced direct Idea subjects; organisation-specific activity scope; distinguish explicit subject from inferred relevance. Preserve multiple organisations on a partnership and unknown company relevance on external events.
2. **Status and relevance:** make confirmation scope/process inspectable; expose the quake's missing route premise; preserve the precise competitive-position reason.
3. **Query correctness:** aggregate alternative supports once; validate complete requirements and shortcut lineage; count statement/report identities; preserve requested empty cutoffs.
4. **Representation:** remove repeated payload. Compare the existing graph with a smaller read projection before removing support/judgment vertices.
5. **Coverage cases:** two ideas in one report, company/subsidiary scope, same-direction different-reason/period, quotation exclusion and Unicode spans. Run the Cypher loader and diagnostic queries in the chosen review environment before saying the runtime works.

No database, compression library, query framework, learning system or numerical score is selected. No implementation plan is executed. This is a correction proposal for Badr to accept, modify or reject.

## Primary references and limits

**R1. E. F. Codd (1970), A Relational Model of Data for Large Shared Data Banks.** [Original paper](https://www.engineering.upenn.edu/~zives/03f/cis550/codd.pdf), especially §2.2. Reviewed redundancy/consistency discussion. Applied narrowly to logical versus stored representation and derived projections; not a graph-versus-SQL performance comparison.

**R2. Todd J. Green, Grigoris Karvounarakis and Val Tannen (2007), Provenance Semirings.** [Original paper](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf), §§2–4. Reviewed alternatives versus joint inputs and multiplicity. Our support-route formula is a design application; no semiring engine, probabilistic independence or general negation/conflict algorithm is adopted.

**R3. Christian S. Jensen and Richard T. Snodgrass (1999), Temporal Data Management.** [Original paper](https://www2.cs.arizona.edu/~rts/pubs/TKDEJan99.pdf), §2. Reviewed modeled-world time versus database-history time. Axthena's source availability is an additional application-specific time, and its 2026 annotations remain separate. No real-time/bitemporal subsystem is proposed.

**R4. W3C PROV-DM (2013).** [Derivations](https://www.w3.org/TR/prov-dm/#component2). Reviewed entity/activity/agent and derivation distinctions. Supports retaining processing and inputs while simplifying their presentation. No full PROV/RDF implementation is required, and lineage does not certify truth.

**R5. Dan Olteanu and Jakub Závodný (2012), Factorised Representations of Query Results: Size Bounds and Readability.** [Original paper](https://www.cs.ox.ac.uk/dan.olteanu/papers/oz-icdt12.pdf), abstract and §§1–3. Reviewed compact representation of repeated query combinations. Our proposal uses ordinary grouped output; no empirical or asymptotic speed claim is transferred to Axthena.

**R6. Neo4j, Cypher 5 aggregating functions.** [Official documentation](https://neo4j.com/docs/cypher-manual/5/functions/aggregating/). Reviewed grouping keys, duplicate aggregation and null collection. Used to inspect the supplied query structures; execution in Neo4j remains unverified.

**R7. Wikidata statements and qualifiers.** [Statements](https://www.wikidata.org/wiki/Help:Statements), [qualifiers](https://www.wikidata.org/wiki/Help:Qualifiers). Reviewed the role of statement-specific references, time and applicability. Used as a practical scoping example; no adoption of Wikidata's confirmation/rank policy.

The earlier research catalogue remains a broader reference base. This review deliberately adds no new backend choice. The findings are evidence about this model/probe, hypotheses about uncovered cases, and proposals for correction—not accepted decisions.
