# OpenCode Review — Ingestion Iteration Close

## Read first

Read:

- `AGENTS.md`
- `docs/project/context.md`
- `docs/architecture/phase1-historical-ingestion.md`
- `docs/architecture/phase1-ingestion-iteration-close.md`
- `docs/project/opencode-handoff.md`
- `docs/project/opencode-review-2026-09-04.md`

The 2026-09-05 iteration-close architecture is the current authority where older notes conflict.

## Current implementation mismatches found in second review

The current code still has these temporary skeleton constraints:

1. `Unknown` intervals can have empty `unresolved_ranges` even though coverage is not proven.
2. `IngestionResult` owns one optional `MboBuffer`, so mixed venue/source stream scopes are rejected.
3. `IngestionMetadata` owns one aggregate `DataState`, which can collapse range-local states.
4. `RecoveryPolicy::decide(bool)` loses the reason/state behind unresolved data.
5. `source_artifact_identity` is one optional string, so segmented provenance cannot be represented.
6. `SynchronousIngestor` rejects overlapping mapping ranges globally, even though the same `InstrumentId` may legitimately have simultaneous mappings for different venue streams.
7. The fake provider returns one materialized batch per request. This is accepted for the current synchronous slice and is not a bug to fix now.

## Accepted engineering-manager decisions

- Same `InstrumentId` may appear on multiple venues; `VenueId` distinguishes venue and `SourceId` distinguishes feed/source.
- Keep the existing single-scope `MboBuffer` representation and 64-byte record unchanged.
- A logical ingestion result may contain multiple `MboBuffer`s, one per distinct stream context.
- Preserve range-local quality/state; do not make one worst aggregate state authoritative.
- Evidence-free `Unknown` intervals remain unresolved.
- Recovery stays injected and abstract; replace the boolean input with a structured context/plan seam, but keep only `NoopRecoveryPolicy` concrete.
- Source artifact provenance becomes a range-aware collection.
- Keep producer -> batch -> consumer. For now, one provider request -> one batch is accepted.
- No Databento/XML/storage/cache persistence/retry execution/async/concurrency in this maintenance pass.

## Implementation guardrail

Quality/range state must retain enough scope to distinguish overlapping venue/source streams. If the existing canonical types cannot express this without introducing a new scope identity/type, stop and ask one focused engineering-manager question before inventing that type.

## Required verification

Update/add tests for at least:

- valid events + no quality evidence -> `Unknown` and requested interval unresolved;
- zero events + no quality evidence -> `Unknown` and requested interval unresolved;
- explicit `Complete` evidence -> resolved coverage;
- same `InstrumentId` with two `VenueId`s -> two stream buffers, not rejection;
- distinct source stream contexts remain separate;
- ordering preserved within each stream;
- multiple source artifacts with different ranges round-trip in metadata;
- recovery policy receives structured state/unresolved context and `NoopRecoveryPolicy` returns no action;
- range-local states are preserved without destructive worst-state collapse;
- L1/L2 remain explicitly unsupported;
- all existing data-model and ingestion tests still pass with warnings-as-errors.

Do not start the real Databento adapter or XML parser after this pass. Stop and report for engineering-manager review.
