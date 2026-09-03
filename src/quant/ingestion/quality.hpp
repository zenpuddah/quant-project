#pragma once

#include "quant/ingestion/query.hpp"

#include <algorithm>
#include <span>
#include <vector>

namespace quant::ingestion {

enum class DataQualityKind {
    Complete,
    Degraded,
    Missing,
    Corrupt,
    SequenceGap,
};

struct DataQualityObservation {
    TimeRange range;
    DataQualityKind kind;
};

enum class DataState {
    Unknown,
    Complete,
    Degraded,
    Missing,
    Corrupt,
};

class DataStateReducer {
public:
    [[nodiscard]] static DataState reduce(
        const TimeRange requested,
        const std::span<const DataQualityObservation> observations) {
        validate(requested);

        std::vector<TimeRange> observed_ranges;
        observed_ranges.reserve(observations.size());
        bool has_complete = false;
        bool has_degraded = false;
        bool has_missing = false;
        bool has_corrupt = false;

        for (const auto& observation : observations) {
            validate(observation.range);
            if (!intersection(requested, observation.range)) {
                continue;
            }
            observed_ranges.push_back(*intersection(requested, observation.range));
            switch (observation.kind) {
            case DataQualityKind::Complete:
                has_complete = true;
                break;
            case DataQualityKind::Degraded:
                has_degraded = true;
                break;
            case DataQualityKind::Missing:
                has_missing = true;
                break;
            case DataQualityKind::Corrupt:
                has_corrupt = true;
                break;
            case DataQualityKind::SequenceGap:
                has_degraded = true;
                break;
            }
        }

        if (!covers(requested, observed_ranges)) {
            return DataState::Unknown;
        }
        if (has_corrupt) {
            return DataState::Corrupt;
        }
        if (has_missing) {
            return DataState::Missing;
        }
        if (has_degraded) {
            return DataState::Degraded;
        }
        if (has_complete) {
            return DataState::Complete;
        }
        return DataState::Unknown;
    }

    [[nodiscard]] DataState operator()(
        const TimeRange requested,
        const std::span<const DataQualityObservation> observations) const {
        return reduce(requested, observations);
    }

private:
    [[nodiscard]] static bool covers(const TimeRange requested, std::vector<TimeRange>& ranges) {
        if (ranges.empty()) {
            return false;
        }
        std::sort(ranges.begin(), ranges.end(), [](const TimeRange& lhs, const TimeRange& rhs) {
            if (lhs.start != rhs.start) {
                return lhs.start < rhs.start;
            }
            return lhs.end < rhs.end;
        });

        auto cursor = requested.start;
        for (const auto& range : ranges) {
            if (range.start > cursor) {
                return false;
            }
            if (range.end > cursor) {
                cursor = range.end;
            }
            if (cursor >= requested.end) {
                return true;
            }
        }
        return false;
    }
};

[[nodiscard]] inline DataState reduce_data_state(
    const TimeRange requested,
    const std::span<const DataQualityObservation> observations) {
    return DataStateReducer::reduce(requested, observations);
}

} // namespace quant::ingestion
