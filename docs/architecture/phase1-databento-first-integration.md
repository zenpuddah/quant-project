# Phase 1 Databento First Integration

## Status

Accepted engineering-manager decisions from the 2026-09-05 Databento integration brainstorming session.

This document extends the existing historical-ingestion architecture. It defines the first real provider vertical slice only. XML-backed mapping, storage/replay, retry execution, async execution, and production batching remain deferred.

## Goal

Prove the first real end-to-end market-data path:

```text
MarketDataQuery
      ↓
manual/in-memory provider mapping
      ↓
Databento historical MBO request
      ↓
Databento adapter / interpreter
      ↓
canonical observations + quality evidence
      ↓
SynchronousIngestor
      ↓
MboBuffer(s) + metadata/state
```

The first test target is a deliberately small historical request, roughly one to two trading days, so the current one-request/one-batch implementation can be exercised before adding bounded multi-batch streaming.

## 1. Official Databento C++ client

Use the official `databento-cpp` historical client for the first real provider implementation.

The provider-specific SDK remains behind `ProviderPort`; no Databento request concepts should leak into canonical query/domain types except where the canonical model independently needs the concept.

Databento's official documentation recommends CMake `FetchContent` and requires CMake 3.24+, OpenSSL 3+, libcrypto, and zstd. The repository currently has no accepted repo-wide build-system migration. Keep dependency/build integration minimal and isolated; do not silently redesign the whole repository build.

## 2. Dual time semantics in MarketDataQuery

The canonical query must preserve both exchange-event time and provider-receive time.

Conceptually:

```text
MarketDataQuery
├── event_time_range      optional
├── receive_time_range    optional
├── fetch policy
└── optional derivation margin
```

Rules:

- at least one time range must be present;
- event time is the default/primary semantic for ordinary canonical queries;
- if only event time is supplied, an adapter whose provider filters on receive time may derive a receive-time fetch range;
- the derivation behavior is explicit through query policy rather than hidden adapter behavior;
- the query may provide before/after safety margin for that derived provider range;
- if the strict/explicit policy is selected and the provider requires a missing time basis, fail before making the provider request;
- if both event-time and receive-time ranges are explicitly present, returned records must satisfy both;
- preserve both timestamps in canonical observations whenever the provider supplies both.

Databento historical `timeseries.get_range` filters `start`/`end` on `ts_recv` when the schema contains it, otherwise on `ts_event`. MBO contains both.

## 3. Databento MBO actions are interpreted, not blindly enum-mapped

Do not perform an independent one-record-to-one-`MboAction` translation for all Databento MBO actions.

Databento MBO includes Add, Cancel, Modify, Clear, Trade, Fill, and None. On `XNAS.ITCH`, an exchange Order Executed is normalized as:

```text
Trade -> Fill -> Cancel
```

The `Cancel` is the actual displayed-book quantity mutation. Treating both Fill and Cancel as executable book mutations would double-count the execution.

Accepted direction:

```text
provider-native event group
        ↓
provider-specific interpreter
        ├── canonical Trade observation
        ├── canonical OrderExecution observation
        └── canonical MBO book mutation
```

Principle:

```text
prefer provider-supplied semantics
preserve the richest native information
synthesize only canonical information that is genuinely missing
never recompute/apply a book mutation already supplied by the provider
```

## 4. Canonical OrderExecution observation

Add a provider-neutral, optional first-class execution/fill observation rather than leaking the Databento name `Fill` into the core.

Conceptually it carries execution evidence such as:

```text
OrderExecution
├── header / instrument / venue / source / timestamps
├── resting order id, when known
├── executed quantity
├── execution/trade price, when supplied/meaningful
├── trade/match identity, when available
└── aggressor identity, when available
```

The exact minimal field set should follow actual Databento records and existing canonical types; do not invent fields merely for future providers.

`OrderExecution` represents execution evidence. `MboAction` remains the book-mutation vocabulary.

## 5. Identity translation remains manual for the first slice

For now, use the existing deterministic in-memory/manual mapping direction.

```text
Databento instrument_id
        ↓
canonical InstrumentId

Databento publisher/dataset identity
        ↓
canonical VenueId + SourceId
```

Databento IDs remain provider-native evidence and must not become canonical identity.

XML-backed mapping remains deferred until the real Databento path works.

## 6. Databento quality evidence feeds canonical DataState

Use provider evidence plus record/channel evidence plus our own validation.

Databento `MetadataGetDatasetCondition` provides a daily dataset condition:

```text
available
  -> data available with no known issues

degraded
  -> available, but may contain missing/correctness issues

pending
  -> not yet available; may become available later

missing
  -> unavailable
```

`last_modified_date` is provenance/version evidence, not a DataState by itself.

Initial canonical interpretation:

```text
available + successful request + validation passes + no known bad-book evidence
    -> Complete

degraded
    -> Degraded

pending
    -> Unknown

missing
    -> Missing

our structural/unusable validation failure
    -> Corrupt
```

Record/channel flags may worsen the result. In particular, bad-book/gap evidence can degrade a range. Receive-timestamp-quality evidence should affect receive-time quality and must not automatically mean that the book itself is corrupt.

Do not infer completeness from event count.

## 7. Provider/API failure is ingestion failure, not market-data knowledge

Infrastructure/API failures must stay outside canonical `DataState`.

Examples:

```text
timeout
HTTP/server failure
rate limit
authentication failure
entitlement failure
```

These mean the ingestion operation failed to obtain evidence. They do not mean the market data is `Missing` or canonically `Unknown`.

Accepted rule:

```text
provider/API failure
      ↓
ingestion/query operation failure
      ↓
recovery/retry policy layer

NOT
      ↓
canonical DataState evidence
```

Do not commit an incomplete failed ingestion as authoritative knowledge. Data already fetched before a failure may remain staged/temporary until the ingestion operation is accepted. Exact partial-result/failure-envelope mechanics can be refined when the first real SDK error path is encountered.

## 8. Existing canonical field representation is sufficient

The existing canonical record model already has the needed primary MBO fields:

```text
ts_event      -> event_time
ts_recv       -> receive_time
sequence      -> sequence
channel_id    -> channel_id
flags         -> source_flags
price         -> Price
size          -> Quantity
order_id      -> OrderId
```

Price normalization is particularly direct because Databento price uses signed integer nanounits and canonical `Price` already uses scale 9.

Field conversion is adapter implementation, not a new architecture problem unless real data exposes an incompatibility.

## 9. Provider-specific metadata uses a sidecar/component

Do not widen the 64-byte `MboRecord` for Databento-only fields, control information, or native identifiers.

Preserve provider-specific evidence outside the hot physical record through an attached/referenceable metadata component or sidecar.

Guideline:

```text
event-specific provider metadata
    -> sidecar/reference

stream/batch-level provider metadata
    -> store once, reference by identity
```

The canonical observation remains provider-independent while source evidence remains recoverable.

Do not build a generic plugin/metadata framework before the first concrete Databento fields justify its exact shape.

## 10. First batching/execution mode stays simple

For the first real integration:

```text
1 Databento request
      ↓
1 ProviderBatch
      ↓
existing synchronous consumer
```

Constrain integration tests to roughly one to two days of data.

This is a development simplification, not a permanent memory model.

Databento supports incremental pull/callback consumption, so later the same provider request can produce several bounded batches:

```text
1 provider request
      ↓
ProviderBatch 1
ProviderBatch 2
...
```

Keep producer -> batch -> consumer as the architectural boundary.

The first implementation may use the simplest synchronous/pull SDK path internally. Synchronous pull must remain an adapter/execution choice, not a canonical/provider-port semantic requirement. Future async/callback/concurrent execution reuses the same query, canonical records, batch semantics, validation, and quality model.

## 11. First vertical-slice guardrails

Implement only enough to prove:

```text
canonical query
-> real Databento historical XNAS MBO request
-> manual identity mapping
-> Databento record interpretation
-> canonical MBO / Trade / OrderExecution observations
-> quality evidence
-> existing ingestion result
```

Keep deferred:

- XML parser/registry;
- multi-batch production streaming;
- async/concurrency;
- retry loops/backoff/provider fallback;
- storage/replay/cache persistence;
- L1/L2 provider support;
- repo-wide build-system redesign;
- generalized provider-metadata framework beyond what the first adapter needs.

If real Databento records expose a contradiction with the accepted canonical boundaries, stop and raise one focused engineering-manager question rather than silently redesigning the model.

## Provider documentation checked

- Historical API and request time semantics: `https://databento.com/docs/api-reference-historical`
- C++ historical consumption/API: `https://databento.com/docs/api-reference-historical/helpers/console-log-receiver-receive?historical=cpp&live=cpp`
- MBO schema: `https://databento.com/docs/schemas-and-data-formats/mbo`
- XNAS TotalView-ITCH normalization: `https://databento.com/docs/venues-and-datasets/xnas-itch`
- Official C++ quickstart/build integration: `https://databento.com/docs/getting-started/build-first-app?historical=cpp&live=cpp`
