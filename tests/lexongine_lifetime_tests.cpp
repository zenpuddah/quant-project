#include "lexongine_test_support.hpp"
#include "lexongine/results.hpp"
#include "lexongine/binding.hpp"
#include "lexongine/registry.hpp"

namespace {
using namespace lexongine;
using namespace lexongine::test;
std::shared_ptr<ResourceAccount> account(std::uint64_t bytes = 65536) {
    return take(ResourceAccount::create({{bytes, bytes, bytes, bytes, bytes, 65536, 65536}, 64, 64, 256, 2}));
}
void reserve_before_allocation() {
    auto resources = account(8);
    bool called = false;
    auto value = make_owned<std::int64_t>(resources, ResourceKind::Retention, 9, {}, [&] {
        called = true; return std::int64_t{7};
    });
    rejects(std::move(value), FailureCode::ResourceExceeded);
    require(!called && resources->current(ResourceKind::Retention) == 0, "allocated before reservation");
}
void external_lifetime() {
    auto resources = account();
    std::weak_ptr<ResourceAccount> weak = resources;
    auto value = take(make_owned<std::vector<int>>(resources, ResourceKind::Retention, 64, {}, [] { return std::vector<int>{1, 2, 3}; }));
    auto copy = take(value.share("consumer-B", "window"));
    require(resources->current(ResourceKind::Retention) == 64, "shared payload double charged");
    resources.reset();
    require(!weak.expired() && copy.get()[1] == 2, "escaped value lost account or data");
    value = {};
    require(!weak.expired() && copy.get()[0] == 1, "first holder invalidated second");
    copy = {};
    require(weak.expired(), "account leaked after final external release");
}
void immutable_copy_and_warning() {
    auto resources = account();
    std::vector<int> source{4, 5};
    auto value = take(make_owned<std::vector<int>>(resources, ResourceKind::Retention, 64, {}, [&] { return source; }));
    source[0] = 99;
    require(value.get()[0] == 4, "published buffer aliases mutable source");
    success(resources->advance_age(2));
    success(resources->advance_age(3));
    std::size_t warnings = 0;
    for (const auto& event : resources->events()) { warnings += event.kind == RetentionEventKind::LongRetention ? 1 : 0; }
    require(warnings == 1 && value.get()[0] == 4, "retention warning duplicated or forcibly released data");
    success(resources->close_evidence());
    const auto count = resources->events().size();
    value = {};
    require(resources->current(ResourceKind::Retention) == 0, "final release did not remove charge");
    require(resources->events().size() == count, "destruction wrote after evidence close");
}
void pinned_destruction() {
    bool destroyed = false, pinned_in_destructor = false;
    struct Payload {
        bool* destroyed; bool* pinned; std::weak_ptr<const void> code;
        ~Payload() noexcept { *pinned = !code.expired(); *destroyed = true; }
    };
    auto resources = account();
    ModulePin pin = std::make_shared<int>(1);
    std::weak_ptr<const void> weak = pin;
    auto object = take(make_owned<Payload>(resources, ResourceKind::State, sizeof(Payload), pin,
        [&] { return Payload{&destroyed, &pinned_in_destructor, weak}; }));
    pin.reset();
    object = {};
    require(destroyed && pinned_in_destructor && weak.expired(), "host pin did not span destruction");
}
void hold_limit() {
    auto resources = take(ResourceAccount::create({{1024, 1024, 1024, 1024, 1024, 65536, 65536}, 4, 1, 32, 2}));
    auto value = take(make_owned<int>(resources, ResourceKind::Retention, sizeof(int), {}, [] { return 1; }));
    rejects(value.share("second", "external"), FailureCode::ResourceExceeded);
    require(value.get() == 1, "quota failure invalidated original holder");
}
void exclusive_transfer() {
    auto resources = take(ResourceAccount::create({{4096, 4096, 4096, 4096, 4096, 65536, 65536}, 16, 1, 64, 2}));
    const TypeContract semantic{"test.integer", 1, {1, {}}};
    auto value = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [] { return std::int64_t{3}; }));
    auto erased = take(ErasedValue::from(std::move(value), semantic));
    require(resources->current(ResourceKind::Retention) == 8 && erased.control()->type() == std::type_index(typeid(std::int64_t)),
            "exclusive transfer duplicated ownership/charge");
}
void atomic_bundle_and_reads() {
    auto resources = account();
    const TypeContract semantic{"test.integer", 1, {1, {}}};
    const ValueContract integer{semantic, std::type_index(typeid(std::int64_t)), StorageKind::ScalarCopy, {}};
    auto slot = take(ResultSlot::create(resources, {integer, integer}, 1, Sha256{}, std::nullopt));
    const UpdateContext first{{"clock", 0}, PointTime{10}, 10, 10};
    auto partial = take(PendingOutcome::create(resources, first, 2));
    auto value = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [] { return std::int64_t{7}; }));
    success(partial.set_output(0, take(ErasedValue::from(std::move(value), semantic))));
    rejects(validate_pending(std::move(partial), *slot, first), FailureCode::OutputInvalid);
    rejects(slot->read<std::int64_t>(0, first), FailureCode::MissingRequired);
    auto complete = take(PendingOutcome::create(resources, first, 2));
    for (PortIndex i = 0; i < 2; ++i) {
        auto payload = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [i] { return std::int64_t{7} + i; }));
        success(complete.set_output(i, take(ErasedValue::from(std::move(payload), semantic))));
    }
    slot->commit(take(validate_pending(std::move(complete), *slot, first)));
    auto read1 = take(slot->read<std::int64_t>(0, first));
    auto read2 = take(slot->read<std::int64_t>(0, first));
    require(read1.value == 7 && &read1.value == &read2.value, "reads changed stable current publication");
    auto scalar_copy = take(read1.retain("external", "scalar_copy"));
    require(scalar_copy.get() == 7 && &scalar_copy.get() != &read1.value, "scalar retention must copy the value");
    rejects(slot->read<std::uint64_t>(0, first), FailureCode::TypeMismatch);
    auto future = first; future.decision_time_ns = 9;
    rejects(slot->read<std::int64_t>(0, future), FailureCode::FutureRead);
    auto wrong_extent = first; wrong_extent.extent = PointTime{11};
    rejects(slot->read<std::int64_t>(0, wrong_extent), FailureCode::UpdateProtocol);
    auto duplicate = take(PendingOutcome::create(resources, first, 2));
    duplicate.warming(1);
    rejects(validate_pending(std::move(duplicate), *slot, first), FailureCode::UpdateProtocol);
    auto second = first; second.key.sequence = 1;
    auto warming = take(PendingOutcome::create(resources, second, 2));
    warming.warming(1);
    slot->commit(take(validate_pending(std::move(warming), *slot, second)));
    rejects(slot->read<std::int64_t>(0, second), FailureCode::MissingRequired);
    require(read1.value == 7, "later warming invalidated retained read");
}
void provenance_envelope() {
    auto resources = account();
    const TypeContract semantic{"test.integer", 1, {1, {}}};
    const ValueContract integer{semantic, std::type_index(typeid(std::int64_t)), StorageKind::ScalarCopy, {}};
    auto input = take(ResultSlot::create(resources, {integer}, 0, Sha256{std::byte{1}}, std::nullopt));
    auto output = take(ResultSlot::create(resources, {integer}, 0, Sha256{std::byte{2}}, std::nullopt));
    auto publish = [&](ResultSlot& slot, const UpdateContext& context, std::int64_t raw) {
        auto pending = take(PendingOutcome::create(resources, context, 1));
        auto value = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [raw] { return raw; }));
        success(pending.set_output(0, take(ErasedValue::from(std::move(value), semantic))));
        slot.commit(take(validate_pending(std::move(pending), slot, context)));
    };
    const UpdateContext first{{"clock", 0}, Interval{0, 60}, 60, 60};
    // Publication age counts actual inputs, not key distance across a source gap.
    const UpdateContext second{{"clock", 2}, Interval{120, 180}, 180, 180};
    publish(*input, first, 10);
    const auto old_parent = take(input->read<std::int64_t>(0, first, 0)).parent();
    publish(*input, second, 20);
    require(resources->current(ResourceKind::Retention) == 8, "parent metadata retained ancestor payload");
    const std::array<BoundInput, 1> bindings{{{input, 0, 0}}};
    PublicationAllocator allocator{resources, 2};
    auto pending = take(PendingOutcome::create(resources, second, 1));
    auto payload = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [] { return std::int64_t{10}; }));
    success(pending.set_output(0, take(ErasedValue::from(std::move(payload), semantic))));
    success(ProvenanceValidator::attach(pending, take(allocator.parents({old_parent})), bindings, 1, second));
    output->commit(take(validate_pending(std::move(pending), *output, second)));
    auto value = take(output->read<std::int64_t>(0, second));
    require(value.publication().available_at_ns == 180 && value.publication().key.sequence == 2,
            "lagged publication was backdated");
    const auto& parent = output->current()->parents.entries()[0].metadata();
    require(parent.key.sequence == 0 && parent.available_at_ns == 60 && parent.computation_digest[0] == std::byte{1},
            "selected original parent metadata was lost");
    auto bad = take(PendingOutcome::create(resources, second, 1));
    rejects(ProvenanceValidator::attach(bad, ParentSelections::none(), bindings, 1, second), FailureCode::OutputInvalid);
    rejects(ProvenanceValidator::attach(bad, take(allocator.parents({old_parent, old_parent})), bindings, 1, second), FailureCode::OutputInvalid);
    rejects(ProvenanceValidator::attach(bad, take(allocator.parents({old_parent})), bindings, 0, second), FailureCode::OutputInvalid);
    auto unrelated = take(ResultSlot::create(resources, {integer}, 0, Sha256{std::byte{1}}, std::nullopt));
    publish(*unrelated, second, 20);
    auto foreign = take(unrelated->read<std::int64_t>(0, second, 0)).parent();
    rejects(ProvenanceValidator::attach(bad, take(allocator.parents({foreign})), bindings, 1, second), FailureCode::OutputInvalid);
    auto no_port = take(input->read<std::int64_t>(0, second)).parent();
    rejects(ProvenanceValidator::attach(bad, take(allocator.parents({no_port})), bindings, 1, second), FailureCode::OutputInvalid);
    auto right = take(input->read<std::int64_t>(0, second, 1)).parent();
    auto left = take(input->read<std::int64_t>(0, second, 0)).parent();
    const std::array<BoundInput, 2> two_bindings{{{input, 0, 0}, {input, 0, 0}}};
    rejects(ProvenanceValidator::attach(bad, take(allocator.parents({right, left})), two_bindings, 1, second), FailureCode::OutputInvalid);
}
void bounded_history_and_callback_failure() {
    auto resources = account();
    const TypeContract semantic{"test.integer", 1, {1, {}}};
    const ValueContract integer{semantic, std::type_index(typeid(std::int64_t)), StorageKind::ScalarCopy, {}};
    auto slot = take(ResultSlot::create(resources, {integer}, 1, Sha256{}, std::nullopt));
    for (std::uint64_t key = 0; key < 3; ++key) {
        const UpdateContext context{{"clock", key}, PointTime{static_cast<std::int64_t>(key)}, static_cast<std::int64_t>(key), static_cast<std::int64_t>(key)};
        auto pending = take(PendingOutcome::create(resources, context, 1));
        auto payload = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [key] { return static_cast<std::int64_t>(key); }));
        success(pending.set_output(0, take(ErasedValue::from(std::move(payload), semantic))));
        slot->commit(take(validate_pending(std::move(pending), *slot, context)));
    }
    require(resources->current(ResourceKind::Retention) == 16, "one prior plus current did not retain exactly two scalar payloads");
    const UpdateContext current{{"clock", 2}, PointTime{2}, 2, 2};
    require(take(slot->read_previous<std::int64_t>(0, current, 1)).value == 1, "wrong retained publication selected");
    rejects(slot->read_previous<std::int64_t>(0, current, 2), FailureCode::MissingRequired);
    auto escaped = take(slot->read<std::int64_t>(0, current));
    auto charge = take(resources->reserve(ResourceKind::State, 4096));
    auto failed = take(KernelInstance::create({}, std::move(charge), [resources, semantic](const UpdateContext& context) -> Result<PendingOutcome> {
        auto pending = take(PendingOutcome::create(resources, context, 2));
        auto payload = take(make_owned<std::int64_t>(resources, ResourceKind::Retention, 8, {}, [] { return std::int64_t{99}; }));
        success(pending.set_output(0, take(ErasedValue::from(std::move(payload), semantic))));
        throw std::runtime_error("second output callback failed");
    }));
    rejects(failed.step({{"clock", 3}, PointTime{3}, 3, 3}), FailureCode::CallbackException);
    require(resources->current(ResourceKind::Retention) == 16 && escaped.value == 2, "failed staged bundle leaked or changed earlier publication");
    slot.reset();
    require(resources->current(ResourceKind::Retention) == 8 && escaped.value == 2, "external hold did not survive slot destruction");
}
}
int main() {
    const Case cases[]{{"reservation precedes allocation", reserve_before_allocation},
        {"escaped shared payload lifetime", external_lifetime}, {"immutable copy and bounded warning", immutable_copy_and_warning},
        {"host pin spans typed destructor", pinned_destruction}, {"holder quota without invalidation", hold_limit},
        {"exclusive ownership transfer", exclusive_transfer},
        {"atomic bundle and causal reads", atomic_bundle_and_reads},
        {"typed bounded provenance envelope", provenance_envelope},
        {"bounded history and callback failure", bounded_history_and_callback_failure}};
    return lexongine::test::run(cases);
}
