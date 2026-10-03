# Storage / Arrow / Parquet Testing Guide

**Baseline guide:** These commands and expected outputs describe the implementation reviewed at `590fd34`. The accepted closure contracts in `docs/architecture/phase1-data-integrity-session-2026-10-03.md` are not yet enforced by these checks. The current implementation handoff requires new negative/failure tests and updates to this guide when the encoding and publication paths change.

Run commands from the repository root, in the same terminal. No provider credentials or market-data downloads are needed. Fixtures are synthetic.

## 1. Build

### Standard CMake path

Requires a C++20 compiler, CMake 3.25+, and Arrow/Parquet C++ packages. On macOS with Homebrew, provision them if needed:

```sh
brew install cmake apache-arrow
BUILD="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-build.XXXXXX")"
cmake -S integration/storage -B "$BUILD" -DCMAKE_PREFIX_PATH="$(brew --prefix apache-arrow)"
cmake --build "$BUILD"
ctest --test-dir "$BUILD" --output-on-failure
```

In CLion, open `integration/storage/CMakeLists.txt` as the isolated project and use the same Arrow prefix in the CMake profile.

**Current local limitation:** Native Arrow CMake packages were absent during verification. A previous temporary package shim passed CTest, but it is not a repository dependency or a prerequisite for these commands.

### Existing local PyArrow 21 fallback (macOS)

This directly exercises the installed C++ headers/libraries; it does **not** verify native CMake package discovery. First check `python3 -c 'import pyarrow; print(pyarrow.__version__)'`; these library filenames are for version 21.

```sh
BUILD="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-build.XXXXXX")"
PA="$(python3 -c 'import pyarrow; print(pyarrow.__path__[0])')"
COMMON=(-std=c++20 -Wall -Wextra -Wpedantic -Werror -I src -isystem "$PA/include")
LIBS=("$PA/libparquet.2100.dylib" "$PA/libarrow.2100.dylib" "-Wl,-rpath,$PA")
clang++ "${COMMON[@]}" integration/storage/storage_tests.cpp "${LIBS[@]}" -o "$BUILD/quant_storage_tests"
clang++ "${COMMON[@]}" integration/storage/replay_boundary_tests.cpp "$PA/libarrow.2100.dylib" "-Wl,-rpath,$PA" -o "$BUILD/quant_storage_replay_boundary_tests"
clang++ "${COMMON[@]}" integration/storage/manual_round_trip.cpp "${LIBS[@]}" -o "$BUILD/quant_storage_manual_round_trip"
```

If configuration says `ArrowConfig.cmake` is missing, the C++ package is missing or its prefix is not supplied; that is a dependency setup failure, not a failed round trip. Stop on compiler/linker errors before running binaries.

## 2. Automated Unit / Boundary Checks

The framework-free executables report `...: passed` and return zero on success.

```sh
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src tests/data_model_tests.cpp -o "$BUILD/data_model_tests"
"$BUILD/data_model_tests"
"$BUILD/quant_storage_replay_boundary_tests"
```

| Check | Input → expected invariant | Failure means |
|---|---|---|
| `data_model_tests` | Canonical values and typed MBO events → valid identity/decimal/action semantics, optional fields, stream scope, 64-byte aligned records | The underlying canonical model/layout contract regressed |
| `test_metadata_and_schema_validation` (unit-style checks **inside** `quant_storage_tests`) | Negative ID, whitespace-padded integer, empty provenance range, unknown kind, wrong price column type → rejection | Invalid metadata/schema can cross the storage boundary |
| `quant_storage_replay_boundary_tests` | A `FakeReader` implementing `MarketDataReader` → compiles and links with **Arrow only** | Replay-facing headers acquired a Parquet dependency or the interface no longer compiles |

The boundary executable does not emit replay events; its fake returns `NotImplemented`. Runtime replay is tested below. There is no separate storage-only unit executable.

## 3. Automated Integration Tests

```sh
"$BUILD/quant_storage_tests"
```

Expected: `storage_tests: passed`. This runs all named checks, including the unit-style checks above, and deletes its temporary artifacts on success. Run it serially: it uses a fixed temporary fixture directory.

| Test / behavior | Input → expected output or invariant | Failure means |
|---|---|---|
| `test_mbo_round_trip_and_replay`: physical round trip | Add/Modify/Clear in stream `42/7/9`, range `[100,105)` → all 9 physical fields and complete dataset metadata unchanged | Serialization, decoding, metadata, or stream context was lost/changed |
| Same test: presence bits | Modify has sequence/channel **present as zero**; Clear has absent receive time → zero remains present and absence remains absent | Zero and missing were conflated; inspect `control` |
| Same test: projections | Batch includes extra `archive_only` column → Full retains it; Replay excludes it | Column projection is wrong or archive evidence is discarded |
| Same test: sequential replay | Persisted Add at 100, Modify at 102, Clear at 104 → 3 events in that order | Events were dropped, reordered, or decoded incorrectly |
| `test_trade_and_execution_round_trip` | Trade at 200 and OrderExecution at 300 → price/quantity, trade receive time, execution order ID/quantity and absent execution price survive | Non-MBO codecs or optional-value persistence regressed |
| Same test: invalid side | Trade Arrow column contains side code `2` → decoder rejects it | Malformed side data is silently converted to Buy/Sell |

Replay preserves persisted row order; it does not establish provider-valid order or sort history. These are small single-batch fixtures, not a throughput or multi-stream ordering validation.

The decision review in `docs/project/design-decision-review-2026-10-01.md` reproduced additional gaps: overwrites, row/metadata mismatches, incomplete canonical row validation, and unsupported-version labeling. The checks here demonstrate serialization of correctly paired fixtures; they do not establish those missing contracts.

## 4. Manual End-to-End Verification

```sh
RUN_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-manual.XXXXXX")"
"$BUILD/quant_storage_manual_round_trip" "$RUN_ROOT"
```

Read `integration/storage/manual_round_trip.cpp` while running it. The stages are:

1. Construct 3 canonical MBO events (Add, Modify, Clear).
2. `to_arrow` produces 3 rows / 9 physical columns.
3. `ParquetStorageBackend::write` writes a file and returns a `DataFragment`.
4. `MarketDataReader::read_metadata` and `read_batches(Full)` recover metadata and Arrow rows; compare every physical field.
5. `stream_events` reads the replay projection; compare every canonical event/header with its input and print it.

Expected output (replace `<RUN_ROOT>` with your temporary directory):

```text
canonical rows=3 record_bytes=64
arrow rows=3 columns=9
parquet=<RUN_ROOT>/data/mbo/instrument_42_venue_7_source_9_100_105_canonical-v1.parquet
metadata matches=true stream=42/7/9 range=[100,105) schema=canonical-v1
arrow_read rows=3 physical_fields_equal=true
replay[0] Add t=100 recv=101 seq=7 channel=2 order=100 side=Buy price_raw=100000000000 quantity_raw=2000000 flags=11
replay[1] Modify t=102 recv=103 seq=0 channel=0 order=100 side=Sell price_raw=null quantity_raw=null flags=12
replay[2] Clear t=104 recv=null seq=null channel=null order=null side=null price_raw=null quantity_raw=null flags=13
replay rows=3 canonical_events_equal=true
manual_round_trip: passed
```

The file is retained. A nonzero exit and `manual_round_trip: failed: ...` identifies the failed stage. Tiny timestamps are synthetic epoch nanoseconds. This verifies storage/replay, not order-book reconstruction, trading fills, or data completeness.

## 5. Inspect the File Yourself

Requires Python with `pyarrow` (already present in the local fallback environment):

```sh
FILE="$RUN_ROOT/data/mbo/instrument_42_venue_7_source_9_100_105_canonical-v1.parquet"
python3 integration/storage/inspect_parquet.py "$FILE"
```

The independent Python reader prints `rows=3 row_groups=1`, the 9-column Arrow schema, sorted `quant.*` footer metadata, and each physical row. Check:

- `quant.data_kind=mbo`, `quant.instrument_id=42`, `quant.venue_id=7`, `quant.source_id=9`.
- `quant.time_range.start_ns=100`, `quant.time_range.end_ns=105`, `quant.schema_version=canonical-v1`.
- Historical acquisition, `manual-v1` adapter/mapping versions, and source artifact `synthetic:mbo-three-events` covering `[100,105)`.
- Quality-reference count is zero: this synthetic example makes no completeness claim. Checksum is omitted; the backend stores supplied checksum metadata, not a computed integrity check.
- Raw fields below (price scale **9**, quantity scale **6**):

| Row | event_time | sequence | order_id | price | quantity | control |
|---|---:|---:|---:|---:|---:|---:|
| Add | 100 | 7 | 100 | 100000000000 | 2000000 | 1016 |
| Modify | 102 | 0 | 100 | 0 | 0 | 1273 |
| Clear | 104 | 0 | 0 | 0 | 0 | 4 |

MBO physical columns are non-nullable. Optional values are encoded by `control`, so physical zero is not automatically a real value. Compare the Modify/Clear rows with the logical replay above. Instrument/venue/source identity is restored from metadata, not repeated in row columns.

## 6. Reading Order / Entry Points

1. `integration/storage/manual_round_trip.cpp` — the complete runnable flow.
2. `src/quant/data/observations.hpp` — `MboBuffer`, `MboRecord`, `MboRecordView`, and `mbo_detail` presence masks.
3. `src/quant/storage/dataset.hpp` — `DataFragment`, `StreamIdentity`, `DatasetLocalMetadata`.
4. `src/quant/storage/arrow_interchange.hpp` — `schema_for`, `to_arrow`, `from_arrow`, `events_from_arrow`, `CanonicalEvent`.
5. `src/quant/storage/backend.hpp` — `MarketDataReader` and `StorageBackend` contracts.
6. `src/quant/storage/parquet_backend.hpp` — `ParquetStorageBackend`, metadata codecs, `consume_batches`, `write`, `read_batches`, `stream_events`.
7. `integration/storage/storage_tests.cpp` — the actual assertions described above.

Owner validation is complete when you can explain why row count/field equality matters, why zero differs from absence, why stream identity lives in metadata, and why replay order is a storage guarantee rather than a timestamp sort.
