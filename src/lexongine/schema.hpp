#pragma once

#include <array>
#include <string_view>

namespace lexongine {
struct SchemaDescriptor { std::string_view name, fields; };
// Ordered wire fields, not C++ object layout. Shared by all later XML projections.
inline constexpr auto schema_descriptors = std::to_array<SchemaDescriptor>({
    {"ComputationIdentityV1", "operation,parameters,inputs,outputs,sources,initialization,processing_scope,history,timing_policy,numerical_policy,missing_policy,sharing_contract,codec_contract,validation_contract"},
    {"OperationIdentityV1", "namespace,name,semantic_version,binary_digest,dependencies_digest,source_build_digest,sdk_build_contract_id"},
    {"CanonicalParamsV1", "schema_version,values"}, {"NamedParamV1", "name,value"},
    {"InputIdentityV1", "input_name,producer_identity,output_port,prior_outputs,alignment_contract,missing_policy"},
    {"OutputIdentityV1", "output_name,type_contract,storage_kind,codec_contract,validation_contract"},
    {"TypeContractV1", "nominal_name,semantic_version,meaning"}, {"ContractV1", "id,version,parameters"},
    {"SequenceScopeV1", "clock,begin,end"}, {"UpdateKeyV1", "clock,sequence"},
    {"InitializationV1", "contract,actual_prefix,explicit_values"},
    {"SharingV1", "class,init_contract,update_contract,effect_contract,effect_free,replay_safe,cacheable"},
    {"SourceIdentityV1", "snapshot_name,source_version,content_digest,provider_operation,interpretation,query_selection_contract,reference_digest,validated_scope,coverage,order_contract,availability_contract,validation_contract"},
    {"CoverageV1", "expected_scope,complete_keys,gaps,expected_timeline_contract"},
    {"GapV1", "missing_scope,interval,declared_reason"}, {"IntervalV1", "begin_ns,end_ns"},
    {"PointTimeV1", "event_time_ns"}, {"CountHistoryV1", "preceding"},
    {"ArtifactIdentityV1", "computation,processing_scope,ordered_output_types,codec_contract,validation_contract"},
    {"PlanIdentityV1", "effective_composition,logical_order,aliases,admitted_requests,rejected_requests,resource_plan,required_evidence"},
    {"StartupV1", "initialization,history"},
    {"EvidenceReferenceV1", "name,absolute_path,byte_count,digest,finalized"},
    {"EntryReferenceV1", "artifact_id,identity_digest,manifest_digest,manifest_bytes,payload_digest,payload_bytes"},
    {"SnapshotReferenceV1", "absolute_path,byte_count,digest"},
    {"UpdateContext", "key,extent,decision_time_ns,activation_available_at_ns"},
    {"RequestContext", "request,evaluation,phase,key"},
    {"NamedParam", "name,value,origin,provenance"},
    {"NamedLiteral", "name,text,source_location"}, {"SourceLocation", "path,line"},
    {"ParamSet", "values"}, {"ParameterSchema", "version,fields"},
    {"ParameterField", "name,kind,required,constraints"},
    {"ParameterConstraints", "signed_min,signed_max,unsigned_min,unsigned_max,allowed_text"},
    {"OperationKey", "namespace,name,semantic_version,implementation_selector"},
    {"OperationContract", "key,implementation,parameters,inputs,outputs,sharing,timing_protocols,alignment_protocols,missing_protocols,history_protocols,description"},
    {"InputContract", "name,type,alignment,missing_intervals,absence"},
    {"OutputContract", "name,type,storage,codec,validation,cacheable"},
    {"SharingContract", "classification,initialization,update,effect,effect_free,replay_safe,cacheable,correctness_evidence"},
    {"ResourceBounds", "source,state,scratch,staging,retention,graph,evidence"},
    {"PreparationFacts", "processing_scope,initialization,missing_intervals,alignment,admitted_resources"},
    {"ParentPublication", "computation_digest,key,port,extent,available_at_ns,source_reference_digest"},
    {"Published", "outputs,parents"},
    {"PublicationMetadata", "key,extent,available_at_ns,parents,output_types"},
    {"ObservationRequest", "missing_intervals,id,producer,output_name,evaluation,absence,prior_outputs,label"},
    {"InputBindingSpec", "input_name,producer,output_name,prior_outputs,alignment,missing_intervals"},
    {"NodeSpec", "id,label,ordinal,operation,parameters,inputs,initialization,update_policy,availability_policy,effect_policy"},
    {"SourceRequest", "provider_name,snapshot_name,requested_version,interpretation,required_scope,provider_policies"},
    {"SourceBounds", "available_scope,resources"},
    {"SourceMetadata", "snapshot_name,version,content_digest,interpretation,witness,validated_scope,coverage,timing,order,availability,validation,source_reference_digest,provider_implementation"},
    {"TimingDescriptor", "key,extent,available_at_ns,delivery"},
    {"CompleteRecord", "payload_index"}, {"DeclaredGap", "gap"}, {"SourceEnd", "completed_scope"},
    {"Warming", "remaining_preceding"}, {"ValidAbsence", "declared_reason"},
    {"Diagnostic", "code,message,length,truncated,logical_ordinal,request_ordinal,key"},
    {"DiagnosticKey", "clock_ordinal,sequence"},
    {"IntegrationCompletion", "kind,cause,host_contract_id,host_contract_version,host_experiment_identity"},
    {"StepReceipt", "status,key,extent,available_at_ns,gap,completed_scope,sources,observations,reach,cause"}
});
[[nodiscard]] constexpr std::string_view schema_fields(std::string_view name) noexcept {
    for (const auto& record : schema_descriptors) { if (record.name == name) { return record.fields; } }
    return {};
}
} // namespace lexongine
