# Lexongine implementation progress

Initial handoff: 2026-10-14. This is an evidence record, not a substitute for the specifications.

## Baseline

Advisor inspected remote implementation/data-integrity-2026-10-03 at f75cd3c179f3b070f9a85c054ec3704b89f4cb69. No local project checkout or Lexongine product build/test was verified. Actual implementation branch/HEAD/dirty status, local context reconciliation, compiler/libc++/SDK and dependency versions: **not yet recorded by implementer**.

## Tasks

| Task | Status | Actual evidence |
| --- | --- | --- |
| 1 Owned contracts/registry | InProgress | Owned records/schema/typed factories tested; actual-API prototype passes with cached Arrow static libraries; full source/host declarations/review remain open |
| 2 Typed binding/immutable ownership | InProgress | Accounted ownership, host destruction and atomic slot primitives tested; complete card not yet verified |
| 3 Native plugins | Verified | Bounded native arm64/macOS same-build loader and typed round-trip; 4/4 native cases normal and ASan/UBSan under accepted Apple platform boundary |
| 4 Strict XML | InProgress | Pinned TinyXML2 11.0.0 frontend/owned schema resolution pass; CLI overrides/projection and source-admission integration pending |
| 5 Graph/sharing | InProgress | Product canonical-identity/graph/walk checks pass; prepared-run and observation integration pending |
| 6 Preparation/source bridge | InProgress | Coverage/history helpers pass; native Arrow/Parquet 26 packages and existing reader/storage tests verified; full adapter/admission wiring pending |
| 7 Fixture/SMA/lag | InProgress | Canonical numerical helpers and generated bars verified; registered component/scheduler integration pending |
| 8 Standalone/hosted executor | Pending | Host probe is proposed, not financial backtester |
| 9 Cross-run result store | Pending | Filesystem/uncertainty tests unverified |
| 10 CLI/evidence | Pending | Required sink/codec tests unverified |
| 11 Integrated verification | Pending | No product tests rerun by advisor |
| 12 Verified handoff | Pending | Documentation preparation is complete only as recorded by its audit |

## Checkpoint format

Append date/task, full HEAD, branch/dirty state, change/reason, exact commands and exit/matched test counts, important results, environment and limitations, next step. Use Pending/InProgress/Blocked/ImplementedUnverified/Verified. Do not use Verified for a missing prerequisite or empty test match. Record Linux/core results separately from native macOS plugin and actual reader/storage verification. Never copy the research oracle's counts as product evidence.

## Documentation publication — 2026-10-15

Owner authorized publishing the consolidated handoff to `implementation/lexongine-v1` from f75. The 32-file documentation/example/research-reference change preserves product source code. Publication verification compares the resulting Git tree/blob identities with the prepared files. All twelve product tasks remain Pending; document checks and earlier research probes are not product tests.
## 2026-10-15 — Initial baseline checkpoint (historical missing-handoff state)

**Status:** Baseline recorded before production code or interface declarations.
Task 1 is blocked because the accepted Lexongine documentation and its supplied
patch are unavailable in this checkout. This is an execution record, not a
replacement specification or a new design decision.

### Original checkout evidence

| Item | Observed value |
|---|---|
| Checkout | `/Users/macklex/Desktop/quant project` |
| Branch | `implementation/data-integrity-2026-10-03` |
| Full HEAD | `f75cd3c179f3b070f9a85c054ec3704b89f4cb69` |
| Requested accepted baseline | `f75cd3c179f3b070f9a85c054ec3704b89f4cb69` |
| Dirty status | Clean: `git status --porcelain=v1 --untracked-files=all` returned no entries; unstaged/staged diff stats were empty |
| Upstream | `origin/implementation/data-integrity-2026-10-03`, same full commit |
| Ahead / behind upstream | `0 / 0` |
| Local `main` / `origin/main` | Both `95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5`; ahead/behind `0 / 0` |
| Local unpushed commits before this session's changes | None: `git log --all --not --remotes --oneline` returned no entries |
| Stashes / tags | `git stash list` empty; `git show-ref` contained only the recorded branch/remote refs |

`git ls-remote --heads origin` succeeded and returned exactly the integrity and
main branches at the full commits above. No newer owner branch baseline was
advertised. The original checkout's files, branch and HEAD are preserved.

### Isolated implementation checkout

- Branch: `implementation/lexongine-v1` (new local branch; no upstream).
- Worktree: `/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode/lexongine-v1`.
  Git reports the equivalent macOS path beginning `/private/var/`.
- Created with:

  ```sh
  git worktree add -b implementation/lexongine-v1 "/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode/lexongine-v1" f75cd3c179f3b070f9a85c054ec3704b89f4cb69
  ```

- Initial full HEAD: `f75cd3c179f3b070f9a85c054ec3704b89f4cb69`.
- Initial status: clean (`git status --short --branch` printed only the branch).
- Initial local-only commits: none. This session adds only a documentation
  checkpoint on this branch. No merge, push or publication was performed.

### Required reading and missing inputs

Read the available `AGENTS.md`, project context, engineering book, storage/replay
architecture and testing guide, historical decision review, accepted integrity
recap, integrity implementation specification, integrity handoff and verification
report, and research/backtesting/trading scope. Historical scope restrictions
remain dated; the owner's current request authorizes the accepted Lexongine
milestone once its specified contracts are available.

The baseline contains no `docs/lexongine/` directory and no
`docs/project/lexongine-context.md`. Consequently the following required inputs
could not be read:

- `docs/lexongine/README.md`;
- `docs/lexongine/spec/` (all six specifications);
- `docs/lexongine/decisions.md`;
- `docs/lexongine/implementation/plan.md` (the twelve task cards);
- the XML example and JSON reference cases;
- `docs/project/lexongine-context.md` (the current project handoff).

Workspace filename searches found no Lexongine files or `.patch`, `.diff`,
`.zip`, `.tar`, or `.gz` documentation delivery. The approved scratch directory
was also empty before worktree creation. No patch was supplied in the request.
`git apply --check` therefore has not been run; it requires the actual patch.
When supplied, check it first and reconcile this progress file and the appended
project-context entry before applying it.

### Task and verification status

| Work | Status / evidence |
|---|---|
| Baseline reconciliation and isolated worktree | Complete; observed Git evidence above |
| Documentation verification | `git diff --check` and `git diff --cached --check` passed; full staged diff reviewed |
| Task 1 and foundational declarations | **Blocked** on the missing accepted handoff/specifications/task card |
| Actual callback source/host interface prototype | **Blocked** on the missing source/host contracts; no prototype or integration claim |
| Tasks 2–12 | **Blocked**; task definitions/dependencies are unavailable |
| Focused failing/passing implementation checks | Not run; no implementation started |
| CMake, warnings-as-errors, sanitizer, TinyXML2, Arrow and native macOS plugin checks | **Unverified** in this session |
| Graph, fixture, cache, source, host and final acceptance evidence | Not produced |

Inspected `src/quant/storage/backend.hpp`: `MarketDataReader` exposes
`read_batches_checked` and `stream_ordered_events`; the latter accepts
`ConsumerRequirements` and a `SequencedEventConsumer` returning `arrow::Status`
for `integrity::BoundObservation`. This is source inspection only, not a reader
integration test. No replacement callback abstraction was introduced.

**Next input required:** the accepted documentation patch (attachment or local
path), or a commit/branch containing the complete Lexongine handoff. Resume with
patch reconciliation, required reading, and Task 1 plus the actual source/host
interface prototype. Settled baseline, cache, lag and Strict/Skip decisions are
not being reopened.

## 2026-10-15 — Owner documentation received and reconciled

The owner supplied `61ecf87892a9eebfce397cea522941864d92a6c7` on
`origin/implementation/lexongine-v1`. Fetch succeeded; its parent/common baseline
is `f75cd3c179f3b070f9a85c054ec3704b89f4cb69`. The 32-file change is documentation,
examples and supporting research. The earlier missing-handoff blocker is resolved.

Before reconciliation the isolated worktree was clean at local-only documentation
commit `4fdd20720382245efcd36f839c409c3b7f2657b5`; divergence was one local and one
remote commit. Rebased that local checkpoint onto the owner's commit. The sole
add/add conflict was this progress file: preserved the owner's task table and
publication record and the local historical evidence, with this explicit closure.
The shared context merged automatically, retaining both entries. No product code
exists yet. No patch application is needed because delivery was a Git commit.
Original integrity/main branches remain unchanged; no merge or push occurred.

### Pre-code checkout and environment

After reconciliation: branch `implementation/lexongine-v1`, full HEAD
`33f3060257266af33b0ec880ace1e356fcf8ecea`, clean worktree. One local-only
documentation commit above owner baseline `61ecf87892a9eebfce397cea522941864d92a6c7`;
no owner dirty work. All six operative specifications plus overview, decisions,
plan, XML example, JSON cases, start prompt and updated shared/project reasoning
have now been read. Prior integrity/storage readings remain applicable.

Environment commands succeeded: `cmake --version` = 4.4.3; `clang++ --version` =
Apple clang 21.0.0 (clang-2100.1.1.101), arm64-apple-darwin25.6.0;
`xcrun --show-sdk-version` = 26.5; `xcrun --show-sdk-path` =
`/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk`; `uname -m` = arm64.
`brew list --versions tinyxml2 apache-arrow cmake` reported only cmake 4.4.3.
Python import discovery reported PyArrow unavailable. TinyXML2 11.0.0 and actual
Arrow/Parquet builds need explicitly supplied prerequisites; no dependency was
downloaded/installed. Foundation CMake will explicitly select bridge OFF and
report that limitation rather than substitute a private reader imitation.

## 2026-10-15 — Foundation checkpoint (Tasks 1–2 in progress)

Starting HEAD `33f3060257266af33b0ec880ace1e356fcf8ecea`, branch
`implementation/lexongine-v1`. Changes are new `src/lexongine/`, isolated
`integration/lexongine/`, focused tests and these documentation updates. Existing
Qaedalus source/layout/reader files are unchanged. This checkpoint is not task or
milestone closure.

Implemented owned model records, exact required parameter parsing and canonical
origin-independent equality, initial central schema table, exact-version registry,
typed registration/preparation/instance adapters, fixed diagnostics, separate
source-gap/timing/host-outcome vocabulary, charged resource/holder metadata,
immutable payload controls and atomic validated bundles. Host-erased controls and
callback manager destruction live in a common compiled core library so a plugin
pin spans the complete typed destruction call. Numerical author callbacks remain
typed. Opaque owning kernel wrappers are complete before `Result<T>` use.

Failing checks, honestly distinguished:

- Initial `clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -I src -fsyntax-only tests/lexongine_contract_tests.cpp`
  failed at the missing model header (compile-red, no runtime cases executed).
- The analogous lifetime syntax check failed at missing `results.hpp`; the later
  lifetime build failed at missing `binding.hpp` (compile-red).
- A focused runtime check then reproduced duplicate scheduling: contract target
  failed **7/8 cases**, `typed factory ownership and fresh state: expected a
  diagnostic, received success`. Added the kernel's pre-callback resolved-key
  guard; the same unchanged assertion now passes.

Strict commands, from this isolated worktree (temporary root is
`/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode`):

```sh
TMP="/var/folders/14/mvcf30lj2bz5nmw28f8nr1ch0000gn/T/opencode"
cmake -S integration/lexongine -B "$TMP/lexongine-build" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF
cmake --build "$TMP/lexongine-build"
ctest --test-dir "$TMP/lexongine-build" --output-on-failure
cmake -S integration/lexongine -B "$TMP/lexongine-sanitized" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF -DLEXONGINE_SANITIZERS=ON
cmake --build "$TMP/lexongine-sanitized"
ctest --test-dir "$TMP/lexongine-sanitized" --output-on-failure
```

Both CTest configurations have passed **2/2 matched targets** (contracts and
lifetime). A final `ctest --test-dir "$TMP/lexongine-build" -V` and corresponding
sanitized `-V` run explicitly printed **8/8 contract cases and 6/6 lifetime cases**;
host/library/test code is instrumented in the sanitizer build. Native
plugin, full source adapter, scheduler, graph, XML, cache and final acceptance
remain unverified/unimplemented. The actual-API prototype is a distinctly named
`lexongine_source_host_contract_probe`, not a substitute for Task 6 or 8.

### Dependency provisioning approved during execution

The owner explicitly selected **Provision accepted dependencies**: official
TinyXML2 11.0.0 in the isolated scratch area and native Homebrew Arrow/Parquet.
Initial git clone and brew download timed out. Retrying git with HTTP/1.1
succeeded: clean TinyXML2 checkout at
`$TMP/tinyxml2-11.0.0`, full commit `9148bdf719e997d1f474be6bcc7943881046dba1`.

Homebrew selected Apache Arrow `25.0.1_8` and its declared dependencies. A retry
downloaded several bottles but reported HTTP/2 PROTOCOL_ERROR for aws-sdk-cpp;
the outstanding attempt was terminated before a bounded HTTP/1.1 retry. The
temporary `$TMP/lexongine-curlrc` selects HTTP/1.1, connect timeout 20 seconds,
low-speed threshold 1024 bytes/second for 45 seconds and per-transfer maximum
600 seconds. It is supplied through `HOMEBREW_CURLRC`; no user curl/Git config was
changed. Installation is not yet verified. Native package and reader checks stay
Blocked/Unverified until a real configure/build/test succeeds.

Remaining foundation work includes complete pre-admission metadata accounting,
typed binding/retention edge cases, explicit source/host owning declarations,
actual-reader prototype compilation, and the full card's negative/lifetime
matrix. The current passing subset is not evidence that these remaining contracts
are closed.

## 2026-10-15 — Provenance envelope and reservation hardening

Starting full HEAD `001c1de687f29f288ed19eac04b869a75bee2f03` on
`implementation/lexongine-v1`. The owner selected **Typed provenance envelope**
after the publication-interface gap was surfaced. The accepted addition is in
components.md and the decision ledger; no lag/count/Strict/Skip behavior was
reopened.

New runtime failures reproduced before fixes:

- Lifetime target failed **5/6 cases** on `scalar retention must copy the value`.
  Scalar retention now makes a separately charged value copy; immutable-owned
  payload sharing retains one allocation charge.
- Contract target failed **7/8 cases** when graph capacity was fully occupied but
  preparation still succeeded. Preparation now receives an explicit host account,
  reserves its admitted metadata ceiling before parsing/factory work and transfers
  the reservation into PreparedKernel lifetime. Canonicalizers cannot omit/change
  explicit parameters or return a noncanonical order. Typed binding checks the
  actual C++ witness before state construction.
- Provenance checks first failed compilation against the incomplete new envelope;
  this is compile-red, not a claimed executed regression. The completed checks
  exercise typed input binding and parent selection, original timing/identity,
  metadata-only retention, current activation availability, original nonconsecutive
  keys, missing/duplicate/reordered/foreign/over-history parent rejection.

Strict and sanitizer rebuilds plus `ctest --test-dir "$TMP/lexongine-build"
--output-on-failure` and the corresponding `lexongine-sanitized` command pass
**2/2 targets**. Their source case sets are now **8 contract + 7 lifetime cases**.
New provenance storage is reserved before allocation; runtime authority tokens
are not semantic identities and will not be persisted. Source/host end-to-end,
graph/reuse codecs and complete task-card closure remain pending.

Native prerequisite result: configuring `lexongine-native` with
`-DLEXONGINE_QAEDALUS_BRIDGE=ON -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/apache-arrow`
failed at `find_package(Arrow)` (no tests compiled or matched). The HTTP/1.1
Homebrew retry was stopped after another stalled transfer period; the log records
SIGTERM, not a successful install. Earlier retries explicitly reported an
aws-sdk-cpp HTTP/2 PROTOCOL_ERROR. No provisioning process is intentionally left
running. Native Arrow and the actual reader prototype stay **Blocked/Unverified**.
TinyXML2 remains available at the pinned official checkout. Continue independent
core work; do not turn these core checks into a source-integration claim.

## 2026-10-15 — Independent numerical slice (Task 7)

Starting HEAD `064ae639c63d410c92b75983252a2c5b7ac04798` on the same isolated
implementation branch. Implemented checked canonical-Price SMA/lag window helpers,
signed nearest-ties-even rounding, checked Price subtraction, exact Bar-close
extraction and the locally generated 120 canonical bars. Existing financial types
and validators were inspected/reused; no domain layout or storage API changed.
These mathematical helpers do not implement source-gap scheduling, graph sharing,
registered typed components or a financial model.

Initial syntax-only test failed on missing `quant/lexongine/sma.hpp` (compile-red).
The first named-target build preceded CMake regeneration and reported no rule for
the new target; after explicit configuration, `lexongine_sma_tests` passed **6/6
cases**. It checks exact/equal-input state, signed ties/extreme sums, N/B policy
validation, feasible-but-unallocatable windows, pre-allocation quota rejection,
subtract-before-add at the signed bound, independent subtraction overflow, lag
startup/repeated values, canonical fixture fields and reference values.

The separate test transport `lexongine_arithmetic_probe` calls these compiled
helpers. `verify_arithmetic.py` independently recomputes full windows using Python
integers and Fraction; it imports neither production arithmetic nor the research
oracle. Both normal and instrumented probe executions passed with seed 20261015:

```text
rounding=266, SMA_runs=50, SMA_updates=3851, lag_runs=8, lag_updates=672
```

Exact verification (same TMP/worktree as above):

```sh
cmake -S integration/lexongine -B "$TMP/lexongine-build" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF
cmake --build "$TMP/lexongine-build"
ctest --test-dir "$TMP/lexongine-build" -V
cmake -S integration/lexongine -B "$TMP/lexongine-sanitized" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF -DLEXONGINE_SANITIZERS=ON
cmake --build "$TMP/lexongine-sanitized"
ctest --test-dir "$TMP/lexongine-sanitized" -V
```

Both configurations passed **4/4 matched CTest targets**: 8 contract, 7 lifetime,
6 numerical cases, plus the independent oracle. CMake selected existing Python
3.14.8 at `/opt/homebrew/Frameworks/Python.framework/Versions/3.14/bin/python3.14`.
No sanitizer diagnostics were emitted.

Numerical fixture results: fast 101 outputs, slow 71, lagged slow 70; key49 means
100395000000/100245000000; key119 means 101095000000/100945000000; spread raw
150000000 and lagged spread 160000000. These are numerical helper results, not
logical-observation/graph/cache/host execution evidence. Complete Task 7 wiring and
the source/host acceptance experiment remain pending. Continue independent graph
validation/identity work while preserving the native Arrow blocker.

## 2026-10-15 — Graph identity and frozen-order traversal (Task 5)

Starting HEAD `a1edadbc2c241ec4a1bd6e02ede837028f8f2914`, branch
`implementation/lexongine-v1`. The owner chose **Include selector** when inspection
found OperationKey distinguished factories by implementation selector but the
draft OperationIdentityV1 omitted it. Updated the owning schema and ledger before
implementing the codec. Provider and transitive computation identity include the
selector plus all three implementation digests and SDK/build contract.

Implemented a bounded two-pass canonical encoder, exact ordered transitive
identities, production FNV-1a64 candidate hashing, full byte comparison, separate
sharing eligibility, deterministic logical Kahn ordering and first-occurrence
projection. Identity counting allocates no output buffer; reservations precede
emission. Unique/effectful/unproven upstreams cannot make pure descendants
automatically shareable. Source validity remains a separate preparation gate.

New checks first failed compilation at missing graph.hpp. A later runtime test
failed **6/7 cases**: a Skip producer could incorrectly connect to a Strict
consumer. The graph connection gate now checks producer, binding and consumer
policy consistently; the assertion was retained. Focused strict and sanitized
graph CTest runs now pass **8/8 cases**, including forced collisions, 19 semantic
field changes, recursive A→B→C identity, selector changes within one binary,
ordered subtraction ports, cycles, limits, units/clocks and Strict/Skip identity.

Reproduced product graph/walk evidence:

```text
duplicate-computation graph: logical=6, physical=5
counterexample logical order: S,p1,A,p2,B
counterexample physical first occurrences: S,p1,A,B
p2 aliases p1
B failure retains earlier A
failure after A leaves p2 and B unreached
```

These are structural and callback-traversal tests over explicit test descriptors,
not a claim of a completed numerical scheduler or validated market source.
`walk_logical` is the reusable traversal that the executor must consume.

Both complete currently defined suites pass **5/5 CTest targets**, strict and
ASan/UBSan, using the earlier configure/build commands and `ctest --output-on-failure`.
Focused commands were `cmake --build "$TMP/lexongine-build" --target lexongine_graph_tests`
and `ctest --test-dir "$TMP/lexongine-build" -R '^lexongine_graph_tests$' -V`, then
the equivalent sanitized commands. Build flags now explicitly include
`-fno-fast-math` alongside warnings-as-errors.

### Actual MarketDataReader prototype — direct native-library verification

The approved Homebrew download had completed the Arrow bottle even though its
remaining dependencies/install failed. Extracted that existing official archive
into `$TMP/arrow-bottle-inspect` without changing the system prefix. This provided
real Arrow 25 headers and static archives for the actual-API prototype.

```sh
ARROW="$TMP/arrow-bottle-inspect/apache-arrow/25.0.1_8"
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -fno-fast-math -I src -isystem "$ARROW/include" -fsyntax-only integration/lexongine/source_host_contract_probe.cpp
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -fno-fast-math -I src -isystem "$ARROW/include" integration/lexongine/source_host_contract_probe.cpp "$ARROW/lib/libarrow.a" "$ARROW/lib/libarrow_bundled_dependencies.a" -L "$TMP/lexongine-build" -llexongine_core -Wl,-rpath,"$TMP/lexongine-build" -o "$TMP/lexongine-reader-probe"
"$TMP/lexongine-reader-probe"
clang++ -std=c++20 -Wall -Wextra -Wpedantic -Werror -fno-fast-math -fsanitize=address,undefined -fno-omit-frame-pointer -I src -isystem "$ARROW/include" integration/lexongine/source_host_contract_probe.cpp "$ARROW/lib/libarrow.a" "$ARROW/lib/libarrow_bundled_dependencies.a" -L "$TMP/lexongine-sanitized" -llexongine_core -Wl,-rpath,"$TMP/lexongine-sanitized" -o "$TMP/lexongine-reader-probe-sanitized"
"$TMP/lexongine-reader-probe-sanitized"
```

Syntax check succeeded. Both executables printed **1/1 cases passed**, exercising
the actual checked reader signature, explicit requirements, callback-scoped copies,
original ordinals 10/12 and nonmonotonic event times, plus explicit causal timing.
Project/core code was instrumented in the second run; prebuilt Arrow was not.

Observed SHA-256:

- official `apache-arrow--25.0.1_8.arm64_tahoe.bottle.tar.gz`:
  `8028c307e83c0040e8e5554f7ef359336146408141910a94cd215d0a8a92322f`;
- `libarrow.a`: `671ccaf7232c4dc88e64ff3b4b4f10c9146648549c9ffd15b0bc97954ae1b4f3`;
- `libarrow_bundled_dependencies.a`:
  `f6ebc1f33150f32b4149141804257372dd704fa3792c5fbd82afb2d886d4aab8`.

This closes the bounded actual-API prototype check only. It is not the complete
Task-6 source adapter or persisted acquisition test. Native Arrow CONFIG discovery
and the full reader/storage bridge remain Blocked/Unverified. No private reader
imitation, data acquisition, bar aggregation or storage API change was introduced.

## 2026-10-15 — Strict authoring frontend checkpoint (Task 4)

Starting full HEAD `9338c8d4f6c3cdbc9f9aa5e3d77280e7242c8dde` on
`implementation/lexongine-v1`. Added owned declaration/resolved configuration
records, the explicit TinyXML2 adapter, fixed-vocabulary preflight and registry
schema resolution. The core retains no TinyXML/DOM dependency. Parsing preserves
initialization directives; source/history preparation must derive their actual
NodeSpec facts rather than the frontend guessing ranges.

Verification sequence:

- Initial frontend target linked unsuccessfully because parse_xml was not yet
  implemented; no runtime assertions ran at that checkpoint.
- After initial implementation, a new declaration test failed **5/6 cases**:
  XML version 1.1/unsupported encoding could pass TinyXML's generic declaration
  handling. Added strict XML 1.0/UTF-8 declaration validation, duplicate/order
  checks and legal character/reference enforcement.
- A policy test then failed **6/7 cases**: source/observation policy incompatibility
  was not yet rejected during resolution. Added explicit supported/selected policy
  checks without choosing an implicit policy for an unbound root.
- The final frontend target passes **8/8 cases**, normal and sanitized, with full
  example-field assertions, owned strings after input destruction, schema-typed
  params/origins, no executable factory invocation, missing/unknown/duplicate data,
  numeric grammar/range, DTD/entities/namespaces/PI/declarations, explicit limits,
  named references, driver and cache-disabled behavior.

Exact frontend configuration:

```sh
cmake -S integration/lexongine -B "$TMP/lexongine-build" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF -DLEXONGINE_XML_FRONTEND=ON -DLEXONGINE_TINYXML2_SOURCE_DIR="$TMP/tinyxml2-11.0.0"
cmake --build "$TMP/lexongine-build"
ctest --test-dir "$TMP/lexongine-build" --output-on-failure
cmake -S integration/lexongine -B "$TMP/lexongine-sanitized" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF -DLEXONGINE_SANITIZERS=ON -DLEXONGINE_XML_FRONTEND=ON -DLEXONGINE_TINYXML2_SOURCE_DIR="$TMP/tinyxml2-11.0.0"
cmake --build "$TMP/lexongine-sanitized"
ctest --test-dir "$TMP/lexongine-sanitized" --output-on-failure
```

Both complete currently defined suites passed **6/6 CTest targets**. Following
the final frontend assertions/trace-ceiling adjustment, both focused
`ctest --test-dir ... -R '^lexongine_frontend_tests$' -V` runs again passed **8/8
cases**. The sanitizer build instruments project/core/frontend and the supplied
TinyXML2 source. The external Arrow archives remain separately uninstrumented.

Pinned dependency rejection was also checked with a scratch-only CMake target
advertising TinyXML2 11.0.1: configuration of `lexongine-unsupported-xml` failed
at `Explicit TinyXML2 source must be version 11.0.0`, before a product build.
This is a negative configuration check, not a passing runtime target.

Central projection field tables now include the concrete configuration records;
unknown schemas remain distinguishable from the supported empty disabled-cache
record. Provider-specific completeness/availability policy validation, full source
admission, CLI overrides and complete XML projection round trips remain later
integration obligations. No run execution or accepted cache publication is claimed.

## Resume checkpoint — 2026-10-15

Owner requested continuation from the paused XML checkpoint. Verified clean
`implementation/lexongine-v1` at full HEAD
`24557020537e2935f37fc0ec08a8d96614df31fa`; the original integrity checkout remains
at `f75cd3c179f3b070f9a85c054ec3704b89f4cb69`. Six local checkpoint commits follow
the owner's published `61ecf87892a9eebfce397cea522941864d92a6c7`. No owner dirty
files or additional local changes were present. Resume with foundation lifetime
checks and the accepted native plugin mechanism, retaining prior accepted
provenance/selector clarifications and the explicit native-package limitations.

### Resumed lifetime checkpoint

Added focused checks before the fixes: the lifetime executable failed **6/8
cases** on exclusive transfer (`holder metadata exhausted`) and a current-key
read with a different extent (`expected a diagnostic, received success`). Erasure
now transfers the existing producer lease; current/provenance reads enforce the
activation extent. Raw immutable control adoption is internal to host adapters,
and accounts cannot be moved while leases refer to them.

Added explicit bounded previous-publication access, preserving original metadata
and checking the current activation, type, availability and declared retention.
The new check initially failed compilation at the missing API. It now verifies
one prior plus current payload, out-of-bound rejection, callback failure after
staging one port, cleanup and an external hold surviving slot destruction.
Committed history retains k+1 payloads; additional pending payloads and metadata
remain charged while staging, including when external holders prevent release.

Commands: `cmake --build "$TMP/lexongine-build" --target lexongine_lifetime_tests`
then `ctest --test-dir "$TMP/lexongine-build" -R '^lexongine_lifetime_tests$' -V`,
and the equivalent `lexongine-sanitized` commands. Both pass **1/1 targets, 9/9
cases**, with no sanitizer diagnostics. Full source/host/final-evidence integration
is still pending. Next: native same-build module/registry transaction verification.

## Native plugin checkpoint — 2026-10-15 (Task 3)

Starting HEAD `0cd80b06bb68bc48b393631d030b840b0d988f01` on
`implementation/lexongine-v1`. Implemented bounded prepare-time native loading,
generated same-build SDK contract, completed-build manifest/binary binding,
dependency inventory, transactional registry staging and host-held lifetime pins.
Explicit output-port policies are prebound into PublicationAllocator; numerical
callbacks can allocate/freeze their declared typed outputs without registry access.
Pins cover both operation code and type/freeze/deletion code. Exact native type
binding can reuse a pre-registered SDK type; a different witness/storage rejects.

Initial plugin compilation failed at the missing output-copy capability. The
first native runtime run then failed **0/3 cases** because CoreFoundation appeared
as a delayed-initialization dependency outside the active dyld image list. The
SDK's `dylib_use_command`/`DYLIB_USE_DELAYED_INIT` definitions and Apple's dyld
source were checked. The owner selected **Pin app dependencies**: hash application
and non-system dependency files, record loaded Apple image UUIDs and OS/SDK facts,
and explicitly trust the Apple shared-cache/delayed platform boundary. This is
recorded in the decision ledger and owning component specification.

The actual native target now passes **4/4 cases** using nine CMake-generated
module variants. Checks include matching build, wrong probe ID, missing probe or
registration symbol, missing NUL termination, nonzero probe result, partial
registration rollback, duplicate registration, a pre-registered SDK type,
different same-sized native witness, distinct actual implementation/build digests
under one ABI label, malformed/missing manifest, changed binary, explicit limits,
and module lifetime after registry/definition/prepared-factory/instance teardown.
The retained custom typed payload is read by the host and released only while its
native deleter remains pinned. These are native Mach-O executions, not Linux-only
declaration checks. CMake supplies actual target paths and CMAKE_DL_LIBS.

Verification commands (existing explicit XML/bridge settings retained):

```sh
cmake --build "$TMP/lexongine-build" --target lexongine_plugin_tests -j 4
ctest --test-dir "$TMP/lexongine-build" -R '^lexongine_plugin_tests$' -V
cmake -S integration/lexongine -B "$TMP/lexongine-sanitized" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=OFF -DLEXONGINE_SANITIZERS=ON -DLEXONGINE_XML_FRONTEND=ON -DLEXONGINE_TINYXML2_SOURCE_DIR="$TMP/tinyxml2-11.0.0"
cmake --build "$TMP/lexongine-sanitized" --target lexongine_plugin_tests -j 4
ctest --test-dir "$TMP/lexongine-sanitized" -R '^lexongine_plugin_tests$' -V
cmake --build "$TMP/lexongine-build" -j 4
ctest --test-dir "$TMP/lexongine-build" --output-on-failure
cmake --build "$TMP/lexongine-sanitized" -j 4
ctest --test-dir "$TMP/lexongine-sanitized" --output-on-failure
```

Both complete suites passed **7/7 targets**. After the final bootstrap-budget
check, the focused normal and sanitized plugin targets again passed **1/1 target,
4/4 cases**. Project, host, test modules and TinyXML2 are instrumented in the
sanitizer build; Apple platform libraries are not. No sanitizer diagnostics.

Observed pipeline: arm64, AppleClang 21.0.0.21000101, libc++ 210106, Apple SDK
26.5, C++20, explicit RTTI/exceptions/default visibility, no fast-math. Each build
exports `sdk-build-facts.txt` and `generated/lexongine/build_contract.hpp`; every
module exports its strict `.lexongine-build` sidecar. ABI and source-input hashes
are regenerated when SDK headers or declared test build inputs change.

Scope/limits: trusted synchronous same-build thin 64-bit macOS modules; no hot
reload, untrusted-code isolation or all-platform ABI promise. Delayed Apple images
are explicitly distinguished from hashed non-system files. Source/build manifests
are trusted build-pipeline records bound to actual binaries, not signatures or
reverse compilation. Native Arrow CONFIG and full persisted reader integration
remain separate and unverified. Source/preparation, complete scheduling, result
reuse, CLI/evidence and integrated acceptance are still pending.

## Coverage/history preparation and native prerequisite recovery

Starting HEAD `134dacd9413399ace514ba27ac7b532b0b6a2fe2`. Added bounded timeline
partition validation, original-key Strict/Skip handling, require-value readiness
using actual complete-record counts, and checked count-history propagation over
the frozen logical order. The initial syntax-only check failed at missing
prepare.hpp. Both focused strict and sanitized `lexongine_prepare_tests` targets
now pass **4/4 cases**. Tests cover uncovered/overlapping/reordered/missing-tail
data, explicit gaps, malformed gap extents, point-event time regression without
sorting, physical payload bounds, all-gap/insufficient-history rejection, preserved
evaluation boundaries and history recurrence 49→68 / 49→50. These helpers do not
certify provider/canonical payload validity or implement the full source service.

Native prerequisite recovery used the owner's existing provisioning approval.
Installed Snappy 1.3.1, re2 2025-11-05_2 and utf8proc 2.12.0 from cached bottles.
The first actual Arrow CONFIG retry then failed at AWSSDKAlt. A new bounded
Homebrew retry succeeded for aws-sdk-cpp 1.11.900_2 and its required dependency
upgrades. The extracted Arrow 25 CONFIG could then configure/link, but its
unrelocated `@@HOMEBREW_PREFIX@@` shared-library install names failed at runtime;
that run is a failure, not native-library verification.

The official `brew install apache-arrow` subsequently succeeded at **26.0.0**.
Its required dependencies included protobuf 36.2, grpc 1.84.0_2, z3 5.1.0,
llvm 23.1.3_1, simdjson 5.0.5, thrift 0.25.0_1 and uriparser 1.0.2. Project builds
continue using AppleClang 21 through /usr/bin/c++, not the newly installed LLVM.
Homebrew cleanup removed the old cached Arrow 25 archive; its separately extracted
scratch copy and recorded digest remain historical evidence.

Actual native package commands:

```sh
cmake -S integration/lexongine -B "$TMP/lexongine-native" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=ON -DLEXONGINE_XML_FRONTEND=ON -DLEXONGINE_TINYXML2_SOURCE_DIR="$TMP/tinyxml2-11.0.0" -DArrow_DIR=/opt/homebrew/opt/apache-arrow/lib/cmake/Arrow -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/apache-arrow
cmake --build "$TMP/lexongine-native" -j 4
ctest --test-dir "$TMP/lexongine-native" --output-on-failure
cmake -S integration/lexongine -B "$TMP/lexongine-sanitized" -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_QAEDALUS_BRIDGE=ON -DLEXONGINE_SANITIZERS=ON -DLEXONGINE_XML_FRONTEND=ON -DLEXONGINE_TINYXML2_SOURCE_DIR="$TMP/tinyxml2-11.0.0" -DArrow_DIR=/opt/homebrew/opt/apache-arrow/lib/cmake/Arrow -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/apache-arrow
cmake --build "$TMP/lexongine-sanitized" -j 4
ctest --test-dir "$TMP/lexongine-sanitized" --output-on-failure
cmake -S integration/storage -B "$TMP/lexongine-storage-native" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/apache-arrow -DArrow_DIR=/opt/homebrew/opt/apache-arrow/lib/cmake/Arrow -DParquet_DIR=/opt/homebrew/opt/apache-arrow/lib/cmake/Parquet
cmake --build "$TMP/lexongine-storage-native" -j 4
ctest --test-dir "$TMP/lexongine-storage-native" --output-on-failure
```

Results: **9/9 current Lexongine CTest targets pass** through native Arrow CONFIG,
both normal and ASan/UBSan project builds, including the actual-reader prototype.
**4/4 existing storage targets pass** against native Arrow/Parquet 26.0.0 in the
normal build. Dependency finders emitted lz4/Thrift CONFIG warnings before their
supported library fallback succeeded. Project compiler warnings remain errors.
Prebuilt Arrow/Parquet and platform libraries were not sanitizer-instrumented.

The historical native-package availability blocker is now resolved in this
environment. The actual Lexongine replay adapter, complete source/preparation
service, registered component wiring, shared run lifecycle, result store and
CLI/evidence acceptance remain implementation work. No full milestone completion
is inferred from these prerequisite/helper results; existing storage source code
and integrity contracts were not modified.
