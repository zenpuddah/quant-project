# Phase 1 Storage and Replay Foundations

## Status

- **Accepted:** Arrow is the in-memory columnar interchange layer for the first storage slice.
- **Accepted:** Parquet is the primary persisted analytical/archive format.
- **Accepted:** Storage and replay consumers request an access pattern rather than a file format.
- **Accepted:** The first persisted data kinds are MBO, Trades, and OrderExecution.
- **Implemented:** The first Arrow codecs, Parquet backend, storage-independent reader, replay projection, and focused integration tests are present.
- **Verified:** The focused tests pass against a locally installed PyArrow C++ bundle; the isolated CMake target configures and passes CTest through a temporary package shim over that bundle, while native package discovery remains dependent on an Apache Arrow C++ development installation.
- **Review finding:** Basic serialization/replay was verified in the baseline, but artifact immutability and row/metadata consistency are not enforced. See `docs/project/design-decision-review-2026-10-01.md` for the historical failure evidence.
- **Accepted supplement — 2026-10-03:** `docs/architecture/phase1-data-integrity-session-2026-10-03.md` governs closure of the reviewed gaps, including row StreamId, ordinal scope, staged validation/evidence, immutable versions, compatibility, and eligibility. These new guarantees are not yet implemented. Use `docs/project/opencode-data-integrity-handoff-2026-10-03.md` for the current task.
- **Deferred:** A custom binary replay store, `BinaryReplayBackend`, SQLite/catalog storage, graph storage, live execution, and strategy/backtesting logic.

## Goal

Introduce the smallest boundary that supports both analytical batch access and future event-by-event replay without changing canonical market semantics or the ingestion path.

```text
canonical observations
        |
        v
Arrow record batches
        |
        v
StorageBackend
        |
        +--> Parquet archive backend
        |
        v
MarketDataReader
        |
        +--> read Arrow batches
        +--> stream canonical events sequentially
```

The replay consumer depends on `MarketDataReader` and canonical event types. It does not include or call Parquet APIs. The current sequential implementation is:

```text
Parquet -> Arrow record batch -> canonical event iteration
```

The future binary backend is permitted only after measurements demonstrate that this path is an actual bottleneck.

## Canonical model guardrails

- `MboRecord` remains 64 bytes and 64-byte aligned.
- Existing `InstrumentId`, `VenueId`, `SourceId`, `Timestamp`, `TimeRange`, and fixed-scale `Price`/`Quantity` types remain authoritative.
- Provider-specific concepts remain behind ingestion/provider adapters or dataset-local provenance metadata.
- Storage does not redefine event meaning, ordering, quality, or identity.
- Persisted data retains useful canonical/archive fields rather than only a strategy replay subset.

For MBO, the baseline Arrow schema preserves the physical record fields: `event_time`, `source_receive_time`, `sequence`, `order_id`, `price`, `quantity`, `source_flags`, `channel_id`, and `control`. Stream identity is stored once in the fragment metadata. The baseline Trade and OrderExecution codecs persist observation and time/ordering fields, but omit per-row identity and reconstruct it from file metadata. The accepted 2026-10-03 supplement adds persisted row StreamId and a separate ordinal without enlarging MboRecord; it also requires identity checks before original context is discarded.

## Data fragments and metadata

`DataFragment` is the minimum persisted-data identity:

```text
DataFragment
├── data kind
├── canonical stream identity
│   ├── InstrumentId
│   ├── VenueId
│   └── SourceId
├── half-open time range [start, end)
├── canonical schema version
└── storage locator
```

Dataset-local metadata is kept with the Parquet artifact through Parquet key-value metadata for the first implementation. It includes stream identity, range, data kind, `AcquisitionMode`, schema/adapter/mapping versions, optional quality references, range-aware source artifact provenance, and an optional checksum.

Static/reference metadata remains structured reference evidence. The accepted supplement requires retaining and binding the exact reference definitions/mapping snapshot needed to interpret each published version, whether embedded or linked immutably. Instrument/provider mappings, venue references, and source tables are not moved into a database or generalized catalog by this slice.

## Access boundary

The storage-independent boundary exposes:

- `read_batches`: synchronous Arrow batch access for research and analytical consumers;
- `stream_events`: synchronous sequential canonical-event access for replay consumers;
- `write`: persistence of a canonical Arrow batch sequence plus dataset-local metadata.

The boundary supports a full batch projection and a replay projection. The Parquet backend selects only the canonical replay columns for `stream_events`; it does not expose this selection as a Parquet concern to consumers.

No asynchronous callbacks, worker pools, queues, locks, or live execution are introduced.

## Filesystem layout

The first local layout is deliberately portable:

```text
data/
├── mbo/
├── trades/
└── order_executions/
```

Each persisted fragment is a Parquet artifact. A database-backed catalog and broad dataset discovery framework are not part of this slice.

## Dependency boundary

Arrow and Parquet C++ integration is isolated in a storage-specific CMake target that consumes an environment-provided Apache Arrow installation through `find_package`. The root project remains dependency-free and keeps its existing standalone C++20 test workflow.

The storage-independent reader and replay-facing headers contain no Parquet-specific APIs. The concrete Parquet backend is the only implementation that includes Parquet headers.

## Verification targets

The focused storage tests must demonstrate:

- canonical MBO -> Arrow -> Parquet -> Arrow round trip;
- preservation of MBO fields, stream identity, and half-open range metadata;
- persistence of Trades and OrderExecution;
- deterministic sequential replay order;
- replay projection excluding archive-only columns;
- no Parquet dependency in replay/consumer-facing code.
