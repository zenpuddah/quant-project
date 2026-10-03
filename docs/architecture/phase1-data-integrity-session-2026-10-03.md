# Data integrity and staged persistence — session recap, 2026-10-03

## Status and purpose

- **Accepted direction:** The owner accepted the decisions summarized below in the 2026-10-02/03 architecture discussion.
- **Review basis:** Repository commit `590fd349e683b0f5c0524f7248f2eb6b3e89a150`, its decision-coverage review, implementation, and the full discussion.
- **Not implemented:** The new stream catalog, persisted row StreamId, shared ordinal, staging/failure persistence, artifact version identity, and reader compatibility gates have not been implemented during this session.
- **Readiness:** The owner accepted the three final closure contracts at the end of this session. The reviewed ingestion/storage architecture decisions are settled and ready for a bounded implementation specification and plan.
- **Boundary:** This document is an accepted decision recap, not a complete implementation specification or authorization to execute production changes. Physical formats, metadata layouts, and publication mechanisms must be made explicit in that specification; deferred features remain deferred.
- **Current handoff:** `docs/project/opencode-data-integrity-handoff-2026-10-03.md` translates these contracts into the next implementation task. An explicit implementation request supplies execution authorization; this documentation update itself changes no production behavior.

The original project remains a C++20/Python research/backtesting platform. This session assessed data correctness on engineering grounds rather than using the interview deadline as a substitute for correctness. Existing boundaries, including the 64-byte MboRecord and isolated dependencies, remain in force.

## 1. Row identity and single-stream artifacts

- **Decision:** Persist a compact StreamId on every stored canonical row. Resolve it through a catalog to InstrumentId, VenueId, and SourceId. Each canonical observation file contains one stream. Resolve/check original identity during conversion before discarding that original context.
- **Reason:** A file label alone cannot detect a mixed-stream input or an incorrect identity label. An ID referencing an existing entry does not prove it was assigned to the correct observation.
- **Invariant:** Each persisted row's StreamId resolves to its original canonical tuple and agrees with the file's declared stream. Unknown mappings and mixed-stream candidates cannot become published canonical input.
- **Trade-offs:** A new mapping and conversion checks are required. Catalog existence checks cannot detect incorrect upstream provider-to-canonical mappings.
- **Implementation scope:** Trade and OrderExecution checks use their original headers; MBO checks use its existing buffer scope. Stored/in-memory sidecar columns do not enlarge MboRecord. Processing may attach resolved identity columns while retaining existing Arrow value arrays. New columns may require allocation.
- **Required tests:** Correct mapping; mixed input; wrong file scope; missing mapping; the same instrument on different venues/sources; preservation of MboRecord layout.

Catalog persistence and stability are governed by accepted closure contract A below.

## 2. Range membership

- **Decision:** The canonical query supplies applicable time constraints. Validate eligible observations after documented provider overfetch/query filtering. If both event-time and source-receive-time constraints are requested, enforce both.
- **Reason:** Stored labels do not prove that observations belong to their declared historical interval.
- **Invariant:** Published canonical rows satisfy the requested constraints and their fragment's declared half-open event-time range. `[start, end)` includes start and excludes end. Range membership does not by itself establish complete coverage or point-in-time information availability.
- **Trade-offs:** Requires comparisons and precise distinction between provider fetch ranges and canonical selection ranges. Legitimate overfetch must not be mislabeled as corruption.
- **Implementation scope:** Retain query and actual provider request/filter decisions. Out-of-range observations after intended selection cause recorded failures rather than silent relabeling.
- **Required tests:** Start included; end excluded; just-outside boundaries; dual-time constraints; expected overfetch; a correctly shaped but incorrectly labeled stored batch.

## 3. Staging, invalid rows, and recovery

- **Decision:** Retain acquired evidence in staging. Validate and record failures per row. Keep failed segments and failure metadata, retain previously validated work, and block unresolved affected segments from research/replay. Recovery is explicit and followed by revalidation.
- **Reason:** Preserve diagnostic evidence and avoid unnecessary refetches without presenting unresolved data as usable input.
- **Invariant:** Original acquired evidence remains recoverable; no silent deletion, timestamp repair, or publication of unresolved candidates. Retained segments do not imply that a larger requested range is complete.
- **Trade-offs:** Staging storage and stable failure references are needed. For order-dependent events, an invalid mutation can invalidate later state; good row shape alone cannot establish segment usability.
- **Implementation scope:** Reuse canonical financial validators. Record original artifact/row references, failed rules, reasons, query context, and recovery attempts. When invalid data cannot be constructed as a canonical C++ value, preserve it at the raw stage rather than forcing it into a canonical container. Start with explicit/manual investigation or refetch; automated row repair is deferred.
- **Required tests:** Zero-quantity Trade/OrderExecution; invalid MBO shape; retained failure evidence; blocked unresolved data; preserved good segments; recovery must revalidate; dependency impact is not confused with individual row validity.

The eligibility contract is accepted in closure contract C below. Its concrete integration with DataState/DataUsabilityPolicy belongs in the implementation specification.

## 4. Immutable published versions and corrections

- **Decision:** Published artifact versions are immutable. Changed/corrected data receives a new version. Staging may be mutable. A current-version selection may change; a backtest records its exact input version. Save/publication policy remains separate from MarketDataQuery selection semantics.
- **Reason:** An explicit overwrite instruction still destroys the evidence behind an earlier experiment. Retaining versions allows comparison of data corrections versus strategy changes.
- **Invariant:** The same published version refers to the same stored observations. Current selection must be resolved to an exact version before a run proceeds.
- **Trade-offs:** Extra storage and version references. Automatic deduplication, branches, merges, and general revision management remain deferred.
- **Implementation scope:** Distinct artifact-version identity and non-replacing publication after successful staging. Correction publication never edits old observations. Artifact version is distinct from StreamId, schema version, and the ordinal's ordering scope.
- **Required tests:** Existing published destination cannot be replaced; corrections coexist with old versions; current selection changes do not change old inputs; failed publication yields no usable new version.

Complete publication of data plus supporting evidence is governed by accepted closure contract B. Concrete operation/retry identity mechanics belong in the implementation specification.

## 5. Schema compatibility and reader strategies

- **Decision:** Unknown encoding/schema versions are rejected before rows are delivered. Each known version selects a reader with an explicit column and interpretation contract. Start with one concrete reading strategy; XML-described reading state machines and a general descriptor interpreter are future options.
- **Reason:** A stored version label and compatible-looking column types do not establish compatible financial meaning.
- **Invariant:** Every decoded artifact is handled by a reader supporting its declared encoding, and its actual schema matches that contract.
- **Trade-offs:** Old-version support requires maintenance. Describing a state machine does not by itself implement decoding semantics.
- **Implementation scope:** A supported-version gate plus actual schema validation. The new StreamId and ordinal columns must be reflected in a deliberately named encoding contract; existing files must not be silently relabeled with a changed contract. Exact new version naming is an implementation-spec detail still to record.
- **Required tests:** Known version succeeds; unsupported version is rejected before event delivery; known label with wrong columns fails; supported legacy handling is explicit if introduced.

## 6. Provider order versus pipeline order

- **Decision:** Preserve Databento returned succession; validate applicable provider rules at the provider/canonical-preparation boundary. Keep StreamId and a separate uint64 ordinal, assigned before filtering and splitting by data kind. Preserve original provider sequence, channel, timestamps, and flags as evidence.
- **Reason:** Provider sequence can identify one original message expanded into several normalized rows. Our ordinal preserves individual returned positions; it does not manufacture evidence of exchange correctness or completeness.
- **Invariant:** Row-preserving transformations retain event-ordinal associations and succession across batches/files. Ordinals in separate acquisitions are not comparable without an explicit merge contract. Confirmed violations and unresolved requirements remain staged for affected consumers.
- **Trade-offs:** Additional column/sidecar, checking state across batches, and explicit ordering-scope metadata. Gaps after filtering are legitimate and not independent proof of missing events.
- **Implementation scope:** Separate snapshot rules from ordinary-message rules; carry validation state across batches; allow documented repeated sequences and normalization groups; do not silently sort by ts_event. Ordinal scopes must be named in the artifact metadata and shared across MBO/Trade/OrderExecution partitions from the same acquisition. If future conversion expands one input row into multiple outputs, define a sub-position rule before implementing it. Derived aggregates need their own output ordering plus input lineage, not a false one-to-one source-row ordinal.
- **Required tests:** Equal timestamps; Trade/Fill/Cancel with repeated provider sequence; replacement Cancel/Add; non-printable execution groups; snapshots; batch boundaries; filtering; cross-kind partitioning; reordered/duplicated ordinals; wrong event association; distinct-acquisition scopes.

Provider assumptions and independently checked evidence must be distinguished in validation reports. The source checks below do not establish that session identity is present in every normalized DBN row; reset/session handling must not be guessed from a global counter.

## 7. Separately persisted stages

- **Decision:** Separately retain provider representation, canonical preparation outputs, and the consumer representations actually produced. Keep stage metadata and links to exact input versions and transformation versions. Failed canonical candidates remain staged.
- **Reason:** A fixed converter or different consumer preparation can be rerun from retained input without acquiring the same evidence again.
- **Invariant:** A consumer dataset is traceable to exact canonical and provider inputs, including the validation outcome and transformation used. Original provider evidence is not overwritten by a prepared representation.
- **Trade-offs:** Storage duplication and dependency bookkeeping. Stage responsibilities can remain stable while transformation implementations change.
- **Implementation scope:** Retain the Databento-provided normalized representation, not a claim to possess original Nasdaq network packets. Parquet is the accepted analytical storage format; the exact first canonical/consumer file contracts and the evidence package still need specification. Sharing a physical format does not collapse the logical stages. Performance must be measured rather than inferred from the format name.
- **Required tests:** Reprocess retained raw input without a network request; trace a prepared version through its parents; preserve raw data after conversion failure; separate acquisition failure from data-quality facts.

## 8. Accepted final closure contracts

The owner accepted these three contracts after the recap. The rules below now govern the implementation specification; concrete mechanisms are not selected merely by this acceptance.

### A. Catalog stability and availability

**Problem:** Immutable rows can still change meaning if a catalog mapping changes, and an external catalog can be missing when an artifact is moved.

- **Decision:** StreamId never gets reassigned to a different tuple. Retain the exact instrument/source/venue reference definitions and mapping snapshot needed to interpret each published version.
- **Reason:** Immutable rows must retain immutable identity meaning and remain interpretable when moved.
- **Invariant:** Missing or inconsistent references fail before consumption; the same published input cannot acquire a different identity through a catalog edit.
- **Trade-offs:** Reference evidence needs persistence and version links. Provider IDs remain time-aware evidence and do not substitute for stable StreamId.
- **Implementation scope:** Bind each publication to its reference snapshot. Embedded evidence versus a linked immutable artifact is a specification choice; no database-backed discovery catalog is required.
- **Required tests:** Attempted reassignment; missing references; changed reference definitions; reopening/moving an artifact with its retained reference evidence.

### B. Evidence package and complete publication

**Problem:** Separate stage files do not ensure that provenance survives, and a crash can expose a file while its references or failure report are absent. Version IDs also do not specify retry behavior.

- **Decision:** Each publication records its raw inputs, queries, reference mappings, transformation versions, validation results, failures, and outputs. Make a version available only when all required data and evidence are complete. Distinguish a retry from a new acquisition.
- **Reason:** Separate persisted files alone do not establish reproducibility or complete publication after a failure.
- **Invariant:** Eligible versions have resolvable required data/evidence, are not replacements of old versions, and preserve the evidence behind validation and recovery. Current selection changes only after completion.
- **Trade-offs:** Additional metadata and completion bookkeeping are required.
- **Implementation scope:** Specify acquisition time/mode/outcome, actual provider ranges, raw artifacts, ordinal scope, mappings/reference snapshot, schema/adapter/transform versions, scoped provider conditions/quality, row failures, recovery actions, and parent/output links. Keep large record evidence outside MboRecord. Exact field layouts, stage formats, retry/operation identifiers, and the completion marker belong in the specification; a sidecar manifest is a candidate mechanism.
- **Required tests:** Missing evidence/reference blocks availability; interrupted write leaves no eligible version; complete publication succeeds without replacement; retry/new-acquisition identity is explicit; existing versions remain readable.

**Retry detail for specification review:** A candidate policy is to give a deliberate new acquisition a new identity and retry unfinished staging under its existing operation identity while retaining attempt evidence. Existing published identity is rejected rather than assumed identical. Content-verified idempotency and deduplication remain deferred.

### C. Eligibility gate and consumer dependencies

**Problem:** Current DefaultDataUsabilityPolicy accepts Complete and Degraded; SequenceGap reduces to Degraded. Our new agreement blocks unresolved order-sensitive data. Reusing the current default without a separate validation/eligibility contract could bypass that agreement.

- **Decision:** Explicitly gate consumption on the consumer's required resolved checks. Order-sensitive replay requires resolved ordering and sufficient initial book state. Keep factual DataState and validation evidence separate from eligibility.
- **Reason:** The existing acceptance of Degraded/SequenceGap can bypass the agreed unresolved-data staging policy.
- **Invariant:** A valid isolated row does not authorize consumption of dependent invalid state. Unknown required ordering, incomplete required event groups, and missing initialization block the affected consumer. Retaining good segments never silently claims complete requested coverage.
- **Trade-offs:** Consumer requirements and dependency ranges must be represented, alongside factual quality evidence.
- **Implementation scope:** Integrate a gate with the existing usability boundary. Specify appropriate snapshot or accepted empty-book/session initialization for book replay. Timestamp-quality flags alone do not imply book corruption. Partial-range selection is explicit.
- **Required tests:** Default Degraded acceptance cannot bypass unresolved-order gating; missing initial state; incomplete groups; unrelated retained good segments; timestamp-quality versus book-quality distinction; explicit partial-range consumption.

## Additional verification and deferred work

- **Daily condition boundary:** Databento's get_dataset_condition uses inclusive UTC start/end dates, whereas market-data time ranges are half-open. The current adapter's shared date-range helper rounds end to the next date and condition reduction covers the whole request segment. The extra condition date observed in the old smoke is explained by the endpoint convention; request/response day scoping still needs a focused fix and regression tests. Each condition must affect only the applicable intersecting day/range. This is an implementation issue with source support, not a need for new infrastructure.
- **Deferred:** XML interpreter, generalized recovery engine, global sequence across independent acquisitions, automatic merge of overlapping downloads, deduplication, generalized catalog, binary replay backend, and automatic rebuild orchestration.
- **Outside this closure:** First strategy, bars/calendars, information-availability/decision clock, execution/cost model, price-times-quantity accounting, risk, corporate actions, research validation, and the C++/Python interface remain a separate research/backtesting design. Immutable corrected data is not automatically point-in-time data that was available to the historical strategy.

## Source and implementation checks

Primary sources checked in this conversation:

- Databento common fields, index timestamp, and flags: https://databento.com/docs/standards-and-conventions/common-fields-enums-types
- Databento XNAS normalization: https://databento.com/docs/venues-and-datasets/xnas-itch
- Databento snapshot semantics: https://databento.com/docs/standards-and-conventions/mbo-snapshot
- Nasdaq session/message sequencing: https://www.nasdaqtrader.com/content/technicalsupport/specifications/dataproducts/moldudp64.pdf
- Databento consistency/versioning guidance: https://databento.com/blog/data-cleaning
- Databento condition dates: https://databento.com/docs/api-reference-historical/metadata/metadata-get-dataset-condition
- Martin Fowler, Preserve Whole Object: https://refactoring.com/catalog/preserveWholeObject.html
- Stroustrup/Sutter, C++ Core Guidelines I.4/C.40: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines
- PostgreSQL referential integrity: https://www.postgresql.org/docs/current/ddl-constraints.html

Confirmed source facts: ordinary receive-time guarantees have documented qualifications; ts_event need not be monotonic; normalized XNAS records from one native message share sequence; snapshots preserve priority; flags distinguish receive-time quality, channel gaps, and event completion. These facts justify targeted checks, not a universal consecutive sequence validator or proof of provider infallibility.

Current implementation was inspected at the pinned commit: the writer directly opens deterministic final paths, codecs omit stream identity without the new checks, version validation is label-only, the provider filters before gathering some evidence, provider output is separated by kind without a shared ordinal, and the default quality policy accepts degraded/sequence-gap results. The adapter does retain provider fields and react to quality flags, and ingestion already invokes canonical validators on received canonical observations; invalid observations are skipped and summarized rather than persisted with the new row-failure contract.

No implementation tests or credentialed downloads were rerun for this documentation-only recap. Prior test results in the baseline remain historical evidence, not proof that the newly agreed invariants are enforced. The implementation handoff must include negative regression tests and failure-publication tests, not only happy-path round trips.
