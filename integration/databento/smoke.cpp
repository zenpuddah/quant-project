#include "quant/ingestion/databento_provider.hpp"
#include "quant/ingestion/synchronous_ingestor.hpp"

#include <databento/historical.hpp>

#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>

namespace {

using namespace quant::data;
using namespace quant::ingestion;

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

DataState state(const IngestionResult& result) {
    return result.metadata.data_state;
}

const char* state_name(const DataState value) {
    switch (value) {
    case DataState::Unknown:
        return "unknown";
    case DataState::Complete:
        return "complete";
    case DataState::Degraded:
        return "degraded";
    case DataState::Missing:
        return "missing";
    case DataState::Corrupt:
        return "corrupt";
    }
    return "unknown";
}

std::int64_t parse_timestamp(const char* value) {
    std::string text{value};
    std::size_t parsed = 0;
    const auto result = std::stoll(text, &parsed);
    if (parsed != text.size()) {
        throw std::invalid_argument("timestamp arguments must be Unix nanoseconds");
    }
    return result;
}

} // namespace

int main(int argc, char** argv) {
    try {
        if (argc != 1 && argc != 4) {
            throw std::invalid_argument("usage: quant_databento_smoke [symbol start_unix_nanos end_unix_nanos]");
        }

        const std::string symbol = argc == 4 ? argv[1] : "AAPL";
        const std::int64_t start_nanos = argc == 4 ? parse_timestamp(argv[2]) : 1'704'205'800'000'000'000LL;
        const std::int64_t end_nanos = argc == 4 ? parse_timestamp(argv[3]) : 1'704'229'200'000'000'000LL;
        const TimeRange requested_range{time(start_nanos), time(end_nanos)};
        const MarketDataQuery query{
            InstrumentId{1},
            VenueId{1},
            MarketDataLevel::L3,
            requested_range,
        };

        InMemoryInstrumentMappingRegistry mappings;
        mappings.add(ProviderMappingSegment{
            InstrumentId{1},
            "databento",
            symbol,
            VenueId{1},
            std::nullopt,
            requested_range,
            SourceId{1},
        });

        DatabentoStrictLogReceiver log_receiver;
        auto client = ::databento::Historical::Builder().SetKeyFromEnv().SetLogReceiver(&log_receiver).Build();
        DatabentoProvider provider{client};
        NoopCache cache;
        NoopRecoveryPolicy recovery;
        SynchronousIngestor ingestor{cache, mappings, provider, recovery};
        const auto now = std::chrono::duration_cast<std::chrono::nanoseconds>(
                             std::chrono::system_clock::now().time_since_epoch())
                             .count();
        const auto result = ingestor.ingest(
            query,
            Timestamp::from_unix_nanos(static_cast<std::int64_t>(now)),
            "databento-cpp-v0.67.0",
            "canonical-mbo-v1",
            "manual-v1");

        std::size_t mbo_count = 0;
        for (const auto& buffer : result.mbo_buffers) {
            mbo_count += buffer.size();
        }
        std::cout << "provider=databento dataset=XNAS.ITCH schema=MBO symbol=" << symbol << '\n'
                  << "mbo_records=" << mbo_count << " trades=" << result.trades.size()
                  << " executions=" << result.order_executions.size()
                  << " state=" << state_name(state(result)) << '\n';
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "quant_databento_smoke: failed: " << error.what() << '\n';
        return 1;
    }
}
