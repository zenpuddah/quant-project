#pragma once

#include "quant/data/value_types.hpp"

#include <algorithm>
#include <cstddef>
#include <optional>
#include <span>
#include <stdexcept>
#include <utility>
#include <vector>

namespace quant::ingestion {

struct TimeRange {
    data::Timestamp start;
    data::Timestamp end;

    TimeRange(const data::Timestamp start_time, const data::Timestamp end_time)
        : start(start_time), end(end_time) {
        if (end <= start) {
            throw std::invalid_argument("time range end must be after start");
        }
    }

    friend bool operator==(const TimeRange&, const TimeRange&) = default;
};

[[nodiscard]] inline bool is_valid(const TimeRange& range) noexcept {
    return range.start < range.end;
}

inline void validate(const TimeRange& range) {
    if (!is_valid(range)) {
        throw std::invalid_argument("time range end must be after start");
    }
}

enum class MarketDataLevel {
    L1,
    L2,
    L3,
};

struct MarketDataQuery {
    data::InstrumentId instrument_id;
    std::optional<data::VenueId> venue_id;
    MarketDataLevel level;
    TimeRange range;

    MarketDataQuery(
        const data::InstrumentId instrument,
        std::optional<data::VenueId> venue,
        const MarketDataLevel data_level,
        const TimeRange requested_range)
        : instrument_id(instrument), venue_id(std::move(venue)), level(data_level), range(requested_range) {
        validate(range);
    }
};

inline void validate(const MarketDataQuery& query) {
    validate(query.range);
}

[[nodiscard]] inline bool overlaps(const TimeRange lhs, const TimeRange rhs) {
    validate(lhs);
    validate(rhs);
    return lhs.start < rhs.end && rhs.start < lhs.end;
}

[[nodiscard]] inline std::optional<TimeRange> intersection(const TimeRange lhs, const TimeRange rhs) {
    validate(lhs);
    validate(rhs);

    const auto start = std::max(lhs.start, rhs.start);
    const auto end = std::min(lhs.end, rhs.end);
    if (end <= start) {
        return std::nullopt;
    }
    return TimeRange{start, end};
}

[[nodiscard]] inline std::vector<TimeRange> subtract(
    const TimeRange requested,
    const std::span<const TimeRange> covered) {
    validate(requested);

    std::vector<TimeRange> clipped;
    clipped.reserve(covered.size());
    for (const auto& covered_range : covered) {
        validate(covered_range);
        if (const auto overlap = intersection(requested, covered_range)) {
            clipped.push_back(*overlap);
        }
    }

    std::sort(clipped.begin(), clipped.end(), [](const TimeRange& lhs, const TimeRange& rhs) {
        if (lhs.start != rhs.start) {
            return lhs.start < rhs.start;
        }
        return lhs.end < rhs.end;
    });

    std::vector<TimeRange> missing;
    auto cursor = requested.start;
    for (const auto& covered_range : clipped) {
        if (covered_range.end <= cursor) {
            continue;
        }
        if (cursor < covered_range.start) {
            missing.emplace_back(cursor, covered_range.start);
        }
        if (cursor < covered_range.end) {
            cursor = covered_range.end;
        }
        if (cursor >= requested.end) {
            break;
        }
    }

    if (cursor < requested.end) {
        missing.emplace_back(cursor, requested.end);
    }
    return missing;
}

} // namespace quant::ingestion
