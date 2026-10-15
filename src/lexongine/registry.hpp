#pragma once

#include "lexongine/model.hpp"
#include "lexongine/binding.hpp"

#include <functional>
#include <tuple>
#include <typeindex>

namespace lexongine {

// A code pin is owned before any object whose destructor can enter that module.
struct CxxTypeWitness { ModulePin pin; std::type_index type; };
enum class SharingClass { StatelessDeterministic, StatefulDeclared, Unique };
struct SharingContract {
    SharingClass classification;
    Contract initialization, update, effect;
    bool effect_free, replay_safe, cacheable;
    std::vector<std::string> correctness_evidence;
};
struct InputContract {
    std::string name;
    TypeContract type;
    Alignment alignment;
    MissingIntervalPolicy missing_intervals;
    AbsencePolicy absence;
};
struct OutputContract {
    std::string name;
    TypeContract type;
    StorageKind storage;
    Contract codec, validation;
    bool cacheable;
};
struct OperationContract {
    OperationKey key;
    ImplementationIdentity implementation;
    ParameterSchema parameters;
    std::vector<InputContract> inputs;
    std::vector<OutputContract> outputs;
    SharingContract sharing;
    std::vector<std::string> timing_protocols;
    std::vector<Alignment> alignment_protocols;
    std::vector<MissingIntervalPolicy> missing_protocols;
    std::vector<std::string> history_protocols;
    std::string description;
};
struct PreparationFacts {
    SequenceScope processing_scope;
    InitializationSpec initialization;
    MissingIntervalPolicy missing_intervals;
    Alignment alignment;
    ResourceBounds admitted_resources;
    std::shared_ptr<ResourceAccount> preparation_account;
};
struct SourceMetadata {
    std::string snapshot_name, version;
    Sha256 content_digest;
    TypeContract interpretation;
    CxxTypeWitness witness;
    SequenceScope validated_scope;
    SourceCoverage coverage;
    Contract timing, order, availability, validation;
    Sha256 source_reference_digest;
    ImplementationIdentity provider_implementation;
};

enum class FreezeStrategy { ScalarCopy, ExclusiveConstruction, DeepCopy };
template<class T> struct PublicationTraits; // Every supported type explicitly chooses its storage policy.
template<class T> using PublishValue = typename PublicationTraits<T>::type;
template<class T> struct TypedTypePolicy {
    TypeContract contract;
    StorageKind storage;
    Result<void> (*validate)(const T&);
    Result<std::uint64_t> (*measure)(const T&);
    FreezeStrategy freeze_strategy;
    T (*freeze)(const T&);
    ModulePin pin;
};
template<class T> struct RegisteredType {
    TypedTypePolicy<T> policy;
    CxxTypeWitness witness;
};
template<class T> struct InputPort { std::string name; RegisteredType<T> type; std::uint64_t prior_outputs; };
template<class T> struct OutputPort { std::string name; RegisteredType<T> type; };

class StateAllocator {
public:
    explicit StateAllocator(std::shared_ptr<ResourceAccount> account) : account_(std::move(account)) {}
    Result<Reservation> reserve(std::uint64_t bytes) noexcept { return account_->reserve(ResourceKind::State, bytes); }
private:
    std::shared_ptr<ResourceAccount> account_;
};
class PublicationAllocator {
public:
    PublicationAllocator(std::shared_ptr<ResourceAccount> account, std::uint64_t maximum_parents)
        : account_(std::move(account)), maximum_parents_(maximum_parents) {}
    Result<ParentSelections> parents(std::span<const ParentSelection> selected) noexcept {
        return ParentSelections::create(account_, maximum_parents_, selected);
    }
    Result<ParentSelections> parents(std::initializer_list<ParentSelection> selected) noexcept {
        return parents(std::span<const ParentSelection>{selected.begin(), selected.size()});
    }
    template<class T> Result<Immutable<T>> freeze(const T& input, const RegisteredType<T>& type) noexcept {
        return guarded([&]() -> Result<Immutable<T>> {
            if (!type.policy.validate || !type.policy.measure || !type.policy.freeze) {
                return diagnostic(FailureCode::UnsupportedContract, "incomplete typed freeze contract");
            }
            if (auto valid = type.policy.validate(input); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
            auto bytes = type.policy.measure(input);
            if (const auto* error = std::get_if<Diagnostic>(&bytes)) { return *error; }
            return make_owned<T>(account_, ResourceKind::Retention, std::get<std::uint64_t>(bytes), type.policy.pin,
                                 [&] { return type.policy.freeze(input); });
        });
    }
private:
    std::shared_ptr<ResourceAccount> account_;
    std::uint64_t maximum_parents_;
};
struct InstanceServices {
    std::shared_ptr<ResourceAccount> account;
    std::vector<BoundInput> inputs;
};
class KernelInstance {
public:
    KernelInstance(KernelInstance&&) noexcept;
    KernelInstance& operator=(KernelInstance&&) noexcept;
    ~KernelInstance() noexcept;
    KernelInstance(const KernelInstance&) = delete;
    KernelInstance& operator=(const KernelInstance&) = delete;
    Result<PendingOutcome> step(const UpdateContext&) noexcept;
    static Result<KernelInstance> create(ModulePin, Reservation, std::function<Result<PendingOutcome>(const UpdateContext&)>) noexcept;
private:
    struct Impl;
    explicit KernelInstance(std::unique_ptr<Impl>) noexcept;
    std::unique_ptr<Impl> impl_;
};
class PreparedKernel {
public:
    PreparedKernel(PreparedKernel&&) noexcept;
    PreparedKernel& operator=(PreparedKernel&&) noexcept;
    ~PreparedKernel() noexcept;
    PreparedKernel(const PreparedKernel&) = delete;
    PreparedKernel& operator=(const PreparedKernel&) = delete;
    Result<KernelInstance> instantiate(InstanceServices&) const noexcept;
    [[nodiscard]] const CanonicalParams& parameters() const noexcept;
    [[nodiscard]] const HistoryRequirement& history() const noexcept;
    [[nodiscard]] const ResourceBounds& resources() const noexcept;
    static Result<PreparedKernel> create(ModulePin, CanonicalParams, HistoryRequirement, ResourceBounds,
                                        std::function<Result<KernelInstance>(InstanceServices&)>) noexcept;
private:
    friend class OperationDefinition;
    void adopt_preparation_reservation(Reservation) noexcept;
    struct Impl;
    explicit PreparedKernel(std::unique_ptr<Impl>) noexcept;
    std::unique_ptr<Impl> impl_;
};
template<class P, class S, class Inputs, class Outputs> struct TypedOperation;
template<class P, class S, class... In, class... Out>
struct TypedOperation<P, S, std::tuple<In...>, std::tuple<Out...>> {
    OperationContract contract;
    std::tuple<InputPort<In>...> inputs;
    std::tuple<OutputPort<Out>...> outputs;
    Result<P> (*parse_params)(const ParamSet&);
    Result<CanonicalParams> (*canonicalize)(const P&);
    Result<HistoryRequirement> (*history)(const P&, const PreparationFacts&);
    Result<ResourceBounds> (*resources)(const P&, const PreparationFacts&);
    Result<S> (*make_state)(const P&, const InitializationSpec&, StateAllocator&);
    StepResult<std::tuple<PublishValue<Out>...>> (*step)(S&, const P&, const std::tuple<ReadValue<In>...>&,
                                                     const UpdateContext&, PublicationAllocator&);
    Result<void> (*validate_outputs)(const P&, const std::tuple<PublishValue<Out>...>&, const UpdateContext&);
    ModulePin pin;
};

inline Result<void> validate_connection(const InputContract& input, const TypeContract& actual,
                                        std::string_view producer_clock, std::string_view consumer_clock,
                                        MissingIntervalPolicy policy) noexcept {
    if (!(input.type == actual)) { return diagnostic(FailureCode::TypeMismatch, "nominal port meaning does not match"); }
    if (producer_clock != consumer_clock || producer_clock.empty()) {
        return diagnostic(FailureCode::UnsupportedContract, "independent clock alignment is unsupported");
    }
    if (input.alignment != Alignment::SameStep || input.missing_intervals != policy) {
        return diagnostic(FailureCode::UnsupportedContract, "input alignment or missing policy mismatch");
    }
    return ok();
}

class OperationDefinition {
public:
    using Prepare = std::function<Result<PreparedKernel>(const ParamSet&, const PreparationFacts&)>;
    OperationDefinition(OperationContract contract, ModulePin pin, Prepare prepare);
    ~OperationDefinition() noexcept;
    [[nodiscard]] const OperationContract& contract() const noexcept { return contract_; }
    [[nodiscard]] Result<CanonicalParams> prepare_parameters(const ParamSet& input, std::uint64_t string_bytes) const noexcept {
        return parse_parameters(input, contract_.parameters, string_bytes);
    }
    [[nodiscard]] Result<PreparedKernel> prepare(const ParamSet&, const PreparationFacts&) const noexcept;
private:
    ModulePin pin_;
    OperationContract contract_;
    Prepare prepare_;
};
Result<std::shared_ptr<const OperationDefinition>> make_definition(OperationContract, ModulePin, OperationDefinition::Prepare) noexcept;

class Registry {
public:
    [[nodiscard]] static Result<Registry> create() noexcept { return Registry{}; }
    [[nodiscard]] Result<void> register_definition(OperationContract contract, ModulePin pin, OperationDefinition::Prepare prepare) noexcept {
        return guarded([&]() -> Result<void> {
            if (frozen_) { return diagnostic(FailureCode::InvalidConfig, "registry is frozen"); }
            if (!prepare) { return diagnostic(FailureCode::InvalidConfig, "operation requires an explicit typed preparation factory"); }
            if (contract.key.name.empty() || contract.key.name_space.empty() || contract.key.semantic_version == 0 ||
                contract.key.implementation_selector.empty() || contract.implementation.sdk_build_contract_id.empty()) {
                return diagnostic(FailureCode::InvalidConfig, "incomplete operation identity");
            }
            for (const auto& existing : definitions_) {
                if (existing->contract().key == contract.key) {
                    return diagnostic(FailureCode::DuplicateDefinition, "operation key already registered");
                }
            }
            for (std::size_t i = 0; i < contract.parameters.fields.size(); ++i) {
                const auto& field = contract.parameters.fields[i];
                if (!field.required || field.name.empty()) { return diagnostic(FailureCode::InvalidConfig, "parameter must be required and named"); }
                for (std::size_t j = 0; j < i; ++j) {
                    if (contract.parameters.fields[j].name == field.name) { return diagnostic(FailureCode::InvalidConfig, "duplicate schema field"); }
                }
            }
            auto definition = make_definition(std::move(contract), std::move(pin), std::move(prepare));
            if (const auto* error = std::get_if<Diagnostic>(&definition)) { return *error; }
            definitions_.push_back(std::get<std::shared_ptr<const OperationDefinition>>(std::move(definition)));
            return ok();
        });
    }
    template<class T> Result<RegisteredType<T>> register_type(TypedTypePolicy<T> policy) noexcept {
        return guarded([&]() -> Result<RegisteredType<T>> {
            if (frozen_) { return diagnostic(FailureCode::InvalidConfig, "registry is frozen"); }
            if (!policy.validate || !policy.measure || !policy.freeze || policy.contract.nominal_name.empty() ||
                policy.contract.semantic_version == 0 || policy.storage != PublicationTraits<T>::storage ||
                (policy.storage == StorageKind::ScalarCopy &&
                 (policy.freeze_strategy != FreezeStrategy::ScalarCopy || !std::is_trivially_copyable_v<T>))) {
                return diagnostic(FailureCode::InvalidConfig, "incomplete or contradictory typed storage contract");
            }
            for (const auto& existing : types_) {
                if (existing.semantic == policy.contract) {
                    if (existing.witness != std::type_index(typeid(T)) || existing.storage != policy.storage) {
                        return diagnostic(FailureCode::TypeMismatch, "nominal type has different C++ witness/storage");
                    }
                    return diagnostic(FailureCode::DuplicateDefinition, "type contract already registered");
                }
            }
            types_.push_back({policy.contract, std::type_index(typeid(T)), policy.storage, policy.pin});
            auto pin = policy.pin;
            return RegisteredType<T>{std::move(policy), {std::move(pin), std::type_index(typeid(T))}};
        });
    }
    template<class P, class S, class... In, class... Out>
    Result<void> register_definition(TypedOperation<P, S, std::tuple<In...>, std::tuple<Out...>>) noexcept;
    [[nodiscard]] Result<std::shared_ptr<const OperationDefinition>> resolve(const OperationKey& key) const noexcept {
        for (const auto& definition : definitions_) {
            if (definition->contract().key == key) { return definition; }
        }
        return diagnostic(FailureCode::UnknownDefinition, "exact operation version/implementation not registered");
    }
    [[nodiscard]] Result<void> freeze() noexcept { frozen_ = true; return ok(); }
    [[nodiscard]] bool frozen() const noexcept { return frozen_; }
    [[nodiscard]] const auto& definitions() const noexcept { return definitions_; }
private:
    bool frozen_ = false;
    std::vector<std::shared_ptr<const OperationDefinition>> definitions_;
    std::vector<ValueContract> types_;
};

} // namespace lexongine

#include "lexongine/typed_operation.hpp"
