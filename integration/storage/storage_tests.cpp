#include "quant/storage/parquet_backend.hpp"

#include <arrow/api.h>

#include <cstdint>
#include <filesystem>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <system_error>
#include <variant>
#include <vector>

namespace {

using namespace quant::data;
using namespace quant::ingestion;
using namespace quant::storage;

void require(const bool condition, const std::string_view message) {
    if (!condition) {
        throw std::runtime_error(std::string(message));
    }
}

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

TimeRange range(const std::int64_t start, const std::int64_t end) {
    return TimeRange{time(start), time(end)};
}

StreamIdentity stream() {
    return StreamIdentity{InstrumentId{42}, VenueId{7}, SourceId{9}};
}

EventHeader header(
    const std::int64_t event_time,
    const std::optional<Timestamp> source_receive_time,
    const std::optional<std::uint64_t> sequence,
    const std::optional<std::uint32_t> channel_id,
    const std::uint64_t source_flags) {
    return EventHeader{
        InstrumentId{42},
        VenueId{7},
        time(event_time),
        source_receive_time,
        sequence,
        channel_id,
        source_flags,
        SourceId{9},
    };
}

MboBuffer mbo_fixture() {
    MboBuffer buffer{MboStreamContext{InstrumentId{42}, VenueId{7}, SourceId{9}}};
    buffer.append(MboAdd{
        header(100, time(101), std::uint64_t{7}, std::uint32_t{2}, 11),
        OrderId{100},
        Side::Buy,
        Price::from_integer(100),
        Quantity::from_integer(2),
    });
    buffer.append(MboModify{
        header(102, time(103), std::uint64_t{0}, std::uint32_t{0}, 12),
        OrderId{100},
        Side::Sell,
        std::nullopt,
        std::nullopt,
    });
    buffer.append(MboClear{header(104, std::nullopt, std::nullopt, std::nullopt, 13)});
    return buffer;
}

DatasetLocalMetadata metadata(
    const DataKind kind,
    const StreamIdentity identity,
    const TimeRange time_range) {
    return DatasetLocalMetadata{
        kind,
        identity,
        time_range,
         AcquisitionMode::Historical,
         "canonical-v1",
        "adapter-v1",
        "mapping-v1",
        {"quality:complete"},
        {SourceArtifactProvenance{
            "artifact:source-a",
            range(time_range.start.unix_nanos(), time_range.end.unix_nanos()),
        }},
        std::string{"checksum-a"},
    };
}

void require_same_record(const MboRecord& lhs, const MboRecord& rhs) {
    require(lhs.event_time == rhs.event_time, "MBO event time must round-trip");
    require(lhs.source_receive_time == rhs.source_receive_time, "MBO receive time must round-trip");
    require(lhs.sequence == rhs.sequence, "MBO sequence must round-trip");
    require(lhs.order_id == rhs.order_id, "MBO order id must round-trip");
    require(lhs.price == rhs.price, "MBO price must round-trip");
    require(lhs.quantity == rhs.quantity, "MBO quantity must round-trip");
    require(lhs.source_flags == rhs.source_flags, "MBO source flags must round-trip");
    require(lhs.channel_id == rhs.channel_id, "MBO channel id must round-trip");
    require(lhs.control == rhs.control, "MBO control must round-trip");
}

arrow::Status test_metadata_and_schema_validation() {
    const auto dataset_metadata = metadata(DataKind::Mbo, stream(), range(100, 105));

    auto encoded = parquet_detail::encode_metadata(dataset_metadata);
    ARROW_RETURN_NOT_OK(encoded->Set(std::string{parquet_detail::instrument_id_key}, "-1"));
    require(!parquet_detail::decode_metadata(*encoded).ok(), "negative metadata ids must be rejected");

    encoded = parquet_detail::encode_metadata(dataset_metadata);
    ARROW_RETURN_NOT_OK(encoded->Set(std::string{parquet_detail::range_start_key}, " 100"));
    require(!parquet_detail::decode_metadata(*encoded).ok(),
            "whitespace-padded metadata integers must be rejected");

    encoded = parquet_detail::encode_metadata(dataset_metadata);
    ARROW_RETURN_NOT_OK(
        encoded->Set(std::string{parquet_detail::source_artifact_prefix} + "0.end_ns", "100"));
    require(!parquet_detail::decode_metadata(*encoded).ok(), "empty source artifact ranges must be rejected");

    auto invalid_kind_metadata = dataset_metadata;
    invalid_kind_metadata.data_kind = static_cast<DataKind>(99);
    bool invalid_kind_rejected = false;
    try {
        validate(invalid_kind_metadata);
    } catch (const std::invalid_argument&) {
        invalid_kind_rejected = true;
    }
    require(invalid_kind_rejected, "unknown dataset data kinds must be rejected");

    auto invalid_schema = arrow::schema({
        arrow::field(std::string{column_names::event_time}, arrow::int64(), false),
        arrow::field(std::string{column_names::source_receive_time}, arrow::int64(), false),
        arrow::field(std::string{column_names::sequence}, arrow::uint64(), false),
        arrow::field(std::string{column_names::order_id}, arrow::uint64(), false),
        arrow::field(std::string{column_names::price}, arrow::int32(), false),
        arrow::field(std::string{column_names::quantity}, arrow::int64(), false),
        arrow::field(std::string{column_names::source_flags}, arrow::uint64(), false),
        arrow::field(std::string{column_names::channel_id}, arrow::uint32(), false),
        arrow::field(std::string{column_names::control}, arrow::uint32(), false),
    });
    require(!validate_batch_schema(*invalid_schema, DataKind::Mbo).ok(),
            "canonical Arrow column types must be validated");
    return arrow::Status::OK();
}

arrow::Status test_mbo_round_trip_and_replay(ParquetStorageBackend& backend) {
    const auto source = mbo_fixture();
    ARROW_ASSIGN_OR_RAISE(const auto canonical_batch, to_arrow(source));

    arrow::Int32Builder archive_only_builder;
    for (std::size_t index = 0; index < source.size(); ++index) {
        ARROW_RETURN_NOT_OK(archive_only_builder.Append(static_cast<std::int32_t>(index + 1)));
    }
    std::shared_ptr<arrow::Array> archive_only_array;
    ARROW_RETURN_NOT_OK(archive_only_builder.Finish(&archive_only_array));
    ARROW_ASSIGN_OR_RAISE(
        const auto archive_batch,
        canonical_batch->AddColumn(canonical_batch->num_columns(), "archive_only", archive_only_array));

    const auto dataset_metadata = metadata(DataKind::Mbo, stream(), range(100, 105));
    const std::vector<ArrowBatch> batches{archive_batch};
    ARROW_ASSIGN_OR_RAISE(const auto fragment, backend.write(dataset_metadata, batches));

    ARROW_ASSIGN_OR_RAISE(const auto restored_metadata, backend.read_metadata(fragment));
    require(restored_metadata == dataset_metadata, "dataset-local metadata must round-trip");
    require(fragment.time_range == range(100, 105), "fragment time range must remain half-open");
    require(fragment.locator.find("data/mbo/") != std::string::npos,
            "MBO fragments must use the portable MBO directory layout");

    std::vector<ArrowBatch> full_batches;
    ARROW_RETURN_NOT_OK(backend.read_batches(
        fragment,
        BatchProjection::Full,
        [&full_batches](const ArrowBatch& batch) {
            full_batches.push_back(batch);
            return arrow::Status::OK();
        }));
    require(full_batches.size() == 1, "small MBO fixture should be read as one Arrow batch");
    require(full_batches[0]->GetColumnByName("archive_only") != nullptr,
            "full batch access must retain archive-only columns");
    ARROW_ASSIGN_OR_RAISE(const auto restored, from_arrow(*full_batches[0], stream()));
    require(restored.size() == source.size(), "MBO row count must round-trip");
    for (std::size_t index = 0; index < source.size(); ++index) {
        require_same_record(source.data()[index], restored.data()[index]);
    }
    require(restored.at(1).sequence() == std::optional<std::uint64_t>{0},
            "MBO presence bits must preserve zero sequence values through Arrow and Parquet");
    require(!restored.at(2).source_receive_time(),
            "MBO presence bits must preserve absent receive times through Arrow and Parquet");

    std::vector<ArrowBatch> replay_batches;
    ARROW_RETURN_NOT_OK(backend.read_batches(
        fragment,
        BatchProjection::Replay,
        [&replay_batches](const ArrowBatch& batch) {
            replay_batches.push_back(batch);
            return arrow::Status::OK();
        }));
    require(replay_batches.size() == 1, "small replay fixture should be read as one Arrow batch");
    require(replay_batches[0]->GetColumnByName("archive_only") == nullptr,
            "replay projection must exclude archive-only columns");

    std::vector<CanonicalEvent> events;
    ARROW_RETURN_NOT_OK(backend.stream_events(
        fragment,
        [&events](const CanonicalEvent& event) {
            events.push_back(event);
            return arrow::Status::OK();
        }));
    require(events.size() == 3, "sequential replay must emit every persisted MBO event");
    require(std::get<MboEvent>(events[0]).order_id->value() == 100,
            "sequential replay must preserve the first event order");
    require(std::get<MboEvent>(events[1]).header.event_time == time(102),
            "sequential replay must preserve event-time order");
    require(std::get<MboEvent>(events[2]).action == MboAction::Clear,
            "sequential replay must preserve canonical action order");
    return arrow::Status::OK();
}

arrow::Status test_trade_and_execution_round_trip(ParquetStorageBackend& backend) {
    const auto trade_header = header(200, time(201), std::uint64_t{10}, std::uint32_t{3}, 21);
    const std::vector<Trade> trades{
        Trade{trade_header, Price::from_integer(101), Quantity::from_integer(4), Side::Buy},
    };
    ARROW_ASSIGN_OR_RAISE(const auto trade_batch, to_arrow(std::span<const Trade>{trades}));
    arrow::Int8Builder invalid_side_builder;
    ARROW_RETURN_NOT_OK(invalid_side_builder.Append(2));
    std::shared_ptr<arrow::Array> invalid_side_array;
    ARROW_RETURN_NOT_OK(invalid_side_builder.Finish(&invalid_side_array));
    ARROW_ASSIGN_OR_RAISE(
        const auto invalid_trade_batch,
        trade_batch->SetColumn(
            trade_batch->schema()->GetFieldIndex(column_names::aggressor_side),
            arrow::field(std::string{column_names::aggressor_side}, arrow::int8()),
            invalid_side_array));
    require(!trades_from_arrow(*invalid_trade_batch, stream()).ok(),
            "trade aggressor side values outside the canonical encoding must be rejected");

    const auto trade_metadata = metadata(DataKind::Trades, stream(), range(200, 201));
    const std::vector<ArrowBatch> trade_batches{trade_batch};
    ARROW_ASSIGN_OR_RAISE(const auto trade_fragment, backend.write(trade_metadata, trade_batches));
    std::vector<ArrowBatch> restored_trade_batches;
    ARROW_RETURN_NOT_OK(backend.read_batches(
        trade_fragment,
        BatchProjection::Full,
        [&restored_trade_batches](const ArrowBatch& batch) {
            restored_trade_batches.push_back(batch);
            return arrow::Status::OK();
        }));
    require(restored_trade_batches.size() == 1, "trade fixture should be read as one Arrow batch");
    ARROW_ASSIGN_OR_RAISE(const auto restored_trades, trades_from_arrow(*restored_trade_batches[0], stream()));
    require(restored_trades.size() == 1, "trade row count must round-trip");
    require(restored_trades[0].price == trades[0].price && restored_trades[0].quantity == trades[0].quantity,
            "trade price and quantity must round-trip");
    require(restored_trades[0].header.source_receive_time == trade_header.source_receive_time,
            "trade source receive time must round-trip");

    const std::vector<OrderExecution> executions{
        OrderExecution{
            header(300, std::nullopt, std::uint64_t{11}, std::uint32_t{4}, 22),
            OrderId{100},
            Quantity::from_integer(2),
            std::nullopt,
        },
    };
    ARROW_ASSIGN_OR_RAISE(
        const auto execution_batch,
        to_arrow(std::span<const OrderExecution>{executions}));
    const auto execution_metadata = metadata(DataKind::OrderExecution, stream(), range(300, 301));
    const std::vector<ArrowBatch> execution_batches{execution_batch};
    ARROW_ASSIGN_OR_RAISE(
        const auto execution_fragment,
        backend.write(execution_metadata, execution_batches));
    std::vector<ArrowBatch> restored_execution_batches;
    ARROW_RETURN_NOT_OK(backend.read_batches(
        execution_fragment,
        BatchProjection::Full,
        [&restored_execution_batches](const ArrowBatch& batch) {
            restored_execution_batches.push_back(batch);
            return arrow::Status::OK();
        }));
    require(restored_execution_batches.size() == 1, "execution fixture should be read as one Arrow batch");
    ARROW_ASSIGN_OR_RAISE(
        const auto restored_executions,
        executions_from_arrow(*restored_execution_batches[0], stream()));
    require(restored_executions.size() == 1, "execution row count must round-trip");
    require(restored_executions[0].resting_order_id == executions[0].resting_order_id &&
                restored_executions[0].executed_quantity == executions[0].executed_quantity,
            "order execution fields must round-trip");
    require(!restored_executions[0].price, "optional order execution price must round-trip as absent");
    return arrow::Status::OK();
}

arrow::Status run_tests() {
    const auto root = std::filesystem::temp_directory_path() / "quant-storage-foundation-tests";
    std::error_code cleanup_error;
    std::filesystem::remove_all(root, cleanup_error);
    ARROW_RETURN_NOT_OK(test_metadata_and_schema_validation());
    ParquetStorageBackend backend{root};
    ARROW_RETURN_NOT_OK(test_mbo_round_trip_and_replay(backend));
    ARROW_RETURN_NOT_OK(test_trade_and_execution_round_trip(backend));
    std::filesystem::remove_all(root, cleanup_error);
    return arrow::Status::OK();
}

} // namespace

int main() {
    try {
        const auto status = run_tests();
        if (!status.ok()) {
            std::cerr << "storage_tests: failed: " << status.ToString() << '\n';
            return 1;
        }
        std::cout << "storage_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "storage_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
