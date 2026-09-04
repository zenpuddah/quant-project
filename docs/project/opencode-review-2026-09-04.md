# OpenCode Review — Synchronous Ingestion Skeleton

## Status

The generic synchronous ingestion skeleton from Tasks 1–6 has been reviewed after implementation.

**Direction is accepted:** the provider-independent query, range math, cache/recovery seams, historical mapping boundary, provider port, quality observations, metadata envelope, and synchronous orchestration are the right overall structure.

**Do not start the real Databento adapter or XML parser yet.** The review exposed one required semantic correction, one future-facing provider-boundary constraint, and one unresolved engineering-manager decision.

## 1. Required correction — event count is not data-quality evidence

The current orchestration infers quality from the presence or absence of MBO events:

```text
valid events + no explicit quality evidence -> Complete
zero events + no explicit quality evidence  -> Missing
```

This contradicts the already accepted `DataState` model. An empty interval can mean either no market activity or unavailable data, and event presence alone does not prove complete interval coverage.

The required rule is:

```text
explicit provider/adapter coverage or quality evidence
        -> Complete / Degraded / Missing / Corrupt / ...

no explicit coverage/quality evidence
        -> Unknown
```

Consequences for the next narrow maintenance change:

- valid MBO events with no explicit quality/coverage evidence may still enter the valid canonical `MboBuffer`, but the interval must not be synthesized as `Complete` merely because events exist;
- zero MBO events with no explicit quality/coverage evidence must not be synthesized as `Missing`; the state remains `Unknown`;
- zero events plus explicit `Complete` coverage evidence is a valid complete result;
- explicit `Missing`, `Degraded`, `SequenceGap`, or `Corrupt` evidence continues to drive `DataState`;
- tests must distinguish market inactivity from missing data and must not use event count as a completeness oracle.

This is a correction back to accepted architecture, not a new design expansion.

## 2. Provider boundary must remain chunk-capable

The current fake provider API returns one materialized `ProviderBatch` containing `std::vector<MboEvent>`. That is acceptable for proving the synchronous orchestration with deterministic fakes.

It is **not** accepted as the final real-Databento ingestion shape for large L3 histories. The accepted architecture says batch/chunk processing is the primitive and a whole historical request must not be assumed to fit in memory.

Before implementing the real Databento adapter, propose the smallest chunk-capable provider/consumer shape to the engineering manager. Do not add threads, queues, async machinery, storage, or backpressure infrastructure merely to solve this. The requirement is only that the real adapter must be able to emit/consume bounded batches incrementally rather than forcing full-request materialization.

## 3. Engineering-manager decision required — `InstrumentId` versus venue listing

The implementation exposed a real unresolved boundary:

```text
MarketDataQuery
  InstrumentId = X
  venue = unspecified
        ↓
historical mapping may resolve multiple venue/source scopes
        ↓
current IngestionResult owns one optional MboBuffer
        ↓
MboBuffer owns one InstrumentId/VenueId/SourceId stream context
```

The current skeleton correctly stops by rejecting mixed stream scopes rather than silently changing the 64-byte MBO representation.

Do not change `MboBuffer`, create a multi-buffer result, or redefine identity until the engineering manager answers:

> Should one canonical `InstrumentId` represent one specific tradable venue listing, or can one `InstrumentId` span several venue listings of the same economic security?

This decision determines whether a single-stream `IngestionResult` is the correct canonical result shape or only a temporary Phase 1 restriction.

## Current implementation position

```text
Canonical market-data model                 implemented
Concrete fixed-scale/64-byte MBO model      implemented
Historical ingestion architecture           accepted
Generic synchronous ingestion skeleton      implemented
Post-implementation architecture review     completed

Next narrow correction:
  event-count != quality inference

Then engineering-manager decision:
  InstrumentId/listing scope

Then dependency review:
  Databento client approach
  XML parser approach

Only after those gates:
  real Databento historical MBO adapter
  XML-backed mapping registry
```

## OpenCode execution rules from this checkpoint

If asked to continue implementation now:

1. Read `AGENTS.md`, `docs/project/context.md`, `docs/architecture/phase1-historical-ingestion.md`, `docs/project/opencode-handoff.md`, and this review.
2. The only pre-approved maintenance change is removing event-count-based `Complete`/`Missing` inference and updating the corresponding tests while preserving the rest of the skeleton.
3. Do not add Databento/XML dependencies yet.
4. Do not redesign the provider API into a concrete streaming/chunk framework yet; first propose the minimum chunk-capable boundary when real-provider integration is about to begin.
5. Do not change the single-stream `MboBuffer`/result shape until the engineering manager resolves the identity/listing question.
6. If implementation reveals another contradiction or major trade-off, stop and ask one focused question.
