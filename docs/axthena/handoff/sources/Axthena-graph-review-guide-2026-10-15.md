# Axthena: inspect the extracted graph

This packet turns the **retained A outputs from the harder fictional trial** into an inspectable graph. It does not run the LLM again. All articles, organisations, people, stocks and dates are fictional. Some dates deliberately reach 2028 to test calendar boundaries; this is not the proposed twelve-month real-news dataset.

The purpose is to let Badr decide whether the produced meanings and links match Axthena. The projection is a review aid, not an accepted storage design. Representation, abstraction and query-optimisation research follows that review.

## Open the graph

1. In your Neo4j query editor, paste the complete contents of `load.cypher` and run it as one statement. It uses the new `AxHardReview` label and namespaced IDs; it contains no reset or deletion command. It does not target the earlier AxLab/AxDemo fixtures.
2. Open `queries.cypher`. Run **Q0 and Q0b individually** to check the loaded counts: **373 nodes, 715 relationships**.
3. Run **Q1**, then use the graph result to explore three representative shapes. Select a node to inspect its properties. `name` provides short display labels; full meaning remains in `Idea.summary` and the linked evidence.
4. Use **Q2–Q17** one at a time for the review cases below. Graph-returning queries are Q1, Q3, Q5 and Q13; the other queries return tables for exact inspection.

The loader is self-contained: no external article downloads, APOC, credentials or separate import files. It uses `MERGE` with fixed IDs so a sequential rerun is intended to reuse its records. Concurrent loading and rerun behaviour have not been tested in a database. Do not use a broad database deletion command to reload it.

**Validation limit:** offline integrity and source-fidelity checks passed. A separate reviewer inspected the graph and loader. Neo4j parsing and execution have not been performed here. Q0/Q0b are the first database checks for your review environment.

## What is represented

| Record | Meaning in this projection |
|---|---|
| Report | Original supplied source, publication/availability/collection dates and paragraphs. All 36 remain, including the insufficient one. |
| Expression | One retained source expression, its classification and claimed event phase, attribution, evidence and stock judgments. |
| Idea | Its complete summary, directly linked to the concerned organisations and stated activity domain. There are 38 report-local Ideas. |
| Judgment | A retained UP/DOWN claim about a stock, with its own forecast period or explicit missing-period state. |
| Passage → Paragraph | An exact selected quote and its complete original paragraph. Character and UTF-8 byte positions are zero-based, with the end excluded. |
| Organisation / Stock / Domain | Supplied identities, business categories and catalogue links; these do not establish dated real-world ownership or dependencies. |
| Source / Person | Traceable source IDs. A Person represents the supplied identity only; no real-world identity is inferred. |
| ProcessingRecord / ExtractionRun | Processing completeness and evidence of which saved run produced a record. These are kept outside the news meaning. |
| IdentityCase / ComparisonCase | Separate diagnostic inputs and outcomes. Candidate lists were supplied; no search engine or similarity index ran in this projection. |

Stock issuance and NovaCloud's parent link come from the **undated fixture catalogue**. An Idea concerning NovaCloud is not automatically rewritten as a NovaChips Idea. A catalogue domain is distinct from the domain supported by an individual expression.

All 38 Ideas remain separate. The 36 meaning-comparison tasks use independent example pairs and supply no foreign keys to these extracted Ideas. Their `SAME` labels therefore do **not** merge nodes. Repeated `CREATE` answers for RidgeCompute came from independent identity tasks; they are not a demonstration of sequential duplicate prevention.

## Review cases

| Query | Inspect | Expected result |
|---|---|---|
| Q1, Q3 | Joint versus independent views | H08 has one Idea concerning two organisations, with NOVA UP and DRAG DOWN. H17 has two independently developed Ideas. |
| Q2, Q4 | Qualification and evidence | H08's contract condition and H01's commercial-acceptance condition remain in the full summary and exact source passage. Neither condition is asserted to have occurred. |
| Q5 | Subsidiary targeting | H04, H15, H20, H24 and H26 concern NovaCloud directly. Its parent is a separate organisation. |
| Q6 | Domain boundaries | H10 concerns Ridge Materials' SOFTWARE_TOOLS, although its catalogue lists MATERIALS. H12 has no extracted domain. |
| Q7 | A claim and a later denial | On 14 October, H18's production rumour is visible. On 15 October, H19's denial is also visible. Neither record overwrites the other. |
| Q8 | Unknown forecast periods | Four judgments retain direction but have missing dates. No numerical default has been invented. |
| Q9 | Empty UP/DOWN lists | Flat-price, relative-performance, withdrawn and profit-growth forecasts retain their meaning. An empty list does not mean “no forecast.” |
| Q10 | Partial and capped extraction | H28 is COMPLETE with a cap omission and two Ideas; H30 is PARTIAL with one valid Idea; H36 is INSUFFICIENT with none. |
| Q11 | Borderline semantic comparisons | HM03 and HM13 retain their original comparison decisions and explanations for owner review. They do not merge extracted Ideas. |
| Q12 | Identity decisions | Name/vector candidate union and intersection remain inspectable alongside the selected organisation. |
| Q13 | Shared article, separate subjects | H06 has one O5/MATERIALS Idea and one O2/AI_CHIPS Idea. The article does not establish an O5→O2 supply relationship. |
| Q14 | Announcement versus completion | Acquisition agreement and completed acquisition remain different meanings. A confirmed plan is not confirmed future execution. |
| Q15–Q17 | Useful reads and traceability | UP views return full qualification and evidence; `sel` and `selene` remain distinct; saved extraction provenance is queryable. |

## Gaps exposed by producing the graph

1. **Events and dependencies are not yet separate extracted records.** The current response describes them in summaries and gives a coarse event phase. It does not emit structured event identities, dependency links or their evidence. This packet does not invent them. Their absence is a gap in this extraction contract, not a decision to remove them from Axthena.
2. **Facts are currently an expression classification.** There is no separate Fact/Confirmation record or implemented confirmation process in these outputs. `confirmation_scope` was supplied to the trial. `OCCURRED` means the source claims occurrence; H18 shows why it cannot mean independently verified occurrence.
3. **Conditions remain prose.** Reading only UP/DOWN and dates loses material qualifications. The supplied queries return full meaning and evidence. Whether to structure conditions is still a design question; no condition evaluator or reason model is added here.
4. **Grouping was tested separately from insertion.** This packet cannot demonstrate real cross-report deduplication, clustering quality, compression or speed. It preserves the distinction between source expressions and reusable Ideas so that behaviour can be reviewed later.
5. **The time queries are limited.** They use the supplied earliest supported source-availability date. They do not recreate historical extraction/model states. H01's forecast starts on publication, before availability; its collection date is later still. Trial forecast ends are exclusive; this is not an accepted production boundary rule.

No social weights, predictive skill estimates or causal influence scores are invented. Real-source access, complete twelve-month coverage, storage performance and numerical-consumer suitability remain unvalidated.

## Contents and verification

`graph.json` contains the exact node/relationship export. `projection_manifest.json` records counts, file hashes and limitations. `evidence/` retains the original input, combined A output, instructions and the three original A batch inputs/outputs/submissions. The original broader experiment manifest mentions B/C runs; their files remain in the earlier full trial archive, not this A-only packet.

`build_projection.py` rebuilds the disposable export with the Python standard library. `check_projection.py` verifies structure, complete reconstruction of all 36 retained report outputs, exact evidence spans, diagnostic inputs/results and provenance. `validation.json` records the result. These scripts are review utilities, not the proposed C++ application.

Counts: 36 Reports; 38 Expressions; 38 Ideas; 14 Judgments; 42 Passages; 68 Paragraphs; 26 Sources; 10 Persons; 6 Organisations; 2 Stocks; 5 Domains; 36 ProcessingRecords; 3 ExtractionRuns; 12 IdentityCases; 36 ComparisonCases; 1 Fixture.

Cypher syntax references checked for this export: [Neo4j MERGE](https://neo4j.com/docs/cypher-manual/current/clauses/merge/) and [Neo4j FOREACH](https://neo4j.com/docs/cypher-manual/current/clauses/foreach/). Documentation review is not engine execution.

For feedback, a report/Idea ID, the query used, the observed result and the intended result are enough. Badr's review decides whether the representation fits. This packet does not mark the model accepted or advance production implementation.
