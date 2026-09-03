#pragma once

#include "quant/data/observations.hpp"
#include "quant/ingestion/instrument_mapping.hpp"
#include "quant/ingestion/quality.hpp"

#include <cstddef>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace quant::ingestion {

struct ProviderBatch {
    std::vector<data::MboEvent> mbo_events;
    std::vector<DataQualityObservation> quality_observations;
    std::vector<data::SourceId> source_ids;
    std::optional<std::string> source_artifact_identity;
};

class ProviderPort {
public:
    virtual ~ProviderPort() = default;
    [[nodiscard]] virtual std::string_view provider_name() const noexcept = 0;
    virtual ProviderBatch fetch(const ProviderMappingSegment& segment) = 0;
};

class FakeProvider final : public ProviderPort {
public:
    explicit FakeProvider(std::string provider) : provider_(std::move(provider)) {
        if (provider_.empty()) {
            throw std::invalid_argument("fake provider name must not be empty");
        }
    }

    [[nodiscard]] std::string_view provider_name() const noexcept override { return provider_; }

    void enqueue_response(ProviderBatch response) { responses_.push_back(std::move(response)); }

    ProviderBatch fetch(const ProviderMappingSegment& segment) override {
        validate(segment);
        if (segment.provider != provider_) {
            throw std::invalid_argument("provider mapping does not match provider port");
        }
        if (next_response_ >= responses_.size()) {
            throw std::logic_error("fake provider has no response for requested segment");
        }
        calls_.push_back(segment);
        return std::move(responses_[next_response_++]);
    }

    [[nodiscard]] const std::vector<ProviderMappingSegment>& calls() const noexcept { return calls_; }

private:
    std::string provider_;
    std::vector<ProviderBatch> responses_;
    std::vector<ProviderMappingSegment> calls_;
    std::size_t next_response_ = 0;
};

} // namespace quant::ingestion
