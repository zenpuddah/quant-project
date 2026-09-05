# Project Context

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
- **Deferred:** No real provider adapter, XML parser, persistent cache, storage/replay, Python binding, lineage persistence, or backtesting implementation yet.
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
- Cache remains a `NoopCache`; persistent cache/storage/replay are deferred.
- Recovery is injected policy; retry/backoff/repair execution remains deferred.
- Range-local quality/state remains scoped and non-destructive.

## Databento first real integration — accepted 2026-09-05

See `docs/architecture/phase1-databento-first-integration.md`.

### Provider/dependency direction

- **Accepted:** Use the official `databento-cpp` historical client behind `ProviderPort`.
- **Accepted:** First real target is a deliberately small `XNAS.ITCH` MBO request, roughly one to two trading days, so the whole existing path can be tested before production batching.
- **Guardrail:** Databento docs recommend CMake `FetchContent` and require CMake 3.24+, OpenSSL 3+, libcrypto, and zstd. Keep dependency/build integration minimal; do not silently redesign the whole repository build.

### Dual query time semantics

- **Accepted:** Canonical query semantics must preserve both exchange-event time and provider-receive time.
- **Accepted:** `MarketDataQuery` evolves from one generic range to optional `event_time_range` and optional `receive_time_range`; at least one is required.
- **Accepted:** Event time is the default/primary semantic for ordinary canonical queries.
- **Accepted:** If only event time is supplied and a provider such as Databento MBO filters on receive time, the adapter may derive a receive-time fetch range when the query selects derivation policy.
- **Accepted:** The query can carry before/after safety margin for that derived provider range.
- **Accepted:** A strict policy can require the provider-native time range explicitly and fail before the request if it is absent.
- **Accepted:** If both ranges are supplied, returned canonical records must satisfy both.
- **Accepted:** Preserve both timestamps on canonical observations whenever the provider supplies both.

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
- **Accepted:** Bad-book/gap evidence may degrade affected data. Receive-timestamp-quality evidence affects receive-time quality and must not automatically mean the book is corrupt.
- **Accepted:** Never infer `Complete` from event count.

### API/infrastructure failure semantics

- **Accepted:** Provider/API failures belong to the ingestion operation, not canonical market-data knowledge.
- **Accepted:** Timeout, rate limit, auth, entitlement, or server failure must not become `Missing` or `Unknown` in stored `DataState` merely because ingestion failed.
- **Accepted:** Failed ingestion must not be committed as authoritative knowledge. Already-fetched data can remain staged/temporary until the operation is accepted.
- **Accepted direction:** Recovery/retry policy handles operation failure separately from canonical quality state. Exact partial-result/failure-envelope mechanics may be refined when the first real SDK failure path is encountered.

### Field normalization and provider metadata

- **Accepted:** Existing canonical MBO representation is sufficient for primary Databento fields (`ts_event`, `ts_recv`, sequence, channel, flags, price, size, order id); normalization is adapter work unless real data exposes a mismatch.
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

- Minimal project/build integration needed for `databento-cpp` without silently introducing an unwanted repo-wide build-system redesign.
- Exact minimal `OrderExecution` field set after inspecting the concrete C++ MBO record API.
- Exact Databento provider-metadata sidecar shape after identifying which native fields are not already canonical and are worth preserving.
- Exact ingestion-operation failure/partial-result envelope once a real SDK failure path exposes the necessary information.
- XML parsing library/dependency — intentionally deferred until Databento vertical slice works.
- Storage/replay/cache persistence, C++/Python boundary, execution realism, ML dataset correctness, and other later Phase 1 concerns remain deferred.

## Current architecture task

- **Implemented:** Canonical data model and generic synchronous ingestion skeleton are stable enough for the first real provider slice.
- **Accepted:** Databento first-integration semantics above are now the active design.
- **Do not add:** XML parser, persistent storage/cache, replay, retry loops, async/concurrency, L1/L2 provider support, or broad build/tooling refactors during this slice.

## Next action

1. Pull latest `main` and read the current architecture/context.
2. Implement the smallest real Databento historical `XNAS.ITCH` MBO vertical slice using the official C++ client.
3. First update the canonical types/tests required by accepted design: dual query time semantics and provider-neutral `OrderExecution`.
4. Add the Databento adapter/interpreter and manual/in-memory mapping needed for one small real query.
5. Integrate Databento daily dataset-condition evidence into existing quality observations without treating API failures as canonical data state.
6. Keep one request -> one batch for the first test.
7. Run existing tests plus focused adapter/integration tests, then stop for engineering-manager review before XML or multi-batch work.

## Last updated

- **Accepted:** 2026-09-05.
