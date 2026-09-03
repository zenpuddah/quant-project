#include "quant/ingestion/quality.hpp"

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

Timestamp time(const std::int64_t nanos) {
    return Timestamp::from_unix_nanos(nanos);
}

TimeRange range(const std::int64_t start, const std::int64_t end) {
    return TimeRange{time(start), time(end)};
}

DataState reduce(
    const TimeRange requested,
    const std::vector<DataQualityObservation>& observations) {
    return DataStateReducer::reduce(requested, observations);
}

void test_quality_reduction() {
    const auto requested = range(10, 20);
    require(
        reduce(requested, {{requested, DataQualityKind::Complete}}) == DataState::Complete,
        "complete evidence must reduce to complete state");
    require(
        reduce(requested, {{requested, DataQualityKind::Degraded}}) == DataState::Degraded,
        "degraded evidence must reduce to degraded state");
    require(
        reduce(requested, {{requested, DataQualityKind::Missing}}) == DataState::Missing,
        "missing evidence must reduce to missing state");
    require(
        reduce(requested, {{requested, DataQualityKind::SequenceGap}}) == DataState::Degraded,
        "sequence-gap evidence must reduce to degraded state");
    require(
        reduce(requested, {{requested, DataQualityKind::Complete}, {range(15, 18), DataQualityKind::Corrupt}}) ==
            DataState::Corrupt,
        "corrupt evidence must take precedence over overlapping complete evidence");
}

void test_unknown_and_coverage() {
    const auto requested = range(10, 20);
    require(
        reduce(requested, {}) == DataState::Unknown,
        "no evidence must reduce to an explicit unknown state");
    require(
        reduce(requested, {{range(10, 15), DataQualityKind::Complete}}) == DataState::Unknown,
        "partial evidence must not pretend the uncovered range is complete");
    require(
        reduce(requested, {{range(10, 15), DataQualityKind::Complete}, {range(15, 20), DataQualityKind::Missing}}) ==
            DataState::Missing,
        "adjacent quality evidence must cover the requested range honestly");
    require(
        reduce(requested, {{range(0, 10), DataQualityKind::Complete}, {range(20, 30), DataQualityKind::Complete}}) ==
            DataState::Unknown,
        "endpoint-adjacent evidence must not cover a half-open request");
}

} // namespace

int main() {
    try {
        test_quality_reduction();
        test_unknown_and_coverage();
        std::cout << "data_quality_tests: passed\n";
    } catch (const std::exception& error) {
        std::cerr << "data_quality_tests: failed: " << error.what() << '\n';
        return 1;
    }
    return 0;
}
