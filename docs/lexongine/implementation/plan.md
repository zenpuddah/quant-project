# Lexongine v1 — consolidated implementation plan

Twelve tasks; bounded computation engine, source adapter and host seam. Behavioral/technical owner batches are closed. The owner retains major decisions and has delegated routine engineering choices. Use [the handoff](../README.md), all six specifications and [reference cases](../examples/reference-cases.json); research is optional context, not extra authority.

## Baseline and working discipline

The advisor inspected remote f75cd3c179f3b070f9a85c054ec3704b89f4cb69 on implementation/data-integrity-2026-10-03. Main was95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5. No actual local checkout or product tests were run. OpenCode must record actual branch/full HEAD/dirty state, read local AGENTS/context/engineering entries and reconcile newer unpushed decisions. Preserve owner work. Use an isolated implementation/lexongine-v1 checkout/worktree from the accepted baseline; do not merge into main or modify unrelated work.

Build C++20, framework-free focused tests and an isolated integration/lexongine CMake3.25 target; no root build migration. Supply accepted TinyXML2 11.0.0 explicitly. Core has no Arrow dependency. The included actual Qaedalus bridge needs explicit Arrow/Parquet prerequisites; its missing dependencies are Blocked/Unverified, not a passing/deferred milestone. Native macOS same-build plugin verification is required. Do not silently install/fetch new dependencies.

All graph/configuration is fixed per run. Exact sharing, causal immutable values, explicit policies, complete required validation and fail-stop are invariant. Existing Qaedalus types/layout/storage APIs remain unchanged. Automatic exact-full-scope output reuse is v1. Neither a complete backtester nor real-feed bar creation is included.

Write and run meaningful failing focused checks before the corresponding implementation; then implement, rerun, inspect the diff and commit a coherent local checkpoint. Check matched test counts: zero matched CTest tests is not success. Reserve bounded diagnostics and required evidence before execution. Record actual commands/results/HEAD in progress after meaningful work. A failed prerequisite stops dependent tasks; independent work can continue. Escalate consequential contradictions together; resolve routine names/layout details and record them. Do not weaken tests to claim completion.

## Dependency order

Tasks1–2 establish contracts/ownership. Task3 binds the plugin ABI. Task4 establishes strict input/configuration. Task5 freezes the logical graph and sharing. Task6 validates sources/history/resources and the checked adapter. Task7 supplies deterministic numeric components. Task8 runs both standalone and hosted lifecycles. Task9 adds valid output reuse. Task10 finalizes CLI/evidence projections. Task11 verifies integrated behavior independently. Task12 records and hands off actual status.

Prototype the actual reader callback seam and hosted declarations before freezing Task1/2 interfaces; complete their implementation/tests in Task6/8. This avoids a fixture-only architecture without reversing the dependency order.

## Proposed file map

Existing files below are verified paths; every Lexongine path is new/proposed. Follow the repository's focused headers and standalone-test style.

| Path | Responsibility |
| --- | --- |
| src/lexongine/model.hpp | IDs, semantic parameter/port/update/outcome and resource records |
| src/lexongine/registry.hpp | Owned operation/type definitions and typed parameter preparation |
| src/lexongine/binding.hpp | Typed slots, kernel adapters and complete publication staging |
| src/lexongine/graph.hpp | DAG validation, canonical equality/hash, exact interning and mapping |
| src/lexongine/prepare.hpp | Required history, source validation/admission, resource plan and frozen plan |
| src/lexongine/execution.hpp | Run lifecycle, update scan, observation masks and fail-stop |
| src/lexongine/results.hpp | Immutable ownership, retention and accounted buffer allocation |
| src/lexongine/reuse.hpp | Exact reusable-artifact contracts, eligibility, validation and replay cursors |
| src/lexongine/evidence.hpp | Bounded event/report records; minimal failure envelope |
| src/lexongine/plugins.hpp | Platform-independent module pins and minimal probe contract |
| integration/lexongine/xml_frontend.hpp and .cpp | TinyXML-2 adapter, strict vocabulary/config validation |
| integration/lexongine/xml_report.hpp and .cpp | Versioned plan/report projection |
| integration/lexongine/plugin_loader.cpp | macOS loader/probe/registration adapter |
| integration/lexongine/result_store.hpp and .cpp | Bounded local artifact store, integrity/codec adapter, lock and atomic acceptance |
| integration/lexongine/CMakeLists.txt | Isolated host/demo/plugin/test targets |
| src/quant/lexongine/bar_close.hpp | Qaedalus canonical Bar to Price adapter |
| src/quant/lexongine/sma.hpp | Checked bounded integer SMA and declared arithmetic |
| src/quant/lexongine/price_difference.hpp | Checked Price subtraction |
| src/quant/lexongine/lag_price.hpp | Explicit fixed-count Price lag with preserved parent timing/lineage |
| integration/lexongine/fixture.hpp and fixture_main.cpp | Explicit validated 120-bar source and demonstration |
| integration/lexongine/cli_main.cpp and cli_tests.cpp | Strong CLI and interface tests over the shared registry/preparation/execution API |
| docs/lexongine/examples/first-computation.xml | Complete required configuration and requests |
| integration/lexongine/verify_fixture.py | Independent naive Python/Fraction expectations |
| tests/lexongine_contract_tests.cpp | Registry/descriptors/strict configuration |
| tests/lexongine_graph_tests.cpp | Cycles, collisions, identity and sharing legality |
| tests/lexongine_lifetime_tests.cpp | Ownership, retention, managed quota and cleanup |
| tests/lexongine_execution_tests.cpp | Temporal/readiness/status/failure behavior |
| tests/lexongine_sma_tests.cpp | Arithmetic, window state and source-type reuse |
| tests/lexongine_reuse_tests.cpp | Candidate compatibility, coverage, validation, replay and continuation separation |
| integration/lexongine/result_store_tests.cpp | Filesystem corruption, quotas, locking, partial writes and restart behavior |
| integration/lexongine/plugin_tests.cpp and test_plugin.cpp | Probe compatibility and module lifetime |
| docs/lexongine/spec/ | Consolidated operative contracts |
| docs/project/lexongine-context.md | Owner decisions/current source and implementation evidence |
| docs/project/engineering-book.md and context.md | Focused accepted reasoning and session status |

Do not modify src/quant/data/value_types.hpp, observations.hpp, storage encodings or existing reader APIs for the standalone engine. Do not add a root CMakeLists.txt. The checked reader bridge below is included; real bar production and financial models require separate domain design.


Additional included integration paths:

| Path | Responsibility |
| --- | --- |
| integration/lexongine/qaedalus_replay_source.hpp and .cpp | Bounded adapter to actual checked MarketDataReader; explicit Arrow target |
| integration/lexongine/replay_source_tests.cpp | Actual-API fake reader and persisted acquisition bridge tests |
| integration/lexongine/backtest_host_probe.hpp and .cpp | Test-only controller and distinct intent ledger; no financial-model implementation |
| integration/lexongine/hosted_execution_tests.cpp | advance_one/finish equivalence and host failure gate |
| integration/lexongine/frontend_tests.cpp and evidence_tests.cpp | Exact schema and required evidence tests |
| tests/lexongine_prepare_tests.cpp | Preparation, gap coverage, admission and resource bounds |
| docs/lexongine/implementation/progress.md | Exact implementation/verification evidence by task |


## Task 1 — Owned contracts and registry

**Files:** model.hpp, registry.hpp, tests/lexongine_contract_tests.cpp; create the isolated CMake target with the tests it needs.

**Consumes:** selected written spec and baseline. **Produces:** the model records and registry signatures above; test-only definitions for an int64 source, identity transform and unique action.

- [ ] Write failing framework-free tests: reject duplicate OperationKey; reject unresolved version; missing/unknown/duplicate required param; wrong port units/clock; label changes leave semantic equality unchanged; prepare-owned descriptor remains valid after source text/DOM destruction.
- [ ] Run the contract target and verify each negative case fails for the expected missing behavior.
- [ ] Implement owned records, canonical named parameters and registry resolution. OperationDefinition defines schema, validate/prepare params, semantic codec/equality, shareability, resource bounds and typed factory. Registry lookups are preparation-time only.
- [ ] Enforce explicit declaration rather than generic implicit defaults. Use operation-version facts with visible origins in the effective descriptor.
- [ ] Run contract tests with warnings-as-errors and commit the focused result.

Included requirements for this task:

- [ ] own MissingIntervalPolicy Strict/Skip, source SourceGap record and explicit accepted policy/count basis fields; distinguish gaps from numeric ValidAbsence/Failure.
- [ ] own explicit replay/source binding metadata, independent source succession/clock mapping, callback-scoped payload ownership and provider capability boundaries. Record prototype declarations consistent with actual MarketDataReader signatures.
- [ ] own StepReceipt/IntegrationCompletion/IntegrationOutcome and explicit driver=hosted/standalone values, distinct from synchronous execution. Add AwaitingCompletion lifecycle; declare advance_one,fail_host,abort_host,finish,execute. Receipt source/observation views are immutable/current/lifetime-accounted, with Processed/Gap/Exhausted/Stopped statuses and fixed cause references.

## Task 2 — Typed binding and immutable publication

**Files:** binding.hpp, results.hpp, evidence.hpp; tests/lexongine_lifetime_tests.cpp.

**Consumes:** TypeContract, UpdateContext, OutcomeKind and definitions. **Produces:** typed slots, StepResult<Outputs>, PendingOutcome/ValidatedOutcome, nonthrowing commit/discard and run-owned prepared call.

- [ ] Write failing tests: two reads return one stable publication without updating; scalar retention copies values; large retained output remains unchanged after later updates; staged two-output kernel failing after output one exposes neither; wrong/missing declared output rejects; plugin-backed deleter remains pinned.
- [ ] Write quota tests: retention k prior outputs requires k+1 payload capacity; absence/warming consume no produced-payload slot; checked size arithmetic rejects overflow; quota failure occurs before commit; escaped owned handle remains charged until release.
- [ ] Use the selected immutable owning-handle policy: resource account/module pins outlive the run when handles do; final release removes the charge. Require explicit retention_warning_steps; test one bounded warning at threshold crossing with holder/reason references, and no forced invalidation or premature plugin unload.
- [ ] Record allocation bytes once across all shared holders. Use instrumented holder/lease labels for diagnostics; raw shared_ptr::use_count alone cannot identify owners. Logging metadata must never hold owning output references. Verify retained callers keep the resource account/module pins alive after the run and cleanup/destruction never throws to report logging failure.
- [ ] Implement prebound typed access and operation-specific storage. Large producers transfer exclusive immutable storage or copy; no mutable ring/source view becomes a retained value.
- [ ] Make complete bundle commit nonthrowing through preallocated storage/ownership swaps. Call output validators before it. Reserve minimal failure/request status storage before execution; detailed traces have separate explicit quotas.
- [ ] Translate ordinary callback exceptions to bounded diagnostics. Cleanup and probe/registration functions cannot throw across their contract.
- [ ] Verify lifetime tests under ASan/UBSan and commit.

Included requirements for this task:

- [ ] own explicit replay/source binding metadata, independent source succession/clock mapping, callback-scoped payload ownership and provider capability boundaries. Record prototype declarations consistent with actual MarketDataReader signatures.
- [ ] register integration services/required sinks before instantiate/first update. Host account state cannot enter numeric kernels through captures/globals. Qaedalus reader/source remains the owning specifications's declared typed adapter; expected future financial input snapshots need a separate explicit contract.

## Task 3 — Minimum runtime-plugin mechanism

**Files:** plugins.hpp, plugin_loader.cpp, plugin_tests.cpp, test_plugin.cpp; isolated CMake plugin target.

**Consumes:** registry and module-pinned callbacks/owners. **Produces:** explicit prepare-time loading and retained ModulePin used by definitions, instances and output deleters.

- [ ] Write tests for matching build, mismatched probe, malformed/oversized probe, missing symbols, duplicate registration and cleanup after partial preparation.
- [ ] Pin exact host SDK/build/toolchain/stdlib/ABI settings in one generated build contract. Host and plugin are built by the same accepted pipeline.
- [ ] Define primitive bootstrap lexongine_probe_v1(char* out, uint32_t capacity), returning 0 only for a complete NUL-terminated build identifier in caller-owned bounded storage; any other result rejects. Only after matching it may the host call lexongine_register_v1(Registry&, Diagnostic*), returning a primitive status. Registration stages transactionally and exposes no half-registered definition on failure.
- [ ] Implement the macOS adapter with explicit module paths and selected eager/local symbol resolution. Use CMake's target-generated plugin path and CMAKE_DL_LIBS, with an explicit test-plugin build dependency; do not hard-code a Linux suffix or -ldl. Keep loader initialization trusted; do not call this a sandbox or stable numerical C ABI.
- [ ] Separate actual binary/dependency/source-build digests from the ABI label. Verify loaded implementation content; changing it without changing its label/version must prevent cache reuse. Test real macOS/libc++ typed host/plugin round-trip with required SDK type visibility/RTTI; mismatched witness rejects, never falls back to a raw cast.
- [ ] Test typed outputs, any managers and factory captures retained after run/registry teardown. Host-owned controls hold pins until paired plugin destruction returns; a pin inside the plugin payload/control block alone is insufficient. No unload while any such code can run.
- [ ] Run plugin tests and commit. No hot reload or automatic plugin discovery.

## Task 4 — Strict XML front end

**Files:** xml_frontend.hpp/.cpp, first-computation.xml; contract tests; isolated TinyXML-2 integration.

**Consumes:** registry schemas and owned model. **Produces:** parse_xml and ParsedComposition with source line diagnostics, then resolve_composition with explicit Registry access. The initial parse exposes only the bounded skeleton/plugin list and raw parameter literals; operation-schema resolution follows plugin registration.

- [ ] Write tests for missing/unknown fields, duplicate attributes/IDs/parameters, trailing numeric text such as 20junk, signed/unsigned range errors, unsupported root version, undeclared references, DTD/unknown nodes, unsupported namespace and file/depth/count/text limits.
- [ ] Bind TinyXML-2 11.0.0 through an explicitly supplied approved checkout or installation. Reject a different unsupported version instead of silently fetching one.
- [ ] Parse only the spec vocabulary. Copy required strings into owned descriptions; never expose DOM handles. Use from_chars with complete-token/error checks rather than permissive XML numeric getters. Resolve operation-specific parameter types through the explicit Registry argument after the plugin-list stage.
- [ ] Keep literals and producer references distinct. Normalize exact attribute order/numeric spellings into typed params; do not normalize arithmetic structure.
- [ ] Add a fully populated example: execution sync; failure stop; same-step alignment; source fixture-v1 with explicit missing_intervals=strict; node/output bindings; SMA N/B/signed64/nearest_ties_even/fail; empty initialization at step0; evaluation [49,120); current-only retention; explicit resource/trace limits and bounded automatic result-store policies. Reject missing/unknown cache fields; preparation-time directory overrides are explicit and appear in effective config.
- [ ] Round-trip inspection must show every effective parameter and its declared/derived/versioned origin. Verify tests and commit.

Included requirements for this task:

- [ ] require source missing_intervals and lag count_basis fields; reject absent/unknown/incompatible settings. Explicitly add strict to the original XML and create a separate skip gap fixture.
- [ ] require/parse/export explicit driver=standalone|hosted; the updated original XML fixture declares standalone and missing_intervals=strict. No implicit host-driver default.

## Task 5 — Graph validation and exact sharing

**Files:** graph.hpp, tests/lexongine_graph_tests.cpp.

**Consumes:** owned descriptions and registry legality. **Produces:** validate_graph, intern_exact, deterministic logical-to-physical mappings.

- [ ] Write tests: exact duplicate shares; different source version, ordered input, config, operation version, init history, clock or error policy stays separate; different labels/request IDs can still share; unique identical actions never share.
- [ ] Inject a constant hasher: unequal specs must remain separate. Assert equal semantic specs produce equal production hashes.
- [ ] Owner clarification: test A→B→C transitive identity. Change A parameters/source/version while B/C remain textually unchanged; both downstream identities must change and prior artifacts must miss. Reverse operation sequence or subtraction input ports; no match even when sample outputs coincide. Force collisions at each dependency level and verify full ordered equality rather than inspecting only the immediate input value.
- [ ] Validate named ports and adjacency; use deterministic indegree topological ordering with declaration-ordinal tie-break and freeze the logical schedule before interning. Reject self-loop and longer cycles with involved-node diagnostics; no recursive graph execution.
- [ ] Canonicalize dependencies bottom-up; encode semantic fields with explicit tags/lengths and stable integer encoding. FNV-1a64 offset 14695981039346656037, prime 1099511628211, intentional unsigned modulo-2^64 arithmetic. Full equality inspects all relevant fields; no raw object/pointer hashing.
- [ ] Apply separate shareability legality after equality. Preserve all output ports, logical aliases and action occurrences. Do not run repeated rewrite/fusion/pruning passes.
- [ ] Preserve physical first-occurrence projection of that logical schedule; never sort the optimized graph independently for execution. Add S,p1,A,p2,B counterexample from the owning specification, verifying A then B and retention of A when B fails. Fail between aliases: first physical publication may exist, later logical alias/request remains NotReached/Aborted.
- [ ] Test differing consumer masks sharing one unchanged producer stream: at55 consumer from49 is evaluating, consumer from60 is warming, with one producer step. Producer callbacks cannot read RequestContext. Different actual producer initialization streams stay separate. Verify and commit.

## Task 6 — History, source validation, admission and resources

**Files:** prepare.hpp; graph/contract/lifetime tests.

**Consumes:** graph, registry contracts and SourceResolver. **Produces:** prepare, frozen PreparedPlan, per-request rejection evidence and SourceSnapshot ownership.

- [ ] Write count-history tests: SMA20 needs19 preceding +current; SMA50 needs49 +current; SMA20(SMA50) needs68 +current; one-step lag(SMA50) needs50 preceding +current. Fan-out uses the union scope, not sums of independently fetched duplicates.
- [ ] Test insufficient history rejects without shifting start; different explicit initialization prefixes are not widened for sharing; unsupported time/prefix history modes reject in this slice.
- [ ] SourceResolver resolves an immutable identity/version/interpretation and exact scope. Its validation path can inspect full required data; numerical bound ports expose only currently eligible values and declared retained outputs.
- [ ] Test path/snapshot change between validation and execution cannot change the bound source; failed shared source scope rejects all dependent requests; independently eligible requests remain named in the plan.
- [ ] Account source/state/scratch/staging/retention/graph/evidence estimates and host-managed quotas separately. Reject checked size overflow and a globally overbudget submission before creating state; do not silently drop requests for budget.
- [ ] Complete required validation precedes every dependent numerical callback. Sample failure may reject early; a passing sample never admits a source. Check all source-known typed consumer constraints through declared projection validators, without running numeric kernels. With valid fixture B=100500000000, reject SMA-dependent requests before any callback because key51 exceeds B; independently compatible requests remain admitted. Computed outputs retain runtime checks; no hidden numerical precomputation is permitted.
- [ ] Test arithmetically feasible but unallocatable N (N=INT64_MAX,B=1); checked ring/metadata sizes and total budgets reject before state allocation. Retrieval unions do not widen actual semantic initialization domains.
- [ ] Freeze policies, mapping, resource accounting and source ownership; create no mutable per-run state until instantiate. Verify and commit.

Included requirements for this task:

- [ ] validate complete records plus declared gap ledger as exact expected-scope partition, count actual usable history and reject insufficient readiness without shifting evaluation. Present corrupted data/wrong instruments still reject. Admit only policy-compatible components/requests.
- [ ] add proposed integration/lexongine/qaedalus_replay_source.hpp/.cpp and replay_source_tests.cpp for the source-bridge implementation slice. Explicit selected fragments/query/ConsumerRequirements are supplied by Qaedalus. Checked replay materializes a bounded charged immutable selected slice and host-only timing descriptors during validation; advance_one obtains the next descriptor/UpdateContext, then next() exposes only its eligible value; no assumed push-stream pause/resume. Over-limit/unsupported/unresolved source checks reject before numeric calls.
- [ ] register integration services/required sinks before instantiate/first update. Host account state cannot enter numeric kernels through captures/globals. Qaedalus reader/source remains the owning specifications's declared typed adapter; expected future financial input snapshots need a separate explicit contract.

## Task 7 — Qaedalus fixture, arithmetic and explicit lag

**Files:** src/quant/lexongine/bar_close.hpp, sma.hpp, price_difference.hpp, lag_price.hpp; fixture.hpp; arithmetic/execution tests.

**Consumes:** existing canonical Bar/Price/Quantity/Timestamp and typed binding adapter. **Produces:** registered qaedalus.fixture_bars v1, qaedalus.bar_close v1, statistics.sma_price v1 and qaedalus.price_difference v1. Exact port/config/identity names follow the supplied XML example.

- [ ] Inspect actual canonical type APIs at the selected commit. Reuse them; add no private alternate financial type or market record field.
- [ ] Write SMA state tests with explicit N/B/rounding: last-N exact input ring, once/update counter, output only after N inputs, never own rounded-output feedback.
- [ ] Write signed/tie tests: 1/2→0,3/2→2,−1/2→0,−3/2→−2,5/2→2,−5/2→−2; N=1 exact; malformed N/B rejects.
- [ ] Test B>INT64_MAX/N rejects without overflowing multiplication; input outside B rejects by comparisons without abs(INT64_MIN); independent rounding helper can safely handle extreme signed S even if that S is outside the chosen SMA domain.
- [ ] Implement checked subtract-evicted then add-current. Add a legal-window transient test N=2,B=INT64_MAX/2 with constant B: correct ordering succeeds; append-first would overflow.
- [ ] Rounding uses q/r and unsigned remainder magnitude compared with N−magnitude; no signed minimum negation and no doubled remainder. Publish Price9 with explicit policy; use actual supplied inputs in state.
- [ ] Price difference uses existing checked Price subtraction; test overflow independently of SMA bounds.
- [ ] Register series.lag_price v1 with explicit positive lag_steps, single-clock complete-bar-update count basis, empty initialization and explicit compatible Strict/Skip missing-interval policies. Checked bounded state stores lag_steps prior Price outputs and their original publication timing/lineage; no ancestor-row access API.
- [ ] Test repeated equal values still advance lag; first lag_steps applicable parent publications warm; each later update emits the selected earlier value under the current activation key with original parent identity/availability preserved only as lineage. New availability must include the current activation boundary, never be backdated to the old parent. Strict source gap fails; Skip source gap is logged with no numeric callback and the next complete bar resumes with retained state. Arbitrary undeclared component absence/missing still fails; no calendar-day interpretation.
- [ ] Keep the original six-logical/five-physical fixture unchanged numerically. Add a separate lag fixture observing SMA20(t) minus lag1(SMA50) on [50,120):70 values, each raw160000000. Starting at49 rejects rather than silently shifting evaluation. Compare general positive lag counts against a simple independent sequence oracle.
- [ ] Construct the complete provider facts in the owning specification:120 bars, origin Unix ns0,60000000000ns intervals, nonzero Instrument/Venue/Source IDs1, interval-end event/availability time, explicit optionals/flags, O/H/L/C raw100000000000+10000000*i, volume raw1000000. Fully validate content/coverage; a Bar alone is not a completeness certificate.
- [ ] Run arithmetic/state tests, sanitizer checks and commit.

Included requirements for this task:

- [ ] SMA2/lag1 reference at original keys0,2,3 produces means105/115 and lag100/110; no input-count/window shift at gap1. Keep the120-bar fixture unchanged numerically.
- [ ] locally generate120 canonical complete bars from close100+0.01*i using the owning specifications fields. Keep synthetic labeling and independent oracle. No downloaded-feed or persisted-Bar claim.

## Task 8 — Synchronous executor and failure boundary

**Files:** execution.hpp, tests/lexongine_execution_tests.cpp.

**Consumes:** PreparedPlan, typed prepared calls, source snapshot and pending publications. **Produces:** instantiate and execute.

- [ ] Write tests for repeated equal values, multiple consumers/duplicate reads, same-key replay rejection, exactly one advancement per applicable physical update and no mutable state sharing across runs.
- [ ] Process source step49 exactly once:49 preceding warmup inputs, fiftieth current input, SMA50 publication, then evaluated observations. Test late/early/delayed availability cannot leak future data.
- [ ] Define status table: same-step inputs all Published→invoke; Warming→waiting; ValidAbsence→declared bundle-wide absence or required-value failure; MissingRequired/Failure→stop. Never substitute stale publication. At source closure unresolved required scope fails acceptance.
- [ ] Walk frozen logical order and resolve each physical producer at first occurrence per update, then visit aliases at their original logical boundaries. Track last_resolved_key separately from last_published_key, actual advances and cache deliveries. Warming own-state callbacks advance once; dependency-waiting outcomes resolve the key without invoking. Repeated reads never advance or deliver twice. Failure/protocol errors outrank warming.
- [ ] Deliver observations at their reached logical boundary in declared request order using RequestContext; unique action scope gates never enter producer UpdateContext. Observer exception stops the run; already delivered observations/actions remain partial. Do not eager-broadcast aliases.
- [ ] Test multi-input mismatch rejects; no implicit merge of independent source ordinals; required values read only from current allowed slots and bounded earlier outputs.
- [ ] Test failure after staged output discards bundle, stops downstream and other admitted branches, preserves original cause and marks earlier results partial. Diagnostic handler failure does not replace the primary cause.
- [ ] Preserve deterministic unique action order and multiplicity using separate test-only simulated action nodes. No evaluated actions during warmup.
- [ ] Register RequiredEvidenceSet/finalizer before execution; use explicit in-memory test sinks until integration projections exist. Return a terminal RunReport for normal failed runs; API misuse returns Diagnostic. Numerical Completed/EvidenceIO at close yields Acceptance Rejected, never success or cache promotion. Reserve return/cause/status storage and permit no fallible mandatory work after acceptance.
- [ ] Disallow execute on a terminated RunInstance (AlreadyExecuted). Deliberate fresh instantiate replays required history. Verify and commit.

Included requirements for this task:

- [ ] record each skipped timeline interval once, invoke no numerical/action callback, retain state and resume once at next actual key. Ordinary multi-input same-key alignment stays intact; no independent-source gap merge is introduced.
- [ ] implement one per-timeline-event scheduler primitive. execute wraps advance_one+finish, maintaining private reducer state across all updates. Hosted callers interleave domain decisions/effects and use fail_host/abort_host on participating failures. Enforce end/stop/early-finish/terminal transitions and required-scope/readiness closure; no implicit acceptance when source scope is incomplete.

## Task 9 — Automatic validated cross-run result reuse

**Files:** reuse.hpp, result_store.hpp/.cpp, reuse/result-store tests; prepare/execution/evidence integration. Backend/format and trust/limits are selected in the current contract under the owner's accepted cache mechanism and delegated routine choices.

**Consumes:** exact prepared identities, validated source snapshots, typed output contracts and complete run outcomes. **Produces:** explicit bounded ResultStore, candidate validation, automatic cache-served producer streams and acceptance promotion.

- [ ] Implement an in-memory test store first and the selected sequential macOS local-files adapter. Require explicit path, automatic read/write, same-build local trust, exact-full-scope matching, SHA-256 integrity, writer lock, fail-on-corruption, bypass-new-entries capacity policy, explicit-only cleanup and all entry/count/disk/decoded byte limits. Reconcile the integrity provider with the selected repository; do not add a database or core XML/market-storage dependency.
- [ ] Use the frozen format recommendation: strict versioned manifest/payload XML through TinyXML-2, canonical checked int64 decimal Price coefficients and nominal scale-9 contract; no object-memory/float encoding. Use the concrete canonical byte/manifest/payload/marker schemas in the owning specification, then write round-trip/negative tests. Origin marker digests are derived in the validated lookup view; provisional manifests contain origin_run_id only, avoiding circular digests. Wrap the existing dependency-free SHA-256 helper from src/quant/storage/file_integrity.hpp in the integration adapter; introduce no new dependency or core market-storage coupling.
- [ ] Register replay-safe/cacheable flags and supported typed codecs separately from within-run sharing. Effectful/action nodes, unknown eligibility and unsupported codecs compute normally with explicit reasons. Never suppress required runtime checks/effects by calling a node cacheable.
- [ ] Validate full canonical identity after candidate lookup, including input content/snapshot/version, operation/build, configuration/numerics, ordered ports and clock, init/history and exact processing scope, type/codec/validation contract versions. Force candidate collisions; change each relevant field independently and require a miss. No last-value matching, scope widening or partial overlap reuse.
- [ ] Store every applicable outcome key/status and complete bundle with original timing, compact canonical parent lineage, coverage and accepted originating-run evidence. Remap semantic parent identities to the new run; retain original run/artifact as separate provenance. Cached files never contain mutable state.
- [ ] Validate current required sources plus cached identity, integrity, coverage, monotonic keys, startup, outcomes and decoded output invariants before acceptance. A cache cannot admit an invalid source. Corruption and actual store I/O failures fail; absence/incompatibility are reported misses. Budget rejection precedes unsupported allocation.
- [ ] Replay each cached outcome only at its permitted update/decision boundary. Test read-ahead cannot expose future data, equal values still deliver distinct updates, independent logical observations/actions remain intact, and physical kernel advances are distinguished from cache delivery counts.
- [ ] Stage entries privately; publish complete entry manifests and the accepted originating-run marker only after numerical execution, required evidence and required cache writes validate. Failed/aborted/evidence-failed/cache-write-failed runs expose no eligible entries, even if some temporary entry files exist. Embedded snapshot inventory excludes its own digest and the marker; final marker includes the finalized snapshot digest. Required logs/exports/payloads/manifests and Pending snapshot must be flushed/closed successfully before publishing the final marker. No required post-marker append/copy/directory fsync is permitted. CommitOutcome is Committed/NotCommitted/Unconfirmed; bounded locked reconciliation resolves ambiguous visibility where possible, otherwise report Unconfirmed and withhold success. Do not falsely label an uncertain acknowledged origin proven failed. Inject failure/crash at every stage; restart validates the authoritative marker and ignores incomplete/unaccepted entries. Test lock contention, explicit unpinned cleanup and bounds.
- [ ] Run the fixture twice with an isolated explicitly empty store: first computes; second automatically reuses eligible results with identical logical values/status/key/availability/lineage and actions. Repeat across two CLI processes. Disable reuse explicitly for a fresh oracle comparison. Use a separate fixed immutable snapshot[1,1,3,5], N2/B5: processing[0,3)→Warm,1,2; repeat→same via cache; extension[0,4) must miss on scope alone and recompute Warm,1,2,4 from all four inputs. The120-bar fixture cannot itself satisfy a121st bar. Do not continue SMA from a saved mean.
- [ ] At full store capacity, test the configured bypass decision is reported and numerical results remain valid without a new cache write/marker; do not silently grow or evict. Actual ENOSPC/EDQUOT/EIO is an error, not configured-capacity bypass. Validate temporary/disk and decoded buffer accounting, including pinned readers.
- [ ] Run focused strict/sanitized store, reuse and execution tests; commit only with reproduced commands/results.

Included requirements for this task:

- [ ] include policy, count basis and ordered gap coverage in recursive identity/manifest validation. Strict-vs-Skip mismatch cannot hit even if values match. Cache replay reproduces skipped timeline evidence and complete-update numerical outcomes without future access.
- [ ] finish gates acceptance/cache publication on host outcome plus required domain evidence finalization. Report engine outcome, host outcome, run acceptance and pure feature cache status separately. Cache hits never suppress domain decisions/intents or restore financial state. A required host report cannot be written after accepted marker publication.

## Task 10 — Plan/report XML and before/after DOT

DOT and before/after graph inspection are owner-accepted. XML report encoding is the selected delegated engineering contract in the configuration specification.

**Files:** xml_report.hpp/.cpp, evidence.hpp projection, fixture_main.cpp, cli_main.cpp and cli_tests.cpp; execution/graph tests.

**Consumes:** frozen description, mapping and RunReport. **Produces:** export_dot, export_plan_xml, export_report_xml and human summary from the same records.

- [ ] Test escaped IDs/labels/messages, rejected request reasons, full effective params/source versions, shared aliases and unique actions.
- [ ] Export before graph with6 logical computations and after graph with5 physical computations for the fixture. XML mapping identifies both fast consumers independently.
- [ ] Report advancement and publication counts separately from evaluated observation counts; preserve all logical trial IDs.
- [ ] Implement the accepted separate runtime retention log through the same evidence records. Require explicit path/format/open/flush/failure/overflow/byte/event policies from the fixture; selected key_value_lines_v1 uses escaped quoted fields, create_new, on_event flush and stop-on-error. Record run/update, allocation/publication/producer IDs, bytes, age clock/unit, known holders and retention reasons; emit the long-retention warning and outstanding-holds summary. Do not log payloads or retain output handles.
- [ ] Test runtime visibility before run completion, distinct files for repeated runs through explicit path overrides, shared allocation counted once, valid window/history retention reasons, unknown external holders reported honestly, bounded warnings, escaping, quota/write failures preserving the reserved cause, and no success/cache promotion before required log finalization. Account bytes still retained after run completion; record that snapshot without requiring throwing/destructor writes to a closed log.
- [ ] Include cache eligibility, hit/miss/incompatibility/corruption/capacity decisions, exact coverage, artifact/origin identity, cached delivery versus kernel advance counts and explicit effective store policies. Annotate cache-serving in the plan/DOT without hiding the logical dependencies.
- [ ] Report NumericalOutcome, AcceptanceStatus and CachePublicationStatus separately; select stable Diagnostics/CLI exit mappings from the owning specification. Required report export is a preconfigured sink before terminal execute, never an unconstrained fallible operation added afterward. Report success, failure, rejected and aborted outcomes distinctly. Do not write failed/aborted results as ordinary zero scores. Required trace/export overflow marks acceptance failed/evidence incomplete without losing the reserved minimal cause.
- [ ] Round-trip the XML using the strict schema and compare semantic fields. Treat DOT as a visualization projection; Graphviz installation is optional, not an execution dependency.
- [ ] Implement the accepted strong/flexible CLI requirement through the shared C++ API: list/describe operations, validate compositions, inspect plans and run explicit configurations; expose preparation-time parameter overrides and selected observations through the same schema/validation; produce structured failures and meaningful exit codes. These command capabilities are the bounded implementation scope, not an additional general shell. Use exact commands/options/exit codes from the owning specification and test that overrides appear in effective config and sharing identity.
- [ ] Test CLI listing/descriptions against registry fields, validation rejection without numerical callbacks, explicit parameter override precedence and provenance, unknown/invalid overrides, selected logical observations, and distinct success/rejection/failure exit behavior. CLI inspection and execution must use the same effective composition; no independent default insertion.
- [ ] Demo and CLI accept explicit output paths; no external publishing or provider acquisition. Run report/graph/CLI tests, then commit the focused result.

Included requirements for this task:

- [ ] report gaps/policy/count basis, actual advances/observations and elapsed intervals distinctly; gap/evidence limits are still mandatory.
- [ ] finish gates acceptance/cache publication on host outcome plus required domain evidence finalization. Report engine outcome, host outcome, run acceptance and pure feature cache status separately. Cache hits never suppress domain decisions/intents or restore financial state. A required host report cannot be written after accepted marker publication.

## Task 11 — Independent end-to-end verification and measurements

**Files:** verify_fixture.py; execution/SMA tests; fixture executable targets.

**Consumes:** fixture report with raw coefficients and update/request identities. **Produces:** reproducible acceptance evidence and honest baseline measurements.

- [ ] Python oracle recomputes each complete window from raw integers and Fraction; it does not import/use production arithmetic. Check source120, SMA20 outputs101 from19, SMA50 outputs71 from49, four observations71 each, spread raw150000000.
- [ ] Compare shared and deliberately unshared execution for every successful logical output/status/key/action, including different labels, repeated prices and signed fine ticks. For contract-deterministic computation failures, compare logical failure prefix, action order and stopped-run/no-success boundary. Physical resource/cache-I/O/evidence paths can fail at different positions because work differs; test each fail-stop boundary separately and explain differences rather than promising identical operational failures. Test every fixture transport split position; splits cannot reset history or create partial output.
- [ ] Verify first evaluated raws100395000000/100245000000 and final101095000000/100945000000. Add randomized bounded signed inputs against the independent oracle with fixed explicit seed.
- [ ] Verify the separate lag fixture and fresh/shared/unshared/cache-served modes against naive output/status/timing expectations. Explain physical count differences. Include changed input/version/config/build/history/numerics and output-corruption adversarial cases; invalid current sources must reject despite an earlier valid artifact.
- [ ] Run all focused tests strict and sanitized, then the existing dependency-free tests. Run included reader/storage integration with its supplied dependencies. If unavailable, record the bridge Blocked/Unverified and do not mark the full milestone complete; core tests remain independently reportable.
- [ ] Measure preparation, execution, publication/retention and report time independently for a fixed explicit workload. Compare shared/unshared counts, managed peak bytes and elapsed time with source/config/build identities. Do not infer speed from node count.
- [ ] Record exact commands/compiler/versions/results and any limitations. Verify no canonical data layout/API changes or unintended dependencies. Commit acceptance evidence.

Included requirements for this task:

- [ ] independent oracle checks strict rejection, skip outputs/keys/history/readiness, reuse incompatibility, same-gap cache replay and fail-on-present-corruption. All-gap input cannot pass require-value acceptance.
- [ ] first use the same typed sequence via fixture provider and fake checked replay provider, compare statuses/keys/availability/lineage/callback lifetime and all split positions. Use the isolated explicitly enabled storage-integration target with supplied Arrow/Parquet dependencies for real persisted-acquisition replay; no root build migration or silent dependency installation. Task6 is not complete until the actual-API adapter tests pass with Arrow; a dependency-free callback probe is separate supporting evidence. The adapter test depends on the foundation interfaces, not the reverse.
- [ ] named target lexongine_hosted_execution_tests verifies standalone-vs-hosted equivalence, once-per-update state, warming/gap delivery, two toy trials sharing one indicator and recording distinct intents, changed host state leaving market-only feature identity unchanged, and injected host/evidence failure withholding acceptance/cache. Fake financial rules are explicitly probes. Run with warnings-as-errors and sanitizer configuration before execution/integration milestone commits.

## Task 12 — Repository documentation and owner handoff

**Files:** accepted docs/lexongine/README.md, docs/project/lexongine-context.md, engineering-book.md and context.md.

**Consumes:** accepted spec and actual verification. **Produces:** truthful implemented/verified status and remaining integration boundary.

- [ ] Record problem/reason/invariant/trade-off/source check for significant accepted choices. Keep council, psychology and biology analogies out of repository technical docs.
- [ ] Preserve accepted versus proposed versus implemented versus tested distinctions. Do not copy this research's tests as though they passed against product code.
- [ ] Link fixture, explain graph/mapping, report schema and reproduced commands. Record trusted plugin/same-build scope, source availability assumption and accounted-memory limits.
- [ ] Preserve v2 notes for checkpoints, alignment, schedule optimization, native arithmetic alternatives, mutability, stronger plugin boundary, interactive debugging and ML revisit.
- [ ] Update session context and present the isolated branch/diff for owner review. Do not merge or publish without the relevant user instruction.

Included requirements for this task:

- [ ] record source-bridge tested scope versus remaining real complete-bar path. The existing storage baseline exposes MBO/Trades/OrderExecution, not a verified Bar source. An explicit trade-to-bar reducer or ready-Bar source contract is separate domain work before financial strategy integration.
- [ ] document computation engine/source bridge readiness separately from full financial backtesting. Qaedalus's chosen strategy, execution/cost/risk model, order/fill/position/cash/valuation/PnL and real complete-bar/event path remain domain work governed by the repository's research-backtesting-trading scope; existing open choices are not silently selected by Lexongine.


## Focused verification targets

| Task | Nonzero focused CTest match / assertion |
| --- | --- |
| 1 | lexongine_contract_tests — owned records/registry, no request phase in numeric context |
| 2 | lexongine_lifetime_tests — atomic bundles, leases, one allocation charge, module destructor tail |
| 3 | lexongine_plugin_tests — real macOS witness round-trip, ABI mismatch and unload lifetime |
| 4 | lexongine_frontend_tests — strict XML, required source/input/observe policies and effective overrides |
| 5 | lexongine_graph_tests — collisions, recursive ordered equality and effect-order counterexample |
| 6 | lexongine_prepare_tests and lexongine_replay_source_tests — full/gap coverage, admission, actual reader bridge |
| 7 | lexongine_sma_tests — exact signed arithmetic, readiness and original-key lag/skip cases |
| 8 | lexongine_execution_tests and lexongine_hosted_execution_tests — same primitive, once/update and host failures |
| 9 | lexongine_reuse_tests and lexongine_result_store_tests — exact hit/scope miss, corruption/quotas/uncertainty |
| 10 | lexongine_evidence_tests and lexongine_cli_tests — bounded sinks, exact projections, distinct exits |
| 11 | All Lexongine tests plus independent Fraction oracle, strict/sanitized/native plugin and actual source integration |
| 12 | Documentation/example/path/progress crosscheck and focused diff review |

The expected task assertions above supplement each card, not replace it. For Tasks9/10 use typed test sinks before integrated XML finalization; integrated acceptance remains unverified until Task11. Physical resource/cache-I/O failures need their own fail-stop checks, not an impossible claim of identical failure positions across different workloads.

## Verification commands for the implementer

These commands describe future checks; no Lexongine product command was run by the advisor. Supply real approved absolute dependency paths and disposable explicit output directories. The example uses create_new evidence paths: change its path explicitly for repeat runs; never silently overwrite it.

```bash
cmake -S integration/lexongine -B build/lexongine -DCMAKE_BUILD_TYPE=Debug -DLEXONGINE_TINYXML2_SOURCE_DIR=/absolute/approved/tinyxml2-11.0.0 -DLEXONGINE_QAEDALUS_BRIDGE=ON
cmake --build build/lexongine
ctest --test-dir build/lexongine --output-on-failure
build/lexongine/lexongine_fixture --config docs/lexongine/examples/first-computation.xml --output build/lexongine/demo
python3 integration/lexongine/verify_fixture.py build/lexongine/demo/report.xml
```

The isolated bridge target must use supplied Arrow/Parquet CONFIG locations when needed; consult the current storage testing guide rather than guessing root build commands. Foundation work can explicitly configure bridge OFF, but progress must retain its incomplete status. C++ flags: -Wall -Wextra -Wpedantic -Werror, no fast-math. A separate build/lexongine-sanitized uses explicit LEXONGINE_SANITIZERS=ON, ASan/UBSan and -fno-omit-frame-pointer consistently on host/tests/plugin. No native128 requirement. Repeat necessary focused checks when code or unresolved concerns change; avoid gratuitous unrelated reruns.

## Completion boundary

Complete this milestone only after fixture/lag/skip/point-event examples, shared/unshared/cache comparisons, independent arithmetic, source adapter, hosted lifecycle, strict codecs, bounded lifetime/evidence, cross-process reuse, failure paths and real macOS plugin verification pass with reproducible product evidence. Missing environment checks remain explicitly partial/blocked. Task12 reports the branch/diff and limitations; no merge/push/publish is authorized by this prompt.

The result is an implemented computation engine with source/host seams. Real Bar production, chosen strategies, execution/cost/risk models and financial accounting remain separately scoped Qaedalus work. Do not add them just to call the demo a backtest.
