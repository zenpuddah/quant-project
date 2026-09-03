#pragma once

namespace quant::ingestion {

enum class RecoveryAction {
    NoAction,
    Retry,
    RepairMissingRanges,
    Abort,
};

class RecoveryPolicy {
public:
    virtual ~RecoveryPolicy() = default;
    virtual RecoveryAction decide(bool has_unresolved_ranges) const = 0;
};

class NoopRecoveryPolicy final : public RecoveryPolicy {
public:
    [[nodiscard]] RecoveryAction decide(const bool) const override { return RecoveryAction::NoAction; }
};

} // namespace quant::ingestion
