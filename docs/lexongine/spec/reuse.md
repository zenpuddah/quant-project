# Exact sharing and cross-run output reuse

Within-run sharing and reuse of earlier-run outputs are distinct mechanisms. Both require compatible exact semantics; only the latter needs validated durable provenance. Full ordered transitive identity matters: for A→B→C, changing A's parameters/source/version changes B and C identity. Reordering noncommutative inputs or operation sequence remains different even if observed output values happen to match. Preserve compact provenance, not every ancestor payload or an API for accessing all historical rows.

Owner clarification, 2026-10-15: an explicit implementation selector is part of
operation identity even when multiple factories have the same binary/build
digests. Human labels are not selectors.

Implementation of the existing eligibility gate: eligibility is checked through the
ordered dependency chain: in this bounded slice, descendants of a Unique,
effectful or unproven producer are not automatically shareable merely because
their own callback is pure. Equal canonical bytes alone do not waive that gate.

## Artifact services



- ArtifactIdentity: versioned canonical computation bytes/digest; exact processing scope; output TypeContract list; codec and validation contract versions; source/implementation/init/update/availability/effect fields. Equality checks complete fields, not digest alone.
- ArtifactCandidate: store-private immutable handles and bounded metadata; not decoder-ready authority.
- ValidatedArtifact: pinned manifest/payload, complete decoded bounded outcome stream and originating accepted-run record; immutable and owned; cursor is fresh per run.
- LookupDecision: variant<Miss{reason},Candidate{ArtifactCandidate}>; actual I/O/parse errors are Diagnostic, never Miss.
- ArtifactStreamRecord: key, kind, optional complete payload bundle, PublicationMetadata, warming count or declared absence reason; exactly one record per applicable key. Failure/MissingRequired streams cannot become eligible artifacts.
- StagedEntry: owned unique ID, exact ArtifactIdentity, bounded private stream accumulator/writer, count/bytes/digests; never directly lookup-eligible.
- FinalizationInput: owned completed precommit snapshot, closed required evidence inventory, staged entry manifest list, explicit capacity decision and accepted-record specification.
- CommitOutcome: Committed{record_digest},NotCommitted{Diagnostic},Unconfirmed{Diagnostic,commit_id}. Unknown outcome never returns accepted success.

```cpp
Result<LookupDecision> ResultStore::lookup(const ArtifactIdentity&,
                                         ResourceAccount&) noexcept;
Result<ValidatedArtifact> ResultStore::validate(ArtifactCandidate&&,
  const ArtifactIdentity&,ResourceAccount&) noexcept;
Result<ArtifactCursor> ValidatedArtifact::cursor() const noexcept;
Result<OutcomeFrame> ArtifactCursor::next(const UpdateContext&) noexcept;
Result<StagedEntry> ResultStore::stage(const ArtifactIdentity&,
                                     ResourceAccount&) noexcept;
Result<void> StagedEntry::append(const OutcomeFrame&) noexcept;
Result<PreparedCommit> ResultStore::prepare_commit(
  std::vector<StagedEntry>&&,const FinalizationInput&) noexcept;
CommitOutcome ResultStore::publish(PreparedCommit&&) noexcept;
Result<CommitOutcome> ResultStore::reconcile(const CommitId&) noexcept;
```

ResourceAccount, validated input/codec pins and the declared store lock live as long as required by preparation/execution/finalization. A reopened path cannot replace validated bytes unnoticed: pin already validated buffers/handles, verify exact content on reading, or reject a provider that cannot hold an immutable snapshot. The local adapter counts provisional disk bytes; entry/store quotas do not waive decoded-memory admission. For disabled reuse, no ResultStore is required or accessed. No-new-entry/capacity-bypass runs perform no hidden cache write.

## Selected local result store

Automatic validated reuse is included in v1. The backend is bounded trusted same-build local XML artifacts with SHA256, single-process writer lock, immutable accepted entries, exact-full-processing-scope matching, explicit capacity bypass and explicit-only cleanup. No distributed store, automatic repair/eviction, state checkpoint restoration or partial-scope splice is included. The store adapter is separate from Qaedalus ingestion's NoopCache and immutable storage publication.

A full exact processing/init scope repeat can serve validated output outcomes without numerical advances. A scope extension misses and creates fresh state reconstructed from required source history; a saved average alone cannot continue an SMA. Keep source validation and consumer readiness mandatory even on a cache hit. Validate the current full source identity/coverage/order, full canonical lineage bytes, build/type/codec/validation contracts, originating accepted marker, payload digest/length and exact outcome coverage before use. Pinned bytes cannot change between validation and delivery. Hash equality alone is insufficient.

An invalid or corrupted encountered candidate and real I/O error fail preparation; they are not silently treated as misses. An ordinary absent candidate or incompatible identity is a documented Miss. Capacity bypass is selected before writing a new entry; it never converts a failed write into success. Disabled/full/no-new-entry runs perform no hidden store marker/write. Resource limits cover decode, staged disk, source data, outcome metadata and retained payloads separately.

## Coverage and gaps

ArtifactIdentity includes the exact SourceCoverage and ordered source timing/reference contract. A manifest contains expected_scope, complete_keys and ordered SourceGap ledger, counts and coverage_digest explicitly. Numeric payloads have one outcome per complete-update key, including startup Warming; gap keys have no numeric outcome. Their union must exactly match the declared expected timeline without duplicates, overlap or unidentified holes. Ordered keys are original engine keys, never compressed to remove gaps. A filtered raw acquisition ordinal gap is not a SourceGap.

For multi-input same-clock compositions the source timeline/coverage contracts must agree on applicable events; v1 does not invent a merge of unrelated sparse sources. Component compatibility and actual processing scopes are explicit. Cache replay delivers the same skipped timeline events, original keys, availability and lineage. Strict/Skip, lag count basis, initialization, query/selection/order and actual upstream build changes invalidate compatibility.

Eligibility requires replay-safe/cacheable effect-free computation and an exact supported typed codec. Cache-serving a shared indicator cannot suppress either trial's separate intent/order/action or restore financial/account state. See [integration](qaedalus-integration.md) and [execution](execution.md).

## Integrity and identity encoding

Candidate sharing uses FNV-1a64 (offset14695981039346656037, prime1099511628211, explicit unsigned modulo2^64) then full equality plus legality. Persistence uses SHA256 through an isolated wrapper around the existing helper. Neither is an equivalence proof or authentication of untrusted code. Exact deterministic field encoding and manifest projections are in [configuration](configuration.md). Final accepted-run publication is governed by [resources and evidence](resources-evidence.md).
