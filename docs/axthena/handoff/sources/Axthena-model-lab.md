# Axthena — populated Cypher model lab

This is a proposed representation for Badr to inspect before any further architecture or implementation work. It does not select Axthena's production database. C++ remains the accepted main application language.

The scenario uses fictional NovaChip, its NOVA stock, subsidiary NovaCloud, supplier ForgeFoundry, equipment supplier LithoWorks, competitor DragonLogic and acquisition target SoftPeak. Every article, person, date, confirmation and price is invented. This lab supplements the earlier real-report example; it does not change the accepted initial Nvidia/Microsoft stock universe.

## Run it

1. Use an **empty disposable Neo4j database** and its Browser query editor. The files use Neo4j Cypher 5-compatible syntax without APOC.
2. Paste the entire `Axthena-model-lab-load.cypher` file into the editor and run it as **one statement**. The loader contains no deletion commands.
3. Open `Axthena-model-lab-queries.cypher`. Run **Q0**, then **Q1**. Select the Graph result for Q1. **G0** gives an optional overview of the world without its evidence detail.
4. Run the remaining numbered queries individually. Each includes the expected answer. Begin with Q1–Q3 to review meaning; Q7–Q9 exercise conflicts and dated dependencies.

The loader creates **174 nodes and 324 relationships** under the `AxLab` label, with IDs beginning `axlab/`. Reloading the identical file into the same unmodified lab database reuses those identities. It is not a reset mechanism and will not overwrite existing node properties after hand edits. Start another empty disposable database for a clean experiment. The earlier real-report example uses a different label, `AxDemo`.

**Verification:** identifiers, relationship endpoints, uniqueness, complete fictional text hashes, exact passage offsets and the expected scenario answers were checked locally. A second independent review found no blocking fixture issue. **The Cypher has not been executed in Neo4j here.** Q0 and I0 provide checks for your first actual database run; syntax and runtime acceptance remain to be confirmed there.

## What each record means

| Record | Meaning in this proposed model |
|---|---|
| Stock | A traded identity. NOVA points to its issuer and contributing subsidiary with different associations. |
| Organisation | Company, publisher or institution. Suppliers and acquisition targets remain outside ownership until supported. |
| Domain | An organisation's area of activity. NovaChip has chip and software domains. |
| Process / Resource / Product | Broad work, required inputs and resulting outputs. An absent input link means missing detail, not input-free production. |
| Event | An occurrence being discussed. Announcing a production plan and later starting production are separate events. |
| Report / Source | An article or post and its publication channel. Organisation news and personal opinions stay separate. |
| EvidenceVersion / Passage | Retained original fictional text and the precise supporting excerpt with offsets. |
| Expression / Idea | One source's statement and a shared meaning. Grouping expressions never discards their authors or passages. |
| Fact / Confirmation | A precisely scoped accepted statement and the external process/evidence used to support it. The processes here are illustrative. |
| Judgment | An optional UP/DOWN stock-price position, its stated timing and how timing was obtained. |
| Dependency / Interpretation | A source-reported relationship with supporting evidence, or a separate analyst hypothesis built from evidence. |
| Person / PersonWeight | A stable account identity and a separate, global vector. All vector values here are explicitly dummy. |
| View | A versioned selection of sources and interpretations. It does not imply national or platform consensus. |
| PriceBar | A separate observed-data shape with daily opening, high, low, closing and volume values. These prices are dummy. |

The extra support records make distinctions visible; their exact names and granularity remain proposals. The lab is not a proposed mandatory extraction of all records from every article.

## First picture: partnership

Three publications describe the same NovaChip–ForgeFoundry announcement. They retain **three reports, three expressions, three exact passages and one shared idea**.

NovaChip is the documented original information source for the announcement. North Business Journal explicitly expresses strong support. South Business Journal copies the company text without expressing agreement. Publication count is therefore three; documented origin count is one. Silence is not agreement, and repeated publication is not independent confirmation.

The company text and South copy have different evidence identities but the same content hash. Original source identity, publisher identity and agreement strength answer different questions.

## Review cases and expected answers

| Query | Question exercised | Expected answer |
|---|---|---|
| Q0 | Complete load? | 174 nodes, 324 relationships; `passed=true`. |
| Q1 | Shared meaning with retained evidence? | Three source-expression paths into one partnership idea. |
| Q2 | Spread, origin and agreement distinguished? | Three publishers; one origin; North strong; others unstated; South copied. |
| Q3 | Issuer, subsidiary and supplier distinguished? | NOVA points to NovaChip and NovaCloud, not ForgeFoundry, LithoWorks or SoftPeak. |
| Q4 | Occurrence time versus source availability? | Event counts 3, 4, 5, 8 at the four specified cutoffs. |
| Q5 | Stable anonymous identities and separate weights? | Four judgments from three accounts; distinct anonymous accounts; dummy global vectors. |
| Q6 | Deduplication without lost authors? | One UP idea retains two people, two expressions and two passages. DOWN is separate. |
| Q7 | Later conflict changes the appropriate dated answer? | Revenue 80 alone at 11:00; 80 versus 82 and `on_hold` at 13:00. |
| Q8 | Indirect interpretation needs all its support? | Ineligible March 4; eligible March 5; remains a hypothesis. |
| Q9 | Cycles and delayed dependency information? | Zero eligible routes March 4; one March 5; traversal bounded at three links. |
| Q10 | Views preserve source selection? | Company 1, media 2, mixed 3 partnership reports; one documented origin each. |
| Q11 | Prices inspectable alongside eligible earlier statements? | Five bars; no statements March 3; three selected statements March 4–7; no causal claim. |
| Q12 | Broad input/process/output world? | Chip and software outputs; fabrication needs silicon/equipment; software needs power. |
| I0 | Basic integrity? | Five rows, zero violations, all `passed=true`. |

## Meaning and time safeguards

**Confirmed news is not a blanket truth stamp.** In this fixture it marks the established publication or scoped announcement. A company announcing a low-power chip confirms that the announcement occurred; it does not independently establish its claimed power savings or later production. Fact scope is narrower than the entire passage. Most confirmation records cite first-party statements; these are not independent verification of business performance. The conflicting audit record is a separate source.

**Conflicts have a scope.** The revenue discrepancy concerns the same company, period, accounting basis, unit and consolidation scope. It does not place unrelated partnership facts or the entire earnings event on hold. Q7 derives conflict from confirmations eligible at the cutoff, rather than applying the current `Conflict.status` to every historical answer. Q7 uses all retained eligible sources. A future view-filtered conflict query must explicitly choose between a corpus-wide conflict warning and a conflict visible only inside the selected view; Q10 does not decide that policy.

**The missing-information rumour stays a rumour.** The March 5 SoftPeak report has unknown information origin and no Fact or ownership edge. The March 6 company announcement confirms a proposed acquisition, not its completion. No `OWNS` link is created for SoftPeak. Quoted third-party judgments are still deferred.

**Statements do not become stock forecasts by implication.** The earnings and technology announcements have no automatic UP/DOWN judgment. The four personal statements expressly concern NOVA's stock. Three identify a chip-domain subject. The demand-only statement leaves the domain unspecified. Its missing source timing remains visible alongside an illustrative near-term default label; no numerical duration has been selected.

**Dated reads follow supporting evidence.** Event occurrence, printed publication date, first source availability, collection and processing are distinct. The ForgeFoundry report is printed March 3 but first available March 5. Its dependencies cannot enter a March 4 source-information answer. The earthquake occurred March 3 but was first reported March 4. Dates use uniform UTC ISO strings for transparent comparisons in this lab; this is not a final storage-type decision.

**These are retrospective source-information queries.** All classifications, interpretations, grouping, view selections and weights were manually constructed on October 14, 2026. They were not available to an analyst in March 2025. No LLM was run, no historical fitted classification is invented, and this fixture does not establish a backtest-ready operational history. Its cutoffs test which source evidence could support a later reconstruction, using explicitly fictional availability timestamps.

**Relationships have support.** Initial stock/domain/process/competitor links are declared fictional analyst configuration in `Context`, with that context ID on the edges. Dependency links have separate assertion records and source passages. `DEPENDS_ON` is a convenient navigation projection, not an additional independent assertion. The quake interpretation requires all three dependency support chains and never asserts a stock-price effect.

**A daily close is an observation, not a decision input before its availability.** Q11 only pairs statements whose source availability precedes the bar's stated availability, with a separate fixed statement-selection cutoff. It is an inspection table, not an opening-time decision dataset or predictive score. Price movement alone cannot establish motive, credibility or causal power.

## Keep this review bounded

Review whether the representation matches your meaning. Record corrections against concrete rows or graph paths. The next step is model review, not backend selection, benchmarks or product implementation. The accepted C++ decision and all other unselected technology choices remain unchanged.
