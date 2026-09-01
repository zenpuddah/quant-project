#pragma once

#include <compare>
#include <cstdint>
#include <stdexcept>
#include <string>
#include <utility>

namespace quant::data {

class InstrumentId {
public:
    explicit InstrumentId(const std::uint64_t value) : value_(value) {
        if (value == 0) {
            throw std::invalid_argument("InstrumentId must be non-zero");
        }
    }

    [[nodiscard]] constexpr std::uint64_t value() const noexcept { return value_; }

    friend constexpr bool operator==(const InstrumentId&, const InstrumentId&) = default;
    friend constexpr auto operator<=>(const InstrumentId&, const InstrumentId&) = default;

private:
    std::uint64_t value_;
};

class OrderId {
public:
    explicit OrderId(const std::uint64_t value) : value_(value) {
        if (value == 0) {
            throw std::invalid_argument("OrderId must be non-zero");
        }
    }

    [[nodiscard]] constexpr std::uint64_t value() const noexcept { return value_; }

    friend constexpr bool operator==(const OrderId&, const OrderId&) = default;
    friend constexpr auto operator<=>(const OrderId&, const OrderId&) = default;

private:
    std::uint64_t value_;
};

class Timestamp {
public:
    explicit constexpr Timestamp(const std::int64_t unix_nanos) noexcept : unix_nanos_(unix_nanos) {}

    [[nodiscard]] static constexpr Timestamp from_unix_nanos(const std::int64_t unix_nanos) noexcept {
        return Timestamp(unix_nanos);
    }

    [[nodiscard]] constexpr std::int64_t unix_nanos() const noexcept { return unix_nanos_; }

    friend constexpr bool operator==(const Timestamp&, const Timestamp&) = default;
    friend constexpr auto operator<=>(const Timestamp&, const Timestamp&) = default;

private:
    std::int64_t unix_nanos_;
};

class VenueId {
public:
    explicit VenueId(std::string value) : value_(std::move(value)) {
        if (value_.empty()) {
            throw std::invalid_argument("VenueId must not be empty");
        }
    }

    [[nodiscard]] const std::string& value() const noexcept { return value_; }

    friend bool operator==(const VenueId&, const VenueId&) = default;
    friend auto operator<=>(const VenueId&, const VenueId&) = default;

private:
    std::string value_;
};

class CurrencyCode {
public:
    explicit CurrencyCode(std::string value) : value_(std::move(value)) {
        if (value_.size() != 3 || !is_uppercase_ascii(value_[0]) || !is_uppercase_ascii(value_[1]) ||
            !is_uppercase_ascii(value_[2])) {
            throw std::invalid_argument("CurrencyCode must be three uppercase ASCII letters");
        }
    }

    [[nodiscard]] const std::string& value() const noexcept { return value_; }

    friend bool operator==(const CurrencyCode&, const CurrencyCode&) = default;
    friend auto operator<=>(const CurrencyCode&, const CurrencyCode&) = default;

private:
    [[nodiscard]] static constexpr bool is_uppercase_ascii(const char value) noexcept {
        return value >= 'A' && value <= 'Z';
    }

    std::string value_;
};

class SourceInfo {
public:
    SourceInfo(std::string provider, std::string dataset = {}, std::string schema = {})
        : provider_(std::move(provider)), dataset_(std::move(dataset)), schema_(std::move(schema)) {
        if (provider_.empty()) {
            throw std::invalid_argument("SourceInfo provider must not be empty");
        }
    }

    [[nodiscard]] const std::string& provider() const noexcept { return provider_; }
    [[nodiscard]] const std::string& dataset() const noexcept { return dataset_; }
    [[nodiscard]] const std::string& schema() const noexcept { return schema_; }

    friend bool operator==(const SourceInfo&, const SourceInfo&) = default;

private:
    std::string provider_;
    std::string dataset_;
    std::string schema_;
};

class FixedDecimal {
public:
    static constexpr std::uint8_t max_scale = 18;

    explicit constexpr FixedDecimal(const std::int64_t coefficient, const std::uint8_t scale = 0)
        : coefficient_(coefficient), scale_(scale) {
        if (scale > max_scale) {
            throw std::invalid_argument("FixedDecimal scale must be at most 18");
        }
    }

    [[nodiscard]] static constexpr FixedDecimal from_integer(const std::int64_t value) noexcept {
        return FixedDecimal(value, 0);
    }

    [[nodiscard]] constexpr std::int64_t coefficient() const noexcept { return coefficient_; }
    [[nodiscard]] constexpr std::uint8_t scale() const noexcept { return scale_; }
    [[nodiscard]] constexpr bool is_zero() const noexcept { return coefficient_ == 0; }
    [[nodiscard]] constexpr bool is_negative() const noexcept { return coefficient_ < 0; }
    [[nodiscard]] constexpr bool is_positive() const noexcept { return coefficient_ > 0; }

    [[nodiscard]] int compare(const FixedDecimal& other) const;

    friend bool operator==(const FixedDecimal& lhs, const FixedDecimal& rhs) {
        return lhs.compare(rhs) == 0;
    }

    friend std::strong_ordering operator<=>(const FixedDecimal& lhs, const FixedDecimal& rhs) {
        const int result = lhs.compare(rhs);
        if (result < 0) {
            return std::strong_ordering::less;
        }
        if (result > 0) {
            return std::strong_ordering::greater;
        }
        return std::strong_ordering::equal;
    }

private:
    [[nodiscard]] static std::uint64_t magnitude(const std::int64_t value) noexcept {
        if (value >= 0) {
            return static_cast<std::uint64_t>(value);
        }
        return std::uint64_t{0} - static_cast<std::uint64_t>(value);
    }

    std::int64_t coefficient_;
    std::uint8_t scale_;
};

inline int FixedDecimal::compare(const FixedDecimal& other) const {
    if (coefficient_ == 0 && other.coefficient_ == 0) {
        return 0;
    }

    const bool lhs_negative = coefficient_ < 0;
    const bool rhs_negative = other.coefficient_ < 0;
    if (lhs_negative != rhs_negative) {
        return lhs_negative ? -1 : 1;
    }

    const auto lhs_digits = std::to_string(magnitude(coefficient_));
    const auto rhs_digits = std::to_string(magnitude(other.coefficient_));
    const int lhs_integer_digits = static_cast<int>(lhs_digits.size()) - static_cast<int>(scale_);
    const int rhs_integer_digits = static_cast<int>(rhs_digits.size()) - static_cast<int>(other.scale_);

    int magnitude_result = 0;
    if (lhs_integer_digits < rhs_integer_digits) {
        magnitude_result = -1;
    } else if (lhs_integer_digits > rhs_integer_digits) {
        magnitude_result = 1;
    } else {
        const auto target_scale = scale_ > other.scale_ ? scale_ : other.scale_;
        auto lhs_padded = lhs_digits;
        auto rhs_padded = rhs_digits;
        lhs_padded.append(static_cast<std::size_t>(target_scale - scale_), '0');
        rhs_padded.append(static_cast<std::size_t>(target_scale - other.scale_), '0');

        if (lhs_padded < rhs_padded) {
            magnitude_result = -1;
        } else if (lhs_padded > rhs_padded) {
            magnitude_result = 1;
        }
    }

    return lhs_negative ? -magnitude_result : magnitude_result;
}

class Price {
public:
    explicit Price(FixedDecimal value) : value_(std::move(value)) {}

    [[nodiscard]] const FixedDecimal& value() const noexcept { return value_; }

    friend bool operator==(const Price&, const Price&) = default;
    friend auto operator<=>(const Price&, const Price&) = default;

private:
    FixedDecimal value_;
};

class Quantity {
public:
    explicit Quantity(FixedDecimal value) : value_(std::move(value)) {
        if (value_.is_negative()) {
            throw std::invalid_argument("Quantity must not be negative");
        }
    }

    [[nodiscard]] const FixedDecimal& value() const noexcept { return value_; }

    friend bool operator==(const Quantity&, const Quantity&) = default;
    friend auto operator<=>(const Quantity&, const Quantity&) = default;

private:
    FixedDecimal value_;
};

class Money {
public:
    Money(CurrencyCode currency, FixedDecimal amount)
        : currency_(std::move(currency)), amount_(std::move(amount)) {}

    [[nodiscard]] const CurrencyCode& currency() const noexcept { return currency_; }
    [[nodiscard]] const FixedDecimal& amount() const noexcept { return amount_; }

    friend bool operator==(const Money&, const Money&) = default;

private:
    CurrencyCode currency_;
    FixedDecimal amount_;
};

enum class InstrumentType {
    Equity,
    Option,
    Future,
    Other,
};

enum class Side {
    Buy,
    Sell,
};

enum class MboAction {
    Add,
    Modify,
    Cancel,
    Execute,
    Clear,
};

} // namespace quant::data
