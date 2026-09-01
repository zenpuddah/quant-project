#include "quant/data/reference.hpp"
#include "quant/data/validation.hpp"

#include <cstdint>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string_view>

namespace {

using namespace quant::data;

void require(const bool condition, const std::string_view message) {
    if (!condition) {
        throw std::runtime_error(std::string(message));
    }
}

template <typename Function>
void require_throws(Function&& function, const std::string_view message) {
    bool threw = false;
    try {
        function();
    } catch (const std::invalid_argument&) {
        threw = true;
    }
    require(threw, message);
}

bool contains_code(const ValidationIssues& issues, const std::string_view code) {
    for (const auto& issue : issues) {
        if (issue.code == code) {
            return true;
        }
    }
    return false;
}

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

EventHeader header() {
    return EventHeader{
        InstrumentId{1},
        VenueId{"XNAS"},
        time(100),
        time(110),
        std::uint64_t{7},
        std::uint32_t{2},
        std::uint64_t{0},
        SourceInfo{"databento", "test", "mbo"},
    };
}

ReferenceVersion reference(
    const InstrumentId id,
    const Timestamp from,
    const std::optional<Timestamp> until,
    const std::string_view symbol) {
    return ReferenceVersion{
        id,
        from,
        until,
        InstrumentType::Equity,
        std::string(symbol),
        CurrencyCode{"USD"},
        Price{FixedDecimal{1, 2}},
        Quantity{FixedDecimal{1}},
    };
}

void test_value_types() {
    require(FixedDecimal{10, 2} == FixedDecimal{1, 1}, "decimal equality must be scale-independent");
    require(FixedDecimal{120, 2} > FixedDecimal{119, 2}, "decimal ordering must be exact");
    require(FixedDecimal{-1} < FixedDecimal{0}, "negative decimal must compare below zero");
    require(FixedDecimal{1, 3} < FixedDecimal{1, 2}, "decimal scale must affect value ordering");
    require(FixedDecimal{0, 18} == FixedDecimal{0}, "all zero decimal representations must compare equal");

    require_throws([] { InstrumentId{0}; }, "zero instrument id must be rejected");
    require_throws([] { OrderId{0}; }, "zero order id must be rejected");
    require_throws([] { VenueId{""}; }, "empty venue id must be rejected");
    require_throws([] { SourceInfo{""}; }, "empty source provider must be rejected");
    require_throws([] { CurrencyCode{"usd"}; }, "lowercase currency code must be rejected");
    require_throws([] { FixedDecimal{0, 19}; }, "excessive decimal scale must be rejected");
    require_throws([] { Quantity{FixedDecimal{-1}}; }, "negative quantity must be rejected");
}

void test_reference_history() {
    const InstrumentId id{1};
    ReferenceHistory history{id};
    history.append(reference(id, time(0), time(10), "ABC"));
    history.append(reference(id, time(10), std::nullopt, "XYZ"));

    require(history.size() == 2, "reference history must retain both versions");
    require(history.at(time(9)) != nullptr, "reference history must resolve an active version");
    require(history.at(time(9))->symbol == "ABC", "reference lookup must be point-in-time");
    require(history.at(time(10))->symbol == "XYZ", "validity end must be exclusive");
    require(history.at(time(-1)) == nullptr, "reference lookup before history must be empty");

    require_throws(
        [&] { history.append(reference(InstrumentId{2}, time(20), std::nullopt, "OTHER")); },
        "reference history must not mix instruments");
    require_throws(
        [&] { history.append(reference(id, time(20), std::nullopt, "LATE")); },
        "reference history must not append after an open interval");

    ReferenceHistory overlapping{id};
    overlapping.append(reference(id, time(0), time(10), "ABC"));
    require_throws(
        [&] { overlapping.append(reference(id, time(9), std::nullopt, "OVERLAP")); },
        "reference validity intervals must not overlap");
}

void test_mbo_events() {
    const auto event_header = header();
    const auto price = Price{FixedDecimal{12345, 2}};
    const auto quantity = Quantity{FixedDecimal{10}};

    const MboEvent add{
        event_header,
        MboAction::Add,
        OrderId{100},
        Side::Buy,
        price,
        quantity,
    };
    require(add.has_complete_order_state(), "complete add must expose complete order state");
    require(is_valid(validate(add)), "complete add must validate");

    const MboEvent clear{
        event_header,
        MboAction::Clear,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt,
    };
    require(is_valid(validate(clear)), "empty clear must validate");

    const MboEvent incomplete_add{
        event_header,
        MboAction::Add,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt,
    };
    const auto add_issues = validate(incomplete_add);
    require(contains_code(add_issues, "missing_order_id"), "incomplete add must report missing order id");
    require(contains_code(add_issues, "incomplete_add"), "incomplete add must report missing order fields");

    const MboEvent invalid_clear{
        event_header,
        MboAction::Clear,
        OrderId{101},
        std::nullopt,
        std::nullopt,
        std::nullopt,
    };
    require(contains_code(validate(invalid_clear), "clear_has_order_fields"),
            "clear must not carry order fields");
}

void test_trade_quote_and_bar() {
    const auto event_header = header();
    const auto bid = Price{FixedDecimal{100}};
    const auto ask = Price{FixedDecimal{101}};
    const auto quantity = Quantity{FixedDecimal{5}};

    const Trade trade{event_header, bid, quantity, Side::Buy};
    require(is_valid(validate(trade)), "positive trade must validate");

    const Trade zero_trade{event_header, bid, Quantity{FixedDecimal{0}}, std::nullopt};
    require(contains_code(validate(zero_trade), "zero_trade_quantity"),
            "zero trade quantity must be rejected");

    const Quote quote{event_header, bid, quantity, ask, quantity};
    require(is_valid(validate(quote)), "two-sided quote must validate");

    const Quote crossed{event_header, ask, quantity, bid, quantity};
    require(contains_code(validate(crossed), "crossed_quote"), "crossed quote must be rejected");

    const Quote incomplete_bid{event_header, bid, std::nullopt, ask, quantity};
    require(contains_code(validate(incomplete_bid), "incomplete_bid"),
            "quote sides must contain price and quantity together");

    const Bar bar{
        event_header,
        time(0),
        time(60),
        Price{FixedDecimal{100}},
        Price{FixedDecimal{105}},
        Price{FixedDecimal{95}},
        Price{FixedDecimal{101}},
        Quantity{FixedDecimal{1000}},
    };
    require(is_valid(validate(bar)), "well-formed bar must validate");

    const Bar invalid_bar{
        event_header,
        time(60),
        time(0),
        Price{FixedDecimal{110}},
        Price{FixedDecimal{105}},
        Price{FixedDecimal{95}},
        Price{FixedDecimal{101}},
        Quantity{FixedDecimal{1000}},
    };
    const auto bar_issues = validate(invalid_bar);
    require(contains_code(bar_issues, "invalid_bar_interval"), "bar interval must be ordered");
    require(contains_code(bar_issues, "open_outside_range"), "bar open must stay within its range");
}

} // namespace

int main() {
    try {
        test_value_types();
        test_reference_history();
        test_mbo_events();
        test_trade_quote_and_bar();
        std::cout << "data_model_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "data_model_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
