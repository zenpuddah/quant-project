# Configuration, canonical encoding and artifact projections

This is the v1 schema authority for the XML frontend and persisted engine artifacts. The [example](../examples/first-computation.xml) is a complete numerical request, not a sample that silently supplies missing policies. These codecs are integration adapters; the core owns typed records. All schema versions are explicit. Unknown versions/attributes/elements, duplicates, unsupported kinds, absent required values and noncanonical numeric tokens reject.

## Authoring XML

Root: `composition version="1"`. Ordered children: exactly one each of `run`, `limits`, `plugins`, `cache`, `sources`, `nodes`, `observations`. Empty plugins/nodes/observations containers are syntactically possible; preparation separately requires a useful admitted scope. No namespaces, DTD, entity declarations or processing instructions other than the XML declaration. Ordinary XML escaping is allowed; external expansion is never allowed. Reject duplicate attributes before any parser normalization can hide them. Enforce byte bounds before DOM allocation and depth/count/text limits during parsing. API ParseLimits are explicit caller inputs; the CLI uses documented versioned bootstrap caps before reading the in-document limits, whose bounds may only tighten them.

CLI bootstrap parsing contract v1 has fixed safety caps: 1048576 bytes, depth32, 16384 elements and 1024 UTF-8 bytes per string. Export these as versioned tool facts; they are not numerical/source policy defaults. In-document limits remain mandatory. Numeric tokens are `0` or optional minus followed by a nonzero digit and digits; no plus, whitespace, leading zero, negative zero or trailing text. Unsigned fields reject minus. Check the entire token and destination range with from_chars. Boolean parameter literals are exactly true/false.

| Element | Required attributes / children |
| --- | --- |
| run | id, clock, driver=standalone/hosted, execution=synchronous, sharing=exact/disabled, failure=stop, trace=steps/summary; retention_warning_steps; retention_log_path/format/open/flush/failure/overflow/max_bytes/max_events, with accepted format key_value_lines_v1, open create_new, flush on_event, failure/overflow stop |
| limits | xml_bytes, xml_depth, xml_elements, string_bytes, nodes, edges, requests, source_updates, managed_buffer_bytes, trace_events, trace_message_bytes; all canonical uint64, with narrower destination overflow rejected |
| plugins | ordered plugin elements, each required absolute path and build_contract_id; no implicit directory discovery |
| cache, enabled | mode=automatic_read_write, backend=local_files, absolute directory, matching=exact_full_scope, trust=same_build_local_writer, integrity=sha256, writer=single_process_lock, corruption=fail_preparation, capacity=bypass_new_entries, cleanup=explicit_only; max_entries/max_store_bytes/max_entry_bytes/max_decoded_bytes |
| cache, disabled | mode=disabled only; other cache fields reject, no store access |
| sources/source | id, operation, semantic_version, implementation_id, source_version, clock, begin_step, end_step, completeness, empty, missing, missing_intervals=strict/skip, availability; ordered param children permitted only where required by that provider schema |
| nodes/node | id, operation, semantic_version, implementation_id, alignment=same_step or the declared lag activation protocol, initialization; params then ordered input children |
| param | name and value only. Registry/provider versioned schema resolves exact int64/uint64/bool/text kind; a literal never becomes a producer reference |
| input | port, producer, output, prior_outputs, missing_intervals=strict/skip; its order is significant and must match ordered operation ports |
| observations/observe | id, producer, output, begin_step, end_step, absence=require_value, prior_outputs, missing_intervals=strict/skip; clock is checked derivation from its producer, recorded with origin |

Registered operation versions determine required parameters and exact output names; no absent parameter receives a value default. Provider completeness/empty/missing/availability names are validated against the versioned provider, rather than interpreted generically. In the fixture they are complete_only/reject/fail/interval_end_zero_lag_fixture. `missing=fail` covers missing required source identity/scope; `missing_intervals` selects the separate declared-gap policy. `initialization=empty_at_step_0` includes the actual scope/clock derivation; a source beginning elsewhere cannot pretend to be that initialization. Stateless operations require initialization=stateless. Lag requires explicit lag_steps, count_basis=complete_bar_updates and matching policy acceptance.

Operation parameter schema fixes fixture SMA `window:uint64`, `max_abs_input_raw:int64`, `sum_width:text=signed64`, `rounding:text=nearest_ties_even`, `overflow:text=fail`. Price difference requires overflow=fail. Close has an empty required parameter set. Lag uses its registered same-step activation and earlier-publication selection; it does not create a different source clock. Every input and observation explicitly declares its missing-interval acceptance. Source, operation and consumer policies must be compatible before admission.

Pure producer configuration excludes consumer masks. Required evidence selections (CLI report/plan/DOT paths and hosted required domain sinks) are injected as explicit preparation inputs, included in the effective configuration and frozen RequiredEvidenceSet before execute. XML may configure retention directly; it does not imply an undeclared report path. The fixture executable's required `--output` is an explicit integration contract that constructs and exports its bounded required sink specifications before instantiation. A generic CLI uses the explicit paths in [CLI contracts](resources-evidence.md).

The generic frontend exposes a bounded raw skeleton/plugin list first. Load the accepted plugins, freeze their registry, then resolve operation/provider parameter schemas. Copy all description strings out of the DOM. Explicit CLI/API overrides go through the same required-field/type/preparation validation and record their origin; an override cannot change a running graph.

Implementation records: ParsedComposition owns CompositionDeclaration (run,
limits, plugins, cache, sources, nodes and observations), with raw ParamSet literals
and explicit initialization/alignment directives. Composition adds registered
definitions and canonical typed parameters while retaining that owned declaration.
Source preparation supplies validated source facts and lowers directives into
NodeSpec/InitializationSpec; the frontend does not invent initialization ranges or
certify a provider's completeness/availability labels. Those provider-specific
labels are checked by its versioned source service before admission. The runtime
resource-account/reservation members are capabilities, not serialized pointers.
The inspectable V1 projection field tables live in `src/lexongine/schema.hpp`.

The parser receives an explicit preparation account through ParseLimits and
reserves a conservative metadata/workspace ceiling before DOM construction
(`64 * supplied XML bytes + 65536`, checked arithmetic). Schema resolution obtains
its own reservation so multiple resolved descriptions cannot escape accounting.
This is a bounded host charge, not a measured TinyXML allocator/RSS guarantee.
The authoring grammar itself has at most four element levels and sixteen
attributes per element. Narrow preflight rejects duplicate attributes, unsupported
nodes/namespaces/DTD/entities and depth/count/text excess before TinyXML parsing.
Only XML 1.0/UTF-8 declarations are supported. All copied values and typed numbers
still undergo the owning schema checks; preflight is not source validation.

## Scalar encoding

Canonical semantic bytes start with uint64 big-endian domain-byte length followed by UTF-8 domain `lexongine.identity.v1`. A record contains fields in ascending fixed tag order. Each field is uint16 big-endian tag plus uint64 big-endian payload byte length plus payload. Missing, duplicate or unknown tags reject. Unsigned and signed integers use 8-byte big-endian encoding, signed two's-complement bits without arithmetic overflow; narrower model fields are range checked. Bool is one byte0/1. Text is exact bounded UTF-8 bytes with no normalization. Optional is byte0 for absent or byte1 plus encoded value. Lists are uint64 count followed by each item as uint64 byte length plus its encoded value; checked counts/lengths precede allocation. Empty records have zero fields, not omitted required fields.

ParamValue is discriminator Signed64=1,Unsigned64=2,Boolean=3,Text=4 then encoded value. TemporalExtent is PointTime=1 plus event_time_ns, or Interval=2 plus begin_ns/end_ns; never encode a point as a fabricated interval. HistoryRequirement discriminator CountHistory=1,TimeHistory=2,ExplicitPrefix=3; only CountHistory is accepted in this milestone. Enum values are their registered lowercase snake_case UTF-8 spellings. The codec identity/version is included in artifact identity. Canonical named params sort by unsigned UTF-8 name bytes and reject duplicates. Origin notes/display text are exported but excluded from pure numerical equality.

The domain prefix occurs once for a top-level canonical identity/digest input, followed by a uint16 big-endian record-kind code: ComputationIdentityV1=1, ArtifactIdentityV1=2, PlanIdentityV1=3, CoverageV1=4, SourceIdentityV1=5. Nested records, including an input's full producer_identity, contain their framed fields without another domain prefix or kind code; the parent field fixes the exact nested type. The prefix, kind and schema must match before equality. Provider payload content fingerprints use their explicitly registered separate codec/domain, not this identity encoding by accident.

## Fixed identity record fields

Each row assigns tags1..N to the listed fields in exactly that order. Lists preserve order except the explicitly sorted named-parameter list. These are wire records, distinct from C++ memory layout; never hash object padding, pointers, type_index values or DOM serialization. References to upstream computation records include full framed canonical record bytes. Implementations may share immutable bytes internally, but persisted digest-only references cannot replace full equality/validated ordered provenance.

| Record | Tags1..N (ordered exact fields) |
| --- | --- |
| ComputationIdentityV1 | operation, parameters, inputs, outputs, sources, initialization, processing_scope, history, timing_policy, numerical_policy, missing_policy, sharing_contract, codec_contract, validation_contract |
| OperationIdentityV1 | namespace, name, semantic_version, implementation_selector, binary_digest, dependencies_digest, source_build_digest, sdk_build_contract_id |
| CanonicalParamsV1 | schema_version, values |
| NamedParamV1 | name, value |
| InputIdentityV1 | input_name, producer_identity, output_port, prior_outputs, alignment_contract, missing_policy |
| OutputIdentityV1 | output_name, type_contract, storage_kind, codec_contract, validation_contract |
| TypeContractV1 | nominal_name, semantic_version, meaning |
| ContractV1 | id, version, parameters |
| SequenceScopeV1 | clock, begin, end |
| UpdateKeyV1 | clock, sequence |
| InitializationV1 | contract, actual_prefix, explicit_values |
| SharingV1 | class, init_contract, update_contract, effect_contract, effect_free, replay_safe, cacheable |
| SourceIdentityV1 | snapshot_name, source_version, content_digest, provider_operation, interpretation, query_selection_contract, reference_digest, validated_scope, coverage, order_contract, availability_contract, validation_contract |
| CoverageV1 | expected_scope, complete_keys, gaps, expected_timeline_contract |
| GapV1 | missing_scope, interval, declared_reason |
| IntervalV1 | begin_ns, end_ns |
| PointTimeV1 | event_time_ns |
| CountHistoryV1 | preceding |
| TimingPolicyV1 | update_contract, availability_contract |
| ArtifactIdentityV1 | computation, processing_scope, ordered_output_types, codec_contract, validation_contract |
| PlanIdentityV1 | effective_composition, logical_order, aliases, admitted_requests, rejected_requests, resource_plan, required_evidence |

`operation`, `sources` and ordered inputs carry actual verified implementation/content/query facts. SourceIdentity reference_digest binds the full validated source association table; source validation verifies that table, not an arbitrary self-reported label. Source content fingerprints include every canonical payload/timing/reference field under the registered provider codec. Timing/order/coverage/availability facts are identity-bearing ContractV1 records, not human prose. Contracts unsupported by the implementation reject, including phase-dependent numeric behavior and independent-source alignment. Descriptive labels, logical IDs, request masks and origin notes are excluded from ComputationIdentity but included in the effective composition/plan as appropriate.

Full source-reference/content records are held in the pinned validation package. Cryptographic digests validate pinned external content; computation hash matches still undergo full canonical structural equality. Changing upstream parameters, ordered ports, source scope or actual implementation changes downstream canonical bytes. Schema fields changing in future require a new schema version.

Owner clarification, 2026-10-15: include implementation_selector in the initial
OperationIdentityV1. Distinct registered factories can share a binary, operation
name and semantic version; the selector prevents them from colliding as exact
implementations. It supplements actual content/build digests. This correction is
to the pre-implementation v1 artifact contract. Human display labels remain
nonsemantic. The rule applies to provider-operation records and every transitive
computation/artifact identity.

The computation timing_policy field is TimingPolicyV1, containing the node's
declared update and availability ContractV1 records. Its update/effect contracts
must agree with the resolved operation's sharing contracts; effect and initialization
contracts are already represented in SharingV1/InitializationV1. This concrete
field binding keeps the owned NodeSpec policies in identity without hashing prose
or adding arbitrary extension fields.

## XML typed-value projection

Complex owned records in plan/report/identity use this common strict grammar, so independent formatters do not invent incompatible nested formats:

```xml
<record type="CoverageV1">
  <field name="expected_scope"><record type="SequenceScopeV1">...</record></field>
  <field name="complete_keys"><list><item><record type="UpdateKeyV1">...</record></item></list></field>
  <field name="gaps"><list/></field>
  <field name="expected_timeline_contract"><record type="ContractV1">...</record></field>
</record>
```

Ellipses above explain nesting and are not valid payloads. Each field contains exactly one of record/list/i64/u64/bool/text/digest/optional/variant. Scalar text is canonical; bool is true/false; digest is lowercase64hex. Optional has present=true/false and zero/one value child accordingly. Variant has required kind from its record's registered alternatives and exactly one value child. Lists have item children, each one value. Records require every fixed field exactly once in tag order, even empty lists. Only the whitelisted v1 record schemas are allowed. No arbitrary string-key map or unknown extension fields. UTF-8/text/XML escaping never changes equality. Emit ParamValue as a variant and TemporalExtent as point/interval variant with their exact records. This generic projection is evidence, not a universal numerical input type.

For the engine model/evidence projection use the exact owned record fields in [components](components.md), [evidence](resources-evidence.md) and [host receipt](qaedalus-integration.md). Before committing Task1/4, centralize the complete schema descriptor table in code and test each emitted/decoded field against these definitions. Grouped prose such as Composition/PreparedPlan requires explicit code-schema records, an exported schema table and focused round-trip checks before Task10; do not claim their C++ object layout is a wire format. Their descriptive details are not computation keys. This is routine implementation work delegated to OpenCode, with no new owner decision gate.

## Artifact envelopes

Root version is exactly1; required attributes below are exhaustive. Required child order is as listed. Complex children contain exactly one typed record/list from the common grammar. All digest/byte counts are verified against closed bytes; XML whitespace is not a numerical identity. Timing attributes on outcome/parent are `time_kind=point` with event_time_ns only, or `time_kind=interval` with interval_begin_ns/interval_end_ns only. available_at_ns is independent and required. Wrong-kind attributes reject.

| Envelope | Required attributes | Ordered children |
| --- | --- | --- |
| plan | version, run_id, plan_digest, schedule_policy=logical_first_occurrence_v1 | effective_config, sources, logical_nodes, physical_nodes, aliases, logical_schedule, requests, resources, cache_decisions, required_evidence |
| run_snapshot | version, run_id, plan_digest, numerical, integration_outcome, host_contract_id, host_contract_version, host_experiment_identity, acceptance | requests, outcomes, counters, cache, resources, causes, outstanding_holds, precommit_evidence_inventory |
| artifact_manifest | version, artifact_id, identity_digest, origin_run_id, codec_id, codec_version, validation_contract_id, validation_contract_version, outcome_count, payload_bytes, payload_digest, complete_count, gap_count, coverage_digest | canonical_identity, processing_scope, ordered_output_types, coverage, startup |
| price_outcomes | version, clock, begin_step, end_step | ordered outcome elements for complete-update keys only |
| accepted_run | version, run_id, commit_id, numerical=completed, integration_outcome=completed, acceptance=accepted, cache_status, acceptance_policy_digest, build_identity_digest | snapshot_reference, evidence_inventory, entries |

`canonical_identity` contains full lowerhex canonical bytes (text value) and must decode to the requested ArtifactIdentityV1. `coverage` is CoverageV1 and partitions the exact processing scope together with expected-timeline contract. startup is InitializationV1 plus history ContractV1 in a fixed StartupV1 record (tags1 initialization,2 history). ordered_output_types is the ordered TypeContractV1 list. outcome_count equals complete_count and complete_keys length; gap_count is ledger entry count, with skipped interval count reported separately. coverage_digest hashes framed CoverageV1 bytes. Timeline descriptor validation checks corresponding intervals/availability under the same pinned source contract.

`run_snapshot` is a precommit immutable snapshot: successful numerical/host completion still has acceptance=pending. Failed/aborted snapshots may record rejected; final accepted/unconfirmed status is read from the authoritative receipt/marker rather than by rewriting a required snapshot after commit. CLI success receipt is a projection, distinct from the snapshot. Never let a consumer treat pending as accepted.

`outcome` requires step, kind and timing/availability attributes. kind=published has one port per output in operation order and parents; kind=warming has remaining_preceding and parents; kind=valid_absence has declared_reason and parents (not eligible in fixture). No failure stream is reusable. A price `port` has name,type,type_version,scale=9,raw only. Parent has computation_digest,clock,step,port, timing/availability plus optional source_reference_digest, with no ancestor payload. Port value decoding revalidates semantic type. All outcome keys exactly equal coverage.complete_keys; original source gaps remain only in the separate validated ledger.

Evidence references use a fixed EvidenceReferenceV1 record: tags1 name,2 absolute_path,3 byte_count,4 digest,5 finalized. EntryReferenceV1 has tags1 artifact_id,2 identity_digest,3 manifest_digest,4 manifest_bytes,5 payload_digest,6 payload_bytes. SnapshotReferenceV1 has tags1 absolute_path,2 byte_count,3 digest. Entries are ordered unique; markers reference immutable manifest/payload bytes. The evidence inventory excludes the marker; the snapshot's embedded inventory excludes both itself and marker. This prevents self-hash cycles.

A provisional manifest contains origin_run_id only, never origin_record_digest. Validate the originating accepted marker and derive its digest into the lookup/validated view afterward. The final marker may refer to the manifest, so embedding its digest in that same manifest would be circular. Disabled/no-new-entry/capacity-bypass runs write no store marker; their confirmed in-memory acceptance receipt follows required sink finalization as specified in [evidence](resources-evidence.md).

## Schema checks before dependent commits

Task4 tests the exact authoring example, all required policy fields and malformed/unknown variants. Task5 tests canonical bytes and forced hash collisions, including transitive port order. Task9 tests complete/gap coverage, source mutation, origin marker, tampered bytes, unknown fields and strict codecs. Task10 exports and round-trips the full centralized model projection schema before use as required evidence. Tests use independently constructed expected bytes/records, not a serialize-then-deserialize check alone. Add a point-event outcome case as well as interval bars. A schema descriptor export is inspectable by humans/agents; it is not runtime C++ reflection or a new universal data model.
