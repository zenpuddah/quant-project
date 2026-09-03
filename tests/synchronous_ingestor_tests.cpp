#include "quant/ingestion/synchronous_ingestor.hpp"

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

template <typename Function>
void require_throws(Function&& function, const std::string_view message) {
    bool threw = false;
    try {
        function();
    } catch (const std::exception&) {
        threw = true;
    }
    require(threw, message);
}

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

TimeRange range(const std::int64_t start, const std::int64_t end) {
    return TimeRange{time(start), time(end)};
}

ProviderMappingSegment mapping(
    const std::int64_t start,
    const std::int64_t end,
    const std::string_view symbol) {
    return ProviderMappingSegment{
        InstrumentId{42},
        "test-provider",
        std::string{symbol},
        VenueId{7},
        std::nullopt,
        range(start, end),
    };
}

EventHeader header(const std::int64_t event_time, const std::uint64_t sequence = 1) {
    return EventHeader{
        InstrumentId{42},
        VenueId{7},
        time(event_time),
        time(event_time + 1),
        sequence,
        std::uint32_t{2},
        std::uint64_t{11},
        SourceId{9},
    };
}

MboEvent add_event(const std::int64_t event_time, const std::uint64_t order_id, const std::uint64_t sequence = 1) {
    return MboEvent{
        header(event_time, sequence),
        MboAction::Add,
        OrderId{order_id},
        Side::Buy,
        Price::from_integer(100),
        Quantity::from_integer(2),
    };
}

void test_full_miss_produces_result() {
    NoopCache cache;
    InMemoryInstrumentMappingRegistry mappings;
    mappings.add(mapping(0, 10, "TEST"));
    FakeProvider provider{"test-provider"};
    provider.enqueue_response(ProviderBatch{
        {add_event(3, 100)},
        {},
        {SourceId{9}},
        std::nullopt,
    });
    NoopRecoveryPolicy recovery;
    SynchronousIngestor ingestor{cache, mappings, provider, recovery};

    const auto result = ingestor.ingest(
        MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(0, 10)},
        time(1000),
        "adapter-v1",
        "schema-v1",
        "mapping-v1");

    require(provider.calls().size() == 1, "a full cache miss must produce one provider request");
    require(provider.calls()[0].range == range(0, 10), "provider request must use the canonical missing range");
    require(result.mbo.has_value() && result.mbo->size() == 1, "valid provider output must enter the MBO buffer");
    require(result.metadata.actual_coverage == std::vector<TimeRange>{range(0, 10)},
            "valid provider output must produce actual coverage");
    require(result.metadata.unresolved_ranges.empty(), "complete provider output must have no unresolved ranges");
    require(result.metadata.data_state == DataState::Complete, "valid provider output must reduce to complete state");
    require(result.metadata.provider == "test-provider", "result metadata must retain provider identity");
    require(result.metadata.source_ids == std::vector<SourceId>{SourceId{9}},
            "result metadata must retain source identity");
    require(result.metadata.adapter_version == "adapter-v1", "result must retain adapter version identity");
    require(result.metadata.canonical_schema_version == "schema-v1",
            "result must retain canonical schema version identity");
    require(result.metadata.mapping_version == "mapping-v1", "result must retain mapping version identity");
}

void test_mapping_boundary_is_one_logical_result() {
    NoopCache cache;
    InMemoryInstrumentMappingRegistry mappings;
    mappings.add(mapping(0, 10, "OLD"));
    mappings.add(mapping(10, 20, "NEW"));
    FakeProvider provider{"test-provider"};
    provider.enqueue_response(ProviderBatch{{add_event(9, 100, 1)}, {}, {SourceId{9}}, std::nullopt});
    provider.enqueue_response(ProviderBatch{{add_event(10, 101, 2)}, {}, {SourceId{9}}, std::nullopt});
    NoopRecoveryPolicy recovery;
    SynchronousIngestor ingestor{cache, mappings, provider, recovery};

    const auto result = ingestor.ingest(
        MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(5, 15)},
        time(2000));

    require(provider.calls().size() == 2, "a mapping boundary must produce two provider calls");
    require(provider.calls()[0].range == range(5, 10), "first provider call must use the first half-open segment");
    require(provider.calls()[1].range == range(10, 15), "second provider call must use the second half-open segment");
    require(result.mbo.has_value() && result.mbo->size() == 2, "mapping segments must share one logical MBO result");
    require(result.mbo->at(0).order_id()->value() == 100, "first provider event must remain first");
    require(result.mbo->at(1).order_id()->value() == 101, "second provider event must remain second");
    require(result.mbo->at(0).header().instrument_id == InstrumentId{42},
            "normalized events must retain canonical instrument identity");
    require(result.metadata.data_state == DataState::Complete, "complete mapping segments must reduce to complete state");
}

void test_provider_quality_and_validation() {
    {
        NoopCache cache;
        InMemoryInstrumentMappingRegistry mappings;
        mappings.add(mapping(0, 10, "TEST"));
        FakeProvider provider{"test-provider"};
        provider.enqueue_response(ProviderBatch{
            {add_event(2, 100)},
            {DataQualityObservation{range(0, 10), DataQualityKind::Degraded}},
            {SourceId{9}},
            std::nullopt,
        });
        NoopRecoveryPolicy recovery;
        SynchronousIngestor ingestor{cache, mappings, provider, recovery};
        const auto result = ingestor.ingest(
            MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(0, 10)}, time(3));
        require(result.metadata.data_state == DataState::Degraded,
                "degraded provider evidence must reduce to degraded state");
        require(result.metadata.unresolved_ranges == std::vector<TimeRange>{range(0, 10)},
                "degraded provider evidence must remain unresolved for recovery policy input");
    }

    {
        NoopCache cache;
        InMemoryInstrumentMappingRegistry mappings;
        mappings.add(mapping(0, 10, "TEST"));
        FakeProvider provider{"test-provider"};
        provider.enqueue_response(ProviderBatch{
            {},
            {DataQualityObservation{range(0, 10), DataQualityKind::Missing}},
            {},
            std::nullopt,
        });
        NoopRecoveryPolicy recovery;
        SynchronousIngestor ingestor{cache, mappings, provider, recovery};
        const auto result = ingestor.ingest(
            MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(0, 10)}, time(4));
        require(result.metadata.data_state == DataState::Missing,
                "missing provider evidence must reduce to missing state");
        require(!result.mbo.has_value(), "missing provider data must not create an MBO buffer");
    }

    {
        NoopCache cache;
        InMemoryInstrumentMappingRegistry mappings;
        mappings.add(mapping(0, 10, "TEST"));
        FakeProvider provider{"test-provider"};
        provider.enqueue_response(ProviderBatch{
            {MboEvent{header(2), MboAction::Add, std::nullopt, std::nullopt, std::nullopt, std::nullopt}},
            {},
            {},
            std::nullopt,
        });
        NoopRecoveryPolicy recovery;
        SynchronousIngestor ingestor{cache, mappings, provider, recovery};
        const auto result = ingestor.ingest(
            MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(0, 10)}, time(5));
        require(result.metadata.data_state == DataState::Corrupt,
                "validation failure must become corrupt quality evidence");
        require(!result.mbo.has_value(), "invalid MBO events must not enter the valid buffer");
        require(result.metadata.unresolved_ranges == std::vector<TimeRange>{range(0, 10)},
                "validation failure must leave its segment unresolved");
    }
}

void test_explicit_unsupported_levels() {
    NoopCache cache;
    InMemoryInstrumentMappingRegistry mappings;
    FakeProvider provider{"test-provider"};
    NoopRecoveryPolicy recovery;
    SynchronousIngestor ingestor{cache, mappings, provider, recovery};

    require_throws(
        [&] {
            (void)ingestor.ingest(
                MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L1, range(0, 10)}, time(1));
        },
        "L1 queries must fail explicitly");
    require_throws(
        [&] {
            (void)ingestor.ingest(
                MarketDataQuery{InstrumentId{42}, VenueId{7}, MarketDataLevel::L2, range(0, 10)}, time(1));
        },
        "L2 queries must fail explicitly");
    require(provider.calls().empty(), "unsupported levels must not reach the provider");
}

} // namespace

int main() {
    try {
        test_full_miss_produces_result();
        test_mapping_boundary_is_one_logical_result();
        test_provider_quality_and_validation();
        test_explicit_unsupported_levels();
        std::cout << "synchronous_ingestor_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "synchronous_ingestor_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
