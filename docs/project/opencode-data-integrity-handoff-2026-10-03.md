# OpenCode handoff — ingestion/storage integrity, 2026-10-03

> Historical task/snapshot. Preserve the dated commands and evidence below. They do not govern new Lexongine work or reopen completed ingestion/provider/storage tasks. Read [current context](context.md) and [Lexongine handoff](../lexongine/README.md) for current routing.


## Status and objective

The owner accepted the reviewed ingestion/storage design contracts in `docs/architecture/phase1-data-integrity-session-2026-10-03.md`, including its three final closure contracts. Implement those contracts when explicitly asked to implement this handoff. First record a bounded implementation specification and focused plan, then work in reviewable slices with regression tests.

The review baseline is `590fd349e683b0f5c0524f7248f2eb6b3e89a150`. Use the current checkout containing this handoff; do not reset to the baseline. This documentation commit implements no new runtime guarantees. The old `docs/project/opencode-handoff.md` is the historical skeleton handoff, not the current task.

## Required reading

Read in this order:

1. `AGENTS.md` and `docs/project/context.md`.
2. `docs/architecture/phase1-data-integrity-session-2026-10-03.md` and this handoff.
3. `docs/project/design-decision-review-2026-10-01.md` as failure/evidence baseline, not blanket authority to apply its proposals.
4. `docs/architecture/phase1-storage-replay.md` and `docs/project/storage-testing-guide.md`.
5. `docs/architecture/phase1-historical-ingestion.md`, `docs/architecture/phase1-ingestion-iteration-close.md`, `docs/architecture/phase1-databento-first-integration.md`, and `docs/architecture/phase1-query-planning-and-usability.md`.
6. Relevant `docs/project/engineering-book.md` entries, especially the 2026-10-01 audit and 2026-10-03 acceptance.

Inspect the actual implementation/tests before selecting changes. Start with `src/quant/data/validation.hpp`, `src/quant/ingestion/{databento_provider,synchronous_ingestor,result,quality}.hpp`, `src/quant/storage/{dataset,arrow_interchange,parquet_backend,backend}.hpp`, `integration/databento/`, `integration/storage/`, and `tests/`. Check the real filenames rather than assuming an interface exists.

## Specification before code

Write a bounded specification in `docs/architecture/` and an implementation plan in `docs/project/`. Describe responsibilities, data flow, invariants, changes to existing public boundaries, and the smallest mechanisms satisfying the accepted contracts. Make these details explicit:

- StreamId representation, immutable tuple binding, persisted reference/mapping evidence, and checks before original identity is lost. Use row/Arrow sidecar columns without changing MboRecord.
- Each stage's first concrete file contract, exact parent/version links, failure references, and the evidence required for publication. Retain the acquired provider representation; a lossy summary of it is not the raw stage.
- Supported encoding identifiers, actual columns/interpretation, and explicit treatment of baseline files. The new StreamId/ordinal encoding must not silently reuse a label whose contract changed.
- Validation ownership and consumer eligibility. Explain how alternate codec/write/read entry points cannot bypass required checks or detach validation evidence from its data. Do not duplicate expensive validation everywhere without a reason.
- Shared ordinal scope, assignment before filtering/splitting, original row associations, cross-batch checking state, provider grouping/snapshot rules, and replay preservation across partitions. Do not invent a total order across independent acquisitions.
- Concrete immutable artifact/version identities, retry versus new-acquisition identities, non-replacing publication, completion visibility, and current-selection updates. The recap's retry policy and sidecar manifest are candidates, not selected mechanisms.
- Initial-state and dependency requirements for order-sensitive replay; treatment of explicit partial ranges and retained good segments.
- Databento condition request dates and day-local evidence clipping, with examples at midnight and across multiple days. The condition endpoint uses inclusive UTC dates; canonical ranges remain half-open.

Choose routine implementation mechanisms within the accepted boundaries. If a choice changes an accepted contract, requires a new dependency, or exposes a significant unresolved architecture/provider issue, ask the owner one focused question. Do not reopen settled decisions or expand deferred scope just to complete a slice. An unresolved decision should not prevent independent work whose contract is already clear.

## Required behavior and regression evidence

| Boundary | Required behavior | Meaningful regressions |
|---|---|---|
| Identity/catalog | Every stored canonical row has a StreamId matching its original tuple and file scope; required exact references remain available and immutable | Mixed streams, wrong scope/ID association, missing references, reassignment, same instrument on different venue/source, moved artifact with retained references |
| Canonical validation/range | Reuse financial validators and enforce declared/query constraints after intended selection | Zero trade/execution quantity, invalid MBO shape/control, half-open endpoints, dual-time queries, legitimate overfetch, mislabeled stored range |
| Staging/recovery | Retain raw evidence and stable per-row failure reasons; unresolved affected data remains unavailable; explicit recovery revalidates | Failure report survives, valid independent segments retained, invalid mutation affects dependent state, no silent repair/drop, incomplete requested range is not claimed complete |
| Encoding/readers | Unknown versions fail before delivery; known versions validate actual columns and meaning | Unsupported label, known label with incorrect schema, deliberate new encoding, explicit legacy policy |
| Source order/ordinal | Preserve returned succession and original row associations; use source-specific checks and a separate shared acquisition ordinal | Equal times, repeated sequence T/F/C and C/A groups, non-printable execution, snapshots, incomplete groups, batch boundaries, filtering gaps, cross-kind partitions, reordered/duplicated/misassociated ordinals, distinct scopes |
| Published versions | New versions coexist with old; existing destinations are never replaced; incomplete data/evidence cannot become available | Repeated destination, corrected acquisition, interrupted data/metadata/reference writes, incomplete completion state, retry/new acquisition, old input still reads unchanged |
| Evidence/stages | Published consumer data resolves exact canonical/raw/reference inputs and transformation/validation evidence | Reprocess retained provider input without network, lineage traversal, preserved raw evidence after conversion failure, unresolved required evidence blocks availability |
| Eligibility/initial state | Factual quality does not override unresolved required consumer checks | Degraded/SequenceGap bypass attempt, missing book initialization, incomplete required group, timestamp-quality flag versus book corruption, explicit usable partial range |
| Daily conditions | Conditions affect only the intersecting UTC day/range | Intraday request, midnight-exclusive end, multi-day mixed conditions, extra response day outside the requested coverage |

Use the primary Databento/Nasdaq sources linked in the accepted recap for provider semantics. Repeated provider sequence values and gaps after symbol filtering are not, alone, corrupt order. Snapshots have separate ordering semantics; ts_event need not be monotonic. F_BAD_TS_RECV, F_MAYBE_BAD_BOOK, and F_LAST describe different facts. Validation must distinguish checked evidence from provider assumptions and must not claim independent exchange completeness from normalized DBN.

The currently acquired Databento representation is normalized provider data, not original exchange network packets. Do not add PCAP acquisition or a full transport recovery framework. Book-replay eligibility needs sufficient initial state even when individual rows pass validation.

## Implementation constraints

- Preserve canonical financial meaning, C++20, exact values, existing point-in-time mappings, and the 64-byte/64-byte-aligned MboRecord. Keep provider-specific types behind adapters/evidence.
- Preserve the MarketDataReader replay boundary; replay consumers must not call Parquet APIs.
- Keep framework-free tests and existing isolated Databento/storage CMake targets. CLion remains the intended IDE. No root build migration or new external dependency without owner acceptance.
- Keep query selection separate from save/publication policy. Stage persistence is not a general cache backend.
- Keep XML reader descriptors, automated row repair/retry orchestration, generalized catalog/cache, deduplication, automatic overlapping-acquisition merge, revision-management frameworks, binary replay, live trading, and strategies/accounting/Python bindings deferred.
- Use synthetic/retained deterministic fixtures by default. Do not make paid requests, access new credentials, or download market data as part of ordinary verification.

## Verification and completion report

For each changed guarantee, add a regression demonstrating the original failure, then implement and verify the fix. Include negative and interrupted-publication cases, not just round trips. Keep order/identity assertions tied to original event associations, rather than checking only sorted ordinal numbers or matching metadata labels.

Run the relevant standalone C++20 tests with strict warnings, deterministic Databento tests, and storage/replay tests. Use sanitizer runs where supported and relevant. Report exact commands and outcomes. If native Arrow/Parquet packages are unavailable, state that limitation separately; a PyArrow library probe or temporary package shim does not prove native find_package support. No environment-wide dependency/build redesign is authorized.

Retain a deterministic end-to-end demonstration: acquired provider fixture -> staged evidence -> validated canonical stage -> published consumer representation -> read/replay, with exact version/reference/evidence links. Include a failed candidate that stays staged and a corrected version that leaves the prior input intact. Update the manual round-trip/inspection tools and testing guide to the actual new contracts.

Update context, architecture, and engineering-book status as work lands. Report the changes, regression evidence, known limitations, and deferred work. Claim closure only for invariants actually implemented and verified. Produce reviewable commits on an implementation branch; leave publishing/merging that implementation to the owner's instructions.
