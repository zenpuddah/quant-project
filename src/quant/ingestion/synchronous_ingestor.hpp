#pragma once

#include "quant/data/validation.hpp"
#include "quant/ingestion/cache.hpp"
#include "quant/ingestion/provider.hpp"
#include "quant/ingestion/recovery.hpp"
#include "quant/ingestion/result.hpp"

#include <algorithm>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace quant::ingestion {

namespace detail {

[[nodiscard]] inline bool same_scope(
    const data::MboStreamContext& lhs,
    const data::MboStreamContext& rhs) noexcept {
    return lhs.instrument_id == rhs.instrument_id && lhs.venue_id == rhs.venue_id &&
           lhs.source_id == rhs.source_id;
}

inline void normalize_ranges(std::vector<TimeRange>& ranges) {
    std::sort(ranges.begin(), ranges.end(), [](const TimeRange& lhs, const TimeRange& rhs) {
        if (lhs.start != rhs.start) {
            return lhs.start < rhs.start;
        }
        return lhs.end < rhs.end;
    });

    std::vector<TimeRange> merged;
    merged.reserve(ranges.size());
    for (const auto& range : ranges) {
        if (merged.empty() || merged.back().end < range.start) {
            merged.push_back(range);
            continue;
        }
        if (merged.back().end < range.end) {
            merged.back().end = range.end;
        }
    }
    ranges = std::move(merged);
}

} // namespace detail

class SynchronousIngestor {
public:
    SynchronousIngestor(
        CachePort& cache,
        InstrumentMappingRegistry& mappings,
        ProviderPort& provider,
        RecoveryPolicy& recovery) noexcept
        : cache_(cache), mappings_(mappings), provider_(provider), recovery_(recovery) {}

    [[nodiscard]] IngestionResult ingest(
        const MarketDataQuery& query,
        const data::Timestamp ingestion_time,
        std::string adapter_version = {},
        std::string canonical_schema_version = {},
        std::string mapping_version = {}) {
        validate(query);
        if (query.level != MarketDataLevel::L3) {
            throw std::invalid_argument("synchronous ingestion currently supports only L3/MBO queries");
        }

        const std::string provider_name{provider_.provider_name()};
        if (provider_name.empty()) {
            throw std::invalid_argument("provider port name must not be empty");
        }

        const auto cache_lookup = cache_.lookup(query);
        if (cache_lookup.status != CacheStatus::Miss || !cache_lookup.covered.empty() ||
            cache_lookup.missing != std::vector<TimeRange>{query.range}) {
            throw std::logic_error("synchronous ingestion currently requires a full NoopCache miss");
        }

        std::vector<TimeRange> actual_coverage;
        std::vector<TimeRange> unresolved_ranges;
        std::vector<DataQualityObservation> quality_observations;
        std::vector<data::SourceId> source_ids;
        std::optional<std::string> source_artifact_identity;
        std::optional<data::MboBuffer> mbo;

        const auto add_source_id = [&source_ids](const data::SourceId source_id) {
            if (std::find(source_ids.begin(), source_ids.end(), source_id) == source_ids.end()) {
                source_ids.push_back(source_id);
            }
        };

        for (const auto& missing_range : cache_lookup.missing) {
            validate(missing_range);
            auto mapping_segments = mappings_.resolve(
                query.instrument_id,
                provider_name,
                missing_range,
                query.venue_id);

            std::vector<ProviderMappingSegment> resolved_segments;
            resolved_segments.reserve(mapping_segments.size());
            std::vector<TimeRange> mapped_ranges;
            mapped_ranges.reserve(mapping_segments.size());
            for (const auto& mapping_segment : mapping_segments) {
                validate(mapping_segment);
                if (mapping_segment.instrument_id != query.instrument_id ||
                    mapping_segment.provider != provider_name) {
                    throw std::invalid_argument("mapping segment does not match the ingestion request");
                }
                if (query.venue_id && mapping_segment.venue_id != query.venue_id) {
                    throw std::invalid_argument("mapping segment does not match the requested venue");
                }

                const auto clipped = intersection(missing_range, mapping_segment.range);
                if (!clipped) {
                    continue;
                }
                auto resolved_segment = mapping_segment;
                resolved_segment.range = *clipped;
                resolved_segments.push_back(std::move(resolved_segment));
                mapped_ranges.push_back(*clipped);
            }
            mapping_segments = std::move(resolved_segments);

            std::sort(
                mapping_segments.begin(),
                mapping_segments.end(),
                [](const ProviderMappingSegment& lhs, const ProviderMappingSegment& rhs) {
                    if (lhs.range.start != rhs.range.start) {
                        return lhs.range.start < rhs.range.start;
                    }
                    return lhs.range.end < rhs.range.end;
                });

            for (std::size_t index = 1; index < mapping_segments.size(); ++index) {
                if (overlaps(mapping_segments[index - 1].range, mapping_segments[index].range)) {
                    throw std::logic_error("mapping resolution returned overlapping provider ranges");
                }
            }

            for (const auto& unmapped : subtract(missing_range, mapped_ranges)) {
                quality_observations.push_back(DataQualityObservation{unmapped, DataQualityKind::Missing});
                unresolved_ranges.push_back(unmapped);
            }

            for (const auto& mapping_segment : mapping_segments) {
                ProviderBatch response = provider_.fetch(mapping_segment);
                for (const auto source_id : response.source_ids) {
                    add_source_id(source_id);
                }
                if (response.source_artifact_identity) {
                    if (source_artifact_identity &&
                        *source_artifact_identity != *response.source_artifact_identity) {
                        throw std::logic_error("one ingestion result cannot represent multiple source artifacts");
                    }
                    source_artifact_identity = *response.source_artifact_identity;
                }

                for (const auto& observation : response.quality_observations) {
                    validate(observation.range);
                    const auto clipped = intersection(mapping_segment.range, observation.range);
                    if (!clipped) {
                        throw std::invalid_argument("provider quality evidence is outside its requested range");
                    }
                    quality_observations.push_back(DataQualityObservation{*clipped, observation.kind});
                    switch (observation.kind) {
                    case DataQualityKind::Complete:
                        actual_coverage.push_back(*clipped);
                        break;
                    case DataQualityKind::Degraded:
                    case DataQualityKind::SequenceGap:
                        actual_coverage.push_back(*clipped);
                        unresolved_ranges.push_back(*clipped);
                        break;
                    case DataQualityKind::Missing:
                    case DataQualityKind::Corrupt:
                        unresolved_ranges.push_back(*clipped);
                        break;
                    }
                }

                bool validation_failed = false;
                for (const auto& event : response.mbo_events) {
                    add_source_id(event.header.source_id);
                    const bool structurally_valid = data::is_valid(data::validate(event));
                    const bool in_requested_scope =
                        event.header.instrument_id == query.instrument_id &&
                        (!query.venue_id || event.header.venue_id == *query.venue_id) &&
                        (!mapping_segment.venue_id || event.header.venue_id == *mapping_segment.venue_id) &&
                        event.header.event_time >= mapping_segment.range.start &&
                        event.header.event_time < mapping_segment.range.end;
                    if (!structurally_valid || !in_requested_scope) {
                        validation_failed = true;
                        continue;
                    }

                    const data::MboStreamContext event_context{
                        event.header.instrument_id,
                        event.header.venue_id,
                        event.header.source_id,
                    };
                    if (!mbo) {
                        mbo.emplace(event_context);
                    } else if (!detail::same_scope(mbo->context(), event_context)) {
                        throw std::logic_error("one ingestion result requires multiple MBO stream buffers");
                    }
                    mbo->append(event);
                }

                if (validation_failed) {
                    quality_observations.push_back(
                        DataQualityObservation{mapping_segment.range, DataQualityKind::Corrupt});
                    unresolved_ranges.push_back(mapping_segment.range);
                }
            }
        }

        detail::normalize_ranges(actual_coverage);
        detail::normalize_ranges(unresolved_ranges);
        const auto data_state = DataStateReducer::reduce(query.range, quality_observations);
        static_cast<void>(recovery_.decide(!unresolved_ranges.empty()));

        IngestionMetadata metadata{
            query,
            std::move(actual_coverage),
            std::move(unresolved_ranges),
            std::move(quality_observations),
            data_state,
            provider_name,
            std::move(source_ids),
            std::move(source_artifact_identity),
            ingestion_time,
            std::move(adapter_version),
            std::move(canonical_schema_version),
            std::move(mapping_version),
        };
        return IngestionResult{std::move(mbo), std::move(metadata)};
    }

private:
    CachePort& cache_;
    InstrumentMappingRegistry& mappings_;
    ProviderPort& provider_;
    RecoveryPolicy& recovery_;
};

} // namespace quant::ingestion
