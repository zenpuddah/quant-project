#pragma once

#include "lexongine/registry.hpp"

namespace lexongine {

struct ParseLimits {
    std::uint64_t xml_bytes, xml_depth, xml_elements, string_bytes;
    std::shared_ptr<ResourceAccount> account;
};
struct CompositionLimits {
    std::uint64_t xml_bytes, xml_depth, xml_elements, string_bytes;
    std::uint64_t nodes, edges, requests, source_updates, managed_buffer_bytes, trace_events, trace_message_bytes;
};
struct RetentionLogConfiguration {
    std::string path, format, open, flush, failure, overflow;
    std::uint64_t max_bytes, max_events;
};
struct RunConfiguration {
    std::string id, clock;
    Driver driver;
    std::string execution, sharing, failure, trace;
    std::uint64_t retention_warning_steps;
    RetentionLogConfiguration retention_log;
};
struct PluginDeclaration { std::string path, build_contract_id; };
struct DisabledCache {};
struct LocalCacheConfiguration {
    std::string mode, backend, directory, matching, trust, integrity, writer, corruption, capacity, cleanup;
    std::uint64_t max_entries, max_store_bytes, max_entry_bytes, max_decoded_bytes;
};
using CacheConfiguration = std::variant<DisabledCache, LocalCacheConfiguration>;
struct SourceDeclaration {
    LogicalId id;
    DeclaredOrdinal ordinal;
    OperationKey operation;
    std::string source_version;
    SequenceScope scope;
    std::string completeness, empty, missing, availability;
    MissingIntervalPolicy missing_intervals;
    ParamSet parameters;
    SourceLocation location;
};
struct NodeDeclaration {
    LogicalId id;
    DeclaredOrdinal ordinal;
    OperationKey operation;
    std::string alignment, initialization;
    ParamSet parameters;
    std::vector<InputBindingSpec> inputs;
    SourceLocation location;
};
struct CompositionDeclaration {
    Reservation charge;
    std::shared_ptr<ResourceAccount> account;
    std::uint64_t metadata_bytes;
    RunConfiguration run;
    CompositionLimits limits;
    std::vector<PluginDeclaration> plugins;
    CacheConfiguration cache;
    std::vector<SourceDeclaration> sources;
    std::vector<NodeDeclaration> nodes;
    std::vector<ObservationRequest> observations;
};
class ParsedComposition {
public:
    [[nodiscard]] const CompositionDeclaration& declaration() const noexcept { return *declaration_; }
private:
    friend class FrontendAccess;
    explicit ParsedComposition(std::shared_ptr<const CompositionDeclaration> value) : declaration_(std::move(value)) {}
    std::shared_ptr<const CompositionDeclaration> declaration_;
};
struct ResolvedParameters {
    std::shared_ptr<const OperationDefinition> definition;
    CanonicalParams parameters;
};
class Composition {
public:
    [[nodiscard]] const CompositionDeclaration& declaration() const noexcept { return *declaration_; }
    [[nodiscard]] const auto& source_parameters() const noexcept { return sources_; }
    [[nodiscard]] const auto& node_parameters() const noexcept { return nodes_; }
private:
    friend class FrontendAccess;
    Composition(Reservation charge, std::shared_ptr<const CompositionDeclaration> declaration, std::vector<ResolvedParameters> sources,
                std::vector<ResolvedParameters> nodes)
        : charge_(std::move(charge)), declaration_(std::move(declaration)), sources_(std::move(sources)), nodes_(std::move(nodes)) {}
    Reservation charge_;
    std::shared_ptr<const CompositionDeclaration> declaration_;
    std::vector<ResolvedParameters> sources_, nodes_;
};

// These declarations describe intent. Preparation lowers explicit initialization
// directives to NodeSpec/InitializationSpec after source/history resolution.
Result<ParsedComposition> parse_xml(std::string_view, const ParseLimits&) noexcept;
Result<Composition> resolve_composition(const ParsedComposition&, const Registry&) noexcept;

} // namespace lexongine
