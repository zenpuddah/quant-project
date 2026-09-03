#pragma once

#include "quant/ingestion/query.hpp"

#include <vector>

namespace quant::ingestion {

enum class CacheStatus {
    Miss,
    FullHit,
    PartialHit,
};

struct CacheLookup {
    CacheStatus status;
    std::vector<TimeRange> covered;
    std::vector<TimeRange> missing;
};

class CachePort {
public:
    virtual ~CachePort() = default;
    virtual CacheLookup lookup(const MarketDataQuery& query) = 0;
};

class NoopCache final : public CachePort {
public:
    [[nodiscard]] CacheLookup lookup(const MarketDataQuery& query) override {
        validate(query);
        return CacheLookup{CacheStatus::Miss, {}, {query.range}};
    }
};

} // namespace quant::ingestion
