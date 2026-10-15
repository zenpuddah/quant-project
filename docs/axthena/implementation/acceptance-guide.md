# Axthena — owner inspection guide

Use this with `v1-slices.md`. The implementation agent supplies the actual working commands, paths, IDs and expected visible results for the active slice. Examples here define the review questions; they are not commands already executed or an existing application.

## What each checkpoint proves

| Slice | Question you should be able to answer | Minimum inspection |
|---|---|---|
| 1 Source material | Did we actually collect useful source text? | Inventory of at most 20 unique articles; open three exact retained bodies, dates, links and any missing-text case |
| 2 Automated interpretation | Does the model run automatically and preserve what the source means? | One automatic call record; source/summary/passages side by side; one qualified forecast and one no-direction/partial contrast |
| 3 Native storage/read | Can I retrieve the same source-grounded result after restart? | Run a stored-data query, open its passage, restart/repeat and reapply the same input without inflating counts |
| 4 Identity | Is the identity decision based on actual retrieved candidates? | Name list, vector list, union, decision, created/reused ID and a later alias reusing a newly created organisation |
| 5 Connected world | Are relationships and confirmations saying the right thing? | Company/subsidiary/domain plus event/dependency/evidence; use a labelled fixture if a dependency is absent from real material, preserving that coverage gap; distinguish announcement/execution and inspect a held disagreement |
| 6 Shared meaning | Can we reduce redundant meaning without losing sources or important differences? | One shared Idea with two Expressions; one near-match staying separate; publication count unchanged by replay/multiple passages |
| 7 Useful investigation/recovery | Do views, time and recovery preserve the story and its limits? | Stock/universe/pair queries, historical contrast, coverage/hold explanation, clean restore and repeated source/Idea answer |

You approve a slice's delivered behaviour. This is not manual approval of each LLM request or organisation creation; accepted automatic behaviours stay automatic.

## The seven final query scenarios

The proposed native entry is `axthena query --request <query-file>`. Once the CLI contract is selected, the agent must generate working query files containing actual selected-run/view IDs and dates. Do not give the owner unresolved placeholders at a checkpoint.

| Query file to supply under the component's `examples/queries/` | Investigator request | Expected meaning |
|---|---|---|
| `01-stock-evidence.json` | What information concerns Nvidia in this interval? | Events, claims, opinions and supported judgments with actual subjects, periods, conditions and passages |
| `02-company-neighbourhood.json` | Show the issuer, its subsidiary and one supported dependency | Corporate association differs from supply; every substantive relationship has evidence/time; unknown impact stays unknown |
| `03-shared-idea.json` | Who expressed this same Idea? | Distinct Reports/Expressions, available person/account attribution and agreement, with each original passage |
| `04-pair-evidence.json` | What concerns Nvidia, Microsoft or both? | Shared information appears once by its defined unit; stock judgments remain separate; no invented pair trade |
| `05-claim-history.json` | What was confirmed, disputed and later reviewed? | Exact claim scope, confirming evidence, hold and dated review; no later resolution silently backdated |
| `06-evidence-trace.json` | Show the source and processing history behind this answer | Original bytes/text, exact span/version, task/answer and run/configuration lineage |
| `07-universe-opinions-and-coverage.json` | Show opinions in my configured universe/view and explain omissions | Prepared direct subject lookup, declared sources, distinct count units, explicit incomplete/empty/failed/held/truncated meanings |

At slice 7, provide 1–3 compact commands exercising these files or a script that runs the catalogue. Expected results must come from the frozen reference/actual retained data. A source lacking a forecast should return no UP/DOWN judgment; do not fabricate a green/red node just to complete the demonstration.

## Corrections and approval

Useful corrections name the evidence and the violated meaning, for example: “This idea concerns the subsidiary, not the parent,” or “These windows differ, so keep the Ideas separate.” The agent records the correction, adds the smallest meaningful regression and resubmits the same slice.

When satisfied, a message such as “Approve slice 3” confirms that result. The agent records your actual message and proceeds to the next slice, subject to any specific architecture choice that genuinely blocks it. A question or a request for another example is feedback, not approval.

Tests are the agent's responsibility. Owner review complements mechanical checks and catches semantic/design mistakes; you should not need to manually verify all 20 articles or read every internal log at every checkpoint.
