# Phase 1 Historical Ingestion — Iteration Close Decisions

## Status

Accepted engineering-manager decisions from the 2026-09-05 review of the synchronous ingestion skeleton.

This document supplements `docs/architecture/phase1-historical-ingestion.md`. Where the older document or review notes conflict with this file, this file is the current decision for this iteration.

## 1. Unknown coverage remains unresolved

Event presence is not coverage evidence.

For a requested interval with valid records but no explicit provider/adapter coverage or quality evidence:

```text
actual coverage = not proven
state           = Unknown
unresolved      = yes
```

`Unknown` and `Missing` remain distinct:

- `Unknown`: insufficient evidence.
- `Missing`: explicit evidence that data is missing.

`unresolved_ranges` means "not proven fully resolved". It does not itself mean that recovery must retry.

## 2. Preserve segmented data state

A logical query must not destroy range-local information by collapsing all quality into one worst global state.

The canonical result must preserve normalized state segments so different intervals can independently be `Complete`, `Unknown`, `Degraded`, `Missing`, or `Corrupt`.

Required properties:

- ordered;
- non-overlapping within the same state scope;
- adjacent equivalent segments may be merged;
- fast point/range lookup;
- fast extraction/grouping of usable versus unusable ranges according to policy.

The exact physical index/container is an implementation choice. Prefer the smallest contiguous/sorted representation first; do not introduce a tree or complex index without a measured need.

A single aggregate state may exist only as a derived summary. It must not replace or erase the segmented state representation.

## 3. Instrument identity spans venues

One canonical `InstrumentId` identifies the economic/trading instrument across venue observations. `VenueId` distinguishes the venue on which a record occurred. `SourceId` distinguishes the source/feed.

Therefore the same canonical instrument may legitimately produce several stream scopes:

```text
InstrumentId 42 + VenueId 1 + SourceId 9
InstrumentId 42 + VenueId 2 + SourceId 9
```

The canonical identity must not be duplicated merely because venue differs.

## 4. Preserve one physical MBO buffer per stream scope

`MboBuffer` remains single-scope and its 64-byte record layout remains unchanged.

A logical ingestion result may contain multiple existing `MboBuffer` instances, one per distinct `MboStreamContext` (`InstrumentId`, `VenueId`, `SourceId`).

Do not coerce records from different stream scopes into one buffer. Preserve provider-valid ordering within each stream; do not invent a global order across independent streams.

Implementation guardrail: quality/range state must retain enough scope to avoid collapsing different venue/source states that overlap in time. If the existing types cannot express this without introducing a new canonical scope type, stop and ask the engineering manager before inventing it.

## 5. Batch/producer-consumer direction remains unchanged

The ingestion primitive remains producer -> batch -> consumer.

For the current synchronous slice, one provider request producing one `ProviderBatch` is accepted. A batch of one record is still a batch.

Do not redesign the provider port into async/queues/coroutines now. Later, if real historical requests require finer memory bounds, one request may emit several bounded batches without changing the producer/consumer architecture.

## 6. Recovery remains an injected policy

Recovery must remain abstract and injected into the ingestor.

The current boolean input is too weak. Recovery should receive a structured context carrying the unresolved/state information it needs and return a structured plan/action.

Conceptually:

```text
segmented state + unresolved ranges
              ↓
       RecoveryContext
              ↓
     injected RecoveryPolicy
              ↓
        RecoveryPlan
```

`NoopRecoveryPolicy` remains the first concrete implementation and returns no action.

Do not implement retry loops, backoff, scheduling, provider fallback, or repair workers in this iteration.

## 7. Source artifact provenance is plural and range-aware

A logical query may be satisfied by several provider artifacts. Metadata must not assume one optional artifact identity for the entire result.

Represent source artifacts as a collection. Each entry must carry at least:

- artifact identity/checksum/reference;
- the canonical range it supports.

Additional provider/source metadata may be attached only when already available and useful. Do not introduce persistence/storage handles.

## 8. Current implementation targets

The next maintenance implementation should:

1. mark evidence-free `Unknown` intervals as unresolved;
2. replace single-result MBO storage with multiple single-scope `MboBuffer` instances;
3. preserve segmented range state instead of reducing the result to one authoritative worst state;
4. replace the recovery boolean with an injected structured context/plan seam;
5. replace the single optional source artifact identity with range-aware plural provenance;
6. preserve the current synchronous one-request/one-batch provider behavior;
7. keep Databento, XML, storage, cache persistence, retry execution, async, and concurrency deferred.

After those corrections are reviewed and verified, dependency review for Databento and XML can begin.
