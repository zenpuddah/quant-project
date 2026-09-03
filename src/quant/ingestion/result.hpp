#pragma once

#include "quant/data/observations.hpp"
#include "quant/ingestion/quality.hpp"

#include <optional>
#include <string>
#include <vector>

namespace quant::ingestion {

struct IngestionMetadata {
    MarketDataQuery query;
    std::vector<TimeRange> actual_coverage;
    std::vector<TimeRange> unresolved_ranges;
    std::vector<DataQualityObservation> quality_observations;
    DataState data_state;
    std::string provider;
    std::vector<data::SourceId> source_ids;
    std::optional<std::string> source_artifact_identity;
    data::Timestamp ingestion_time;
    std::string adapter_version;
    std::string canonical_schema_version;
    std::string mapping_version;
};

struct IngestionResult {
    std::optional<data::MboBuffer> mbo;
    IngestionMetadata metadata;
};

} // namespace quant::ingestion
