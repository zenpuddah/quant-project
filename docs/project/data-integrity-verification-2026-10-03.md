# Data-integrity implementation verification — 2026-10-03

Base `95993a8`, local branch `implementation/data-integrity-2026-10-03`. The original storage foundation is extended by the later accepted recap, not reset to the audit baseline. Specification and plan preceded code. Implementation is local; publishing/merging requires the owner's instruction.

## Results

| Verification | Result |
|---|---|
| Eight original + two new dependency-free tests, C++20 strict warnings | 10/10 pass |
| Same standalone tests with ASan/UBSan | 10/10 pass |
| Isolated deterministic Databento CTest | 1/1 pass |
| Instrumented C++ Databento build / deterministic CTest | 1/1 pass |
| Isolated storage CTest with temporary PyArrow 21 CONFIG shim | 4/4 pass |
| Same storage CTest with ASan/UBSan | 4/4 pass |
| Retained/synthetic capture -> canonical -> immutable consumer -> scoped replay demonstration | Pass; v1 remains price 100 after current selects v2 price 101 |
| Independent Python package/file/parent digests, schema, metadata and row inspection | Pass |
| Native Arrow CONFIG discovery | Blocked: no native Arrow package installed; not claimed verified |
| Whitespace/diff checks | Pass |

No credentialed/paid provider request was made. SDK source/dependency build downloads used the existing pinned integration policy, not market data.

## Exact local commands

Run from the repository root. The preapproved temporary root used in this environment was:

```sh
TMP="/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode"
```

### Standalone strict / sanitizer runs

```sh
BUILD="$(mktemp -d "$TMP/final-standalone.XXXXXX")"
for name in data_model_tests data_quality_tests ingestion_query_tests ingestion_ports_tests ingestion_result_tests ingestion_provider_tests ingestion_query_plan_tests synchronous_ingestor_tests data_integrity_tests ingestion_retention_tests; do
  clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src "tests/$name.cpp" -o "$BUILD/$name" && "$BUILD/$name" || exit 1
done
BUILD="$(mktemp -d "$TMP/final-standalone-sanitized.XXXXXX")"
for name in data_model_tests data_quality_tests ingestion_query_tests ingestion_ports_tests ingestion_result_tests ingestion_provider_tests ingestion_query_plan_tests synchronous_ingestor_tests data_integrity_tests ingestion_retention_tests; do
  clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -fsanitize=address,undefined -fno-omit-frame-pointer -I src "tests/$name.cpp" -o "$BUILD/$name" && ASAN_OPTIONS=detect_leaks=0 "$BUILD/$name" || exit 1
done
```

Every executable printed `<name>: passed`; no sanitizer diagnostics.

### Databento integration

```sh
cmake -S integration/databento -B "$TMP/integrity-databento-build"
cmake --build "$TMP/integrity-databento-build" -j 4
ctest --test-dir "$TMP/integrity-databento-build" --output-on-failure
cmake -S integration/databento -B "$TMP/integrity-databento-sanitized" -DDATABENTO_SOURCE_DIR="$TMP/integrity-databento-build/_deps/databento-src" -DCMAKE_CXX_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"
cmake --build "$TMP/integrity-databento-sanitized" -j 4
ASAN_OPTIONS=detect_leaks=0 ctest --test-dir "$TMP/integrity-databento-sanitized" --output-on-failure
```

Both CTest runs pass. Dependency CMake emits a date-library compatibility warning and the Apple linker notes duplicate `-lSystem`; neither is a project compiler/test failure. Prebuilt libdbn and system dependencies are not instrumented; the C++ SDK and project test translation units are instrumented in the sanitizer build.

### Arrow/Parquet integration

Native attempt:

```sh
cmake -S integration/storage -B "$TMP/integrity-storage-native"
```

It stops at `find_package(Arrow CONFIG)` because `ArrowConfig.cmake`/equivalents are absent. No environment-wide package installation/build redesign was performed.

The temporary `quant-guide-packages` shim declared only imported `Arrow::arrow_shared` and `Parquet::parquet_shared` targets pointing to the installed PyArrow 21 include directory and `libarrow.2100.dylib` / `libparquet.2100.dylib`. It is outside the repository, not a production package or committed fallback.

```sh
cmake -S integration/storage -B "$TMP/integrity-storage-build" -DCMAKE_PREFIX_PATH="$TMP/quant-guide-packages"
cmake --build "$TMP/integrity-storage-build" -j 4
ctest --test-dir "$TMP/integrity-storage-build" --output-on-failure
cmake -S integration/storage -B "$TMP/integrity-storage-sanitized" -DCMAKE_PREFIX_PATH="$TMP/quant-guide-packages" -DCMAKE_CXX_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"
cmake --build "$TMP/integrity-storage-sanitized" -j 4
ASAN_OPTIONS=detect_leaks=0 ctest --test-dir "$TMP/integrity-storage-sanitized" --output-on-failure
```

All four tests pass: publication integration, Arrow-only replay boundary, bound Arrow/evidence primitives, and the end-to-end demo. PyArrow binaries are not instrumented; project translation units are. The user testing guide provides standalone direct-link commands that need no temporary shim.

### Manual demonstration / independent inspection

```sh
PA="$(python3 -c 'import pyarrow; print(pyarrow.__path__[0])')"
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src -isystem "$PA/include" integration/storage/manual_round_trip.cpp "$PA/libparquet.2100.dylib" "$PA/libarrow.2100.dylib" -Wl,-rpath,"$PA" -o "$TMP/integrity_demo"
"$TMP/integrity_demo" "$TMP/completed-integrity-demo"
python3 integration/storage/inspect_parquet.py "$TMP/completed-integrity-demo/versions/demo-v1"
```

The explicit demo root was fresh when used; rerun with a new root or omit its argument. Output is recorded in `storage-testing-guide.md`. Inspection finds MBO ordinals `0,1,4`, Trade `2`, OrderExecution `3`; COMPLETE/manifest/file/parent hashes match. Inspection is not a substitute for the C++ eligibility gate.

## Guarantee / regression coverage

The original storage/replay brief is covered: Arrow in-memory interchange, Parquet analytical persistence for MBO/Trades/OrderExecution, storage-independent batch/sequential access, minimum fragment identity, rich canonical fields plus replay projection, technical architecture/context/agent guidance, preserved record layout and isolated targets. Reference evidence is structured and retained; no SQLite, graph storage, live execution, concurrency, custom binary replay backend or strategy code was introduced. The raw capture journal is provider evidence, not a replay store. Later accepted integrity contracts extend this original foundation.

- **Identity/reference:** original tuple checks before conversion, row IDs and immutable compact bindings, missing/changed reference rejection, same-instrument distinct-venue bindings, portable complete version snapshots.
- **Canonical validity/range:** positive Trade/execution quantities, MBO shape/control, half-open/dual-time selection, overfetch preserved before filtering, requested timestamp absence unresolved rather than silently excluded, mislabeled ranges rejected.
- **Evidence/dependencies:** original bytes survive decode/financial failures and interrupted capture; good candidate rows/reports stay staged; explicit revalidation; scoped SequenceGap and raw gap flags cannot bypass Degraded/weak caller replay requirements; snapshots/empty initialization and explicit partial consumption are checked.
- **Order/association:** equal/nonmonotonic event times, qualified receive checking, repeated T/F/C and C/A/F/C groups, separate snapshot rules, cross-chunk checker state, filtered ordinal gaps, duplicate/reordered/misassociated ordinals, separate acquisition scopes, full original raw witnesses. Sorted numbers or internally consistent digests alone do not establish association.
- **Publication:** existing version rejection, new acquisition/corrected version coexistence, current-selection interruption preserves old selection, failure injection at six publication points, explicit attempt resume, complete inventory/parents/transform/schema validation before any callback.
- **Compatibility/access:** new supported v2 meaning/columns, unknown labels and legacy unchecked publication rejected; Arrow-only consumer headers; Full archive versus Replay projection; cross-kind replay within one acquisition only.
- **Provider conditions:** inclusive date requests and day-local clipping, intraday/midnight/multiple-day/extra-response dates, canonical timestamp bounds.

## Remaining limitations / deferred scope

1. Native Arrow/Parquet CONFIG packages remain unavailable locally. Library/shim verification is not native package verification.
2. First production provider interpretation is normalized little-endian XNAS MBO; source-specific checks rely on documented flags and provider-returned succession. Session resets with insufficient evidence remain unresolved; no independent exchange completeness/authenticity proof.
3. Book replay requires a complete selected snapshot or explicitly accepted empty-book evidence. Automatic checkpoint fetching/rebuild, row repair and recovery scheduling are not implemented.
4. Local synchronous single-writer POSIX semantics only. Fsync precedes completion; process/fault simulations do not certify every filesystem/power-loss behavior or network/object storage.
5. Source capture fsyncs each record; first request and read verification remain bounded in-memory (512 MiB per-file read limit), conservative for affected ranges and not throughput-optimized. Production multi-batch scheduling is deferred; checker/counter succession is reusable within a named acquisition.
6. Generic cross-acquisition ordering/merge, deduplication, general revision/catalog/cache/XML infrastructure, binary replay backend, live trading, strategies/accounting and Python bindings remain deferred.
7. Immutable corrected versions do not establish what data was available to a historical strategy. That decision clock/research model is still a separate design.
