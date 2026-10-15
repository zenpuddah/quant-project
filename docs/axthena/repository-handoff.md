# Axthena repository handoff

Date: 2026-10-15. Branch-routing supplement to the compiled handoff. It changes the repository destination, not the accepted logical model or outstanding architecture choices.

## ENG-046 — Separate branch for the second implementation agent

**Decision:** Put the consolidated Axthena context, design, behaviours, tests and implementation plan on a separate branch of the existing repository so the owner can launch a second implementation agent. Use `implementation/axthena-v1` in `zenpuddah/quant-project`.

**Reason:** Give the second session a coherent starting point while separating Axthena from other workstreams.

**Invariant:** Axthena remains a separate project. Preserve accepted AX/ENG semantics and the owner's architecture authority. Branch publication does not accept unselected backend/library/model/default choices, merge Lexongine, change quant code or claim runtime completion. Repository destination is now resolved; do not ask it again.

**Trade-offs:** A shared repository requires explicit routing and isolated component/build paths. This branch inherits the selected main baseline; other branches may advance independently and are referenced rather than merged.

**Implementation scope:** Documentation-only publication: technical handoff, original experiments, branch entry point, second-agent prompt and narrow repository routing. Record a separate Axthena component root at T0; plan-relative files are not root quant files. No production code is added here.

**Required tests:** Branch derives from the inspected main commit; changed paths are documentation/agent guidance only; active links resolve; task/test/decision IDs survive; adapted historical files are declared and current hashes match; original experimental ZIP bytes remain unchanged; remote branch has the intended commit and entry documents. No runtime application tests are claimed for this documentation change.

## Baseline and scope

- Base main commit: `95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5`.
- Main tree: `7a42e871f81e8508026f717622d63c5098461c2f`.
- An existing dirty checkout was inspected read-only; this handoff was prepared in a separate worktree. Its uncommitted work was not incorporated.
- Other observed branches include `implementation/lexongine-v1` and `implementation/data-integrity-2026-10-03`; neither is a dependency of this publication.
- Source packet: `Axthena-implementation-handoff-2026-10-15`, with 36 acceptance families and T0–T12. Latest graph-review/display decisions remain ENG-044/045.

## Next step

The second agent starts at [START_HERE.md](START_HERE.md) and slice 1 of `implementation/v1-slices.md`: the accepted 20-article source trial. It tests and presents each slice, then waits for explicit owner confirmation before the next. The older S0/T0–T12 order is supporting reference. D1–D6 are staged decision groups, not a demand to resolve every performance number before useful work. Preserve accepted behaviours; escalate material unresolved choices instead of converting advice into policy.

Source provider/date bounds, confirmation/time/hold details, backend/libraries, embeddings, grouping boundary, target-machine limits and applicable specification approval retain their handoff status. There is no new approval to spend money or access credentials.


## ENG-047 — Automated LLM communication patterned after OpenCode

**Decision:** Automate model communication using the provider/authentication/request approach of OpenCode. The owner explicitly rejects the proposed manual request/answer exchange.

**Reason:** Manual per-article exchange creates unnecessary work and defeats the intended automated processing flow.

**Invariant:** Retain the replaceable LLM boundary and exact request/response provenance. Files are generated automatically for history/replay. Do not turn the existing ChatGPT access choice into an invented general API entitlement, copy secrets into evidence, or treat model output as validated domain truth. Other architecture recommendations are not accepted by this correction.

**Trade-offs:** Automated access adds runtime/provider/version integration and failure handling. Reusing a pinned headless OpenCode runtime is the recommended first adapter; the accepted direction does not require rebuilding its entire coding-agent system or accept a particular CLI/HTTP binding.

**Implementation scope:** Replace the manual-first proposal in active handoff documents. The next implementation session verifies configured provider access and one automatic request, then runs the bounded sample. Authentication stays with the supported client. Keep C++ domain validation/storage independent.

**Required tests:** Automated submission and capture without per-article human exchange; exact task/attempt correlation; completion and malformed/refused/truncated/timed-out outcomes; raw events distinguished from extraction JSON; fresh-session isolation; duplicate application idempotence; replay without a new model request; credentials absent from retained artifacts. These runtime tests remain pending.

## ENG-048 — First OpenCode source task is a 20-article trial

**Decision:** Make the news-source trial the first OpenCode task. Use a small sample of 20 articles for testing, with no large collection in this initial step.

**Reason:** Validate actual source content and the processing path cheaply before broader work.

**Invariant:** Target 20 unique retained articles and cap the trial at 20. Preserve requested/actual counts, duplicates, missing bodies and failures. Do not fabricate content or expand into twelve-month acquisition automatically. The earlier longer historical target remains later work; this is the immediate task boundary.

**Trade-offs:** A small sample permits quick inspection but does not prove source coverage, statistical accuracy, volume feasibility or historical/predictive usefulness.

**Implementation scope:** S0 in the updated plan: short source window, relevant Nvidia/Microsoft articles, retained evidence, automated model smoke request then bounded processing, and inspectable outputs for review. Provider remains conditional on actual usable access; no new purchase is authorized.

**Required tests:** Retained unique article count never exceeds 20; actual count/gaps are reported; both target coverage and source/body fidelity are visible; automation retains exact inputs/outputs; failures remain distinguishable; no full-year acquisition is triggered. Review the bounded results before expansion.


## ENG-049 — One launch prompt and tested, owner-confirmed vertical slices

**Decision:** Prepare a comprehensive first-V1 agent prompt and implementation plan built from useful slices. Each slice receives clear testing and is confirmed by Badr before the agent begins the next one. Explanations should fit his concrete-example, explicit-state, invariant and transition approach.

**Reason:** Carry the accumulated direction into implementation efficiently while keeping progress inspectable, learning useful and mistakes confined to a reviewable capability.

**Invariant:** One prompt does not mean unattended execution through all checkpoints. Automated model/identity behaviours remain automatic; the human gate is on the slice result. Passing tests, an assistant review, silence or elapsed time is not owner confirmation. Preserve accepted AX/ENG scope and distinguish proposed technologies/defaults from owner choices.

**Trade-offs:** Checkpoints add deliberate pauses while reducing accumulated semantic/design mistakes. The full implementation direction travels in one prompt, with progress/review artifacts allowing reliable continuation between turns.

**Implementation scope:** Active plan `implementation/v1-slices.md`, owner guide, progress ledger and updated launch/routing. Source trial remains capped at 20; no full-year expansion is silently included. This session prepares documentation, not production code. Earlier S0/T0–T12 work packages remain supporting detail rather than a second execution plan.

**Required tests:** Every slice specifies useful input/output, named failure contrasts, exact future verification commands where applicable, an owner demo and explicit stop/approval evidence. Deferred mechanisms and year-scale coverage remain visible. Status cannot become APPROVED without actual owner confirmation; no per-record human identity gate is introduced.
