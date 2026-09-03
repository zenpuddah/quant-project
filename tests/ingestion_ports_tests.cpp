#include "quant/ingestion/cache.hpp"
#include "quant/ingestion/recovery.hpp"

#include <cstdint>
#include <iostream>
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

void test_noop_cache() {
    const MarketDataQuery query{InstrumentId{42}, std::nullopt, MarketDataLevel::L3, TimeRange{time(10), time(20)}};
    NoopCache cache;

    const auto lookup = cache.lookup(query);
    require(lookup.status == CacheStatus::Miss, "NoopCache must always report a miss");
    require(lookup.covered.empty(), "NoopCache must not report covered ranges");
    require(lookup.missing == std::vector<TimeRange>{query.range}, "NoopCache must miss the full canonical range");
}

void test_noop_recovery() {
    const NoopRecoveryPolicy policy;
    require(policy.decide(false) == RecoveryAction::NoAction, "NoopRecoveryPolicy must do nothing without unresolved ranges");
    require(policy.decide(true) == RecoveryAction::NoAction, "NoopRecoveryPolicy must do nothing with unresolved ranges");
}

} // namespace

int main() {
    try {
        test_noop_cache();
        test_noop_recovery();
        std::cout << "ingestion_ports_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "ingestion_ports_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
