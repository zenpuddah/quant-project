# Axthena: expanded extraction trial

15 October 2026 · Experimental findings, not architecture decisions

The larger test still produces a tie. All three instruction variants satisfy the tested structured checks. Independent assistant reviews found no material meaning errors in the retained outputs. That is encouraging for the narrow extraction task, but the experiment also exposes distinctions that the current output format cannot express. It does not establish reliable processing of real news.

## What changed

The original pilot had 17 short reports, five organisation decisions and 14 meaning comparisons. This expansion adds **36 new fictional reports, 12 organisation decisions and 36 comparisons**. These are new samples, not a rerun of the original set. The reports contain 68 paragraphs in English, French and Chinese, including longer passages, background material, corrections, misleading headlines and incomplete downloads. Seventeen reports have different publication and supplied first-supported-availability dates.

The fictional organisations exercise the model without changing the selected real-company MVP universe. Dates extending into 2028 are invented date-boundary tests, not forecasts or historical evidence.

Three assistant authors prepared separate batches. Pre-run reviewers checked their reference answers. Inputs, references and scoring rules were frozen before extraction. The original instructions remained unchanged:

| Variant | Instructions |
|---|---|
| A | Shared rules and required output shape |
| B | A plus four worked examples |
| C | B plus an instruction to audit against the source |

Each variant processed the same three batches in fresh assistant contexts: nine initial submitted responses. References and other runs were withheld by instruction. Every submitted response was retained without repair or replacement. This used in-session assistant workers, not an external model API or automated ordinary ChatGPT interface. Exact model snapshot, seed, sampling settings, token usage, generation latency and dollar cost were not established.

## Measured results

| Check | A | B | C |
|---|---:|---:|---:|
| Reports matching the tested structured reference | 36/36 | 36/36 | 36/36 |
| Organisation decisions, including supplied union/intersection | 12/12 | 12/12 | 12/12 |
| Meaning-comparison labels | 36/36 | 36/36 | 36/36 |
| Retained Ideas | 38 | 38 | 38 |
| Retained stock-price judgments | 14 | 14 | 14 |
| Exact quotations matching their named source paragraph | 42/42 | 48/48 | 52/52 |
| Ideas with required supporting-paragraph coverage | 38/38 | 38/38 | 38/38 |
| Incorrect SAME decisions observed | 0 | 0 | 0 |
| Illustrative reads over saved JSON | 10/10 | 10/10 | 10/10 |

The comparison set contains nine SAME, 24 DIFFERENT and three INSUFFICIENT reference labels. These are supplied pairs, not the output of a measured retrieval system. The nine candidate responses also pass the experiment's output-shape checks. Four deliberately corrupted copies demonstrate that the scorer detects duplicate reports, fabricated quotations, false merges and an unexpected field; these are not additional model runs.

“Matching the reference” means agreement on the fields the scorer checks. It is not an exact match of every summary word, proof of factual truth, or a general accuracy estimate. Several answers were explicitly permitted before execution: H09 allows two event-phase interpretations, while H18/H19 allow either the product or manufacturing domain. A and C choose NONE for H09; B chooses POTENTIAL. This is a recorded taxonomy ambiguity, not a discovered winner. All choose AI_CHIPS for H18/H19.

Three separate assistant reviewers inspected **114 retained summaries, 142 quotations and 108 comparison explanations** against the inputs. They found no definite material semantic error. They did record minor wording and citation-completeness differences. For example, A/H17 includes accurate qualifications from elsewhere in its source paragraph beyond its selected quotation; C/H09 compresses product-mix wording somewhat ambiguously. The current requirement is at least one exact supporting quotation per Idea, not an independent citation for every summary clause. More quotations alone do not establish a better extraction.

## A separate check of question order

The final benchmark review found a construction weakness: each original batch orders its comparison answers as three SAME, eight DIFFERENT, then one INSUFFICIENT. That does not show the workers used a shortcut, but it weakens the test.

A separately frozen follow-up shuffled all 36 pairs, assigned new IDs and reversed left/right on 18 pairs. A fresh worker using A returned **36/36 matching labels**, with valid output shape and task inventory. This is one targeted check on already used meanings, not 36 new examples, a repeated trial of the original packaging, or a new A/B/C contest. The original results were preserved. Its input, mapping, references and raw response are retained under `supplement_order/`.

A separate reviewer checked all 36 explanations and found no clear decision or material explanation defect, but identified **two defensible borderline SAME labels**. HM03/SQ14 equates a conditional prediction with wording that more explicitly claims causation. HM13/SQ35 describes the same transaction while differing in explicit ownership and announcement attribution. Whether these differences should prevent shared-Idea grouping needs owner review of the meaning-equivalence rule. The original reference labels and scores remain unchanged; these are post-run interpretation notes, not silently corrected answers.

## Examples that matter for Axthena

| Case | Difficulty introduced | Observed result in A/B/C |
|---|---|---|
| H08 | One conditional trade: NOVA UP and DRAG DOWN, only if a contract is awarded by a deadline | One joint Idea, two distinct stock judgments, condition retained in the summary |
| H15 | A corrected 9% cost reduction replaces 19%; the subject is a subsidiary and the measure is cost per active tenant | Corrected figure, denominator and subsidiary retained; no invented stock UP |
| H17 | Two developed forecasts in one report; only one is conditional, and their windows differ | Two Ideas, different windows, no transfer of the first condition to the second |
| H18/H19 | A production rumour followed by a company denial on a later date | Both source records remain; a dated read exposes the denial only from its supplied availability |
| H25 | An optimistic French headline conflicts with the author's conditional bearish view in the body | DOWN, correct organisation, condition preserved, publication-relative two-week window |
| H29 | A French report includes an embedded command to fabricate NOVA UP | Command treated as source text; signed software agreement extracted without a stock forecast |
| H30 | Chinese text provides one complete forecast and then a truncated second topic | Valid forecast retained, PARTIAL recorded, no invented second Idea |
| H31 / HM28 | “The stock stays flat” versus “I make no forecast” | Flat outlook preserved in the summary, no UP/DOWN entry; the two meanings remain DIFFERENT |
| H36 | Chinese headline available, article body missing | INSUFFICIENT, zero invented Ideas |

The saved read checks also exercise announcement versus completion, subsidiary scope, deliberate two-Idea omission and source availability. These are small reads over JSON. They do not run Cypher, traverse a graph, resolve truth conflicts, benchmark storage, or prove information was held by Axthena historically.

## Six boundaries the format cannot yet handle adequately

These are separately reviewed design scenarios. They were not submitted as scored extraction cases. The proposed remedies below require owner review.

| Scenario | Current problem | Smallest proposed direction |
|---|---|---|
| G01: qualifying confirmations disagree | Ordinary source categories cannot express the accepted unresolved hold | Retain both conclusions and a dated conflict/hold annotation; decide read policy separately |
| G02: the forecast belongs to a quoted analyst | V1 excludes quoted judgments, but the trial instructions omit that rule | Add the exclusion explicitly and test quoted speech against the speaker's own report |
| G03: “UP over the medium term” | A meaningful but vague horizon is collapsed into missing timing | Retain original horizon wording and distinguish it from any inferred or configured numerical interval |
| G04: one joint Idea concerns chips at one organisation and software at another | One shared domain field loses the organisation/domain pairings | Preserve the relevant domain alongside each organisation within the joint Idea |
| G05: both candidate searches fail | An error can look like successful searches finding no candidate | Record search outcome separately; preserve automatic creation after a completed no-match decision |
| G06: a Wednesday correction sits under a Monday page date | The format assumes the exact wording's availability date is already known | Bind evidence to the retained snapshot and expose unknown earlier availability without inventing history |

There is also a query limitation visible in successful outputs: **conditions are preserved in prose, not separate judgment fields**. H08 is faithful as a readable record. A consumer that reads only `NOVA + UP + dates` would omit its contract-award condition. Choosing how queries expose that qualification is a design task; this trial does not select condition evaluation, a simulator, or V2 reasoning nodes.

## What the clean score does not settle

The sample is synthetic and deliberately exercises known rules. It is harder than the original packet, but it does not establish an upper limit on difficulty. Authors, extractors and reviewers are assistants; independent contexts do not eliminate shared model biases. There are no repeated trials of each prompt on each batch, and isolation was instructed rather than enforced by separate filesystems. A stable prompt advantage cannot be estimated here.

The packet supplies organisation candidates, source types, confirmation scopes and supported availability dates. Obtaining those correctly from a real collector remains untested. Some reports explicitly explain their limitations. Comparisons receive selected pairs and window metadata; some also restate report claims in the same batch, which can assist extraction. Retrieval recall, multi-item grouping consistency, duplicate ingestion and cluster growth are not tested. The six design scenarios also remain unscored. A valid quotation proves where the words occur, not the truth of their claim or the completeness of a summary.

The test does not measure real-source access, download fidelity, persistent graph queries, compression, runtime performance, predictable costs, price predictiveness or reproducible historical operational outputs. Some dates are future synthetic dates, and the temporary end-date convention remains experimental.

## Recommendation for the next review

Keep **A as the provisional baseline**: the added examples and audit instruction show no measured advantage on this packet. This is a simplicity recommendation, not a permanent prompt selection.

Before another larger synthetic run, review the minimum missing distinctions above. Then use a small owner-reviewed real-source packet, preserving the actual text and its uncertainties, to test whether the upstream assumptions hold. Do not quietly repair the frozen experiment to make its scores more persuasive. Any changed format or rule should receive a new version and its own comparison.

Badr's output/query validation remains outstanding. No production C++ code, existing Cypher fixture, live graph, paid model endpoint or quant integration was changed.

## Review files

- `Axthena-hard-samples-2026-10-15.md`: every report with original paragraphs and unchanged A output, followed by identity and comparison examples.
- `Axthena-hard-trial-2026-10-15.zip`: all three prompts, three batches, all nine raw outputs, references, pre-run amendments, scores, exact quote locations, semantic reviews, design cases and offline checking scripts.
- Inside the archive, `README.md` gives navigation and commands. `freeze_manifest.json` and `run_manifest.json` identify frozen inputs and retained executions.
- Context updated under accepted experiment scope ENG-041 and advisory findings P-019. No proposed remedy was recorded as an accepted architecture decision.
