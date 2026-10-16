#include "lexongine/plugins.hpp"
#include "lexongine/build_contract.hpp"
#include "test_plugin_sdk.hpp"
#include "../../tests/lexongine_test_support.hpp"

#include <filesystem>
#include <fstream>
#include <unistd.h>

namespace {
using namespace lexongine;
using namespace lexongine::test;
using namespace lexongine::plugin_test;
std::array<std::string, 9> paths;
std::filesystem::path scratch_root;
PluginLimits limits() { return {1024, 67108864, 1048576, 1048576, 512}; }
std::shared_ptr<ResourceAccount> account() {
    return take(ResourceAccount::create({{16777216, 16777216, 268435456, 16777216, 16777216, 16777216, 1048576}, 512, 256, 4096, 128}));
}
void register_host_type(Registry& registry) {
    static_cast<void>(take(registry.register_type<Payload>({payload_contract(), StorageKind::ImmutableOwned,
        [](const Payload&) -> Result<void> { return ok(); },
        [](const Payload& value) -> Result<std::uint64_t> { return sizeof(Payload) + value.values.size() * sizeof(std::int64_t); },
        FreezeStrategy::DeepCopy, [](const Payload& value) { return value; }, {}})));
}
void bootstrap_and_transaction() {
    for (const auto index : {1U, 2U, 3U, 7U, 8U}) {
        auto registry = take(Registry::create());
        rejects(load_plugin(paths[index], build_contract_id, registry, account(), limits()), FailureCode::UnsupportedContract);
        require(registry.definitions().empty(), "rejected bootstrap changed registry");
    }
    auto registry = take(Registry::create());
    auto resources = account();
    rejects(load_plugin(paths[4], build_contract_id, registry, resources, limits()), FailureCode::InvalidConfig);
    require(registry.definitions().empty(), "failed registration leaked definitions");
    register_host_type(registry);
    auto good = take(load_plugin(paths[0], build_contract_id, registry, resources, limits()));
    require(registry.definitions().size() == 1, "rollback leaked type registration");
    rejects(load_plugin(paths[0], build_contract_id, registry, resources, limits()), FailureCode::DuplicateDefinition);
    require(registry.definitions().size() == 1, "duplicate load changed registry");
    require(!good.dependencies().empty(), "actual loaded dependency inventory missing");
    require(good.platform_identity().find("kern.osversion=") != std::string_view::npos, "explicit Apple platform witness missing");
}
void typed_round_trip_and_lifetime() {
    auto resources = account();
    std::weak_ptr<const void> weak;
    std::optional<Immutable<Payload>> held;
    {
        const PreparationFacts facts{{"clock", 0, 2}, {protocol("empty"), {"clock", 0, 0}, {1, {}}},
            MissingIntervalPolicy::Strict, Alignment::SameStep, {4096, 4096, 4096, 4096, 4096, 32768, 4096}, resources};
        std::optional<PreparedKernel> prepared;
        {
            auto registry = take(Registry::create());
            auto loaded = take(load_plugin(paths[0], build_contract_id, registry, resources, limits()));
            weak = loaded.pin();
            auto type = take(registry.describe_type<Payload>(payload_contract()));
            require(type.witness == std::type_index(typeid(Payload)), "native macOS SDK RTTI mismatch");
            auto definition = take(registry.resolve(operation_key()));
            require(definition->contract().implementation == loaded.identity(), "plugin label replaced verified implementation content");
            prepared.emplace(take(definition->prepare({{{"value", "42", {"native-test", 1}}}}, facts)));
        }
        require(!weak.expired(), "prepared factory lost its module after registry/loader teardown");
        InstanceServices services{resources, {}};
        auto instance = take(prepared->instantiate(services));
        prepared.reset();
        require(!weak.expired(), "instance lost native captures after prepared factory teardown");
        ValueContract type{payload_contract(), std::type_index(typeid(Payload)), StorageKind::ImmutableOwned, {}};
        auto slot = take(ResultSlot::create(resources, {type}, 0, Sha256{}, std::nullopt));
        const UpdateContext context{{"clock", 0}, PointTime{10}, 10, 10};
        slot->commit(take(validate_pending(take(instance.step(context)), *slot, context)));
        auto read = take(slot->read<Payload>(0, context));
        require(read.value.values == std::vector<std::int64_t>{42, 1}, "native typed calculation changed");
        held.emplace(take(read.retain("external", "plugin_output")));
    }
    require(!weak.expired() && held->get().values[0] == 42, "module unloaded with an external typed output");
    held.reset();
    require(weak.expired(), "module pin leaked after paired typed destruction");
}
void type_and_content_identity() {
    auto wrong_registry = take(Registry::create());
    register_host_type(wrong_registry);
    rejects(load_plugin(paths[5], build_contract_id, wrong_registry, account(), limits()), FailureCode::TypeMismatch);
    require(wrong_registry.definitions().empty(), "mismatched witness registered an operation");
    auto first_registry = take(Registry::create()), second_registry = take(Registry::create());
    auto first = take(load_plugin(paths[0], build_contract_id, first_registry, account(), limits()));
    auto second = take(load_plugin(paths[6], build_contract_id, second_registry, account(), limits()));
    require(first.identity().sdk_build_contract_id == second.identity().sdk_build_contract_id, "comparison did not use one ABI label");
    require(first.identity().binary_digest != second.identity().binary_digest && first.identity().source_build_digest != second.identity().source_build_digest,
            "actual implementation changes disappeared behind a stable label");
    require(first.identity().dependencies_digest != Sha256{}, "dependency content identity is absent");
}
void manifest_and_budget_failures() {
    struct Temporary {
        std::filesystem::path path;
        ~Temporary() { std::error_code error; std::filesystem::remove_all(path, error); }
    };
    auto pattern = (scratch_root / "lexongine-plugin-corruption.XXXXXX").string();
    std::vector<char> writable(pattern.begin(), pattern.end()); writable.push_back('\0');
    if (!::mkdtemp(writable.data())) { throw std::runtime_error("could not create explicit plugin test directory"); }
    Temporary temporary{writable.data()};
    const auto binary = temporary.path / "candidate.module";
    std::filesystem::copy_file(paths[0], binary);
    const auto manifest = binary.string() + ".lexongine-build";
    auto registry = take(Registry::create());
    auto resources = account();
    rejects(load_plugin(binary.string(), build_contract_id, registry, resources, limits()), FailureCode::InvalidConfig);
    std::filesystem::copy_file(paths[0] + ".lexongine-build", manifest);
    {
        std::ofstream append{manifest, std::ios::app}; append << "unexpected\n";
        require(static_cast<bool>(append), "failed to construct malformed manifest");
    }
    rejects(load_plugin(binary.string(), build_contract_id, registry, resources, limits()), FailureCode::InvalidConfig);
    std::filesystem::copy_file(paths[0] + ".lexongine-build", manifest, std::filesystem::copy_options::overwrite_existing);
    {
        std::ofstream append{binary, std::ios::binary | std::ios::app}; append.put('x');
        require(static_cast<bool>(append), "failed to construct changed binary");
    }
    rejects(load_plugin(binary.string(), build_contract_id, registry, resources, limits()), FailureCode::SourceChanged);
    require(registry.definitions().empty(), "rejected artifact registered a definition");
    auto bound = limits(); bound.registration_bytes = 1;
    rejects(load_plugin(paths[0], build_contract_id, registry, resources, bound), FailureCode::ResourceExceeded);
    require(registry.definitions().empty(), "over-budget registration became visible");
    bound = limits(); bound.file_bytes = 1;
    rejects(load_plugin(paths[0], build_contract_id, registry, resources, bound), FailureCode::InvalidConfig);
    bound = limits(); bound.metadata_bytes = 2048;
    rejects(load_plugin(paths[0], build_contract_id, registry, resources, bound), FailureCode::ResourcePlanExceeded);
}
}
int main(int argc, char** argv) {
    if (argc != 11) { std::cerr << "nine explicit CMake-generated module paths and scratch root required\n"; return 1; }
    for (std::size_t i = 0; i < paths.size(); ++i) { paths[i] = argv[i + 1]; }
    scratch_root = argv[10];
    const Case cases[]{{"bounded bootstrap and transactional registration", bootstrap_and_transaction},
        {"native typed output and module lifetime", typed_round_trip_and_lifetime}, {"witness and actual content identity", type_and_content_identity},
        {"manifest integrity and registration limits", manifest_and_budget_failures}};
    return lexongine::test::run(cases);
}
