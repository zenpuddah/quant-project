# Storage / Arrow / Parquet testing guide

The original storage foundation is implemented. The accepted 2026-10-03 integrity slice adds v2 row bindings, retained evidence, immutable complete publication and eligibility. Baseline `canonical-v1` files are deliberately unsupported by eligible C++ readers; inspect them externally or regenerate. No market-data credentials/downloads are needed for these tests.

Run commands from the repository root in one bash/zsh terminal. CLion can open `integration/storage/CMakeLists.txt` as the isolated project. MboRecord remains 64 bytes / 64-byte aligned.

## 1. Build and run

### Native CMake packages

Requires CMake 3.25+, C++20 and Arrow/Parquet C++ packages. On macOS, provision missing packages yourself if needed:

```sh
brew install cmake apache-arrow
BUILD="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-build.XXXXXX")"
cmake -S integration/storage -B "$BUILD" -DCMAKE_PREFIX_PATH="$(brew --prefix apache-arrow)"
cmake --build "$BUILD"
ctest --test-dir "$BUILD" --output-on-failure
```

Native Arrow CONFIG package verification is still pending locally. Missing `ArrowConfig.cmake` is dependency setup failure, not a failed round trip. A temporary PyArrow package shim exercises CMake wiring but does not establish native package support.

### Existing macOS PyArrow 21 fallback (verified)

```sh
python3 -c 'import pyarrow; print(pyarrow.__version__)'
BUILD="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-build.XXXXXX")"
PA="$(python3 -c 'import pyarrow; print(pyarrow.__path__[0])')"
COMMON=(-std=c++20 -Wall -Wextra -Wpedantic -Werror -I src -isystem "$PA/include")
LIBS=("$PA/libparquet.2100.dylib" "$PA/libarrow.2100.dylib" "-Wl,-rpath,$PA")
clang++ "${COMMON[@]}" integration/storage/storage_tests.cpp "${LIBS[@]}" -o "$BUILD/quant_storage_tests"
clang++ "${COMMON[@]}" integration/storage/arrow_integrity_tests.cpp "$PA/libarrow.2100.dylib" "-Wl,-rpath,$PA" -o "$BUILD/quant_arrow_integrity_tests"
clang++ "${COMMON[@]}" integration/storage/replay_boundary_tests.cpp "$PA/libarrow.2100.dylib" "-Wl,-rpath,$PA" -o "$BUILD/quant_storage_replay_boundary_tests"
clang++ "${COMMON[@]}" integration/storage/manual_round_trip.cpp "${LIBS[@]}" -o "$BUILD/quant_storage_manual_round_trip"
"$BUILD/quant_arrow_integrity_tests"
"$BUILD/quant_storage_replay_boundary_tests"
"$BUILD/quant_storage_tests"
```

These `.2100.dylib` filenames require PyArrow 21. Stop on compiler/linker errors before running binaries. Successful strict compilation is normally silent; programs print `...: passed` and return zero.

### Dependency-free model/ingestion regressions

```sh
for name in data_model_tests data_quality_tests ingestion_query_tests ingestion_ports_tests ingestion_result_tests ingestion_provider_tests ingestion_query_plan_tests synchronous_ingestor_tests data_integrity_tests ingestion_retention_tests; do
  clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src "tests/$name.cpp" -o "$BUILD/$name" && "$BUILD/$name" || break
done
```

### Deterministic SDK tests (no API requests)

```sh
cmake -S integration/databento -B "$BUILD/databento"
cmake --build "$BUILD/databento" -j 4
ctest --test-dir "$BUILD/databento" --output-on-failure
```

This uses the already accepted pinned SDK and its dependencies. The smoke binary is built but is not run. Do not run the credentialed smoke for routine verification.

## 2. Automated unit and boundary checks

| Check | Input → invariant | Failure means |
|---|---|---|
| `data_model_tests` | Strong values, typed events, point-in-time references → exact arithmetic, scope, presence and 64-byte layout remain valid | Canonical baseline regressed |
| `data_integrity_tests` | Catalog/snapshot, synthetic DBN records and consumer requirements → immutable IDs, range/shape failures, raw retention, snapshot/group/order/initial-state gating | Domain integrity or dependency rules are wrong |
| `ingestion_retention_tests` | Fake provider plus capture observer → every raw record/ordinal retained before selection; failures preserve evidence | Ingestion drops evidence or invents coverage |
| `quant_arrow_integrity_tests` | Bound rows and altered scope/control/ordinals → original identity and association checked, positive quantities enforced; evidence codec and SHA-256 vectors agree | Conversion loses identity/meaning, or package primitives are incorrect |
| `quant_storage_replay_boundary_tests` | Fake MarketDataReader → compiles/links with Arrow only | Consumer headers depend on Parquet or the interface broke |
| SDK translation tests | Official MboMsg bytes, UTC dates/conditions → byte decoder agrees with SDK; intraday/midnight/mixed-day/extra-day conditions clip correctly | Provider interpretation or date boundaries regressed |

The replay-boundary fake returns NotImplemented; it is a compile/link check, not a runtime replay demonstration.

## 3. Automated integration tests

`quant_storage_tests` creates independent temporary fixtures and verifies:

| Scenario | Input → expected output/invariant | Failure means |
|---|---|---|
| Round trip and partitions | Snapshot Clear, Add, Trade/Fill/Cancel → exact headers/values and shared ordinals `0..4`; one stream per file | Fields, scope or original event association changed |
| Projection | Full includes `raw_evidence`; Replay retains canonical fields/StreamId/ordinal but excludes it | Archive access or replay selection is wrong |
| Immutable correction | v1 price 100, new acquisition/v2 price 101 → old handle still returns 100; current changes only after completion | Historical experiment inputs were overwritten |
| Interrupted publication | Fail after raw/ref/canonical/consumer/evidence writes or before COMPLETE → no eligible version; explicit new attempt can resume | Partial packages become visible or retry identity is wrong |
| Invalid candidates | Zero Trade/invalid primitive, wrong scope/range/association, missing refs → failed candidate stays staged with bytes, reports and good canonical rows | Invalid or mislabeled data can publish; diagnostic evidence is lost |
| Consumer gates | Degraded/gap analytics, missing state/groups, explicit partial range → replay cannot weaken mandatory checks; partial access is explicit | DataState acceptance bypasses dependency checks or claims full coverage |
| Reader evidence | Moved package, removed/changed references, unsupported labels → complete references travel; missing/changed evidence fails before callbacks | Immutable identity/version meaning is detached from rows |
| Nontrivial association | Sorted unique ordinals but wrong original event; internally consistent hashes but wrong raw witness → rejection before delivery | Implementation checks only numbers/labels/hashes rather than original associations |

Order preserves returned succession. It does not ts_event-sort, require consecutive provider sequences, or manufacture a total order across acquisitions. Book initialization needs a complete selected snapshot or explicit accepted empty-book evidence.

## 4. Manual end-to-end demonstration

```sh
RUN_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/quant-storage-manual.XXXXXX")"
"$BUILD/quant_storage_manual_round_trip" "$RUN_ROOT"
```

Keep the directory for inspection. The path printed may resolve macOS `/var` to `/private/var`. With no argument, the executable creates a fresh temporary root itself (also used by CTest).

Flow: synthetic normalized provider bytes → planner/provider capture sink → durable raw journal → reload without provider call → validated canonical preparation → complete raw/reference/canonical/consumer package → Arrow read / scoped cross-kind replay. A zero-quantity candidate stays staged; a corrected acquisition publishes v2 and leaves v1 unchanged.

Expected output (`<ROOT>` is your resolved output directory):

```text
canonical_record_bytes=64
captured acquisition=demo-good-0 raw_rows=5
reprocess_without_provider=true requests=1
version1=<ROOT>/versions/demo-v1
encoding=quant-observations-v2 stream=1 tuple=42/7/9 range=[100,200) partitions=3
replay[0] ordinal=0 stream=1 Clear t=100 seq=0
replay[1] ordinal=1 stream=1 Add price_raw=100000000000 t=101 seq=7
replay[2] ordinal=2 stream=1 Trade price_raw=100000000000 quantity_raw=1000000 t=103 seq=8
replay[3] ordinal=3 stream=1 OrderExecution order=100 quantity_raw=1000000 t=103 seq=8
replay[4] ordinal=4 stream=1 Cancel t=103 seq=8
full_has_raw_evidence=true replay_excludes_raw_evidence=true
failed_candidate=staged failed_ordinal=2 rule=zero_trade_quantity
failed_stage=<ROOT>/staging/demo-operation/attempt-1/demo-failed-0
version2=<ROOT>/versions/demo-v2
current=demo-v2 old_version_add_price_raw=100000000000
manual_round_trip: passed
```

This is synthetic nanosecond data, not a live download, strategy, or book reducer. Reusing the same explicit root/IDs is rejected rather than overwriting previous evidence.

## 5. Inspect independently with Python

```sh
python3 integration/storage/inspect_parquet.py "$RUN_ROOT/versions/demo-v1"
python3 integration/storage/inspect_parquet.py "$RUN_ROOT/versions/demo-v1" --evidence
python3 integration/storage/inspect_parquet.py "$RUN_ROOT/versions/demo-v1/.attempt-attempt-1/raw.parquet"
python3 integration/storage/inspect_parquet.py "$RUN_ROOT/staging/demo-operation/attempt-1/demo-failed-0/canonical/mbo.parquet"
```

The inspector verifies package file/parent hashes and shows schemas, footer metadata and rows. It does not substitute for C++ financial/eligibility validation. In v1, MBO has 3 rows with ordinals `0,1,4`; Trade has ordinal `2`; OrderExecution has `3`. Gaps within a kind are intentional. Full MBO consumer data has 12 columns: the original 9, StreamId, ordinal and opaque archived raw evidence.

Check `quant.encoding`, `quant.version_id`, `quant.acquisition_id`, `quant.stream_id`, `quant.stage`, `quant.parent_sha256` and transformation version. Physical zeros still differ from absence through MBO control. Price scale is 9 and quantity scale 6. Raw bytes print as hex, retaining every normalized DBN field, including native fields absent from canonical records. Raw evidence is not a claim to possess original Nasdaq packets.

Required evidence lives under the version's named attempt: `manifest.qmanifest`, `acquisition.qacq`, `references.qref`, `validation.qvalidation`, `raw.parquet`, `canonical/` and `consumer/`. COMPLETE binds the manifest digest. Failed staging has no eligible COMPLETE marker.

## 6. Main reading entry points

1. `integration/storage/manual_round_trip.cpp` — runnable flow.
2. `src/quant/data/observations.hpp` — unchanged record layout and presence masks.
3. `src/quant/integrity/{model,prepare}.hpp` — catalog/reference/acquisition/failure types, checks and eligibility.
4. `src/quant/ingestion/{databento_integrity,databento_provider,synchronous_ingestor}.hpp` — byte interpretation, capture and planning.
5. `src/quant/storage/{dataset,arrow_interchange,backend}.hpp` — bound encoding and storage-independent consumers.
6. `src/quant/storage/{retained_capture,evidence_codec,file_integrity,parquet_backend}.hpp` — durability, evidence, complete publication and gates; footer codecs are in `parquet_metadata.hpp`.
7. `integration/storage/{arrow_integrity_tests,storage_tests}.cpp` and the new standalone integrity/retention tests — actual assertions.

Limits: synchronous/local POSIX storage, 512 MiB first-slice per-file read bound, in-memory verification before callback delivery, conservative blocking of an affected prepared range. Native Arrow package discovery and independent exchange completeness are not established by PyArrow/synthetic tests. Automated checkpoint acquisition, repair, cross-acquisition merge, deduplication and general revision/catalog/cache infrastructure remain deferred.
