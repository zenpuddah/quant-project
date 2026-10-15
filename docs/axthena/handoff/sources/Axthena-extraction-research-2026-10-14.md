# Axthena — extraction methods, model evidence and research directions

Research date: 14 October 2026. Status: primary-source research and advisor proposals. No model was executed on Axthena data. No prompts, harness, production adapter, database or graph fixture were built or changed. Badr retains the architecture decisions.

Read with [Axthena-context.md](Axthena-context.md), [Axthena-engineering-context.md](Axthena-engineering-context.md) and [Axthena-LLM-boundary-proposal-2026-10-14.md](Axthena-LLM-boundary-proposal-2026-10-14.md). The machine-readable bibliography is [Axthena-extraction-reference-index-2026-10-14.json](Axthena-extraction-reference-index-2026-10-14.json).

## Recommendation to review

Start with source-grounded, schema-guided LLM extraction as the reference method. Schema-guided means that the model fills an explicitly defined record. Source-grounded means that every extracted claim points back to a retained passage that actually supports it. Compare a cheaper hosted model with that reference before adding a specialist model or more model calls.

A small local extractor is a promising challenger for names, dates and simple relationships. It has a narrower responsibility than deciding whether two full stock-related Ideas mean the same thing. Keep the final meaning decision separately testable.

Define a small communication contract owned by Axthena before writing model-specific instructions. Providers may change; the source evidence, field meanings, grouping policy and historical outputs must survive that change. The separate boundary proposal specifies requests, attempts, outputs, capabilities and validation responsibilities.

The inspected literature does not establish a universal best extractor for Axthena. It supplies strong component results and useful failure cases. Selecting the two most articulated Ideas, resolving stock/organisation identities, preserving exact evidence, extracting UP/DOWN with the correct period, and matching timed Ideas together still require an Axthena evaluation.

## The task we are evaluating

For example, an article says NovaChip signed a foundry agreement and an author expects NOVA to rise over the next two weeks. The extraction should retain the agreement as a source assertion, identify the organisations and relevant activity, preserve the author's expression, and record the supported stock forecast with its publication-anchored window. Another article discussing the same agreement can carry a different judgment. Shared event identity does not require shared opinion meaning.

Accepted requirements remain intact:

- Original reports, source identities, exact passages, versions and actual processing times remain recoverable.
- At most two most-articulated Ideas are extracted per article in V1. A two-company claim is not automatically two Ideas.
- Ideas point to their concerned organisations/suborganisations and applicable activities. Shared activity categories do not transfer one company's dependencies to another.
- Organisation name and semantic candidate retrieval remain separate; V1 uses their union and retains intersection membership. AI selects an existing identity or creates a separate organisation automatically when none is selected, including uncertain comparisons. Processing failure is a different outcome.
- First-filter Idea candidates share at least one concerned organisation. That is candidate inclusion, not equivalence.
- Judgments concern stock-price UP/DOWN. Rising revenue alone does not establish UP; relative outperformance alone does not establish opposite absolute directions.
- Different actual forecast windows remain separate Ideas. Relative wording uses the publication date unless the source supplies a different reference. Two unqualified weeks means fourteen calendar days.
- No forecast, a forecast with no stated period, an inferred/default period, and failed extraction remain distinguishable. Seven days is still a tentative fallback value.
- A quoted passage establishes traceability, not external truth. Fact confirmation remains a separate process. Conflicting qualifying confirmations retain the on-hold/user-review rule.
- Dedicated reasons/thought-process extraction, refined quote attribution, training and empirical person scoring remain V2. Short comparison justifications are processing provenance, not a new judgment-reason subsystem.
- Valid partial extraction is readable with unfinished processing recorded separately. Ordinary reads do not collect or process missing data.

These rules are the evaluation contract. None of the research below overrides them.

## What the strongest extraction evidence actually measures

F1 balances precision and recall: precision asks how many proposed findings are correct; recall asks how many supported findings were found. F1 scores from different datasets or task definitions are not directly comparable. A benchmark with correct entity locations supplied is easier than extracting those locations and their relationships together.

| Method or benchmark | Original measured result | Conditions and limit | Proposed use |
|---|---|---|---|
| GLiNER2.5, August 2026 author release [R01] | Base Few-NERD 55.14 F1; CrossNER 58.30 versus predecessor 59.06 | Developer comparison across NER/classification tasks; gains are mixed. New joint relationship/record features do not have an equivalent published full-Idea evaluation. | Low-cost source mention and date-span challenger; evaluate multilingual behavior separately. |
| GLiREL, NAACL 2025 [R02] | FewRel 84.48 and Wiki-ZSL 73.91 macro-F1 with 15 unseen relations | Correct entity positions provided; trained on other relations. Re-DocRED drops from 54.13 with gold coreference to 25.08 with predicted coreference. | Typed supplier/ownership/partnership extraction candidate; test the complete pipeline. |
| NuExtract3 official card [R03] | 4B checkpoint: 0.651 ± 0.019 custom extraction score | Approximately 600 private vendor documents; custom JSON-tree scoring, not F1; 27 invalid outputs. | Smaller generative record extractor to test if local serving is practical. |
| GoLLIE, ICLR 2024 [R04] | 7B zero-shot mean F1 55.3 versus 42.3 same-backbone baseline | Fine-tuned to follow annotation guidelines; legacy backbone and modified evaluation tasks. | Evidence for careful definitions/examples; guideline tuning is a later experiment. |
| DREEAM, EACL 2023 [R05] | DocRED relation F1 67.53; corresponding evidence retrieval 57.34 F1 | Fixed Wikipedia relations, supplied entities/coreference; evidence is sentence-level. | Separate relationship correctness from supporting-evidence retrieval. |
| Doc2EDAG, EMNLP 2019 [R06] | Mean Chinese financial event-role F1 76.3; multi-event 67.3 | Five predefined equity-event types; distant annotations. Historical reference, not current top ranking. | Preserve event instances and cross-sentence arguments; inspect Chinese financial examples. |
| Contextual AI ExtractBench, February 2026 [R07] | Seven SEC reports using a 369-field schema: 0% valid output across six tested models | 35 PDFs; broad schemas and output failures dominate. This is not short-news extraction accuracy. | Small extraction contracts; score missing/null/omitted values and validity separately. |
| LlamaIndex ExtractBench, July 2026 [R08] | LlamaExtract Agentic Plus 95.6 value F1, but 46.4 word-grounding F1 | 370 documents; vendor-authored; partly consensus-assisted labels; word grounding includes correct value and box alignment. | Score evidence location independently from value extraction. |
| LangExtract official repository [R09] | No matched public Axthena leaderboard result established | Source alignment, examples, chunking, multiple passes and provider extension are documented features. An unlocatable extraction can have no character interval. | Useful workflow/reference for source highlighting and review; not selected as the C++ production layer. |

The two unrelated ExtractBench papers must not be merged into one leaderboard. Likewise, NuExtract's private score and its result in LlamaIndex's study describe different data and metrics.

Inference for Axthena: request small, explicit records with supporting excerpts. Validate the excerpts against the exact evidence version; separately check that the excerpt supports the field. A correct substring can still be assigned to the wrong company or misread as a stock forecast.

## Model benchmarks with comparable rows

### Structured Output Benchmark, April 2026 preprint [R10]

These rows share the paper's text task: 5,000 transformed HotpotQA examples, temperature zero, maximum 2,048 output tokens and generally reduced reasoning. Scores are schema-complexity weighted and gated; exact values and array order matter. Paper labels do not establish exact model snapshots.

| Paper model label | Valid JSON/schema | Exact value accuracy | Entire response exact |
|---|---:|---:|---:|
| GLM-4.7 | 97.2% | 83.0% | 52.6% |
| Qwen3.5-35B | 97.4% | 82.8% | 51.9% |
| GPT-5.4 | 99.9% | 82.5% | 48.6% |
| Gemini-2.5-Flash | 98.3% | 82.2% | 51.5% |

This is useful proxy evidence, not a stock-Idea leaderboard. Gold includes human/LLM-assisted review; faithful paraphrases can lose exact-match credit. Small score gaps without uncertainty estimates do not justify declaring a decisive winner.

### Financial entity extraction, Cleanlab December 2025 experiment [R11]

All rows use the same corrected FIRE-derived task with Company, Date, Location, Money, Person, Product and Quantity. Code and data are released.

| Model label | Individual fields correct | Entire output correct |
|---|---:|---:|
| GPT-5 | 94.9% | 70.0% |
| Gemini-3-Pro | 93.5% | 62.4% |
| GPT-4.1-mini | 92.2% | 58.0% |
| Gemini-2.5-Flash | 91.9% | 55.7% |

This original experiment is by an evaluation vendor rather than a model provider. The cleaned task removes ambiguous categories; it does not measure full Ideas, source availability, canonical IDs or forecast windows. Its model versions must not be assigned to later releases.

### Chinese financial evidence [R12]

BizFinBench v1's same-study financial NER column reports DeepSeek-R1 71.46, GPT-4o 65.37, Qwen3-32B 49.19 and Qwen3-14B 50.70. This supports testing language and domain directly. It does not predict V4.1-Flash or Qwen3.8 performance. V2 changes the task mix; it is not an update of this exact NER column. English coverage and Chinese-company coverage are also different requirements: a report about a Chinese company can be written in English.

## Current candidates and costs, separate from published scores

Documentation checked 14 October 2026. These are candidates, not accepted model selections. Current availability and documented features do not imply published extraction superiority; an account's access is not established by a public page.

| Role | Documented candidate | Standard uncached input/output USD per million tokens | Selection caveat |
|---|---|---:|---|
| Pinned hosted reference | gpt-5.4-2026-03-05 [R13] | 2.50 / 15.00 | Relevant proxy evidence uses a family label; repeat our own tests on this snapshot. |
| Current hosted challenger | gpt-6.1-sol [R14] | 2.00 / 10.00 | No matched extraction score found; a dated model pin was not established. Supports reasoning effort, not a no-reasoning setting. |
| Budget hosted challenger | qwen3.8-flash, Singapore International [R15] | 0.15 / 0.47 | Current strict-schema support documented; no dated pin or matched extraction score established. |
| Budget hosted challenger | deepseek-flash, documented V4.1-Flash [R16] | Off-peak 0.15 / 0.60; peak 0.30 / 1.20 | Moving alias. JSON-object mode differs from Beta strict tool schemas. |
| Local specialist | fastino/gliner2.5-multi-v1 [R17] | Operating cost unmeasured | 287M encoder, Apache-2.0; span/record extraction is not general LLM judging. |
| Local record challenger | numind/NuExtract3 [R03] | Operating cost unmeasured | 4B, Apache-2.0; model-template and evidence behavior need direct evaluation. |
| Larger local generator | Qwen/Qwen3.5-35B-A3B [R18] | Operating cost unmeasured | 35B total LM parameters, 3B active; Apache-2.0; actual machine fit unknown. |

Illustration only: 1,000 extractions using 8 million input and 1 million billed output tokens cost $35 for GPT-5.4, $26 for GPT-6.1 Sol, $1.67 for Qwen3.8 Flash Singapore, or $1.80/$3.60 for DeepSeek off-peak/peak. This is arithmetic, not an observed workload. Retrieval, third-filter calls, retries, reasoning tokens beyond the assumed output, taxes, source acquisition and local operation are additional or different costs.

For a given pricing snapshot, sum billed input, cached input, output and extra fees across every attempt. Compare cost per usable supported record, rather than price per token alone. A cheaper call can be more expensive if many records need reprocessing.

Local feasibility cannot be selected without the computer's memory and supported runtime. The raw 35B LM weights alone are approximately 17.5 GB decimal at four bits, before other model components and runtime/context memory. Active parameter count is not total resident weight storage. Quantized accuracy needs its own test; a full-precision benchmark is not an Int4 result.

## What research says about the third filter

The question is whether two expressions are equivalent under Axthena's Idea definition. Being about the same company, same event or same topic is insufficient. An embedding similarity score merely helps find candidates.

| Research | Original result and setting | What we can use |
|---|---|---|
| HLGD, NAACL 2021 [R19] | Same-event headline test F1 .796; publication time raises it to .828; human .900 | Add time/context to comparisons. Its same-event grouping is broader than our exact timed opinions. |
| ClaimDiff, ACL Findings 2023 [R20] | Best strengthening/weakening test F1 77.86/49.07; human 86.27/68.29 | Test material qualifiers and information omitted by a common summary. Relations are directed, not equivalence. |
| FinNLI, NAACL Findings 2025 [R21] | Financial inference: RoBERTa-Large 74.57 ± .5 macro-F1; best tested Llama3.1-70B 78.62 | Financial language needs its own inference checks. Inferred economic effects must not become source-stated price forecasts. |
| Claim2Vec, April 2026 preprint [R22] | ClaimMatch clustering ARI .762 versus BGE-M3 .644; MultiClaim-Test .626 versus .610 | Promising second-filter embedding challenger. Inherited LLM labels/transitive clusters limit its use as gold. |
| CohTP, ACL 2026 [R23] | ECB+ gold-mention CoNLL F1 88.9; without temporal components 86.6; predicted mentions 62.8 | Temporal compatibility and upstream extraction matter. Its overlapping-time event policy does not replace our distinct-window rule. |

ARI measures cluster agreement corrected for chance; it is not a percentage of correct pairwise stock forecasts. CoNLL F1 averages event-coreference measures. These scores cannot be pooled with entity F1 or exact JSON accuracy.

HLGD also reports that swapping a pair's order changes 6.3% ± .5 of predictions. Among triplets with at least two predicted positive links, only 26.4% ± 1.4 have the third positive. One positive link can therefore bridge distinct groups. Do not assume that pairwise model similarity behaves like mathematical equality.

Proposed comparison input: originals plus the extracted identities, subject/object roles, target, direction when present, applicable time window and material conditions/quantities. Preserve missing values and the source's qualifiers. No dedicated V1 reason record is needed to inspect the original language.

Test both pair orders and candidate-list permutations. A matches B and B matches C does not authorize joining A and C without checking the Idea contract. Cluster anchoring, member checks or selective verification are alternative policies to evaluate; none is selected here.

Organisation matching has different equality rules. OpenSanctions Pairs [R24] supplies useful multilingual identity research, but its heavily positive blocked-pair corpus, differing model subsets and default positive-when-no-conflict assumption preclude a fair general ranking or policy transfer. Axthena retains automatic separate creation when no organisation is selected. The handling of an uncertain Idea-equivalence decision still needs specification.

## Promising directions, ranked by usefulness to this stage

1. **Better task definitions and counterexamples.** Use a reviewed annotation guide and examples of correct/incorrect extraction. The first experiment should determine whether models honor Axthena's exact distinctions. GoLLIE provides evidence for guideline attention; it does not require us to fine-tune V1.
2. **Extract and verify supporting evidence.** Compare full-record accuracy with evidence fidelity/support. LangExtract and evidence-supervised relation extraction provide concrete mechanisms; the July ExtractBench result shows why evidence scoring deserves its own column.
3. **Small-model assistance after the reference test.** Let a specialist propose names/dates/relations and compare its end-to-end errors/cost with the generative baseline. Never use high confidence on a span as proof of canonical identity or whole-Idea equality.
4. **Selective extra verification.** Spend extra calls on the errors that actually threaten false merges. Trust or Escalate [R25] studies calibration using reviewed labels, but its guarantee concerns human-agreement sampling assumptions; it does not transfer automatically to financial data. This is a V2 research hypothesis after the single-judge baseline.
5. **Claim-aware and time-aware representation.** Claim2Vec/CohTP justify experiments with claim-specific similarity and temporal constraints. Keep strict actual-window separation and measure candidate recall. Better retrieval still cannot repair an incorrect extracted period.
6. **Constrained output and serving optimization.** JSONSchemaBench [R26] compares coverage, efficiency and output quality across 9,558 schemas. XGrammar [R27] reports serving gains under specific hardware/batch configurations; they are not Axthena throughput measurements. Supported schema constraints can improve shape reliability, while content remains separately evaluated.

Guideline tuning, distillation, learning thresholds, automatic adaptive routing and predictive training remain later research, consistent with the existing V2 boundaries. We should not build a general agent framework to run this experiment.

## Proposed evaluation before instructions and implementation

First freeze a small reviewed evaluation definition. Then write the instructions. Use a development packet to refine examples and a separate, untouched packet for comparison. Keep copies of one original report/event together during splitting so syndicated wording does not leak between development and test.

A manageable starting proposal is 30 full-text technology-stock reports and 60 meaning-comparison cases. Counts, sources, language mix and budget require selection. Reuse the existing 24 fictional review cases after updating their superseded temporal policy; label them synthetic diagnostics, not independent benchmark truth. Include real organisation aliases, subsidiary contexts, suppliers, competition and the manual two-stock view. Future Chinese-language tests should use reviewed labels, not machine translations as unquestioned gold.

Compare at most three generative configurations first: the pinned reference plus Qwen3.8 Flash and DeepSeek Flash. A current GPT-6.1 challenger can replace or separately challenge the reference if Badr prefers; its result is unmeasured. Treat one local specialist/record route as optional until local feasibility is known. The same model may have different settings for extraction and comparison; these configurations are recorded separately.

| Measure | What it checks |
|---|---|
| Grounded field precision and recall | Correct organisation, activity, event, source category and stock-target fields; unsupported additions count against precision. |
| Evidence location and support | Exact evidence-version/quote match, unambiguous offsets, and whether the passage actually supports the derived value. |
| Main-Idea selection | Whether the selected one/two Ideas capture the most articulated supported content; evaluated separately from entity tagging. |
| Forecast correctness | Price target, UP/DOWN, no-forecast/missing-period states, actual window, publication reference and retained inference/default origin. |
| Candidate recall by stage | How many reviewed true matches survive filters 1 and 2; audit omitted pairs separately. |
| Merge precision and recall | Correct accepted same-Idea links, damaging false merges and missed sharing; report ambiguous/unresolved coverage. |
| Query correctness | Original passage recovery, organisation/activity scope, per-stock pair judgments, dated source eligibility and visible partial coverage. |
| Reliability and cost | Invalid/refused/truncated outputs, attempts, tokens, elapsed latency, local resources and total cost per accepted result. |

Source-grounding checks should use a declared offset unit, including Chinese/emoji tests; do not rely on the LLM to count UTF-8 bytes. Repeated excerpts require disambiguation, not a silent first-match rule. A saved quote that contradicts its assigned direction fails support even if the quote is a valid substring.

A small sample cannot prove near-zero false merges. For n representative independent accepted merges with zero errors, a binomial model gives a one-sided 95% upper error bound p = 1 - 0.05^(1/n), by solving (1-p)^n = 0.05. At n=60 this is about 4.9%. Clustered articles reduce the effective independence. Use exact binomial intervals where appropriate, report the denominator, and reserve stronger performance claims for a larger representative test.

No fixed accuracy, latency or cost acceptance threshold is selected. Badr should first inspect the returned data and query cases, then decide which errors block V1. The eventual output should distinguish model observations, expected labels and adjudicated corrections.

## Unresolved choices to bring back to Badr

- Exact model/configurations and accessible accounts; local hardware only if a local run is included.
- Final record fields and guideline meanings; evidence offset unit and ambiguous/missing-date handling.
- Source packet, development/test split and acceptable experiment budget.
- Uncertain Idea-equivalence policy, cluster membership consistency and false-merge tolerance.
- Minimal communication-contract details and which provider capabilities the first test requires.

The model provider, decoder/server, database, final prompt text and execution plan remain unselected. The saved boundary is a proposal ready for review, not an implementation approval.

## Primary reference index

R01 [GLiNER2.5 author release](https://fastino.ai/blog/gliner2-5-span-free-information-extraction) · R02 [GLiREL paper](https://aclanthology.org/2025.naacl-long.418/) · R03 [NuExtract3 official card](https://huggingface.co/numind/NuExtract3) · R04 [GoLLIE](https://arxiv.org/html/2310.03668v4) · R05 [DREEAM](https://aclanthology.org/2023.eacl-main.145/) · R06 [Doc2EDAG](https://arxiv.org/abs/1904.07535).

R07 [Contextual AI ExtractBench](https://arxiv.org/html/2602.12247v1) · R08 [LlamaIndex ExtractBench](https://arxiv.org/html/2607.29677v1) · R09 [LangExtract official repository](https://github.com/google/langextract) · R10 [Structured Output Benchmark](https://arxiv.org/html/2604.25359v1) · R11 [Cleanlab original experiment](https://cleanlab.ai/blog/structured-output-benchmark/) · R12 [BizFinBench v1](https://arxiv.org/html/2505.19457v1).

R13 [GPT-5.4 official model page](https://developers.openai.com/api/docs/models/gpt-5.4) · R14 [GPT-6.1 Sol official model page](https://developers.openai.com/api/docs/models/gpt-6.1-sol) · R15 [Qwen3.8 Flash official page](https://www.alibabacloud.com/help/en/model-studio/qwen3-8-flash) and [Qwen schema support](https://www.alibabacloud.com/help/en/model-studio/qwen-structured-output) · R16 [DeepSeek pricing](https://api-docs.deepseek.com/quick_start/pricing/) and [strict tool schemas](https://api-docs.deepseek.com/guides/tool_calls/) · R17 [GLiNER2.5 Multi official card](https://huggingface.co/fastino/gliner2.5-multi-v1) · R18 [Qwen3.5-35B-A3B official card](https://huggingface.co/Qwen/Qwen3.5-35B-A3B).

R19 [HLGD](https://aclanthology.org/2021.naacl-main.255/) · R20 [ClaimDiff](https://aclanthology.org/2023.findings-acl.289/) · R21 [FinNLI](https://aclanthology.org/2025.findings-naacl.257/) · R22 [Claim2Vec](https://arxiv.org/abs/2604.09812) · R23 [CohTP](https://aclanthology.org/2026.acl-long.1345/) · R24 [OpenSanctions Pairs](https://arxiv.org/html/2603.11051v1) · R25 [Trust or Escalate](https://arxiv.org/abs/2407.18370).

R26 [JSONSchemaBench v3](https://arxiv.org/html/2501.10868v3) · R27 [XGrammar](https://arxiv.org/abs/2411.15100). Provider documents and protocol limitations are indexed in the separate boundary proposal and JSON index.
