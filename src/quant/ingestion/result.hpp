#pragma once

#include "quant/data/observations.hpp"
#include "quant/ingestion/quality.hpp"

#include <optional>
#include <string>
#include <vector>

namespace quant::ingestion {

struct SourceArtifactProvenance {
    std::string artifact_identity;
    TimeRange range;

    friend bool operator==(const SourceArtifactProvenance&, const SourceArtifactProvenance&) = default;
};

struct IngestionMetadata {
    MarketDataQuery query;
    std::vector<DataStateSegment> actual_coverage;
    std::vector<DataStateSegment> unresolved_ranges;
    std::vector<DataQualityObservation> quality_observations;
    std::vector<DataStateSegment> data_state_segments;
    DataState data_state;
    std::string provider;
    std::vector<data::SourceId> source_ids;
    std::vector<SourceArtifactProvenance> source_artifacts;
    data::Timestamp ingestion_time;
    std::string adapter_version;
    std::string canonical_schema_version;
    std::string mapping_version;
};

struct IngestionResult {
    std::vector<data::MboBuffer> mbo_buffers;
    IngestionMetadata metadata;
};

} // namespace quant::ingestion
