#pragma once

#include "lexongine/registry.hpp"

namespace lexongine {
namespace detail {
template<class... T, std::size_t... I>
Result<std::tuple<ReadValue<T>...>> read_inputs(const std::vector<BoundInput>& inputs, const UpdateContext& context,
                                              std::index_sequence<I...>) {
    auto reads = std::tuple{inputs[I].slot->template read<T>(inputs[I].port, context)...};
    std::optional<Diagnostic> error;
    std::apply([&](const auto&... result) {
        ([&] { if (const auto* failure = std::get_if<Diagnostic>(&result); failure && !error) { error = *failure; } }(), ...);
    }, reads);
    if (error) { return *error; }
    return std::tuple<ReadValue<T>...>{std::get<ReadValue<T>>(std::move(std::get<I>(reads)))...};
}
template<class T> Result<ErasedValue> erase_output(PublishValue<T> value, const RegisteredType<T>& type,
                                                 PublicationAllocator& allocator) {
    if constexpr (PublicationTraits<T>::storage == StorageKind::ScalarCopy) {
        auto copy = allocator.freeze(value, type);
        if (const auto* error = std::get_if<Diagnostic>(&copy)) { return *error; }
        return ErasedValue::from(std::get<Immutable<T>>(std::move(copy)), type.policy.contract);
    } else {
        if (auto valid = type.policy.validate(value.get()); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
        return ErasedValue::from(std::move(value), type.policy.contract);
    }
}
template<class... Out, std::size_t... I>
Result<void> stage_outputs(PendingOutcome& pending, std::tuple<PublishValue<Out>...>& values,
                          const std::tuple<OutputPort<Out>...>& ports, PublicationAllocator& allocator,
                          std::index_sequence<I...>) {
    std::optional<Diagnostic> failure;
    ([&] {
        if (failure) { return; }
        auto erased = erase_output<Out>(std::move(std::get<I>(values)), std::get<I>(ports).type, allocator);
        if (const auto* error = std::get_if<Diagnostic>(&erased)) { failure = *error; return; }
        auto staged = pending.set_output(static_cast<PortIndex>(I), std::get<ErasedValue>(std::move(erased)));
        if (const auto* error = std::get_if<Diagnostic>(&staged)) { failure = *error; }
    }(), ...);
    if (failure) { return *failure; }
    return ok();
}
}

template<class P, class S, class... In, class... Out>
Result<void> Registry::register_definition(TypedOperation<P, S, std::tuple<In...>, std::tuple<Out...>> operation) noexcept {
    return guarded([&]() -> Result<void> {
        using Op = TypedOperation<P, S, std::tuple<In...>, std::tuple<Out...>>;
        if (!operation.parse_params || !operation.canonicalize || !operation.history || !operation.resources ||
            !operation.make_state || !operation.step || !operation.validate_outputs ||
            operation.contract.inputs.size() != sizeof...(In) || operation.contract.outputs.size() != sizeof...(Out)) {
            return diagnostic(FailureCode::InvalidConfig, "incomplete typed operation");
        }
        bool mismatch = false;
        std::size_t index = 0;
        std::apply([&](const auto&... port) {
            ([&] {
                const auto& declared = operation.contract.inputs[index++];
                mismatch |= declared.name != port.name || !(declared.type == port.type.policy.contract);
            }(), ...);
        }, operation.inputs);
        index = 0;
        std::apply([&](const auto&... port) {
            ([&] {
                const auto& declared = operation.contract.outputs[index++];
                mismatch |= declared.name != port.name || !(declared.type == port.type.policy.contract) || declared.storage != port.type.policy.storage;
            }(), ...);
        }, operation.outputs);
        if (mismatch) { return diagnostic(FailureCode::TypeMismatch, "typed ports disagree with operation descriptor"); }
        auto contract = operation.contract;
        auto pin = operation.pin;
        return register_definition(std::move(contract), pin,
            [operation = std::move(operation)](const ParamSet& literals, const PreparationFacts& facts) -> Result<PreparedKernel> {
                return guarded([&]() -> Result<PreparedKernel> {
                    auto parsed = operation.parse_params(literals);
                    if (const auto* error = std::get_if<Diagnostic>(&parsed)) { return *error; }
                    P parameters = std::get<P>(std::move(parsed));
                    auto canonical = operation.canonicalize(parameters);
                    if (const auto* error = std::get_if<Diagnostic>(&canonical)) { return *error; }
                    auto history = operation.history(parameters, facts);
                    if (const auto* error = std::get_if<Diagnostic>(&history)) { return *error; }
                    if (!std::holds_alternative<CountHistory>(std::get<HistoryRequirement>(history))) {
                        return diagnostic(FailureCode::UnsupportedContract, "only count history is admitted");
                    }
                    auto resources = operation.resources(parameters, facts);
                    if (const auto* error = std::get_if<Diagnostic>(&resources)) { return *error; }
                    const auto declared_resources = std::get<ResourceBounds>(resources);
                    if (auto total = declared_resources.total(); std::holds_alternative<Diagnostic>(total)) { return std::get<Diagnostic>(total); }
                    return PreparedKernel::create(operation.pin, std::get<CanonicalParams>(std::move(canonical)),
                        std::get<HistoryRequirement>(std::move(history)), declared_resources,
                        [operation, parameters = std::move(parameters), facts](InstanceServices& services) -> Result<KernelInstance> {
                            return guarded([&]() -> Result<KernelInstance> {
                                if (!services.account || services.inputs.size() != sizeof...(In)) {
                                    return diagnostic(FailureCode::InvalidConfig, "typed factory input count/account mismatch");
                                }
                                for (std::size_t i = 0; i < services.inputs.size(); ++i) {
                                    const auto& bound = services.inputs[i];
                                    if (!bound.slot || bound.port >= bound.slot->contracts().size() ||
                                        !(bound.slot->contracts()[bound.port].semantic == operation.contract.inputs[i].type)) {
                                        return diagnostic(FailureCode::TypeMismatch, "factory bound slot meaning mismatch");
                                    }
                                }
                                // Fixed adapter/control/closure reservation precedes state construction.
                                auto overhead = services.account->reserve(ResourceKind::State,
                                    sizeof(S) + sizeof(P) + sizeof(Op) + sizeof(InstanceServices) + 1024);
                                if (const auto* error = std::get_if<Diagnostic>(&overhead)) { return *error; }
                                StateAllocator state_allocator{services.account};
                                auto state = operation.make_state(parameters, facts.initialization, state_allocator);
                                if (const auto* error = std::get_if<Diagnostic>(&state)) { return *error; }
                                auto mutable_state = std::make_shared<S>(std::get<S>(std::move(state)));
                                return KernelInstance::create(operation.pin, std::get<Reservation>(std::move(overhead)),
                                    [operation, parameters, mutable_state, services](const UpdateContext& context) -> Result<PendingOutcome> {
                                        return guarded([&]() -> Result<PendingOutcome> {
                                            if (auto valid = validate_context(context); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
                                            auto inputs = detail::read_inputs<In...>(services.inputs, context, std::index_sequence_for<In...>{});
                                            if (const auto* error = std::get_if<Diagnostic>(&inputs)) { return *error; }
                                            auto staged = PendingOutcome::create(services.account, context, sizeof...(Out));
                                            if (const auto* error = std::get_if<Diagnostic>(&staged)) { return *error; }
                                            auto pending = std::get<PendingOutcome>(std::move(staged));
                                            PublicationAllocator allocator{services.account};
                                            auto result = operation.step(*mutable_state, parameters,
                                                std::get<std::tuple<ReadValue<In>...>>(inputs), context, allocator);
                                            if (const auto* error = std::get_if<Diagnostic>(&result)) { return *error; }
                                            if (const auto* warming = std::get_if<Warming>(&result)) { pending.warming(warming->remaining_preceding); return pending; }
                                            if (const auto* absence = std::get_if<ValidAbsence>(&result)) { pending.absent(absence->declared_reason); return pending; }
                                            auto& values = std::get<Published<std::tuple<PublishValue<Out>...>>>(result).outputs;
                                            if (auto valid = operation.validate_outputs(parameters, values, context); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
                                            auto published = detail::stage_outputs<Out...>(pending, values, operation.outputs, allocator, std::index_sequence_for<Out...>{});
                                            if (const auto* error = std::get_if<Diagnostic>(&published)) { return *error; }
                                            return pending;
                                        });
                                    });
                            });
                        });
                });
            });
    });
}
} // namespace lexongine
