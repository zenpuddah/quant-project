# Project Context

## Current project routing — 2026-10-14

**Publication update — 2026-10-15:** The owner authorized pushing the consolidated Lexongine context/specifications/plan/examples/start prompt on `implementation/lexongine-v1`, based on f75. No engine implementation or main-branch merge is part of this documentation publication. OpenCode should use the published branch and record its actual checkout before coding.

Qaedalus (formerly Quadeplus) owns market data, research and financial backtesting; Lexongine (formerly Legongine) owns reusable computation/composition/execution; Axthena (formerly Athena) owns news/events/actors/information evidence. See [documentation index](../README.md).

Lexongine's bounded v1 behavior/technical decisions are accepted; its current source of authority is [Lexongine context](lexongine-context.md) and [consolidated handoff](../lexongine/README.md). No Lexongine implementation was verified in the inspected remote baseline f75cd3c179f3b070f9a85c054ec3704b89f4cb69. OpenCode records actual local checkout/build evidence in [progress](../lexongine/implementation/progress.md), preserving newer local/unpushed context.

Earlier XML/general-cache deferrals below concern their ingestion/storage iteration. Lexongine's accepted strict XML composition frontend, trusted plugins and bounded validated exact-scope numerical result reuse are a project-specific exception; ingestion NoopCache/general reader XML remain deferred. Qaedalus integrity/storage invariants remain mandatory. The included source/host seams do not choose a financial fill/cost/accounting model or imply persisted-Bar support.

Older dated instructions retain their historical scope. Current accepted specifications and recorded implementation evidence govern later work; no old stop gate reopens a completed provider/storage slice or this accepted engine milestone.


## Project objective

- **Accepted:** Build a personal C++20/Python quant-development platform that teaches professional engineering, provides Quant Developer portfolio/interview evidence, and grows into a usable research and backtesting platform.
- **Accepted:** Phase 1 is a small but complete research/backtesting system spanning data, research, features, strategies, orders, risk, execution/fills, portfolio/accounting, PnL, validation, and reproducibility.
- **Accepted:** Phase 2 may evolve toward a more realistic exchange/execution environment with microstructure, order-book behavior, latency, matching, partial fills, and systems topics, but must not distort Phase 1 prematurely.

## Engineering rules

- **Accepted:** Architecture/design precede production implementation.
- **Accepted:** Start with responsibilities, boundaries, data flow, and invariants; keep domain logic separate from infrastructure.
- **Accepted:** Prefer correctness, clarity, testability, reproducibility, and simple/open solutions before performance complexity.
- **Accepted:** Do not invent missing requirements or silently resolve significant trade-offs.
- **Accepted:** The repository owner is engineering manager for architecture/product/major trade-offs; implementation agents execute accepted design and stop with one focused question when a boundary becomes ambiguous.
- **Accepted:** Accepted architecture lives in `docs/architecture/`; reasoning/source checks live in `docs/project/engineering-book.md`.
- **Accepted:** Repository docs stay technical and free of unrelated study/persona material.
- **Accepted:** CLion is the intended IDE. Do not silently turn a local dependency need into a repo-wide build-system redesign.

## Canonical data architecture

- **Accepted:** Provider-specific formats/terminology stop at adapters; the core uses provider-independent canonical semantics.
- **Accepted:** Canonical market concepts include L3/MBO, Trades, Quotes/L1, L2/price-level views, Bars, and now provider-neutral order-execution evidence where the source exposes it.
- **Accepted:** High-information observations can be reduced/derived into lower-granularity views where source semantics allow it; reverse reconstruction is not assumed.
- **Accepted:** Stable internal `InstrumentId` is canonical identity. Symbols/provider IDs remain time-aware mapping/reference evidence.
- **Accepted:** The same canonical `InstrumentId` may span venue observations; `VenueId` distinguishes venue and `SourceId` distinguishes source/feed.
- **Accepted:** Source ordering evidence is preserved. Timestamp-only sorting is insufficient for order-sensitive L3 reconstruction.
- **Accepted:** Observed data and derived data remain conceptually distinct; derived data keeps lineage to original observations.
- **Accepted:** `MarketState` and `DataState` are separate concepts.
- **Accepted:** Corrections/revisions do not silently overwrite observed history; FGIT remains the revisioned-history mental model.
- **Accepted:** `Price`, `Quantity`, and `Money` use exact fixed-scale integer semantics.
- **Accepted:** Snapshots are recovery checkpoints, not canonical historical truth.

See `docs/architecture/phase1-data-model.md` and `docs/project/engineering-book.md`.

## Implemented repository state

- **Implemented:** Executable C++20 canonical data model under `src/quant/data/` with framework-free tests.
- **Implemented:** Binary point-in-time `ReferenceHistory` lookup, compact `uint32_t` venue/source IDs with separate reference tables, and fixed-scale `Price`/`Quantity`/`Money`.
- **Implemented:** `MboRecord` is a finalized 64-byte, 64-byte-aligned fixed-stride physical record. Do not enlarge it for provider-specific metadata without explicit architecture review.
- **Implemented:** `MboBuffer` is single stream-scope (`InstrumentId`, `VenueId`, `SourceId`) and a logical ingestion result may hold multiple such buffers.
- **Implemented:** Dependency-free synchronous ingestion skeleton under `src/quant/ingestion/` with canonical query/range resolution, `NoopCache`, provider/mapping fakes, quality reduction, structured recovery context/plan seam, metadata/provenance, and L3 orchestration tests.
- **Implemented:** `DataStateSegment` preserves scoped range-local state with sorted point/range lookup; one worst aggregate state is only a derived summary.
- **Implemented:** Evidence-free intervals remain `Unknown` and unresolved; event count alone is not quality/coverage evidence.
- **Implemented:** Source artifact provenance is plural and range-aware.
- **Implemented:** Mapping scope can include optional `SourceId`; same instrument can legitimately produce overlapping venue/source streams.
- **Verified:** Data-model and ingestion tests were reported passing with C++20 warnings-as-errors plus ASan/UBSan in the latest maintenance pass.
- **Implemented:** Official Databento `XNAS.ITCH` historical adapter/interpreter is isolated behind `ProviderPort`; deterministic translation tests and an opt-in standalone CMake smoke target are present.
- **Implemented:** Canonical observations preserve provider-side `source_receive_time`; mapping resolution is event-time-only; result metadata carries `AcquisitionMode`.
- **Deferred:** XML parser, generalized persistent cache, Python binding, live ingestion, and backtesting implementation remain deferred. Bounded stage/evidence persistence and lineage are implemented under the 2026-10-03 integrity supplement below; they do not authorize a general cache or orchestration framework.
- **Accepted:** A small Alpaca raw sample exists only as prior research data and does not define the canonical provider architecture.

## Historical ingestion architecture

See:

- `docs/architecture/phase1-historical-ingestion.md`
- `docs/architecture/phase1-ingestion-iteration-close.md`
- `docs/project/opencode-review-2026-09-05.md`

Accepted baseline:

- Databento is the first real provider; Alpaca is only a later provider-independence check.
- First real path is L3/MBO; direct L2/L1 provider ingestion remains deferred.
- `MarketDataQuery` expresses canonical intent; provider request fields stay behind adapters.
- Synchronous execution is first, but async/concurrent execution must later reuse the same query/domain/batch/quality semantics.
- Producer -> batch -> consumer is the ingestion primitive.
- Current first-slice behavior of one provider request -> one `ProviderBatch` is accepted; finer bounded batching is deferred until the real path works.
- Cache remains a `NoopCache`; persistent cache remains deferred. Storage/replay now has a separate accepted foundation and must not be folded into ingestion.
- Recovery is injected policy; retry/backoff/repair execution remains deferred.
- Range-local quality/state remains scoped and non-destructive.

Current Databento slice status:

- **Implemented:** `src/quant/ingestion/databento_provider.hpp` translates XNAS MBO actions into canonical MBO, Trade, and OrderExecution observations, preserves provider metadata sidecars, maps dataset conditions, and rejects source-receive-time-only mapping requests.
- **Implemented:** `integration/databento/` provides a minimal isolated CMake build using the pinned official SDK checkout or `FetchContent` tag `v0.67.0`.
- **Verified:** All direct C++20 warnings-as-errors tests, ASan/UBSan tests, and the deterministic Databento translation CTest pass.
- **Verified:** One credentialed, cost-gated AAPL `XNAS.ITCH` MBO request ran for `[2024-01-02T14:30:00Z, 2024-01-02T14:35:00Z)` at an estimated cost of `$0.022502`; it returned 234,144 provider records, 212,218 MBO records, 12,213 Trades, and 9,713 OrderExecutions.
- **Verified:** The result reduced to one `Complete` state segment with zero corrupt quality observations; `source_receive_time` was present on all provider records, sequence/channel evidence was present on all records, channel `0` was observed, and raw flags `0`, `128`, and `130` were preserved.
- **Observed:** The provider condition response included `available` evidence for both 2024-01-02 and 2024-01-03 while the returned data interval ended at 2024-01-02 14:35 UTC; both conditions were healthy, but the date-range boundary should be reviewed before treating condition evidence as day-local.
- **Implemented:** The smoke harness calls `MetadataGetCost` before `TimeseriesGetRange`, refuses estimates above the `$0.25` target or `$1.00` hard ceiling, and reports canonical counts, timestamps, ordering evidence, quality, state, and provider conditions.

## Query planning and data usability — implemented 2026-09-06

See `docs/architecture/phase1-query-planning-and-usability.md`.

- **Implemented:** `QueryPlanner` produces a provider-independent `QueryPlan` containing the original query, cache-missing ranges, event-time mapping segments, canonical provider queries, provider fetch ranges, and post-fetch filters.
- **Implemented:** `SynchronousIngestor::explain()` and `SynchronousIngestor::ingest()` share the same planner; provider execution receives mapping-clipped canonical queries in deterministic plan order.
- **Implemented:** `DataUsabilityPolicy` is injected separately from factual `DataState`; the initial policy treats `Complete` and `Degraded` as usable and `Unknown`, `Missing`, and `Corrupt` as unusable. This existing default is not sufficient for the newly accepted order-sensitive eligibility contract below.
- **Verified:** New planner, policy, and plan-vs-`FakeProvider` tests pass with C++20 warnings-as-errors.

## Storage and replay foundations — accepted 2026-09-26

See `docs/architecture/phase1-storage-replay.md`.

- **Accepted:** Arrow is the in-memory columnar interchange layer; Parquet is the primary persisted analytical/archive format.
- **Accepted:** The initial persisted data kinds are MBO, Trades, and OrderExecution.
- **Accepted:** `MarketDataReader` is the storage-agnostic access path for Arrow batches and sequential canonical-event replay; replay code must not call Parquet APIs directly.
- **Accepted:** Dataset-local metadata stays with the persisted artifact; static/reference metadata remains external structured metadata.
- **Accepted:** The local layout uses `data/mbo/`, `data/trades/`, and `data/order_executions/` without a database-backed catalog.
- **Accepted:** Arrow/Parquet C++ integration is isolated behind an environment-provided `find_package` CMake target; no root build-system migration is authorized.
- **Implemented:** `src/quant/storage/` provides `DataFragment`, dataset-local metadata, Arrow codecs for MBO/Trades/OrderExecution, `MarketDataReader`/`StorageBackend`, and a concrete Parquet backend with replay projection.
- **Implemented:** `integration/storage/` contains the isolated CMake target and focused round-trip, metadata, projection, ordering, and replay-boundary tests.
- **Verified:** Storage tests compile and pass with strict warnings and ASan/UBSan against the locally installed PyArrow 21 C++ bundle; the isolated CMake target also configures, builds, and passes CTest through a temporary package shim over those libraries. Native `find_package` remains unconfigurable on this machine because no Apache Arrow CMake package is installed.
- **Owner validation:** `docs/project/storage-testing-guide.md` documents unit/boundary checks, integration assertions, exact local build commands, and a retained three-event manual MBO -> Arrow -> Parquet -> Arrow -> replay example with independent Python file/metadata inspection.
- **Deferred:** A custom binary replay backend is performance-justified only; SQLite, graph storage, async/concurrency, live execution, and strategy/backtesting logic remain out of scope.

## Interview-oriented research and trading scope — accepted 2026-09-29

See `docs/project/research-backtesting-trading-scope.md`.

- **Accepted:** The near-term objective is an interview-grade demonstration of correct quantitative-finance and trading-domain reasoning, not a cutting-edge production trading platform.
- **Accepted:** Research/backtesting/trading work prioritizes explicit data flow, point-in-time correctness, costs/fills, state transitions, risk, PnL, validation, and reproducibility.
- **Accepted:** Start with transparent baselines: a small research loop, an explainable backtest, simple execution/cost assumptions, and one or two interpretable strategies.
- **Deferred:** Low-latency optimization, exchange matching simulation, distributed infrastructure, ML-heavy research, complex portfolio optimization, and live trading remain deferred until a concrete requirement justifies them.
- **Study direction:** Research workflow -> backtest mechanics -> trading domain -> validation/metrics -> minimal end-to-end implementation.

## Databento first real integration — accepted 2026-09-05

See `docs/architecture/phase1-databento-first-integration.md`.

### Provider/dependency direction

- **Accepted:** Use the official `databento-cpp` historical client behind `ProviderPort`.
- **Accepted:** First real target is a deliberately small `XNAS.ITCH` MBO request, roughly one to two trading days, so the whole existing path can be tested before production batching.
- **Guardrail:** Databento docs recommend CMake `FetchContent` and require CMake 3.24+, OpenSSL 3+, libcrypto, and zstd. Keep dependency/build integration minimal; do not silently redesign the whole repository build.

### Dual query time semantics

- **Accepted:** Canonical query semantics must preserve both exchange-event time and provider/source receive time.
- **Accepted:** `MarketDataQuery` evolves from one generic range to optional `event_time_range` and optional `source_receive_time_range`; at least one is required, but the current ingestion path rejects source-receive-time-only queries because mappings are event-time valid.
- **Accepted:** Event time is the default/primary semantic for ordinary canonical queries.
- **Accepted:** If only event time is supplied and a provider such as Databento MBO filters on receive time, the adapter may derive a receive-time fetch range when the query selects derivation policy.
- **Accepted:** The query can carry before/after safety margin for that derived provider range.
- **Accepted:** A strict policy can require the provider-native time range explicitly and fail before the request if it is absent.
- **Accepted:** If both ranges are supplied, returned canonical records must satisfy both.
- **Accepted:** Preserve both `event_time` and provider-side `source_receive_time` on canonical observations whenever the provider supplies both. `source_receive_time` is not our own live-system receive timestamp.
- **Accepted:** `AcquisitionMode::Historical` and `AcquisitionMode::Live` identify the ingestion path at result metadata level and are independent of both timestamps.

### Databento MBO action interpretation

- **Accepted:** Do not blindly map every Databento MBO action 1:1 into `MboAction`.
- **Source fact:** On XNAS, Databento normalizes an Order Executed as `Trade -> Fill -> Cancel`; the `Cancel` is the displayed-book quantity mutation.
- **Accepted:** A provider-specific interpreter may produce separate canonical semantics from one provider event group:

```text
provider event group
      ├── Trade observation
      ├── OrderExecution observation
      └── MBO book mutation
```

- **Accepted:** Prefer provider-supplied semantics; synthesize only canonical information that is missing; never double-apply a book mutation that the provider already supplied.
- **Accepted:** Add a provider-neutral first-class `OrderExecution` observation for resting-order execution/fill evidence where available. Do not expose a Databento-specific `Fill` type in the core.
- **Guardrail:** Exact `OrderExecution` fields should be the minimal set justified by real Databento records and existing canonical types; do not predesign fields for hypothetical providers.

### Identity mapping

- **Accepted:** For the first integration, continue using deterministic manual/in-memory mappings.
- **Accepted:** Databento `instrument_id` maps to canonical `InstrumentId`; Databento publisher/dataset identity maps to canonical `VenueId` + `SourceId`.
- **Accepted:** Provider-native IDs remain evidence and never become canonical identity.
- **Deferred:** XML-backed mapping waits until the real Databento path works.

### Quality mapping

- **Accepted:** Databento quality uses provider dataset condition + record/channel evidence + our validation.
- **Accepted initial interpretation:**
  - `available` + successful request + validation passes + no known bad-book evidence -> `Complete`;
  - `degraded` -> `Degraded`;
  - `pending` -> `Unknown`;
  - `missing` -> `Missing`;
  - structurally/unusably invalid canonical input -> `Corrupt`.
- **Accepted:** `last_modified_date` is provenance/version evidence, not quality state by itself.
- **Accepted:** Bad-book/gap evidence may degrade affected data. Source-receive-timestamp quality evidence affects source-receive-time quality and must not automatically mean the book is corrupt.
- **Accepted:** Never infer `Complete` from event count.

### API/infrastructure failure semantics

- **Accepted:** Provider/API failures belong to the ingestion operation, not canonical market-data knowledge.
- **Accepted:** Timeout, rate limit, auth, entitlement, or server failure must not become `Missing` or `Unknown` in stored `DataState` merely because ingestion failed.
- **Accepted:** Failed ingestion must not be committed as authoritative knowledge. Already-fetched data can remain staged/temporary until the operation is accepted.
- **Accepted direction:** Recovery/retry policy handles operation failure separately from canonical quality state. Exact partial-result/failure-envelope mechanics may be refined when the first real SDK failure path is encountered.

### Field normalization and provider metadata

- **Accepted:** Existing canonical MBO representation is sufficient for primary Databento fields (`ts_event`, `ts_recv` as `source_receive_time`, sequence, channel, flags, price, size, order id); normalization is adapter work unless real data exposes a mismatch.
- **Accepted:** Do not widen the 64-byte `MboRecord` for Databento-only control/native metadata.
- **Accepted:** Preserve provider-specific metadata through a sidecar/component/reference outside the hot record; store stream/batch metadata once when possible.
- **Guardrail:** Do not build a generalized provider-metadata framework until concrete Databento fields justify the exact shape.

### Batching and execution mode

- **Accepted:** First integration remains `1 Databento request -> 1 ProviderBatch -> existing SynchronousIngestor`.
- **Accepted:** Restrict the first real test to about one to two trading days.
- **Accepted future direction:** Databento supports incremental pull/callback consumption; later one request can emit multiple bounded `ProviderBatch` chunks without changing producer -> batch -> consumer semantics.
- **Accepted:** The first adapter may use the simplest synchronous/pull SDK path internally, but sync/pull must remain an execution choice hidden behind the provider boundary. Future async/callback/concurrent execution reuses the same canonical semantics.

## Current open questions

Only questions that should block implementation when actually encountered:

- Whether the isolated Databento CMake target should later be adopted by a repo-wide build remains deferred; no root build-system decision has been made.
- Future `OrderExecution` or provider-sidecar fields should be added only when another concrete source justifies them; the first Databento shape is implemented.
- Exact ingestion-operation failure/partial-result envelope once a real SDK failure path exposes the necessary information.
- XML parsing library/dependency — intentionally deferred until Databento vertical slice works.
- C++/Python boundary, execution realism, ML dataset correctness, and other later Phase 1 concerns remain deferred; the accepted storage/replay foundation is recorded in `phase1-storage-replay.md`.

## Design decision coverage review — 2026-10-01

See `docs/project/design-decision-review-2026-10-01.md` for implementation/test evidence and open decisions.

- **Reviewed:** Most first-slice decisions for canonical data, ingestion, query planning and basic Arrow/Parquet replay are represented in code. Research/backtesting implementation remains a proposal, not an accepted type/execution design.
- **Reproduced gaps:** Same-identity Parquet writes overwrite existing artifacts; stream/range metadata can disagree with source rows; mixed-stream Trade encoding loses identity; zero-quantity Trades can persist/replay; arbitrary schema-version labels are decoded using current codecs.
- **Partial:** Provider-valid ordering enforcement and ingestion-evidence persistence are not established by the synthetic round-trip tests. Native Arrow CMake package verification remains pending.
- **Proposed, not accepted:** Immutable publication, explicit row/scope/range validation ownership, and supported-version rejection behavior. Resolve these before treating persisted datasets as authoritative research inputs.
- **Agent guidance:** `AGENTS.md` now points to storage validation and the decision review and clarifies that later accepted ingestion supplements govern subsequent slices.

## Current architecture task

- **Implemented:** Canonical data model and generic synchronous ingestion skeleton are stable enough for the first real provider slice.
- **Accepted:** Databento first-integration semantics above are now the active design.
- **Implemented:** The first Databento historical adapter/translation slice is verified without committing to root build integration or live ingestion.
- **Implemented:** Shared query planning and injectable data usability are verified without changing the canonical record layout or provider port shape.
- **Implemented:** Storage/replay foundations use Arrow batches, a storage-independent reader, and an isolated Parquet backend without changing ingestion or the canonical data model.
- **Do not add:** XML parser, generalized persistent cache, automatic retry/repair loops, async/concurrency, L1/L2 provider support, custom binary storage, SQLite/database-backed catalog infrastructure, live execution, strategy/backtesting logic, or broad build/tooling refactors. The bounded stage/evidence persistence and compact identity catalog accepted below are a separate integrity slice.

## Ingestion/storage integrity closure — accepted 2026-10-03

See `docs/architecture/phase1-data-integrity-session-2026-10-03.md` for the authoritative accepted contracts. The bounded normalized-XNAS/local-POSIX implementation and regressions are complete and published on `implementation/data-integrity-2026-10-03`; native Arrow package verification and the limitations in the verification report remain explicit.

- **Identity:** Persist row StreamId, resolve it to the instrument/venue/source tuple, check original identity during conversion, and keep one stream per canonical file. StreamId never changes meaning. Retain the exact reference definitions/mapping snapshot needed by each published version.
- **Validation and staging:** Apply canonical row and query/range checks after legitimate provider overfetch filtering. Retain original evidence and row-level failures; unresolved affected segments cannot enter research/replay. Recovery is explicit and revalidated; retaining good segments does not imply complete requested coverage.
- **Versions and compatibility:** Published versions are immutable. Corrections create new versions, and consumers pin exact versions. Unknown encodings are rejected before row delivery; supported labels must match real schema/meaning contracts.
- **Order:** Preserve provider-returned succession and applicable provider rules. Use a separate uint64 ordinal assigned before filtering and cross-kind splitting, shared within a named acquisition scope. Independent acquisition ordinals are not comparable. Keep ordering evidence outside the 64-byte MboRecord.
- **Stages and evidence:** Separately retain provider representation, canonical preparation, and the consumer representations actually produced, with exact parent and transformation links. Complete publication requires all required data/reference/validation evidence; distinguish retry from new acquisition. Implemented formats/mechanisms are recorded in `docs/architecture/phase1-data-integrity-implementation.md`.
- **Eligibility:** Factual DataState and consumer eligibility stay separate. Degraded acceptance must not bypass unresolved required ordering, incomplete required event groups, or insufficient initial book state. Partial consumption is explicit and depends on the consumer's requirements.
- **Source clarification/implemented:** Databento dataset-condition date endpoints are inclusive. Condition requests now use floor(start)/floor(end−1ns), and conditions are clipped to their intersecting UTC day. Deterministic intraday, midnight-exclusive, multi-day and extra-response-day tests pass.
- **Scope:** Assess integrity on engineering grounds. XML, automated repair/recovery, generalized catalogs/caches, revision-management frameworks, live ingestion, and binary replay remain deferred. Bounded staging persistence is not a general persistent cache.

## Next action

1. Review `implementation/data-integrity-2026-10-03` against the accepted recap, specification, plan and `docs/project/data-integrity-verification-2026-10-03.md`. This implementation branch is published on GitHub for review; merging into main remains a separate owner instruction.
2. Independently run/review the updated testing guide and negative/failure regressions. Native Arrow/Parquet CMake package verification remains pending; library/shim results are separately documented.
3. Dataset-condition inclusive-date and day-local scoping regressions pass; retain this contract when future provider/range support changes.
4. Keep the first research/backtesting consumer design separate. Stop for engineering-manager review before XML, generalized persistent cache, live ingestion, production multi-batch work, or a future binary replay optimization.

## Integrity implementation progress

- **Implemented/verified, domain slice:** Nonzero uint64 StreamId, immutable tuple catalog/reference snapshot checks, raw acquisition/ordinal/failure types, canonical preparation, source-order/group/snapshot checks and a separate eligibility gate. `data_integrity_tests` passes strict C++20 and ASan/UBSan; original standalone tests remain green.
- **Implemented/verified, provider slice:** Required acquisition-sink port, explicit per-request acquisition IDs through the synchronous planner, full SDK-normalized record capture before filtering/translation, retained operation outcomes, exact native mappings and provider metadata. SDK-byte decoder agreement and inclusive/day-local condition regressions pass in isolated deterministic Databento CTest; strict/sanitizer retention tests pass.
- **Implemented/verified, interchange slice:** `quant-observations-v2` binding columns and conversion-time original-scope/ordinal checks, persisted binding metadata checks, financial validation and noncanonical MBO-control rejection. Arrow-only strict/sanitizer regressions and evidence/reference serialization/SHA-256 known-answer tests pass.
- **Implemented/verified, publication slice:** Durable pre-conversion capture, recoverable unfinished journal prefix, staged failure reports/good canonical candidates, immutable complete package publication, explicit attempt/retry identity, stable references, current selection, fail-before-delivery readers and cross-kind acquisition replay. Full archive retains original byte witnesses; Replay excludes them. Faulted publication and self-consistent-but-misassociated witness tests pass.
- **Verification:** Ten standalone tests, deterministic Databento CTest and four storage CTest targets pass, including ASan/UBSan runs. The retained/synthetic provider demonstration and independent Python package/hash/row inspection pass. Native Arrow CONFIG discovery still fails due to absent packages; PyArrow 21 library/shim checks are reported separately. No paid requests during implementation verification. The implementation branch is published to GitHub and remains unmerged.

## Last updated

- **Repository synchronization:** 2026-10-14 fetched origin and confirmed that both local branches (`main` and `implementation/data-integrity-2026-10-03`) already matched their remote counterparts. No outstanding local commits, tags, or stashes were found. Added ignore rules for local `.DS_Store` files and `.idea/` state, preserving those files, and corrected current publication status above. This housekeeping session changes only ignore rules and documentation; runtime verification remains the previously recorded evidence.

- **Owner publication instruction:** 2026-10-04 push the completed implementation branch to GitHub for review. Runtime verification remains recorded above; this instruction authorizes branch publication, not a main-branch merge.

- **Implemented/verified:** 2026-10-03 bounded integrity closure and deterministic retained/synthetic provider demonstration complete locally. Exact commands/results/limitations are in `docs/project/data-integrity-verification-2026-10-03.md`; original storage/replay foundation remains intact. Implementation publishing/merging still requires owner instruction.

- **Earlier specification checkpoint:** 2026-10-03 bounded formats/ownership/identity/ordinal/publication/eligibility specification and plan recorded before production changes; implementation and verification were pending at that checkpoint and are now recorded above.

- **Accepted/reviewed:** 2026-10-03 data-integrity decisions and three final closure contracts recorded; context, AGENTS.md, historical cross-references, and the current OpenCode handoff updated for the owner-requested GitHub publication. Documentation-only changes; no new production implementation or implementation-test claims.

Earlier dated entries retain the status at that time; the accepted closure above supersedes their open-decision status.

- **Accepted:** 2026-09-05.
- **Implemented:** 2026-09-05 Databento first-slice worktree update.
- **Verified:** 2026-09-05 first credentialed Databento smoke request.
- **Implemented/verified:** 2026-09-06 shared query planning and injectable data usability.
- **Accepted/implemented:** 2026-09-26 storage and replay foundations; implementation is isolated from the root build and canonical model.
- **Verified:** 2026-09-26 Arrow/Parquet storage and replay tests through the local PyArrow C++ probe; standard package-backed CMake verification remains environment-dependent.
- **Implemented/verified:** 2026-10-01 owner testing guide, retained manual round-trip executable, and independent PyArrow inspection; direct strict compilation and both CTest targets pass using PyArrow 21 (temporary package shim for CMake). Manual output and physical `control` values were checked against the guide.
- **Reviewed/verified:** 2026-10-01 decision-coverage audit, eight standalone tests and two storage CTest targets passed; scratch probes reproduced storage invariant gaps. Updated agent guidance; closure recommendations remain proposals pending owner acceptance.
- **Handoff:** 2026-10-02 testing guide, retained example/inspection tools, decision review and agent guidance prepared for repository-backed owner architecture discussion. Artifact, validation and version-policy decisions remain open.

## Lexongine v1 initial implementation attempt — 2026-10-15 (historical blocker)

- **Owner-authorized:** Implement the accepted Lexongine v1 milestone using its current handoff and twelve task cards. Earlier ingestion deferrals retain their dated scope; the current request governs Lexongine. Preserve the accepted storage/integrity contracts and the owner's settled baseline, cache, lag and Strict/Skip decisions.
- **Baseline verified:** Original checkout is clean on `implementation/data-integrity-2026-10-03` at `f75cd3c179f3b070f9a85c054ec3704b89f4cb69`, matching the requested baseline and the remote branch. Local `main` matches `origin/main` at `95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5`. No pre-existing local unpushed commits or stashes were found; live remote-head inspection advertised no newer baseline.
- **Implementation isolation:** Created local `implementation/lexongine-v1` from the accepted commit in `/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode/lexongine-v1`. The original checkout is preserved. No merge or push occurred.
- **Blocked:** The baseline has no `docs/lexongine/` documentation or `docs/project/lexongine-context.md`; workspace searches found no supplied documentation patch. The README, six specifications, decisions, plan, XML example and JSON reference cases are unavailable. Task 1 and its dependent work require those inputs.
- **Evidence:** `docs/lexongine/implementation/progress.md` records the pre-code branch/full HEAD/dirty/unpushed evidence and missing-input inventory. Only documentation was added/updated; no foundational declarations, production implementation, runtime tests or milestone acceptance are claimed. The next action is to obtain the accepted patch/path/commit, run `git apply --check` if applicable, reconcile local documentation and resume the specified task cards.

## Lexongine foundation checkpoint — 2026-10-15

- **Reconciled:** Owner handoff `61ecf87892a9eebfce397cea522941864d92a6c7` is present. The local historical checkpoint was rebased and reconciled at `33f3060257266af33b0ec880ace1e356fcf8ecea`; the earlier missing-documentation blocker is resolved. Original integrity/main branches remain unchanged.
- **In progress:** Tasks 1–2 have owned model/registry/typed factory, initial schema, immutable ownership, resource/holder ledger and atomic slot primitives. Two focused CTest targets pass strict and ASan/UBSan builds; this subset is not full task or milestone acceptance. Detailed evidence and remaining foundation obligations are in `docs/lexongine/implementation/progress.md`.
- **Owner-approved provisioning:** TinyXML2 11.0.0 is a clean official checkout at `9148bdf719e997d1f474be6bcc7943881046dba1`. Native Arrow/Parquet provisioning encountered network failures and is being retried explicitly. The actual-reader prototype remains uncompiled until Arrow is available. No plugin/source/host/graph/cache integration completion is claimed.

- **Later foundation checkpoint:** The owner approved the typed publication-provenance envelope. Immutable metadata references and explicit parent selections now preserve original parent timing while host validation enforces authority/history/order/current availability. New failing tests also closed scalar-copy retention and preparation-reservation gaps. The two strict/sanitizer targets pass with 8 contract and 7 lifetime cases. Task-card closure remains in progress.
- **Native dependency blocker:** The Arrow retry was stopped after repeated stalled downloads; explicit native configuration still fails at `find_package(Arrow)`. Actual reader integration is Blocked/Unverified. The user requested continued independent implementation; no source integration or full milestone acceptance is inferred from core results.
- **Independent arithmetic checkpoint:** Canonical-Price SMA/lag helpers, checked ties-even/subtraction and generated 120-Bar fields now pass focused strict/sanitizer checks. Four CTest targets pass, including a separate Fraction oracle (266 rounding cases, 3,851 SMA updates, 672 lag updates). Specified numerical fixture means/counts/spreads match. Registered component, graph/source/host/cache integration and full task closure remain pending; see progress for exact scope and commands.
