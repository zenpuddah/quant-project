#include "lexongine/results.hpp"
#include "lexongine/binding.hpp"
#include "lexongine/registry.hpp"

namespace lexongine {
namespace {
template<class T> struct ControlAllocator {
    using value_type = T;
    ControlAllocator() = default;
    template<class U> ControlAllocator(const ControlAllocator<U>&) noexcept {}
    T* allocate(std::size_t count) {
        if (count > ownership_control_reserve / sizeof(T)) { throw std::bad_alloc{}; }
        return std::allocator<T>{}.allocate(count);
    }
    void deallocate(T* pointer, std::size_t count) noexcept { std::allocator<T>{}.deallocate(pointer, count); }
    template<class U> bool operator==(const ControlAllocator<U>&) const noexcept { return true; }
};
std::array<std::uint64_t, 7> bounds(const ResourceBounds& value) noexcept {
    return {value.source, value.state, value.scratch, value.staging, value.retention, value.graph, value.evidence};
}
}

Result<std::shared_ptr<ResourceAccount>> ResourceAccount::create(const AccountLimits& limits) noexcept {
    return guarded([&]() -> Result<std::shared_ptr<ResourceAccount>> {
        if (limits.max_allocations == 0 || limits.max_holders == 0 || limits.max_events == 0) {
            return diagnostic(FailureCode::InvalidConfig, "account requires explicit nonzero metadata capacities");
        }
        const auto allocations = checked_multiply(limits.max_allocations, sizeof(Allocation));
        const auto holders = checked_multiply(limits.max_holders, sizeof(Holder));
        const auto events = checked_multiply(limits.max_events, sizeof(RetentionEvent));
        if (std::holds_alternative<Diagnostic>(allocations) || std::holds_alternative<Diagnostic>(holders) ||
            std::holds_alternative<Diagnostic>(events)) { return diagnostic(FailureCode::ResourcePlanExceeded, "account metadata size overflow"); }
        const auto sum = checked_add(std::get<std::uint64_t>(allocations), std::get<std::uint64_t>(holders));
        if (const auto* error = std::get_if<Diagnostic>(&sum)) { return *error; }
        const auto graph = checked_add(std::get<std::uint64_t>(sum), sizeof(ResourceAccount) + 256);
        if (const auto* error = std::get_if<Diagnostic>(&graph)) { return *error; }
        if (std::get<std::uint64_t>(graph) > limits.bytes.graph || std::get<std::uint64_t>(events) > limits.bytes.evidence ||
            limits.max_allocations > std::numeric_limits<std::size_t>::max() ||
            limits.max_holders > std::numeric_limits<std::size_t>::max() || limits.max_events > std::numeric_limits<std::size_t>::max()) {
            return diagnostic(FailureCode::ResourcePlanExceeded, "account metadata exceeds explicit budget");
        }
        auto result = std::shared_ptr<ResourceAccount>(new ResourceAccount(limits));
        result->bounds_ = bounds(limits.bytes);
        result->current_[static_cast<std::size_t>(ResourceKind::Graph)] = std::get<std::uint64_t>(graph);
        result->current_[static_cast<std::size_t>(ResourceKind::Evidence)] = std::get<std::uint64_t>(events);
        result->peak_ = result->current_;
        result->allocations_ = std::make_unique<Allocation[]>(static_cast<std::size_t>(limits.max_allocations));
        result->holders_ = std::make_unique<Holder[]>(static_cast<std::size_t>(limits.max_holders));
        result->events_ = std::make_unique<RetentionEvent[]>(static_cast<std::size_t>(limits.max_events));
        return result;
    });
}
Result<void> ResourceAccount::note(RetentionEvent event) noexcept {
    if (closed_) { return ok(); }
    if (event_count_ == limits_.max_events) {
        const auto error = diagnostic(FailureCode::EvidenceQuota, "retention event capacity exhausted");
        if (!failure_) { failure_ = error; }
        return error;
    }
    events_[event_count_++] = event;
    return ok();
}
Result<Reservation> ResourceAccount::reserve(ResourceKind kind, std::uint64_t bytes) noexcept {
    if (failure_) { return *failure_; }
    if (closed_) { return diagnostic(FailureCode::ResourceExceeded, "closed resource account cannot allocate"); }
    const auto index = static_cast<std::size_t>(kind);
    if (index >= bounds_.size() || bytes > bounds_[index] - current_[index] || next_id_ == std::numeric_limits<std::uint64_t>::max()) {
        return diagnostic(FailureCode::ResourceExceeded, "resource reservation exceeds bound");
    }
    std::size_t slot = 0;
    while (slot < limits_.max_allocations && allocations_[slot].active) { ++slot; }
    if (slot == limits_.max_allocations) { return diagnostic(FailureCode::ResourceExceeded, "allocation ledger full"); }
    if (auto result = note({RetentionEventKind::Allocated, next_id_, bytes, 0}); std::holds_alternative<Diagnostic>(result)) {
        return std::get<Diagnostic>(result);
    }
    allocations_[slot] = {true, false, kind, next_id_, bytes, step_};
    current_[index] += bytes;
    peak_[index] = std::max(current_[index], peak_[index]);
    return Reservation{shared_from_this(), slot, next_id_++};
}
Result<HoldLease> ResourceAccount::hold(std::uint64_t allocation, std::string_view holder, std::string_view reason) noexcept {
    if (failure_) { return *failure_; }
    if (holder.size() >= 64 || reason.size() >= 64 || holder.empty() || reason.empty()) {
        return diagnostic(FailureCode::InvalidConfig, "holder/reason exceeds explicit 63-byte label contract");
    }
    const Allocation* record = nullptr;
    for (std::size_t i = 0; i < limits_.max_allocations; ++i) {
        if (allocations_[i].active && allocations_[i].id == allocation) { record = &allocations_[i]; break; }
    }
    if (!record) { return diagnostic(FailureCode::OutputInvalid, "holder refers to unknown allocation"); }
    std::size_t slot = 0;
    while (slot < limits_.max_holders && holders_[slot].active) { ++slot; }
    if (slot == limits_.max_holders) { return diagnostic(FailureCode::ResourceExceeded, "holder metadata exhausted"); }
    RetentionEvent event{RetentionEventKind::HoldAcquired, allocation, record->bytes, step_ - record->created};
    std::copy(holder.begin(), holder.end(), event.holder.begin());
    std::copy(reason.begin(), reason.end(), event.reason.begin());
    if (auto result = note(event); std::holds_alternative<Diagnostic>(result)) { return std::get<Diagnostic>(result); }
    holders_[slot] = {true, event};
    return HoldLease{shared_from_this(), slot};
}
Result<void> ResourceAccount::advance_age(std::uint64_t step) noexcept {
    if (step < step_) { return diagnostic(FailureCode::UpdateProtocol, "retention age clock regressed"); }
    if (failure_) { return *failure_; }
    step_ = step;
    for (std::size_t i = 0; i < limits_.max_allocations; ++i) {
        auto& record = allocations_[i];
        if (record.active && record.kind == ResourceKind::Retention && !record.warned && step - record.created >= limits_.retention_warning_steps) {
            if (auto result = note({RetentionEventKind::LongRetention, record.id, record.bytes, step - record.created});
                std::holds_alternative<Diagnostic>(result)) { return std::get<Diagnostic>(result); }
            record.warned = true;
        }
    }
    return ok();
}
Result<void> ResourceAccount::close_evidence() noexcept {
    if (closed_) { return diagnostic(FailureCode::UpdateProtocol, "retention evidence already closed"); }
    for (std::size_t i = 0; i < limits_.max_holders; ++i) {
        if (holders_[i].active) {
            auto event = holders_[i].event;
            event.kind = RetentionEventKind::OutstandingAtClose;
            static_cast<void>(note(event));
        }
    }
    closed_ = true;
    if (failure_) { return *failure_; }
    return ok();
}
void ResourceAccount::release(std::size_t slot) noexcept {
    auto& allocation = allocations_[slot];
    current_[static_cast<std::size_t>(allocation.kind)] -= allocation.bytes;
    allocation.active = false;
}
void ResourceAccount::release_hold(std::size_t slot) noexcept {
    auto& holder = holders_[slot];
    holder.event.kind = RetentionEventKind::HoldReleased;
    static_cast<void>(note(holder.event));
    holder.active = false;
}
Reservation::Reservation(Reservation&& other) noexcept
    : account_(std::move(other.account_)), slot_(other.slot_), id_(other.id_) {}
Reservation& Reservation::operator=(Reservation&& other) noexcept {
    if (this != &other) { reset(); account_ = std::move(other.account_); slot_ = other.slot_; id_ = other.id_; }
    return *this;
}
void Reservation::reset() noexcept { if (account_) { account_->release(slot_); account_.reset(); } }
Reservation::~Reservation() noexcept { reset(); }
HoldLease::HoldLease(HoldLease&& other) noexcept : account_(std::move(other.account_)), slot_(other.slot_) {}
HoldLease& HoldLease::operator=(HoldLease&& other) noexcept {
    if (this != &other) { reset(); account_ = std::move(other.account_); slot_ = other.slot_; }
    return *this;
}
void HoldLease::reset() noexcept { if (account_) { account_->release_hold(slot_); account_.reset(); } }
HoldLease::~HoldLease() noexcept { reset(); }
AllocationControl::AllocationControl(ModulePin pin, Reservation payload, Reservation control,
                                    std::shared_ptr<ResourceAccount> account, void* data, void (*destroy)(void*) noexcept,
                                    std::type_index type) noexcept
    : pin_(std::move(pin)), payload_charge_(std::move(payload)), control_charge_(std::move(control)),
      account_(std::move(account)), data_(data), destroy_(destroy), type_(type) {}
AllocationControl::~AllocationControl() noexcept { destroy_(data_); }
Result<std::shared_ptr<const AllocationControl>> make_allocation_control(ModulePin pin, Reservation payload,
    Reservation overhead, std::shared_ptr<ResourceAccount> account, void* data, void (*destroy)(void*) noexcept,
    std::type_index type) noexcept {
    return guarded([&]() -> Result<std::shared_ptr<const AllocationControl>> {
        return std::allocate_shared<AllocationControl>(ControlAllocator<AllocationControl>{}, std::move(pin),
            std::move(payload), std::move(overhead), std::move(account), data, destroy, type);
    });
}

Result<PendingOutcome> PendingOutcome::create(std::shared_ptr<ResourceAccount> account,
                                             const UpdateContext& context, std::size_t outputs) noexcept {
    return guarded([&]() -> Result<PendingOutcome> {
        if (!account) { return diagnostic(FailureCode::InvalidConfig, "missing staging account"); }
        auto payload = checked_multiply(outputs, sizeof(std::optional<ErasedValue>));
        if (const auto* error = std::get_if<Diagnostic>(&payload)) { return *error; }
        auto bytes = checked_add(std::get<std::uint64_t>(payload), sizeof(OutcomeFrame) + 256 + context.key.clock.size() + 1);
        if (const auto* error = std::get_if<Diagnostic>(&bytes)) { return *error; }
        auto reserved = account->reserve(ResourceKind::Staging, std::get<std::uint64_t>(bytes));
        if (const auto* error = std::get_if<Diagnostic>(&reserved)) { return *error; }
        auto frame = std::make_shared<OutcomeFrame>(OutcomeFrame{std::get<Reservation>(std::move(reserved)), context,
            OutcomeKind::Published, 0, 0, std::vector<std::optional<ErasedValue>>(outputs)});
        return PendingOutcome{std::move(frame)};
    });
}
Result<void> PendingOutcome::set_output(PortIndex index, ErasedValue value) noexcept {
    if (!frame_ || frame_->kind != OutcomeKind::Published || index >= frame_->outputs.size() || frame_->outputs[index]) {
        return diagnostic(FailureCode::OutputInvalid, "wrong or duplicate staged output");
    }
    frame_->outputs[index] = std::move(value);
    return ok();
}
void PendingOutcome::warming(std::uint64_t remaining) noexcept {
    frame_->kind = OutcomeKind::Warming;
    frame_->remaining_preceding = remaining;
    for (auto& value : frame_->outputs) { value.reset(); }
}
void PendingOutcome::absent(std::uint32_t reason) noexcept {
    frame_->kind = OutcomeKind::ValidAbsence;
    frame_->declared_reason = reason;
    for (auto& value : frame_->outputs) { value.reset(); }
}
Result<std::shared_ptr<ResultSlot>> ResultSlot::create(std::shared_ptr<ResourceAccount> account,
    std::vector<ValueContract> contracts, std::uint64_t prior_outputs) noexcept {
    return guarded([&]() -> Result<std::shared_ptr<ResultSlot>> {
        if (!account) { return diagnostic(FailureCode::InvalidConfig, "missing slot account"); }
        auto capacity = checked_add(prior_outputs, 1);
        if (const auto* error = std::get_if<Diagnostic>(&capacity)) { return *error; }
        const auto count = std::get<std::uint64_t>(capacity);
        if (count > std::numeric_limits<std::size_t>::max()) { return diagnostic(FailureCode::ResourcePlanExceeded, "retention capacity does not fit size_t"); }
        auto bytes = checked_multiply(count, sizeof(std::shared_ptr<const OutcomeFrame>));
        if (const auto* error = std::get_if<Diagnostic>(&bytes)) { return *error; }
        bytes = checked_add(std::get<std::uint64_t>(bytes), sizeof(ResultSlot) + 256);
        if (const auto* error = std::get_if<Diagnostic>(&bytes)) { return *error; }
        for (const auto& entry : contracts) {
            auto size = type_storage_bytes(entry.semantic);
            if (const auto* error = std::get_if<Diagnostic>(&size)) { return *error; }
            bytes = checked_add(std::get<std::uint64_t>(bytes), sizeof(ValueContract) + std::get<std::uint64_t>(size));
            if (const auto* error = std::get_if<Diagnostic>(&bytes)) { return *error; }
        }
        auto charge = account->reserve(ResourceKind::Graph, std::get<std::uint64_t>(bytes));
        if (const auto* error = std::get_if<Diagnostic>(&charge)) { return *error; }
        return std::shared_ptr<ResultSlot>(new ResultSlot(std::get<Reservation>(std::move(charge)), std::move(contracts),
                                                         static_cast<std::size_t>(count)));
    });
}
Result<ValidatedOutcome> validate_pending(PendingOutcome&& pending, const ResultSlot& slot,
                                         const UpdateContext& context) noexcept {
    if (auto valid = validate_context(context); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
    if (!pending.frame_ || pending.frame_->context.key != context.key || pending.frame_->context.extent != context.extent ||
        pending.frame_->context.activation_available_at_ns < context.activation_available_at_ns ||
        pending.frame_->context.activation_available_at_ns > context.decision_time_ns) {
        return diagnostic(FailureCode::UpdateProtocol, "pending output activation mismatch");
    }
    if (slot.current_ && (slot.current_->context.key.clock != context.key.clock ||
                          slot.current_->context.key.sequence >= context.key.sequence)) {
        return diagnostic(FailureCode::UpdateProtocol, "duplicate or regressed resolved update");
    }
    if (pending.frame_->outputs.size() != slot.contracts_.size()) {
        return diagnostic(FailureCode::OutputInvalid, "output bundle arity mismatch");
    }
    if (pending.frame_->kind == OutcomeKind::Published) {
        for (std::size_t i = 0; i < slot.contracts_.size(); ++i) {
            const auto& value = pending.frame_->outputs[i];
            if (!value) { return diagnostic(FailureCode::OutputInvalid, "incomplete output bundle"); }
            if (!(value->semantic() == slot.contracts_[i].semantic) || value->control()->type() != slot.contracts_[i].witness) {
                return diagnostic(FailureCode::TypeMismatch, "staged output semantic or C++ type mismatch");
            }
        }
    } else if (pending.frame_->kind != OutcomeKind::Warming && pending.frame_->kind != OutcomeKind::ValidAbsence) {
        return diagnostic(FailureCode::OutputInvalid, "unpublishable outcome");
    }
    return ValidatedOutcome{std::move(pending.frame_)};
}
void ResultSlot::commit(ValidatedOutcome&& validated) noexcept {
    current_.swap(validated.frame_);
    if (current_->kind == OutcomeKind::Published) {
        history_[next_history_] = current_;
        next_history_ = (next_history_ + 1) % history_.size();
    }
}

OperationDefinition::OperationDefinition(OperationContract contract, ModulePin pin, Prepare prepare)
    : pin_(std::move(pin)), contract_(std::move(contract)), prepare_(std::move(prepare)) {}
OperationDefinition::~OperationDefinition() noexcept = default;
Result<std::shared_ptr<const OperationDefinition>> make_definition(OperationContract contract, ModulePin pin,
                                                                  OperationDefinition::Prepare prepare) noexcept {
    return guarded([&]() -> Result<std::shared_ptr<const OperationDefinition>> {
        return std::make_shared<const OperationDefinition>(std::move(contract), std::move(pin), std::move(prepare));
    });
}
Result<PreparedKernel> OperationDefinition::prepare(const ParamSet& parameters, const PreparationFacts& facts) const noexcept {
    return guarded([&]() -> Result<PreparedKernel> {
        if (!prepare_) { return diagnostic(FailureCode::UnsupportedContract, "description has no typed factory"); }
        // String bound belongs to the caller's bounded preparation record. This
        // validation never inserts defaults; frontend limits also apply earlier.
        auto parsed = parse_parameters(parameters, contract_.parameters, facts.admitted_resources.graph);
        if (const auto* error = std::get_if<Diagnostic>(&parsed)) { return *error; }
        return prepare_(parameters, facts);
    });
}
struct KernelInstance::Impl {
    ModulePin pin;
    Reservation charge;
    std::function<Result<PendingOutcome>(const UpdateContext&)> step;
    std::optional<UpdateKey> last_resolved_key;
};
KernelInstance::KernelInstance(std::unique_ptr<Impl> impl) noexcept : impl_(std::move(impl)) {}
KernelInstance::KernelInstance(KernelInstance&&) noexcept = default;
KernelInstance& KernelInstance::operator=(KernelInstance&&) noexcept = default;
KernelInstance::~KernelInstance() noexcept = default;
Result<KernelInstance> KernelInstance::create(ModulePin pin, Reservation charge,
                                             std::function<Result<PendingOutcome>(const UpdateContext&)> step) noexcept {
    return guarded([&]() -> Result<KernelInstance> {
        return KernelInstance{std::make_unique<Impl>(Impl{std::move(pin), std::move(charge), std::move(step), std::nullopt})};
    });
}
Result<PendingOutcome> KernelInstance::step(const UpdateContext& context) noexcept {
    return guarded([&]() -> Result<PendingOutcome> {
        if (!impl_) { return diagnostic(FailureCode::InvalidConfig, "empty kernel instance"); }
        if (auto valid = validate_context(context); std::holds_alternative<Diagnostic>(valid)) { return std::get<Diagnostic>(valid); }
        if (impl_->last_resolved_key && (impl_->last_resolved_key->clock != context.key.clock ||
                                         impl_->last_resolved_key->sequence >= context.key.sequence)) {
            return diagnostic(FailureCode::UpdateProtocol, "kernel already resolved this key or clock changed");
        }
        impl_->last_resolved_key = context.key; // Any allocation occurs before the author callback.
        return impl_->step(context);
    });
}
struct PreparedKernel::Impl {
    ModulePin pin;
    CanonicalParams parameters;
    HistoryRequirement history;
    ResourceBounds resources;
    std::function<Result<KernelInstance>(InstanceServices&)> instantiate;
};
PreparedKernel::PreparedKernel(std::unique_ptr<Impl> impl) noexcept : impl_(std::move(impl)) {}
PreparedKernel::PreparedKernel(PreparedKernel&&) noexcept = default;
PreparedKernel& PreparedKernel::operator=(PreparedKernel&&) noexcept = default;
PreparedKernel::~PreparedKernel() noexcept = default;
Result<PreparedKernel> PreparedKernel::create(ModulePin pin, CanonicalParams parameters, HistoryRequirement history,
    ResourceBounds resources, std::function<Result<KernelInstance>(InstanceServices&)> instantiate) noexcept {
    return guarded([&]() -> Result<PreparedKernel> {
        return PreparedKernel{std::make_unique<Impl>(Impl{std::move(pin), std::move(parameters), std::move(history),
                                                         resources, std::move(instantiate)})};
    });
}
Result<KernelInstance> PreparedKernel::instantiate(InstanceServices& services) const noexcept {
    return guarded([&]() -> Result<KernelInstance> {
        if (!impl_) { return diagnostic(FailureCode::InvalidConfig, "empty prepared kernel"); }
        return impl_->instantiate(services);
    });
}
const CanonicalParams& PreparedKernel::parameters() const noexcept { return impl_->parameters; }
const HistoryRequirement& PreparedKernel::history() const noexcept { return impl_->history; }
const ResourceBounds& PreparedKernel::resources() const noexcept { return impl_->resources; }
} // namespace lexongine
