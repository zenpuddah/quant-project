#pragma once

#include "quant/data/value_types.hpp"

#include <cstdint>
#include <optional>

namespace quant::data {

struct EventHeader {
    InstrumentId instrument_id;
    VenueId venue;
    Timestamp event_time;
    std::optional<Timestamp> receive_time;
    std::optional<std::uint64_t> sequence;
    std::optional<std::uint32_t> channel_id;
    std::uint64_t source_flags;
    SourceInfo source;
};

struct MboEvent {
    EventHeader header;
    MboAction action;
    std::optional<OrderId> order_id;
    std::optional<Side> side;
    std::optional<Price> price;
    std::optional<Quantity> quantity;

    [[nodiscard]] bool has_complete_order_state() const noexcept {
        return action != MboAction::Clear && order_id && side && price && quantity;
    }
};

struct Trade {
    EventHeader header;
    Price price;
    Quantity quantity;
    std::optional<Side> aggressor_side;
};

struct Quote {
    EventHeader header;
    std::optional<Price> bid_price;
    std::optional<Quantity> bid_quantity;
    std::optional<Price> ask_price;
    std::optional<Quantity> ask_quantity;
};

struct Bar {
    EventHeader header;
    Timestamp interval_start;
    Timestamp interval_end;
    Price open;
    Price high;
    Price low;
    Price close;
    Quantity volume;
};

} // namespace quant::data
