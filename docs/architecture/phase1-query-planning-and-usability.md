# Phase 1 Query Planning and Data Usability

## Status

- **Accepted:** 2026-09-06 query planning and usability are consumer-facing ingestion boundaries.
- **Implemented:** The first synchronous path uses the shared query planner for both `explain()` and provider execution.
- **Implemented:** Usability is an injected policy over factual `DataStateSegment` values.

This document supplements `phase1-historical-ingestion.md` and `phase1-ingestion-iteration-close.md`.

## Goal

Make the mapping/fetch decisions used by synchronous execution inspectable without creating a second execution engine or changing canonical market-data meaning.

```text
MarketDataQuery
      |
      v
QueryPlanner
      |
      +--> QueryPlan / explain
      |
      v
ProviderPort calls
      |
      v
canonical observations and factual DataState
      |
      v
DataUsabilityPolicy for consumer decisions
```

## QueryPlan

`QueryPlan` retains the original `MarketDataQuery` and the cache-missing ranges. Each planned segment contains:

- the resolved event-time `ProviderMappingSegment`;
- a canonical provider query clipped to that event-time mapping interval;
- a provider fetch range expressed with canonical `TimeBasis` and `TimeRange`;
- post-fetch event-time and source-receive-time filters.

The planner preserves half-open ranges, deterministic mapping order, optional venue/source scope, unmapped ranges, and mapping-overlap validation. A source-receive-time-only query is rejected because mapping validity remains event-time based.

When an explicit source-receive range is present, it is the provider fetch range. When event time is the only range and derivation is selected, the planner expands the event range by the configured margin and exposes the derived source-receive fetch range. Strict fetch policy fails before provider execution when that explicit range is absent.

These are canonical planning concepts. Databento date formatting, schema, dataset, and request objects remain inside the Databento adapter. The adapter reuses the same canonical fetch-range resolution used by the plan.

`SynchronousIngestor::explain()` and `SynchronousIngestor::ingest()` both call `QueryPlanner`; explain does not execute provider calls and does not introduce a separate execution model.

## Data usability

`DataStateSegment` remains the factual range-local quality/completeness result. `DataUsabilityPolicy` is injected into the ingestor and classifies a segment for a particular query as usable or unusable without changing the segment.

The initial policy is:

```text
Complete  -> usable
Degraded  -> usable
Unknown   -> unusable
Missing   -> unusable
Corrupt   -> unusable
```

The policy determines `actual_coverage` and `unresolved_ranges` in the result metadata. It does not reduce, rewrite, or override `DataState`.

## Invariants

- Mapping resolution uses event time only.
- Both time ranges remain post-fetch constraints when present.
- Provider calls follow the same planned segment order shown by explain.
- Provider-specific concepts do not enter `MarketDataQuery`, `QueryPlan`, or `DataUsabilityPolicy`.
- No cache persistence, storage, retry, async, concurrency, batching, or new provider dependency is introduced.

## Verification

The framework-free tests cover one segment, mapping-boundary splitting, dual ranges, receive-only rejection, strict fetch policy, provider-range derivation, policy substitution, and equality between the explained plan and `FakeProvider` calls.
