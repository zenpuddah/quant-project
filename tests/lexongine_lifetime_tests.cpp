#include "lexongine_test_support.hpp"
#include "lexongine/results.hpp"
#include "lexongine/binding.hpp"

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
void atomic_bundle_and_reads() {
    auto resources = account();
    const TypeContract semantic{"test.integer", 1, {1, {}}};
    const ValueContract integer{semantic, std::type_index(typeid(std::int64_t)), StorageKind::ScalarCopy, {}};
    auto slot = take(ResultSlot::create(resources, {integer, integer}, 1));
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
    rejects(slot->read<std::uint64_t>(0, first), FailureCode::TypeMismatch);
    auto future = first; future.decision_time_ns = 9;
    rejects(slot->read<std::int64_t>(0, future), FailureCode::FutureRead);
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
}
int main() {
    const Case cases[]{{"reservation precedes allocation", reserve_before_allocation},
        {"escaped shared payload lifetime", external_lifetime}, {"immutable copy and bounded warning", immutable_copy_and_warning},
        {"host pin spans typed destructor", pinned_destruction}, {"holder quota without invalidation", hold_limit},
        {"atomic bundle and causal reads", atomic_bundle_and_reads}};
    return lexongine::test::run(cases);
}
