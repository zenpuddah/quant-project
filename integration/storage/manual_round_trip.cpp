#include "quant/storage/parquet_backend.hpp"

#include <cstddef>
#include <cstdint>
#include <exception>
#include <filesystem>
#include <iostream>
#include <optional>
#include <string>
#include <tuple>
#include <variant>
#include <vector>

namespace {

using namespace quant::data;
using namespace quant::ingestion;
using namespace quant::storage;

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

EventHeader header(
    const std::int64_t nanos,
    const std::optional<Timestamp> receive,
    const std::optional<std::uint64_t> sequence,
    const std::optional<std::uint32_t> channel,
    const std::uint64_t flags) {
    return EventHeader{InstrumentId{42}, VenueId{7}, time(nanos), receive, sequence, channel, flags, SourceId{9}};
}

auto physical_fields(const MboRecord& record) {
    return std::tie(record.event_time, record.source_receive_time, record.sequence, record.order_id,
                    record.price, record.quantity, record.source_flags, record.channel_id, record.control);
}

bool same_event(const MboEvent& lhs, const MboEvent& rhs) {
    return lhs.header == rhs.header && lhs.action == rhs.action && lhs.order_id == rhs.order_id &&
           lhs.side == rhs.side && lhs.price == rhs.price && lhs.quantity == rhs.quantity;
}

template <typename Integer>
std::string optional_number(const std::optional<Integer>& value) {
    return value ? std::to_string(*value) : "null";
}

arrow::Status run(const std::filesystem::path& root) {
    // Small synthetic timestamps are nanoseconds since the epoch, not real market data.
    MboBuffer source{MboStreamContext{InstrumentId{42}, VenueId{7}, SourceId{9}}};
    source.append(MboAdd{header(100, time(101), 7, 2, 11), OrderId{100}, Side::Buy,
                         Price::from_integer(100), Quantity::from_integer(2)});
    source.append(MboModify{header(102, time(103), 0, 0, 12), OrderId{100}, Side::Sell,
                            std::nullopt, std::nullopt});
    source.append(MboClear{header(104, std::nullopt, std::nullopt, std::nullopt, 13)});
    std::cout << "canonical rows=" << source.size() << " record_bytes=" << sizeof(MboRecord) << '\n';

    ARROW_ASSIGN_OR_RAISE(const auto batch, to_arrow(source));
    std::cout << "arrow rows=" << batch->num_rows() << " columns=" << batch->num_columns() << '\n';

    const StreamIdentity identity{InstrumentId{42}, VenueId{7}, SourceId{9}};
    const TimeRange range{time(100), time(105)};
    const DatasetLocalMetadata metadata{
        DataKind::Mbo, identity, range, AcquisitionMode::Historical,
        "canonical-v1", "manual-v1", "manual-v1", {},
        {SourceArtifactProvenance{"synthetic:mbo-three-events", range}}, std::nullopt,
    };
    ParquetStorageBackend backend{root};
    const std::vector<ArrowBatch> batches{batch};
    ARROW_ASSIGN_OR_RAISE(const auto fragment, backend.write(metadata, batches));
    std::cout << "parquet=" << fragment.locator << '\n';

    // Read through the public consumer boundary, rather than using Parquet APIs here.
    const MarketDataReader& reader = backend;
    ARROW_ASSIGN_OR_RAISE(const auto restored_metadata, reader.read_metadata(fragment));
    if (restored_metadata != metadata) {
        return arrow::Status::Invalid("dataset metadata changed during the round trip");
    }
    std::cout << "metadata matches=true stream=42/7/9 range=[100,105) schema=canonical-v1\n";

    std::size_t read_rows = 0;
    ARROW_RETURN_NOT_OK(reader.read_batches(
        fragment, BatchProjection::Full,
        [&source, &identity, &read_rows](const ArrowBatch& read_batch) {
            ARROW_ASSIGN_OR_RAISE(const auto restored, from_arrow(*read_batch, identity));
            for (std::size_t index = 0; index < restored.size(); ++index) {
                if (read_rows >= source.size() ||
                    physical_fields(restored.data()[index]) != physical_fields(source.data()[read_rows])) {
                    return arrow::Status::Invalid("MBO physical fields or row order changed");
                }
                ++read_rows;
            }
            return arrow::Status::OK();
        }));
    if (read_rows != source.size()) {
        return arrow::Status::Invalid("Arrow read row count changed");
    }
    std::cout << "arrow_read rows=" << read_rows << " physical_fields_equal=true\n";

    std::size_t replay_rows = 0;
    ARROW_RETURN_NOT_OK(reader.stream_events(
        fragment,
        [&source, &replay_rows](const CanonicalEvent& event) {
            const auto* mbo = std::get_if<MboEvent>(&event);
            if (!mbo || replay_rows >= source.size() || !same_event(*mbo, source.at(replay_rows).event())) {
                return arrow::Status::Invalid("canonical replay event or order changed");
            }
            const char* action = mbo->action == MboAction::Add ? "Add" :
                                 mbo->action == MboAction::Modify ? "Modify" : "Clear";
            const char* side = !mbo->side ? "null" : *mbo->side == Side::Buy ? "Buy" : "Sell";
            std::cout << "replay[" << replay_rows << "] " << action
                      << " t=" << mbo->header.event_time.unix_nanos()
                      << " recv=" << (mbo->header.source_receive_time
                          ? std::to_string(mbo->header.source_receive_time->unix_nanos()) : "null")
                      << " seq=" << optional_number(mbo->header.sequence)
                      << " channel=" << optional_number(mbo->header.channel_id)
                      << " order=" << (mbo->order_id ? std::to_string(mbo->order_id->value()) : "null")
                      << " side=" << side
                      << " price_raw=" << (mbo->price ? std::to_string(mbo->price->raw()) : "null")
                      << " quantity_raw=" << (mbo->quantity ? std::to_string(mbo->quantity->raw()) : "null")
                      << " flags=" << mbo->header.source_flags << '\n';
            ++replay_rows;
            return arrow::Status::OK();
        }));
    if (replay_rows != source.size()) {
        return arrow::Status::Invalid("replay row count changed");
    }
    std::cout << "replay rows=" << replay_rows << " canonical_events_equal=true\nmanual_round_trip: passed\n";
    return arrow::Status::OK();
}

} // namespace

int main(const int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "Usage: quant_storage_manual_round_trip <output-root>\n";
        return 1;
    }
    try {
        const auto status = run(std::filesystem::path{argv[1]});
        if (status.ok()) {
            return 0;
        }
        std::cerr << "manual_round_trip: failed: " << status.ToString() << '\n';
    } catch (const std::exception& error) {
        std::cerr << "manual_round_trip: failed: " << error.what() << '\n';
    }
    return 1;
}
