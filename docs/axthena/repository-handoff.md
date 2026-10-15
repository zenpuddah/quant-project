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

The second agent starts at [START_HERE.md](START_HERE.md) and T0, then executes the approved contract in bounded slices. D1–D6 are staged decision groups, not a demand to resolve every performance number before useful work. Preserve accepted behaviours; escalate material unresolved choices instead of converting advice into policy.

Source provider/date bounds, confirmation/time/hold details, backend/libraries, embeddings, grouping boundary, target-machine limits and applicable specification approval retain their handoff status. There is no new approval to spend money or access credentials.
