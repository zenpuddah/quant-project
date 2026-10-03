# Data-integrity implementation plan

Base: `95993a8`; branch: `implementation/data-integrity-2026-10-03`. Authority: accepted recap and handoff. Concrete mechanisms: `docs/architecture/phase1-data-integrity-implementation.md`.

## Reviewable slices

1. **Specification checkpoint:** Record formats, ownership, identities, ordering, complete publication and eligibility before production changes.
2. **Domain integrity and preparation:** Compact StreamId/catalog/reference snapshot, acquisition/ordinal/evidence types, canonical validation and dependency-aware consumer gate; strict standalone regressions.
3. **Provider retention and order:** Full normalized record capture before selection, raw association/ordinal, targeted XNAS checking across chunks, retained decode failures, inclusive daily-condition requests/day clipping; deterministic provider tests.
4. **Bound Arrow interchange:** Versioned StreamId/ordinal columns, original-context binding and row association, financial/control/schema checks. Reject unchecked legacy publication inputs.
5. **Stage/evidence persistence and publication:** Immutable complete packages, digests, retry/attempt records, reference binding, current selection, fail-before-delivery readers; interrupted-write and original-failure regressions.
6. **End-to-end and close:** Retained/synthetic provider fixture -> raw staging -> validated canonical -> consumer publication -> replay; failed candidate and correction demonstration. Update guide/inspection tools, exact verification transcript and limitations.

Update context/engineering status at each checkpoint. Commit only intended files; preserve `.idea/` and `.DS_Store`. Review commits locally. No implementation push or merge without the owner's instruction.

## Verification

- Existing eight framework-free standalone tests, plus new meaningful integrity tests, with C++20 warnings-as-errors.
- Isolated deterministic Databento target and source-specific failure/group/date regressions (no credentials/network market-data calls).
- Isolated storage CTest and manual demonstration with independent Python inspection.
- ASan/UBSan for changed dependency-free and storage/provider paths where supported.
- Distinguish native Arrow CONFIG package verification from temporary PyArrow library/package probing.
- A green baseline does not close the new guarantees: negative tests must exercise observed overwrite/relabel/range/version/zero-quantity failures and package interruption/eligibility scenarios.

## Status

- Specification recorded; implementation pending. Requirements not yet verified are not marked complete.
