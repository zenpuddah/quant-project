#!/usr/bin/env python3
"""Internal Lexongine design oracle; no product code or dependencies.

The first 34,076 rounding cases reproduce the transient exploratory script run
on 2026-10-14, including its deterministic seed and fixture checks. Additional
transition/admission checks were added when saving this rerunnable artifact.
Python's unbounded integers and Fraction are independent mathematical oracles;
this does not execute C++, verify compiler overflow behavior, or test plugins.
"""

from fractions import Fraction
from random import Random

MAX_I64 = (1 << 63) - 1
MIN_I64 = -(1 << 63)


def cxx_divmod_model(numerator: int, denominator: int) -> tuple[int, int]:
    """Model signed C++ truncation toward zero without a float conversion."""
    quotient = abs(numerator) // denominator
    quotient = -quotient if numerator < 0 else quotient
    return quotient, numerator - quotient * denominator


def proposed_round_even_model(numerator: int, denominator: int) -> int:
    """Proposed quotient/remainder publication rule, modeled in Python.

    abs(numerator) occurs only in cxx_divmod_model to model built-in division,
    using Python's unbounded integers; it is not part of the proposed C++ rule.
    C++ implementation uses signed division directly and only negates remainder.
    """
    assert 1 <= denominator <= MAX_I64
    quotient, remainder = cxx_divmod_model(numerator, denominator)
    magnitude = -remainder if remainder < 0 else remainder
    assert 0 <= magnitude < denominator
    if magnitude > denominator - magnitude or (
        magnitude == denominator - magnitude and quotient % 2 != 0
    ):
        quotient += -1 if numerator < 0 else 1
    assert MIN_I64 <= quotient <= MAX_I64
    return quotient


def independent_round_oracle(numerator: int, denominator: int) -> int:
    """Fraction.__round__ provides exact nearest-integer, halfway-to-even."""
    return round(Fraction(numerator, denominator))


def checked_add_model(left: int, right: int) -> int:
    """Fail before evaluating the intended signed-int64 addition."""
    assert MIN_I64 <= left <= MAX_I64
    assert MIN_I64 <= right <= MAX_I64
    if right > 0 and left > MAX_I64 - right:
        raise OverflowError("addition exceeds int64 maximum")
    if right < 0 and left < MIN_I64 - right:
        raise OverflowError("addition exceeds int64 minimum")
    return left + right


def checked_subtract_model(left: int, right: int) -> int:
    """Fail before evaluation; never rewrite subtraction as addition of -right."""
    assert MIN_I64 <= left <= MAX_I64
    assert MIN_I64 <= right <= MAX_I64
    if right > 0 and left < MIN_I64 + right:
        raise OverflowError("subtraction exceeds int64 minimum")
    if right < 0 and left > MAX_I64 + right:
        raise OverflowError("subtraction exceeds int64 maximum")
    return left - right


def admitted_sma_model(window: int, bound: int) -> bool:
    """Admission predicate compares by division; it does not evaluate N*B."""
    return (
        1 <= window <= MAX_I64
        and 0 <= bound <= MAX_I64
        and bound <= MAX_I64 // window
    )


def bounded_input_model(raw: int, bound: int) -> bool:
    """Do not abs(raw); canonical Price MIN_I64 is wider than selected domain."""
    assert 0 <= bound <= MAX_I64
    return -bound <= raw <= bound


def assert_overflows(operation, left: int, right: int) -> None:
    try:
        operation(left, right)
    except OverflowError:
        return
    raise AssertionError((operation.__name__, left, right, "expected overflow"))


def rounding_checks() -> None:
    rng = Random(417)
    cases = [(s, n) for s in range(-100, 101) for n in range(1, 71)]
    cases += [
        (MIN_I64, 1),
        (MAX_I64, 1),
        (MIN_I64, MAX_I64),
        (MAX_I64, MAX_I64),
        (MIN_I64, 2),
        (MAX_I64, 2),
    ]
    cases += [
        (rng.randint(MIN_I64, MAX_I64), rng.randint(1, MAX_I64))
        for _ in range(20_000)
    ]
    assert len(cases) == 34_076
    for numerator, denominator in cases:
        got = proposed_round_even_model(numerator, denominator)
        want = independent_round_oracle(numerator, denominator)
        assert got == want, (numerator, denominator, got, want)
    print("rounding oracle cases passed:", len(cases))
    for numerator, denominator in [
        (1, 2), (3, 2), (-1, 2), (-3, 2), (5, 2), (-5, 2),
        (MIN_I64, 1), (MAX_I64, 1),
    ]:
        print("round", numerator, denominator, "->",
              proposed_round_even_model(numerator, denominator))


def fixture_and_counterexample_checks() -> None:
    bound = 102_000_000_000
    fixtures = {}
    for window in [20, 50]:
        assert admitted_sma_model(window, bound)
        prices = [100_000_000_000 + i * 10_000_000 for i in range(120)]
        ring = []
        total = 0
        outputs = []
        for index, raw in enumerate(prices):
            assert bounded_input_model(raw, bound)
            if len(ring) == window:
                evicted = ring.pop(0)
                total = checked_subtract_model(total, evicted)
            total = checked_add_model(total, raw)
            ring.append(raw)
            assert total == sum(ring)
            if len(ring) == window:
                got = proposed_round_even_model(total, window)
                assert got == independent_round_oracle(sum(ring), window)
                outputs.append((index + 1, got))
        fixtures[window] = dict(outputs)
        print("fixture", window, "outputs", len(outputs),
              "first", outputs[0][1], "last", outputs[-1][1])
    for observation in range(50, 121):
        assert fixtures[20][observation] - fixtures[50][observation] == 150_000_000
    print("fixture shared-ready difference raw: 150000000 at observations 50..120")

    previous = proposed_round_even_model(1, 3)
    correct_next = proposed_round_even_model(2, 3)
    incorrect_next = proposed_round_even_model(previous * 3 + 1 - 0, 3)
    assert (previous, correct_next, incorrect_next) == (0, 1, 0)
    print("rounded feedback counterexample window [0,0,1] -> [0,1,1]:",
          previous, "->", correct_next,
          "incorrect reconstructed state result", incorrect_next)
    assert int(float((1 << 53) + 1)) != (1 << 53) + 1
    print("binary64 raw conversion loses unit at 2^53+1")
    print("all-max average valid, int64 sum invalid:",
          proposed_round_even_model(MAX_I64, 1), 20 * MAX_I64 > MAX_I64)
    maximum_u64_window = (1 << 64) - 1
    low = maximum_u64_window * MIN_I64
    high = maximum_u64_window * MAX_I64
    assert -(1 << 127) <= low <= high <= (1 << 127) - 1
    print("alternative signed128 bound verified for uint64 maximum window")


def transition_and_admission_checks() -> None:
    """Additional cases, separate from the original 34,076 rounding count."""
    transition_count = 0
    # Exercise original and replacing values at both signs and cancellation.
    for window in (1, 2, 3, 20, 50):
        for bound in (0, 1, MAX_I64 // window):
            assert admitted_sma_model(window, bound)
            sequences = (
                [bound] * (window + 2),
                [-bound] * (window + 2),
                [bound if i % 2 else -bound for i in range(window + 2)],
                [-bound] * window + [bound, -bound],
                [bound] * window + [-bound, bound],
            )
            for sequence in sequences:
                ring = []
                total = 0
                for raw in sequence:
                    assert bounded_input_model(raw, bound)
                    if len(ring) == window:
                        evicted = ring.pop(0)
                        total = checked_subtract_model(total, evicted)
                        assert total == sum(ring)
                    total = checked_add_model(total, raw)
                    ring.append(raw)
                    assert total == sum(ring)
                    assert -len(ring) * bound <= total <= len(ring) * bound
                    transition_count += 1
    # With a valid full window, add-first overflows even though replacement fits.
    window = 3
    bound = MAX_I64 // window
    for sign in (-1, 1):
        total = sign * window * bound
        incoming = evicted = sign * bound
        assert_overflows(checked_add_model, total, incoming)
        remaining = checked_subtract_model(total, evicted)
        replacement = checked_add_model(remaining, incoming)
        assert replacement == total
    assert not admitted_sma_model(20, MAX_I64 // 20 + 1)
    assert not admitted_sma_model(0, 0)
    assert not admitted_sma_model(MAX_I64 + 1, 0)
    assert not admitted_sma_model(1, -1)
    assert admitted_sma_model(1, MAX_I64)
    assert not bounded_input_model(MIN_I64, MAX_I64)
    assert bounded_input_model(-MAX_I64, MAX_I64)
    assert_overflows(checked_add_model, MAX_I64, 1)
    assert_overflows(checked_add_model, MIN_I64, -1)
    assert_overflows(checked_subtract_model, MIN_I64, 1)
    assert_overflows(checked_subtract_model, MAX_I64, -1)
    assert checked_subtract_model(MIN_I64, MIN_I64) == 0
    print("additional checked transition steps passed:", transition_count)
    print("additional add-first transient overflow and admission boundary checks passed")


if __name__ == "__main__":
    rounding_checks()
    fixture_and_counterexample_checks()
    transition_and_admission_checks()
