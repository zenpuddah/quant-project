#pragma once

#include "quant/storage/arrow_interchange.hpp"

#include <functional>
#include <span>

namespace quant::storage {

using BatchConsumer = std::function<arrow::Status(const ArrowBatch&)>;
using EventConsumer = std::function<arrow::Status(const CanonicalEvent&)>;

class MarketDataReader {
public:
    virtual ~MarketDataReader() = default;

    [[nodiscard]] virtual arrow::Result<DatasetLocalMetadata> read_metadata(
        const DataFragment& fragment) const = 0;

    virtual arrow::Status read_batches(
        const DataFragment& fragment,
        BatchProjection projection,
        const BatchConsumer& consumer) const = 0;

    virtual arrow::Status stream_events(
        const DataFragment& fragment,
        const EventConsumer& consumer) const = 0;
};

class StorageBackend : public MarketDataReader {
public:
    ~StorageBackend() override = default;

    [[nodiscard]] virtual arrow::Result<DataFragment> write(
        const DatasetLocalMetadata& metadata,
        const std::span<const ArrowBatch> batches) = 0;
};

} // namespace quant::storage
