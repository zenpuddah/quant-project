#include "quant/ingestion/result.hpp"

#include <cstdint>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>

namespace {

using namespace quant::data;
using namespace quant::ingestion;

void require(const bool condition, const std::string_view message) {
    if (!condition) {
        throw std::runtime_error(std::string(message));
    }
}

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

TimeRange range(const std::int64_t start, const std::int64_t end) {
    return TimeRange{time(start), time(end)};
}

EventHeader header() {
    return EventHeader{
        InstrumentId{42},
        VenueId{7},
        time(10),
        time(11),
        std::uint64_t{3},
        std::uint32_t{1},
        std::uint64_t{9},
        SourceId{5},
    };
}

void test_result_keeps_intent_and_outcome_distinct() {
    const MarketDataQuery query{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(10, 20)};
    MboBuffer buffer{MboStreamContext{InstrumentId{42}, VenueId{7}, SourceId{5}}};
    buffer.append(MboAdd{header(), OrderId{100}, Side::Buy, Price::from_integer(100), Quantity::from_integer(2)});

    const IngestionMetadata metadata{
        query,
        {range(10, 15)},
        {range(15, 20)},
        {
            DataQualityObservation{range(10, 15), DataQualityKind::Complete},
            DataQualityObservation{range(15, 20), DataQualityKind::Missing},
        },
        DataState::Missing,
        "fake-provider",
        {SourceId{5}},
        std::nullopt,
        time(1000),
        "fake-adapter-v1",
        "canonical-mbo-v1",
        "mapping-config-v1",
    };
    const IngestionResult result{std::move(buffer), metadata};

    require(result.metadata.query.range == range(10, 20), "metadata must retain the requested range");
    require(result.metadata.actual_coverage == std::vector<TimeRange>{range(10, 15)},
            "metadata must retain actual coverage separately from the request");
    require(result.metadata.unresolved_ranges == std::vector<TimeRange>{range(15, 20)},
            "metadata must retain unresolved ranges for partial results");
    require(result.metadata.data_state == DataState::Missing, "metadata must retain reduced data state");
    require(result.mbo.has_value(), "result must expose the canonical MBO buffer when data is valid");
    require(result.mbo->size() == 1, "result MBO output must reuse the existing buffer representation");
    require(result.mbo->at(0).header().instrument_id == InstrumentId{42},
            "result MBO output must retain canonical identity");
}

void test_metadata_versions_and_optional_artifact() {
    const MarketDataQuery query{InstrumentId{42}, std::nullopt, MarketDataLevel::L3, range(0, 1)};
    const IngestionMetadata metadata{
        query,
        {},
        {range(0, 1)},
        {DataQualityObservation{range(0, 1), DataQualityKind::Missing}},
        DataState::Missing,
        "provider",
        {},
        std::string{"artifact-checksum"},
        time(2),
        "adapter-2",
        "schema-3",
        "mapping-4",
    };

    require(metadata.source_artifact_identity == std::optional<std::string>{"artifact-checksum"},
            "source artifact identity must remain optional metadata");
    require(metadata.adapter_version == "adapter-2", "adapter version must round-trip");
    require(metadata.canonical_schema_version == "schema-3", "canonical schema version must round-trip");
    require(metadata.mapping_version == "mapping-4", "mapping version must round-trip");
    require(metadata.ingestion_time == time(2), "ingestion timestamp must round-trip");
}

} // namespace

int main() {
    try {
        test_result_keeps_intent_and_outcome_distinct();
        test_metadata_versions_and_optional_artifact();
        std::cout << "ingestion_result_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "ingestion_result_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
