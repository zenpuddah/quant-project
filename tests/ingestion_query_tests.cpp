#include "quant/ingestion/query.hpp"

#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

namespace {

using namespace quant::data;
using namespace quant::ingestion;

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

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

TimeRange range(const std::int64_t start, const std::int64_t end) {
    return TimeRange{time(start), time(end)};
}

void require_ranges(const std::vector<TimeRange>& actual, const std::vector<TimeRange>& expected, const std::string_view message) {
    require(actual.size() == expected.size(), message);
    for (std::size_t index = 0; index < actual.size(); ++index) {
        require(actual[index].start == expected[index].start && actual[index].end == expected[index].end, message);
    }
}

void test_query_boundary() {
    const MarketDataQuery query{InstrumentId{42}, VenueId{7}, MarketDataLevel::L3, range(10, 20)};
    require(query.instrument_id == InstrumentId{42}, "query must retain canonical instrument identity");
    require(query.venue_id == std::optional<VenueId>{VenueId{7}}, "query must retain optional venue constraint");
    require(query.level == MarketDataLevel::L3, "query must retain canonical data level");
    require(query.range.start == time(10) && query.range.end == time(20), "query must retain its half-open range");

    require_throws(
        [] { TimeRange{time(10), time(10)}; },
        "zero-length time ranges must be rejected");
    require_throws(
        [] { TimeRange{time(20), time(10)}; },
        "backwards time ranges must be rejected");
}

void test_intervals() {
    const auto requested = range(10, 20);

    require(!overlaps(requested, range(20, 30)), "adjacent half-open ranges must not overlap");
    require(!overlaps(requested, range(0, 10)), "adjacent half-open ranges must not overlap at the start");
    require(!intersection(requested, range(20, 30)), "adjacent ranges must have no intersection");
    require(
        intersection(requested, range(15, 25)) == std::optional<TimeRange>{range(15, 20)},
        "intersection must preserve the half-open overlap");

    require_ranges(
        subtract(requested, std::vector<TimeRange>{}),
        {requested},
        "an uncovered request must be wholly missing");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(10, 15)}),
        {range(15, 20)},
        "prefix coverage must leave the suffix missing");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(15, 20)}),
        {range(10, 15)},
        "suffix coverage must leave the prefix missing");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(13, 17)}),
        {range(10, 13), range(17, 20)},
        "middle coverage must leave ordered prefix and suffix holes");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(10, 14), range(14, 20)}),
        {},
        "adjacent covered ranges must fully cover the request");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(15, 20), range(12, 17), range(10, 13)}),
        {},
        "overlapping covered ranges must be merged logically");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(12, 14), range(16, 18)}),
        {range(10, 12), range(14, 16), range(18, 20)},
        "multiple covered ranges must produce ordered non-overlapping holes");
    require_ranges(
        subtract(requested, std::vector<TimeRange>{range(0, 10), range(20, 30)}),
        {requested},
        "endpoint-adjacent coverage must not remove the request");
}

} // namespace

int main() {
    try {
        test_query_boundary();
        test_intervals();
        std::cout << "ingestion_query_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "ingestion_query_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
