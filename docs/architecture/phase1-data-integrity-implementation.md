# Bounded ingestion/storage integrity implementation specification

## Authority and boundary

Implementation of the accepted 2026-10-03 recap, from `95993a8`, on `implementation/data-integrity-2026-10-03`. Mechanisms below instantiate accepted contracts; they do not reopen the audit proposals. C++20, 64-byte/64-byte-aligned MboRecord, canonical financial validators, provider ports, MarketDataReader and isolated builds remain authoritative.

First source: normalized XNAS.ITCH MBO delivered by the pinned Databento SDK. Retain every delivered record byte, including None, before selection or kind splitting; this is not Nasdaq packet capture. Synthetic acquisitions use the same explicit evidence/preparation contracts. No new third-party dependency, generalized cache/catalog, repair scheduler, XML reader, cross-acquisition merge, strategy, or binding.

## Responsibilities and flow

```text
explicit acquisition identity + query/planned provider request + reference snapshot
   -> provider acquisition (original record bytes + ordinal before selection)
   -> persisted raw attempt and acquisition outcome
   -> source-specific decode/order checks + canonical selection/financial validation
   -> staged canonical candidate + per-row report (including rejected/filtered rows)
   -> independent canonical/consumer files and exact evidence/parent links
   -> complete immutable publication
   -> compatibility/integrity/consumer-eligibility gate -> MarketDataReader
```

Domain integrity types/eligibility are dependency-free. Provider-specific interpretation stays in ingestion adapters/evidence. Parquet/filesystem mechanisms stay in storage. The preparer owns expensive source/canonical checks; publication checks binding/association and persisted outputs. Readers verify the complete package and validate decoded rows before invoking any consumer callback. Baseline inspection codecs cannot publish unchecked batches.

## Identity and references

- StreamId: nonzero uint64; immutable binding to InstrumentId/VenueId/SourceId. A compact append-only set of individually create-only bindings at `catalog/<stream-id>.qref` enforces stability within the store. No database/discovery API.
- Each published package embeds a reference snapshot: stream bindings, complete supplied instrument ReferenceVersion definitions, venue codes, source provider/dataset/schema definitions, and point-in-time ProviderMappingSegments. Missing/contradictory definitions block preparation/publication/read. Snapshot checks include mapping validity and original observation tuple/native binding.
- Moving a complete version directory retains its references. Reads use its snapshot, not a mutable external catalog. Different sources/venues produce different stream bindings even for the same instrument.
- Catalog/snapshot checks do not prove the correctness of a human-approved provider mapping; reports identify that assumption.

## Acquisition, attempt, and version identities

Explicit safe ASCII tokens (1–128 letters/digits/underscore/hyphen) supplied by the caller: operation ID, acquisition ID, attempt ID, artifact-version ID. IDs have distinct meanings. Acquisition ID names the ordinal scope; one provider request/retained input has one scope. Mapping-split requests receive distinct acquisition IDs. A new network acquisition, including a deliberate corrective refetch, always gets a new acquisition ID.

Retrying preparation/publication from the same retained input keeps operation/acquisition identity and uses a new attempt ID, with a recovery reason/previous-attempt reference. It never acquires records again under the old acquisition ID. Published version identity is rejected on repeat, including identical content; verified idempotency/deduplication is deferred. An interrupted version reservation may be resumed only by its owning operation, using a new attempt and the same immutable retained input. Correction publication gets a new version; prior files remain untouched.

## Ordinal and association

- Separate uint64 ordinal, starting at zero, assigned to every returned provider record before filtering, conversion and MBO/Trade/OrderExecution splitting. Checked overflow. Successive bounded input chunks share the counter/check state when they belong to one acquisition.
- Every canonical row retains StreamId and ordinal as separate Arrow columns. The pair (acquisition ID, ordinal) resolves the original raw record. Row-preserving consumer preparation retains that pair. None and excluded rows remain in raw/report, so gaps in selected ordinals are legitimate.
- Canonical preparation records the complete original event association. Publication/read compare values and headers with that ledger, not just sorted ordinal numbers. Duplicate/reordered/misassociated ordinals fail.
- Multi-kind replay within one package merges its partitions by the shared ordinal. Cross-acquisition replay has no implicit total order and is rejected by the merge API.
- First conversion emits zero or one canonical observation per normalized provider record. Expansion is rejected until a sub-position rule is accepted; aggregates are deferred.

## Source order and initialization

XNAS checks are scoped to the acquisition and native instrument/channel; carry state across chunks. Preserve returned succession; never ts_event-sort or require consecutive sequences. Equal times, repeated sequences within normalized groups, and filtered sequence gaps are permitted. Snapshot rows bypass ordinary receive/sequence comparisons and preserve returned priority; snapshot completion uses its explicit flags. Ordinary unflagged receive regression is a violation. Missing/undefined ordering evidence, unexplained counter reset/session boundary, incomplete groups, or F_MAYBE_BAD_BOOK leave the affected required check unresolved/failed.

F_LAST closes the event for that instrument. Group completeness is checked on the raw succession and again for selected dependent output; filtering away required group members blocks consumers requiring complete groups. Do not assume all native messages produce Trade/Fill/Cancel; allow replacement Cancel/Add and non-printable Fill/Cancel. The flags/checks are evidence, not an independent proof of exchange completeness.

Book initialization requires a complete selected snapshot beginning with a snapshot Clear, or an explicit accepted empty-book initialization record with scope/time/reason. A normal mid-session first Add is insufficient. Conservatively block an affected stream/range after an invalid mutation; independent streams/explicit separately prepared ranges remain retained. Recovery does not silently clear failures: rerun preparation from retained or newly acquired input.

## Validation and eligibility

- Decode failures retain original bytes and stable ordinal/rule/reason; invalid primitive values are not forced into canonical types.
- Perform documented overfetch filtering before canonical query/range validation. Excluded rows are recorded as selection outcomes, not Corrupt. Selected rows must match original mapping/snapshot scope, fragment event-time range and both requested time constraints; reuse `data::validate` and reject malformed MBO control/presence representation.
- Report failed rules, raw acquisition/ordinal, dependency scope/range, query/fetch/filter context, transform/version, and recovery attempts. Candidate failures stay staged, never become authoritative coverage.
- Factual DataState is retained independently. Default Complete/Degraded usability remains necessary, not sufficient. A separate consumer requirement gate checks structural/range/identity validity and resolved required ordering, event groups and initial state. Timestamp-quality flags can degrade time quality without declaring book corruption.
- Analytical batch access has explicit requirements; ordered event replay requires resolved order and complete required groups; book replay additionally requires initial state. Explicit partial selection may consume independently eligible prepared fragments while reporting uncovered/blocked ranges. No implicit claim that retained rows cover the entire query.

## First physical contracts

- Raw stage: `quant-provider-bytes-v1` Parquet columns `event_ordinal:uint64 not null`, `provider_record:binary not null`. Complete normalized record bytes (XNAS MBO 56-byte DBN record) are retained, not reconstructed from canonical fields. Acquisition metadata retains full supplied provider metadata, exact request ranges, mappings, conditions and outcome. A required acquisition sink writes request/metadata and an append-only provider-record journal before conversion; each frame is uint64 ordinal, uint32 length, then original bytes (little endian frame integers). This retains unexpected record shapes without losing framing. The journal precedes sealing analytical Parquet and is not a binary replay backend. Unfinished tails/operations stay failed/staged. The first synchronous durability path fsyncs records before acknowledging capture; no optimized buffering policy is claimed.
- Canonical and archival-consumer stages: `quant-observations-v2` Parquet, existing MBO/Trade/OrderExecution canonical columns plus `stream_id:uint64 not null` and `event_ordinal:uint64 not null`. Each file is one stream, kind and acquisition. Separate physical files and stage labels. `archival-consumer-v1` preserves canonical values and adds opaque `raw_evidence:binary not null` from the exact source ordinal; this supports rich analytical access and verifies original row association. Replay projection excludes that archive-only column. This is not an unimplemented feature/bar builder.
- Numeric meanings stay price scale 9, quantity scale 6, epoch ns; MBO control retains current masks. Unknown encodings and known labels with wrong schemas fail before row delivery. `canonical-v1` baseline artifacts are deliberately unsupported for eligible consumption: inspect externally or regenerate from retained input; no silent relabeling or implicit migration.
- Package evidence: bounded versioned token-text (`quant-evidence-v1`), quoted strings and strict integer parsing, explicit counts, no general descriptor interpreter. Contains complete reference/query/request/acquisition/quality/failure/validation/recovery metadata, exact parent/output links and row-association ledger. Parsers reject trailing/missing fields, unreasonable sizes and invalid paths.
- SHA-256 digests bind files, reference snapshot, evidence and completion marker. A small dependency-free implementation with standard known-answer tests avoids extending storage dependencies. Digests detect changes, not authenticity or provider correctness. No checksum is fabricated from a caller label.

## Publication and visibility

Store layout: `staging/<operation>/<attempt>/`, `catalog/<stream-id>.qref`, `versions/<version>/.attempt-<attempt>/`, and optional `current` selection. Staging retains raw bytes and reports for failed operations. Final version directories are exclusive reservations with owner metadata; attempts write distinct files, never edit a completed attempt.

Write/close/fsync raw, references, canonical, consumer, and evidence; verify every required file/digest/schema/association. Create a complete manifest, then publish the `COMPLETE` marker using a non-replacing atomic filesystem operation (hard-link an fsynced temporary marker), followed by directory fsync. Readers require and verify COMPLETE and the entire required package before delivering rows. Fault injection at each data/reference/evidence/marker boundary must leave no eligible version. Single-writer synchronous scope; no scheduler/locks/worker pool introduced. POSIX filesystem durability is the supported first platform (macOS/Linux); filesystem durability beyond local POSIX semantics is not claimed.

Current selection contains an exact version and only changes after complete publication through an atomic replace. Readers resolve it to a pinned DataFragment; old handles remain fixed. Failure while updating current does not invalidate an already complete version or replace old selection. Unsafe tokens/path traversal and symlinked package components are rejected.

## Daily conditions

Condition endpoints are inclusive UTC dates: first = floor(start); last = floor(end − 1 ns). Example [Jan 2 14:30,14:35) requests Jan 2/Jan 2; [Jan 2 23:59,Jan 3 00:00) also Jan 2/Jan 2; [Jan 2 23:59,Jan 3 00:01) requests Jan 2/Jan 3. Retain all response conditions as evidence; each affects only intersection of its UTC day with canonical selection. Extra response days have no effect. Market-data fetch ranges remain half-open and distinct.

## Verification and limits

Regression matrix follows the handoff: identity/catalog references; financial/shape/range failures; evidence retention/revalidation; compatibility; repeated normalization groups/snapshots/chunks/filtering/association; immutable corrections/retries/faulted publication; eligibility and partial ranges; inclusive day clipping. A deterministic provider-fixture demo reprocesses stored raw input, leaves a failed candidate staged, publishes a correction without changing the original, and reads through MarketDataReader.

Official docs pages require JavaScript in the local fetch tool. The accepted recap is the checked provider-semantics baseline; pinned official SDK record/flag definitions and official DBN flag source were additionally checked. No session-reset rule is inferred where evidence is absent. Native Arrow package availability is reported separately from PyArrow probing/shims. No paid/provider credentialed requests.
