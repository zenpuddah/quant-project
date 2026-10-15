# Components and owned interfaces

All strings/vectors are owned. No plan field refers into an XML DOM or a temporary plugin buffer. Numeric kernels see declared typed parameters/inputs and producer timing, not arbitrary graph descriptions, source readers, cache-hit flags, wall clocks or ambient services. Identity-relevant facts are either explicit configuration, versioned component facts, or checked derivations with recorded origin; deriving a source content digest is not a hidden parameter default.

| Record | Exact fields / meaning | Header |
| --- | --- | --- |
| LogicalId, RequestId, ClockId | owned nonempty UTF-8 strings within explicit byte bound; unique in their scope | model.hpp |
| DeclaredOrdinal, PortIndex | uint32; ordinals assigned in document/API declaration order, including sources first | model.hpp |
| UpdateKey | ClockId clock; uint64 sequence. One declared ordering domain, not an acquisition ordinal | model.hpp |
| SequenceScope | ClockId clock; uint64 begin,end; half-open and begin≤end; nonempty where policy requires | model.hpp |
| Interval | int64 begin_ns,end_ns; half-open with begin<end; checked timestamp arithmetic | model.hpp |
| PointTime | int64 event_time_ns; a point event, not an invented interval | model.hpp |
| TemporalExtent | variant<PointTime,Interval>; explicit kind propagated through context, publication, parent lineage, identity and codec | model.hpp |
| UpdateContext | UpdateKey key; TemporalExtent extent; int64 decision_time_ns, activation_available_at_ns. No request ID or phase | model.hpp |
| RequestContext | RequestId request; SequenceScope evaluation; enum Phase{Warmup,Evaluation}; UpdateKey key | model.hpp |
| Sha256 | array<byte,32>; lowercase64hex only in XML | model.hpp |
| OperationKey | owned namespace/name; uint32 semantic_version; explicit implementation selector label | model.hpp |
| ImplementationIdentity | Sha256 binary_digest, dependencies_digest, source_build_digest; owned SDK/build-contract ID | model.hpp |
| AbiCompatibility | SDK version; compiler ID/version; standard library ID/version; architecture; explicit RTTI/exception/visibility/ABI flags | plugins.hpp |
| ParamValue | variant<int64,uint64,bool,string>; first slice rejects other kinds rather than parsing them approximately | model.hpp |
| NamedParam | name, typed value, origin{ExplicitConfig,VersionedFact,Derived}, provenance string | model.hpp |
| CanonicalParams | uint32 schema_version; owned sorted unique named semantic values; origin/provenance exported separately from semantic equality | model.hpp |
| TypeContract | nominal_name; uint32 semantic_version; CanonicalParams meaning (units, scale, dimensions, axes, interpretation) | model.hpp |
| CxxTypeWitness | exact type_index from typeid(T), plus host-held code pin; no string/sizeof cast fallback | registry.hpp |
| InitializationSpec | contract_name/version; actual_prefix SequenceScope; explicit_values CanonicalParams | model.hpp |
| HistoryRequirement | variant<CountHistory{uint64 preceding}, TimeHistory{int64 preceding_ns}, ExplicitPrefix{Sha256 identity,SequenceScope}>; only CountHistory accepted in this slice | model.hpp |
| ResourceBounds | uint64 source,state,scratch,staging,retention,graph,evidence bytes; checked sums; distinct estimate/bound/current/peak evidence | model.hpp |
| SharingContract | class{StatelessDeterministic,StatefulDeclared,Unique}; init/update/effect contract ID/version; correctness evidence references; explicit effect_free,replay_safe,cacheable | registry.hpp |
| ParentPublication | semantic computation digest; original UpdateKey, PortIndex, TemporalExtent, available_at_ns; optional source reference digest | binding.hpp |
| PublicationMetadata | activation UpdateKey/TemporalExtent; available_at_ns; ordered ParentPublication list; output type contracts; no copied ancestor rows | binding.hpp |
| ObservationRequest | explicit accepted missing-interval policy (Strict or Skip); request ID; producer LogicalId/output name; evaluation SequenceScope; absence{RequireValue}; uint64 prior_outputs; descriptor metadata | model.hpp |
| InputBindingSpec | input name; producer LogicalId/output name; uint64 prior_outputs; explicit alignment and accepted missing-interval contracts | model.hpp |
| NodeSpec | LogicalId,label,DeclaredOrdinal,OperationKey,CanonicalParams,ordered InputBindingSpec,InitializationSpec,declared update/availability/effect policies | model.hpp |
| Composition | schema version; owned run/limits/plugin/cache/evidence/source/node/request records; complete effective config and origin record | model.hpp |
| RequestRejection | RequestId; Diagnostic; affected dependency IDs | prepare.hpp |
| PreparedPlan | immutable effective Composition; owned frozen definitions/source snapshots/validated cache artifacts; logical order; alias mapping; identities; resource plan; required evidence specification; no mutable slots/state | prepare.hpp |
| RunInstance | one fresh instance/cursor and ResultSlot per physical producer; logical reach statuses; resource account; required sinks/finalizer; single-use lifecycle | execution.hpp |
| PrepareResult | optional shared_ptr<const PreparedPlan> plan; owned rejected requests and diagnostics; empty plan cannot instantiate | prepare.hpp |
| RunReport | run ID; NumericalOutcome; IntegrationOutcome and declared host experiment identity; AcceptanceStatus; CachePublicationStatus; logical request/node statuses; mapping; source/config/build identities; counters/resources; bounded primary/secondary causes; evidence inventory; outstanding-hold snapshot | evidence.hpp |

Graph display IDs are descriptive; declaration ordinals determine deterministic tie ordering. Changing declaration order can change independent effect order, and appears in the plan/run identity. It does not change an otherwise identical effect-free computation's semantic equality. Source/implementation content fingerprints are verified facts, not merely copied labels. Unknown source identity or unstable bound bytes prohibit a cache hit.

## Typed component boundary

The host uses a project-owned C++20 Result<T>=variant<T,Diagnostic>; Result<void>=variant<monostate,Diagnostic>. Definitions returning Result of an opaque class require that class's complete owning declaration before the variant is instantiated. A forward declaration is not its implementation. Opaque wrappers use host-owned pimpls with nonthrowing move/destruction. No numerical base class is required.

```cpp
// ReadValue<T> contains const T& value plus the scoped ownership lease.
// PublishValue<T> is T for ScalarCopy, Immutable<T> for ImmutableOwned.
// Typed helper checks the declared semantic type against the C++ witness.
template<class P, class S, class Inputs, class Outputs> struct TypedOperation;

template<class P, class S, class... In, class... Out>
struct TypedOperation<P,S,std::tuple<In...>,std::tuple<Out...>> {
  OperationContract contract;
  std::tuple<InputPort<In>...> inputs;
  std::tuple<OutputPort<Out>...> outputs;
  Result<P> (*parse_params)(const ParamSet&);
  Result<CanonicalParams> (*canonicalize)(const P&);
  Result<HistoryRequirement> (*history)(const P&,const PreparationFacts&);
  Result<ResourceBounds> (*resources)(const P&,const PreparationFacts&);
  Result<S> (*make_state)(const P&,const InitializationSpec&,StateAllocator&);
  StepResult<std::tuple<PublishValue<Out>...>> (*step)(
    S&,const P&,const std::tuple<ReadValue<In>...>&,
    const UpdateContext&,PublicationAllocator&);
  Result<void> (*validate_outputs)(const P&,
    const std::tuple<PublishValue<Out>...>&,const UpdateContext&);
};
```

InputPort<T>={name,RegisteredType<T>,prior_outputs}; OutputPort<T>={name,RegisteredType<T>}. OperationContract owns identity, parameter schema, ordered named type contracts, supported protocols, SharingContract and human description. PreparationFacts owns actual processing scope, InitializationSpec, explicit supported policies and admitted resource bounds. StateAllocator and PublicationAllocator expose only reservation/allocation capabilities. They do not expose a source resolver, arbitrary file access, RNG or ambient clock. Author callbacks may throw; host adapters catch ordinary exceptions. Destructors, module bootstrap, fixed-diagnostic transfer and final visibility swaps are nonthrowing.

```cpp
Result<Registry> Registry::create() noexcept;
template<class T> Result<RegisteredType<T>>
Registry::register_type(TypedTypePolicy<T>) noexcept;
template<class P,class S,class Ins,class Outs> Result<void>
Registry::register_definition(TypedOperation<P,S,Ins,Outs>) noexcept;
Result<std::shared_ptr<const OperationDefinition>>
Registry::resolve(const OperationKey&) const noexcept;
Result<void> Registry::freeze() noexcept;
Result<PreparedKernel> OperationDefinition::prepare(
  const ParamSet&,const PreparationFacts&) const noexcept;
Result<KernelInstance> PreparedKernel::instantiate(InstanceServices&) const noexcept;
Result<PendingOutcome> KernelInstance::step(const UpdateContext&) noexcept;
Result<ValidatedOutcome> Executor::validate_pending(PendingOutcome&&,
  const OperationContract&,const UpdateContext&,const ResultSlot&) noexcept;
void ResultSlot::commit(ValidatedOutcome&&) noexcept;
template<class T> Result<ReadValue<T>> ResultSlot::read(
  PortIndex,const UpdateContext&) const noexcept;
```

These are selected declaration contracts, not a claim that this excerpt alone compiles. PreparedKernel owns typed parameters, bounds, identity and pinned host-erased factory. InstanceServices supplies fresh per-run bound slots plus state/publication allocators; a frozen plan cannot hold mutable slots. PendingOutcome is move-only private staging; ValidatedOutcome is a move-only host-issued commit token. ResultSlot holds a complete current OutcomeFrame plus bounded declared retained publications. read checks exact C++ wrapper type and semantic contract, current key/permitted retained key and availability; it never advances state.

TypedTypePolicy<T>={TypeContract,StorageKind,validate,measure,freeze_strategy}. StorageKind is ScalarCopy or ImmutableOwned. For ImmutableOwned, freeze_strategy explicitly declares either host-exclusive construction with no mutable aliases or type-specific deep-copy/freeze. Generic shared_ptr<const T> and const_cast inspection are not proof. reserve(payload+ownership overhead) precedes allocation; the host AllocationControl carries one charge and paired typed destruction callback, keeping module pins until that callback returns. Immutable<T> is a const typed view owning this control. External handle copies do not multiply the payload charge. Module pins also cover callbacks, captured typed parameters, state, source cursors, any managers, witnesses and codecs. Host code/control blocks complete destruction before pins release.

## Source services

No core numerical callback sees these services. Preparation/source/codec service callbacks are also caught by host adapters; any partial provider/factory construction is destroyed under its host pin. They are owned concrete host wrappers with typed registration/erasure, not a mandatory public inheritance tree.

SourceRequest={provider_name,snapshot_name,requested_version,TypeContract interpretation,SequenceScope required_scope,CanonicalParams provider_policies}. SourceBounds={available_scope,ResourceBounds}. SourceMetadata={snapshot_name,version,content_digest,interpretation,CxxTypeWitness,validated_scope,coverage/order/availability contract fields}. SourceCandidate is validator-private pinned inspection data. SourceSnapshot owns immutable validated data/metadata and provider code. SourceCursor is fresh mutable delivery position, not reducer state.

```cpp
template<class T,class Inspection,class Data,class Cursor>
struct TypedSourceProvider {
  std::string name;
  RegisteredType<T> output_type;
  std::function<Result<Inspection>(const SourceRequest&,SourceValidationServices&)> inspect;
  std::function<Result<SourceBounds>(const Inspection&)> bounds;
  std::function<Result<Data>(Inspection&&,const SourceRequest&,SourceValidationServices&)> validate;
  std::function<Result<SourceMetadata>(const Data&)> metadata;
  std::function<Result<Cursor>(const Data&)> make_cursor;
  std::function<Result<SourceDelivery<T>>(Cursor&,const Data&,const UpdateContext&,
                                        PublicationAllocator&)> next;
};
Result<SourceCandidate> SourceResolver::inspect(
  const SourceRequest&,SourceValidationServices&) noexcept;
Result<SourceSnapshot> SourceResolver::validate(
  SourceCandidate&&,const SourceRequest&,SourceValidationServices&) noexcept;
Result<SourceCursor> SourceSnapshot::cursor(PublicationAllocator&) const noexcept;
Result<SourceEvent> SourceCursor::next(const UpdateContext&) noexcept;
```

SourceDelivery<T>=variant<SourceRecord<T>{timing,PublishValue<T>},SourceGap{SequenceScope missing_scope,Interval interval,uint32 declared_reason},SourceEnd{completed_scope}>. SourceEvent is the host-erased PendingOutcome, SourceGap or SourceEnd. SourceGap is host timeline control, not a fabricated payload or arbitrary component absence. SourceResolver::create/register_provider/freeze return Result and own typed adapters/pins. A provider supplies its own Inspection/Data/Cursor types; it never fabricates host pimpls. The host checks expected key, valid TemporalExtent and complete-bar status where applicable, type, availability and coverage before source publication. Under Strict, a declared SourceGap rejects preparation when known or fails at runtime. Under Skip, the host records it and advances only the expected timeline cursor, without invoking numerical kernels or actions. Original keys remain unchanged; gaps cannot be compressed out of source identity. Full required validation can inspect future rows; the source cursor exposes only one currently eligible record. End before required scope closure fails. End is not a numerical outcome.



## Owned supporting records

| Record | Required fields / constraints |
| --- | --- |
| ParamSet | Owned ordered raw NamedLiteral{name,text,source_location}; unique names; operation schema supplies required exact type, never a value default. Parsed/canonical values use CanonicalParams. |
| ParameterSchema | uint32 version; ordered ParameterField{name,ParamKind,required=true,constraints}; missing/unknown/duplicate reject. Every behavior-bearing choice is required or an exported versioned fact. |
| OperationContract | OperationKey key; ImplementationIdentity implementation; ParameterSchema parameters; ordered InputContract and OutputContract; SharingContract sharing; supported timing/alignment/missing/history protocols; owned description. |
| InputContract | name; TypeContract type; supported alignment/missing policy; explicit required-value protocol. |
| OutputContract | name; TypeContract type; StorageKind; codec_id/version and validation_contract_id/version; explicit cacheability supported by its codec. |
| StepResult<Outputs> | variant<Published{Outputs},Warming{uint64 remaining_preceding},ValidAbsence{uint32 declared_reason},Diagnostic>; no partial published bundle. First numeric fixture does not accept arbitrary interior ValidAbsence. |
| PrepareOptions | Owned submitted run ID, explicit validation/event/diagnostic limits, enabled graph comparison mode and declared source/store/evidence services; no hidden numerical defaults. Must agree with Composition. |
| MissingIntervalPolicy | enum Strict,Skip; exact text strict/skip. |
| TimingDescriptor | UpdateKey key; TemporalExtent extent; int64 available_at_ns; variant<CompleteRecord{uint64 payload_index},DeclaredGap{SourceGap}>; ordered, host-only, bounded. Payload indices never enter semantic identity. End is a separate cursor status. |
| SourceCoverage | SequenceScope expected_scope; ordered complete UpdateKeys; ordered SourceGap entries; explicit timing/expected-interval contract ID/version/params; checked counts and digest. Complete keys plus gaps partition the declared expected timeline. |
| SourceMetadata | snapshot_name; version; content_digest; TypeContract interpretation; CxxTypeWitness; validated_scope; SourceCoverage; timing/order/availability/validation contract IDs, versions and canonical parameters; source-reference digest; provider ImplementationIdentity. |

Point-event sources declare their succession/coverage contract and cannot infer missing expected bars from filtered acquisition ordinals. An expected-interval contract is required before a source can emit SourceGap. PublicationMetadata's TemporalExtent describes current activation; each ParentPublication preserves its own original extent. [Configuration](configuration.md) fixes temporal wire tags.

The concrete owned SourceMetadata definition above replaces the abbreviated source-service notation. Declare complete owning wrappers before instantiating Result<T>. These are selected interface contracts, not an assertion that the prose C++ excerpts constitute a compiling implementation.
