# Phase 1 Historical Ingestion — Synchronous Slice

## Status

- **Accepted:** 2026-09-03 architecture direction for the first historical-ingestion slice.
- **Accepted:** Databento is the only real provider implementation target for this slice.
- **Accepted:** Alpaca remains a ghost/provider-independence boundary; do not implement it now.
- **Accepted:** L3/MBO is the first concrete ingestion path. Direct MBP-10/L2 and MBP-1/L1 ingestion is deferred; lower levels may later be derived from sufficiently complete L3 data.
- **Accepted:** Synchronous execution is implemented first. Asynchronous/multithreaded execution must remain possible without changing query/domain semantics.
- **Deferred:** Real caching, storage/access/replay, retries/repair, asynchronous execution, concurrency, direct L2/L1 provider ingestion, schema migration machinery, and automated instrument reconciliation.

## Goal

Build one small, testable ingestion boundary that can eventually fetch Databento historical MBO data without coupling the canonical model to Databento, a cache backend, a storage engine, or an execution model.

The first implementation should prove the boundaries with deterministic fakes/no-op implementations before adding external provider/XML dependencies.

## Core flow

```text
caller
  ↓
canonical MarketDataQuery
  ↓
RangeResolver
  ↓
CachePort                         initially NoopCache -> Miss
  ↓ missing ranges
InstrumentMappingRegistry
  ↓ provider mapping segment(s)
ProviderPort
  ↓
Databento implementation         later concrete implementation
  ↓
canonical MBO batches
  ↓
validation + DataQualityObservation
  ↓
DataStateReducer
  ↓
IngestionResult + IngestionMetadata
```

Provider-specific request fields never become fields of `MarketDataQuery`.

## 1. Canonical query boundary

`MarketDataQuery` expresses what our system wants, not how Databento asks for it.

The query must be based on canonical concepts:

```text
InstrumentId
optional venue constraint
MarketDataLevel (L1/L2/L3)
[start, end)
```

Databento concepts such as dataset code, schema string, `stype_in`, raw symbol, or provider instrument ID belong behind the provider/mapping boundary.

For the first executable provider path, only `L3` is supported. Unsupported levels must fail explicitly rather than silently translating to another schema.

## 2. Half-open ranges and range resolution

All internal time coverage uses half-open intervals:

```text
[start, end)
```

The range resolver is a pure logical component. It computes what part of a requested canonical range is already covered, currently active, or still missing.

Example future behavior:

```text
requested: [Jan 1, Jan 10)
active:    [Jan 5, Jan 8)

new work:
  [Jan 1, Jan 5)
  [Jan 8, Jan 10)

join/wait:
  [Jan 5, Jan 8)
```

For the synchronous first slice there is no active-job concurrency. The same range primitives must be reusable later by a coordinator.

## 3. Cache boundary: ghost now, coverage-aware later

Caching is defined against our canonical query semantics, not against Databento HTTP/client request identity.

```text
MarketDataQuery
      ↓
CachePort
      ↓
Miss / FullHit / PartialHit
```

The first implementation is `NoopCache` and always returns `Miss` with the full requested range missing.

Do not implement files, memory caching, databases, eviction, compaction, invalidation, or cache writes in this slice.

The future cache model must support segmented coverage and patching rather than one-request/one-file identity. A real cache may later use RAM, files, a database, object storage, or a combination without changing ingestion policy.

## 4. Ingestion metadata is independent of caching

Ingestion generates the metadata future caching/reproducibility needs. The cache must not be the owner or creator of this metadata.

Keep the distinction:

```text
MarketDataQuery
= what we asked for

IngestionMetadata
= what actually happened / what we actually received
```

The metadata contract should be able to carry, as the concepts become concrete:

- canonical requested range;
- actual coverage segments;
- provider/source provenance;
- quality observations/state;
- source artifact identity/checksum when one exists;
- adapter/canonical-schema/mapping version identity;
- ingestion timestamp.

Do not build migration or artifact persistence machinery now. Preserve enough identity to make future regeneration/migration possible.

## 5. Instrument identity and XML bootstrap registry

Canonical `InstrumentId` remains our identity. Databento IDs and symbols never become canonical identity.

The initial reconciliation mechanism is a human-maintained XML registry. It maps our identity to provider identity evidence.

Conceptually:

```xml
<instrument id="42" type="Equity" currency="USD">
    <mapping provider="databento"
             valid_from="2012-05-18"
             valid_until="2022-06-09">
        <symbol>FB</symbol>
        <venue>XNAS</venue>
        <provider_id>...</provider_id>
    </mapping>

    <mapping provider="databento"
             valid_from="2022-06-09">
        <symbol>META</symbol>
        <venue>XNAS</venue>
    </mapping>
</instrument>
```

Rules:

- `provider_id` is optional.
- validity is point-in-time and uses `[valid_from, valid_until)` semantics.
- one canonical instrument may have several historical provider mappings.
- a long canonical query may therefore split into several provider query segments.
- all returned canonical records are stamped with the same canonical `InstrumentId` where the mapping says they represent the same instrument.
- price similarity or AI may later help suggest/validate ambiguous mappings, but human-approved deterministic mapping is the ingestion authority.
- do not implement AI reconciliation now.

The exact XML parsing library is not yet accepted. Do not add an XML dependency silently.

## 6. Provider port and Databento adapter

The core uses a provider port. Databento is a concrete implementation behind that port.

```text
canonical query + provider mapping
              ↓
         ProviderPort
              ↓
       Databento adapter/client
              ↓
       canonical MBO batch
```

The Databento implementation owns translation into Databento dataset/schema/symbology/time-request concepts and normalization back into our `MboEvent`/typed MBO semantics.

Alpaca is only a ghost architectural check: interfaces must not contain Databento-only concepts that make an Alpaca implementation structurally impossible.

The exact Databento C++ client/dependency integration is not yet accepted. Do not add the SDK/client dependency silently.

## 7. Batch is the ingestion primitive

The pipeline works in batches. A single record is simply a batch of size one.

```text
provider batch
    ↓
normalize
    ↓
canonical batch
    ↓
validate / quality
    ↓
consumer
```

Do not require a whole historical request to fit in memory. The first synchronous implementation may process one batch at a time. Future backpressure/chunk sizes belong to execution/infrastructure policy.

## 8. Shared data-quality layer

Bad provider/ingestion results must not create a second quality model outside the canonical data architecture.

Use the existing canonical direction:

```text
provider / adapter
      ↓
canonical market records
      +
DataQualityObservation
      ↓
DataStateReducer
      ↓
DataState
```

Examples of quality evidence include degraded provider ranges, unavailable/missing ranges, corrupted input, sequence gaps, and validation failures.

Keep ingestion workflow state separate:

```text
IngestionJobState = running / failed / finished / future retry state
DataState         = quality/completeness of market data
```

`pending` provider/job workflow must not be confused with market-data quality.

The reducer/state vocabulary can start minimal and evolve from real evidence. Do not copy quality flags into every `MboRecord`.

## 9. Recovery is a policy boundary, not an implementation now

Preserve a recovery-policy seam so future code can decide among actions such as retry, repair missing ranges, abort, or no action.

The first implementation is a no-op policy:

```text
NoopRecoveryPolicy -> NoAction
```

Do not implement retry loops, backoff, scheduling, or repair workers.

## 10. Synchronous first; concurrency-aware, not concurrent

The first ingestor blocks until its logical query finishes.

```text
MarketDataQuery
      ↓
SynchronousIngestor
      ↓
result
```

Future asynchronous ingestion must reuse the same query, range, mapping, provider, validation, and quality semantics. Sync/async is an execution policy, not a separate domain model.

Avoid hidden global mutable state. Preserve source ordering evidence (`event_time`, `receive_time`, `sequence`, `channel_id`, flags). Processing completion order must never be assumed to equal market-event order.

A future parallel form may use a map/reduce-like pipeline:

```text
batches -> parallel map/normalize -> ordering/reduce -> consumer
```

No threading, queues, locks, or executors are added now.

## 11. Overlapping work: future coordinator

A future `IngestionCoordinator` may use the same range resolver to join active overlapping work and fetch only uncovered ranges.

For example:

```text
requested = [1,10)
active    = [5,8)

fetch [1,5)
join  [5,8)
fetch [8,10)
```

The synchronous first slice does not implement active-job tracking. Do not bake locks into cache/provider/domain objects in anticipation of it.

## 12. Partial results fall out of segmented coverage

A query may succeed for some segments and fail for others. Do not invent a separate transaction abstraction just for this.

```text
[1,5)   complete
[5,8)   complete
[8,10)  unresolved/degraded
```

`IngestionMetadata` + coverage segments + `DataState` represent this honestly. Future recovery can target only unresolved ranges.

## 13. Version evolution

Keep version identity in metadata so future code can decide whether to regenerate from raw provider data or run a migration on canonical/derived data.

Direction only:

```text
raw provider artifact -> prefer regenerate through newer adapter/model
canonical/derived     -> explicit migration only when needed
```

No migration framework or scripts now.

## 14. Storage/access/replay guardrail

Storage, database/file format, replay API, snapshots, and access indexes remain intentionally deferred.

Current ingestion code must therefore:

- not assume data lives in RAM forever;
- not expose file/database operations through domain/query interfaces;
- not make storage format define canonical meaning;
- produce bounded batches/segments;
- retain enough metadata/provenance for future persistence and replay.

Discuss storage/access/replay only when the current ingestion slice exposes a concrete need or incompatibility.

## Bottleneck tracker

| Concern | Accepted direction | Current status |
| --- | --- | --- |
| Cache tied to exact provider request | Cache canonical query coverage/ranges | Solved architecturally |
| Real cache implementation | `CachePort` + `NoopCache` always miss | Ghost |
| Cache backend coupling | Backend hidden behind cache port | Solved architecturally |
| Partial cache coverage | Segmented half-open ranges; patch missing pieces | Solved architecturally |
| Cache metadata | Generated by ingestion, not cache | Direction accepted |
| Staleness/invalidation | Preserve provider/version evidence; policy later | Deferred |
| Canonical/provider identity | Human-maintained mapping registry | Solved for first slice |
| Historical symbols/provider IDs | Time-aware mapping intervals | Solved architecturally |
| Automated/AI reconciliation | Candidate assistance only; human authority | Deferred |
| Provider leakage | Canonical query; Databento translation behind port | Solved architecturally |
| Missing/degraded/corrupt data | Shared quality observations -> `DataState` | Solved architecturally |
| Retry/repair | Recovery policy seam + no-op policy | Ghost |
| Huge MBO requests / RAM | Batch/chunk primitive | Solved architecturally |
| Backpressure | Enabled by batches; actual policy later | Deferred |
| Multithreading | Execution policy; no hidden global state | Architecture aware |
| Overlapping concurrent queries | Future resolver/coordinator join/split model | Solved architecturally, implementation deferred |
| Parallel ordering | Future map/reduce-like ordering stage | Direction accepted |
| Sync vs async | Shared pipeline; synchronous first | Solved architecturally |
| Partial query failure | Coverage + quality state | Falls out naturally |
| Schema/model evolution | Version metadata; regenerate/migrate later | Future direction |
| Storage/access/replay | Do not couple current boundaries to them | Intentionally deferred |

## Provider source checks

Primary Databento documentation checked for the provider-dependent parts of this design:

- Schemas/data formats: `https://databento.com/docs/knowledge-base` — MBO is L3, MBP-10 is L2, MBP-1 is L1.
- MBO schema: `https://databento.com/docs/schemas-and-data-formats/mbo` — order-ID-keyed events and ordering/provenance fields.
- Symbology: `https://databento.com/docs/standards-and-conventions/symbology` — historical symbol mappings are point-in-time and expose mapping intervals.
- Historical dataset condition: `https://databento.com/docs/api-reference-historical/basics/authentication` — availability/quality conditions and `last_modified_date` exist and are provider evidence, not canonical state definitions.

## Implementation gate

The next implementation is the generic synchronous ingestion skeleton described in `docs/project/opencode-handoff.md`.

Do not implement the real Databento dependency or XML parser until the generic skeleton is reviewed and the exact dependency choice is approved. If implementation reveals a contradictory boundary, hidden provider requirement, major performance trade-off, or a need to restructure existing code, stop and raise one focused engineering-manager question instead of silently resolving it.
