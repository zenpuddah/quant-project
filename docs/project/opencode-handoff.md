# OpenCode Handoff — Phase 1 Synchronous Ingestion Skeleton

## Goal

Implement the smallest testable synchronous ingestion skeleton that proves the accepted boundaries in `docs/architecture/phase1-historical-ingestion.md` without adding Databento/XML dependencies or real cache/storage/retry/concurrency infrastructure.

## Architecture

The first executable slice is:

```text
MarketDataQuery
      ↓
RangeResolver
      ↓
CachePort / NoopCache
      ↓
InstrumentMappingRegistry port
      ↓
ProviderPort
      ↓
canonical MBO batch
      ↓
validation + quality observations
      ↓
DataState reduction
      ↓
IngestionResult
```

Use deterministic test doubles for provider/mapping behavior. Production Databento and XML parsing come only after this skeleton is reviewed.

## Engineering-manager boundary

The repository owner is the engineering manager for architecture/product decisions. OpenCode is the implementation agent.

Do not silently redesign accepted boundaries. If the implementation reveals any of the following, stop and ask one focused question before proceeding:

- an interface cannot represent a real required case;
- existing code contradicts the accepted ingestion design;
- a new external dependency is required;
- Databento semantics force a provider concept into the canonical query;
- a change would restructure the current data model;
- a performance optimization requires concurrency, storage, or ownership changes;
- an accepted ghost/deferred component must become real to continue.

Do not turn a deferred idea into infrastructure just because it is easy to code.

## Global constraints

- C++20.
- Keep current framework-free testing style unless an accepted repository change says otherwise.
- No build-system decision in this slice.
- No external dependencies in this slice.
- No Databento SDK/client integration yet.
- No XML parser yet.
- No real cache backend or cache persistence.
- No storage/access/replay implementation.
- No asynchronous or multithreaded code.
- No retry/backoff/repair loops.
- No Alpaca implementation.
- L3/MBO only for executable ingestion behavior.
- Preserve existing `quant::data` semantics and do not change the 64-byte `MboRecord` layout unless the engineering manager explicitly approves it.

---

## Task 1 — Canonical query and range primitives

### Files

Create:

- `src/quant/ingestion/query.hpp`
- `tests/ingestion_query_tests.cpp`

### Required concepts

Implement a small `quant::ingestion` domain layer containing:

```cpp
struct TimeRange {
    data::Timestamp start;
    data::Timestamp end;
};

enum class MarketDataLevel {
    L1,
    L2,
    L3,
};

struct MarketDataQuery {
    data::InstrumentId instrument_id;
    std::optional<data::VenueId> venue_id;
    MarketDataLevel level;
    TimeRange range;
};
```

Rules:

- ranges use `[start, end)` semantics;
- reject/flag `end <= start` at the boundary using the same project style as existing value/reference validation;
- `MarketDataQuery` contains no Databento dataset/schema/symbology fields;
- first executable provider behavior will support only `L3`, but keep the enum so the canonical intent is explicit.

Add pure range helpers sufficient for later cache/coordinator use:

```cpp
bool overlaps(TimeRange lhs, TimeRange rhs);
std::optional<TimeRange> intersection(TimeRange lhs, TimeRange rhs);
std::vector<TimeRange> subtract(TimeRange requested, std::span<const TimeRange> covered);
```

`subtract` must return ordered non-overlapping missing ranges and correctly handle adjacent half-open intervals.

### Tests

Cover at least:

- invalid range;
- no overlap;
- full coverage;
- partial prefix/suffix coverage;
- a hole in the middle;
- multiple adjacent covered ranges;
- overlapping covered ranges;
- exact endpoint adjacency.

Compile/run with the repository's current warnings-as-errors C++20 style.

Commit after this task if working locally.

---

## Task 2 — Cache and recovery ghost boundaries

### Files

Create:

- `src/quant/ingestion/cache.hpp`
- `src/quant/ingestion/recovery.hpp`
- `tests/ingestion_ports_tests.cpp`

### Cache contract

Define a cache lookup result that can evolve beyond boolean hit/miss:

```cpp
enum class CacheStatus {
    Miss,
    FullHit,
    PartialHit,
};

struct CacheLookup {
    CacheStatus status;
    std::vector<TimeRange> covered;
    std::vector<TimeRange> missing;
};

class CachePort {
public:
    virtual ~CachePort() = default;
    virtual CacheLookup lookup(const MarketDataQuery& query) = 0;
};
```

Implement:

```cpp
class NoopCache final : public CachePort
```

Behavior:

- always `Miss`;
- `covered` empty;
- `missing` contains exactly `query.range`.

Do not add cache writes yet; their artifact/storage contract is intentionally unresolved.

### Recovery contract

Define a minimal policy seam:

```cpp
enum class RecoveryAction {
    NoAction,
    Retry,
    RepairMissingRanges,
    Abort,
};

class RecoveryPolicy {
public:
    virtual ~RecoveryPolicy() = default;
    virtual RecoveryAction decide(/* minimal result/quality input */) const = 0;
};
```

Choose the smallest concrete input that can be expressed using types accepted in later tasks. Do not invent scheduler/backoff types.

Implement:

```cpp
class NoopRecoveryPolicy final : public RecoveryPolicy
```

which always returns `NoAction`.

If defining the `RecoveryPolicy` input before Task 3 would force placeholder types or a bad dependency, move only the interface finalization to Task 3 and ask before inventing a workaround.

### Tests

- `NoopCache` always misses the full canonical range.
- `NoopRecoveryPolicy` returns `NoAction` for every currently representable result state.

---

## Task 3 — Shared ingestion/data quality representation

### Files

Create:

- `src/quant/ingestion/quality.hpp`
- `tests/data_quality_tests.cpp`

### Requirement

Do not create a separate Databento-only quality model. Quality evidence must be provider-independent after translation.

Start with a deliberately small vocabulary based on the cases already accepted:

```cpp
enum class DataQualityKind {
    Complete,
    Degraded,
    Missing,
    Corrupt,
    SequenceGap,
};

struct DataQualityObservation {
    TimeRange range;
    DataQualityKind kind;
};
```

Represent reduced state separately from observations. Keep the reducer pure and deterministic.

A minimal reduced vocabulary is acceptable if it can distinguish healthy/complete, degraded, missing, invalid/corrupt, and unknown/no-evidence states. Do not add provider-specific condition strings to the canonical enum; provider evidence can later live in provenance metadata.

The reducer must not write quality flags into every `MboRecord`.

### Tests

Cover:

- complete evidence;
- degraded evidence;
- missing evidence;
- corrupt evidence taking precedence over healthy evidence for an overlapping range;
- sequence-gap evidence producing a compromised/degraded state;
- no evidence producing an explicit unknown state rather than pretending the range is healthy.

If the exact precedence rule becomes ambiguous while implementing overlapping quality observations, stop and ask the engineering manager instead of inventing a complex state machine.

---

## Task 4 — Ingestion metadata and result envelope

### Files

Create:

- `src/quant/ingestion/result.hpp`
- `tests/ingestion_result_tests.cpp`

### Requirement

Keep request intent separate from observed outcome.

Define an `IngestionMetadata` capable of carrying the information accepted now without choosing storage:

- original `MarketDataQuery`;
- actual coverage segments;
- quality observations/reduced state;
- provider/source identity using existing `SourceId`/source metadata concepts where appropriate;
- ingestion timestamp;
- lightweight version identity fields for adapter, canonical schema, and mapping/config.

Do not introduce filesystem paths, database IDs, DBN objects, or storage handles as mandatory fields.

Source-artifact checksum/identity should be optional because the fake first slice has no provider artifact.

Define an `IngestionResult` for the L3 first slice containing canonical MBO output plus metadata. Prefer reuse of the existing `MboBuffer`/`MboRecordView` data-model boundary rather than creating a second physical MBO representation.

If a single `MboBuffer` cannot correctly represent the accepted query/result scope because venue/source segmentation is required, stop and ask before changing the current buffer or hiding the issue.

### Tests

- requested range and actual coverage are distinct;
- a partial result can represent covered and unresolved/degraded segments honestly;
- metadata version fields round-trip;
- no storage dependency is required.

---

## Task 5 — Provider and mapping ports with deterministic fakes

### Files

Create:

- `src/quant/ingestion/provider.hpp`
- `src/quant/ingestion/instrument_mapping.hpp`
- `tests/ingestion_provider_tests.cpp`

### Instrument mapping contract

Define an interface that can later be backed by XML but does not depend on an XML library now.

It must support the direction needed by ingestion:

```text
InstrumentId + provider + query range
        ↓
one or more provider mapping segments
```

A provider mapping segment needs enough provider-neutral envelope information to represent:

- canonical `InstrumentId`;
- provider identity/name;
- symbol when present;
- venue/listing evidence when present;
- optional provider ID;
- `[valid_from, valid_until)` interval.

Do not make Databento `stype_in`, dataset, schema, or API-specific types part of the canonical mapping interface.

Create only an in-memory deterministic fake/test mapping implementation in this slice.

### Provider port

Define the smallest provider port that lets the synchronous ingestor request one resolved L3 range and receive canonical MBO data + provider quality/provenance evidence.

The port must not expose Databento request structs to callers.

Use a deterministic fake provider in tests. Do not create a fake Alpaca production class merely for symmetry.

### Tests

- one canonical instrument maps to one provider segment;
- one canonical instrument can map to two historical segments across a symbol/provider-ID change;
- optional provider ID is truly optional;
- a query spanning a mapping boundary splits into the two correct half-open provider segments;
- provider fake returns canonical MBO semantics without provider-specific types escaping the port.

---

## Task 6 — Synchronous ingestor orchestration

### Files

Create:

- `src/quant/ingestion/synchronous_ingestor.hpp`
- `tests/synchronous_ingestor_tests.cpp`

### Dependencies

Inject ports/policies explicitly. No service locator and no hidden singleton/global state.

The ingestor should depend on the abstractions created above, conceptually:

```text
CachePort
InstrumentMappingRegistry
ProviderPort
DataState reducer
RecoveryPolicy
```

### First-slice behavior

For an L3 query:

1. validate canonical query/range;
2. ask cache; current production ghost returns full miss;
3. resolve missing canonical ranges against historical provider mappings;
4. synchronously fetch each provider segment in deterministic order;
5. preserve provider ordering evidence already represented by `EventHeader`;
6. validate returned canonical MBO events using the existing data-model validation rules;
7. accumulate data-quality observations;
8. write valid canonical MBO data through the existing typed/logical MBO boundary into `MboBuffer` when scope permits;
9. reduce quality state;
10. produce `IngestionResult` + `IngestionMetadata`;
11. consult the no-op recovery policy but perform no retry/repair action.

Do not add threads, futures, callbacks, coroutine APIs, worker pools, locks, queues, or a map/reduce implementation.

Unsupported `L1`/`L2` queries must return/raise an explicit unsupported-level result using the project's normal error style; do not silently map them to another provider schema.

### Tests

Use only fakes/no-op implementations. Cover:

- full cache miss -> one provider range -> result;
- historical mapping boundary -> two provider calls -> one logical result;
- provider degraded/missing segment -> quality metadata reflects it;
- validation failure becomes quality evidence and does not silently enter the valid MBO buffer;
- provider output order is preserved in synchronous mode;
- `NoopRecoveryPolicy` causes no extra fetch;
- L1/L2 currently fail explicitly;
- no provider-specific request fields appear in caller-facing query/result types.

---

## Stop point after Task 6

Run every existing data-model test plus all new ingestion tests with warnings as errors.

Then stop. Do not start the real Databento adapter or XML parser.

Report to the engineering manager:

1. exact files added/modified;
2. all test commands and results;
3. any place where the fake implementation exposed an awkward boundary;
4. whether `MboBuffer` scope caused any result-shape issue;
5. proposed choices for the Databento C++ client integration and XML parsing library, with trade-offs, before adding either dependency.

The next approved iteration will connect the generic skeleton to real Databento MBO and the XML registry.
