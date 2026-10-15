# Qaedalus source and backtest-host integration

Owner requirement: Lexongine must consume Qaedalus's existing ingestion/normalization/storage/query/replay infrastructure; specify the connection now to avoid building a fixture-only engine and later redoing it. This section selects the thin provider adapter under already accepted source contracts. It does not authorize network acquisition, a replay backend rewrite or a real trade-to-bar implementation.

### Verified baseline boundary

Rechecked the actual remote implementation/data-integrity-2026-10-03 head: f75cd3c179f3b070f9a85c054ec3704b89f4cb69. Read AGENTS.md/context, storage/backend.hpp, dataset.hpp, integrity/model.hpp, integrity/prepare.hpp, ingestion/query_plan.hpp and relevant Parquet backend sections at that exact commit. No local checkout/tests. The remote Lexongine context remains absent. Repository context reports historical verified tests; this is not a rerun.

- MarketDataReader exposes callback-based read_batches_checked(DataFragment,BatchProjection,ConsumerRequirements,BatchConsumer) and stream_ordered_events(span<DataFragment>,ConsumerRequirements,SequencedEventConsumer). Abstract defaults can return NotImplemented; do not fall back to unchecked access. ParquetStorageBackend overrides these paths with eligibility checks.
- SequencedEventConsumer receives const integrity::BoundObservation&={StreamId stream_id,uint64 ordinal,Observation event}. Observation is variant<MboEvent,Trade,OrderExecution>. DataKind lists Mbo,Trades,OrderExecution, not Bars. Canonical Bar exists as a domain type but a stored Bar replay path/trade-to-bar builder is not verified here.
- DataFragment owns data kind, stream identity, time range, schema_version,locator,version_id,acquisition_id,package_locator,row_stream_id,evidence_digest. Metadata has adapter/mapping versions, source artifacts and optional checksum. These are sources for binding/fingerprint checks, not permission to treat empty/optional identity fields as valid cache provenance.
- Ordered replay preserves a shared acquisition-scoped ordinal; unrelated acquisitions cannot be implicitly merged. Parquet's ordered path forces required ordering/groups and initial-state checks for MBO. Source receive time is provider evidence, not automatically simulated decision-time availability.

### Concrete adapter and service ownership

Proposed file integration/lexongine/qaedalus_replay_source.hpp/.cpp registers typed providers through the same TypedSourceProvider<T,Inspection,Data,Cursor> as the fixture. Its host-owned provider callbacks own an explicitly injected MarketDataReader handle plus the declared ReplaySourceBinding; typed std::function adapters permit those owned captures without ambient/global reader lookup. SourceResolver pins their code/control lifetime. Every behavior-bearing binding/selection is declared and fingerprinted; the reader capability itself stays confined to provider validation, not numerical kernels. Core registry/executor has no Arrow/Parquet/provider client dependency. One frozen reader/query/fragment binding produces immutable data; each run gets its own cursor. Any operation factory captures only declared prepared facts/pins, not an undeclared reader capability.

ReplaySourceBinding fields (owned integration record):

| Field | Requirement |
| --- | --- |
| original_query | explicit quant::ingestion::MarketDataQuery, preserving event-time/source-receive constraints and usability policy; no new source acquisition |
| selected_fragments | owned ordered vector<DataFragment> returned/supplied by Qaedalus selection; exact published versions/acquisitions/content/evidence/reference associations resolved during preparation |
| consumer_requirements | all five booleans ordering,groups,initial_state,allow_degraded,explicit_partial explicitly specified; existing reader defaults are not Lexongine defaults |
| delivery_mode | explicit analytical_checked or ordered_event; select ordered_event for order-sensitive replay, never timestamp-sort |
| payload_kind | explicit registered canonical T, supported by selected fragment kind; no universal row conversion |
| expected_scope | declared clock/query scope, complete coverage or explicit gap ledger and original source succession mapping |
| availability_contract | explicit policy/version/fields for simulated availability; event_time/source_receive_time alone cannot invent latency |
| missing_intervals | explicit Strict/Skip plus compatible source expected-interval semantics; cannot override unresolved source ordering/groups/initial-state/structural failures |
| materialization_limits | explicit maximum records,decoded bytes,metadata/gap/evidence bytes; charged before allocation; excess rejects preparation |

Existing source selectors refer to this binding through a declared typed provider config/lookup service. Keep query selection in Qaedalus: do not implement a second query planner, storage catalog or automatic ingestion in Lexongine. A prepared source keeps exact selected versions/immutable content pinned; a mutable locator is not identity.

### Callback replay to engine cursor — bounded v1 mechanism

1. Inspect query/fragments/metadata and estimate resources. Reject unsupported replay/selected kind, unresolved reference/version/order/coverage and invalid policy before allocating or numeric processing.
2. During provider validation, call the checked reader path with explicit requirements. Capture returned canonical typed records and source references into host-owned charged immutable bounded storage, copying any callback-scoped views before their lifetime ends. Retain original acquisition/StreamId/ordinal and timestamps. Full reader/provider validation must complete successfully before accepting this storage. No numerical kernel receives reader/vector access.
3. Because the inspected reader is synchronous push/callback based, the first adapter materializes the bounded selected slice once, then exposes SourceCursor::next(current UpdateContext). It does not assume the reader supports pause/resume, invent a coroutine or reopen/revalidate files on every numerical step. No unbounded queue/whole dataset buffering: an over-limit scope rejects. Actual backend-internal transient allocations are separately reported; host-managed quota is not a hard process-RSS guarantee.
4. Validated source metadata owns a bounded host-only ordered timeline descriptor stream: key, event/interval kind, TemporalExtent (PointTime or Interval), availability and declared gap/end metadata. advance_one obtains the next descriptor and constructs its current UpdateContext before invoking SourceCursor::next(context). Irregular Trade/MBO replay uses its explicitly registered event timing protocol, never uniform fixture-bar intervals or an inferred event-time availability default. Numerical kernels cannot inspect the timeline list/future payloads. A fresh cursor delivers only the currently eligible typed record or declared SourceGap/SourceEnd through the same source publication path used by the fixture. Reads from other kernels cannot drive replay. Available-at and original succession are checked; engine clock keys are separate from acquisition ordinals.
5. Source fingerprint covers exact version/content/reference/evidence, original query/filter, explicit consumer/ordering/availability/coverage/missing policies and source-adapter implementation. Ordered transitive identity then makes upstream query/replay changes invalidate downstream reuse. Original selection/scope/order is visible in plan/evidence.

Bounded materialization is a physical v1 adapter choice, not a promise about ideal performance. A later validated streaming/spool cursor can replace it behind the same source/provider contract, but must prove immutable binding, complete required validation before relevant acceptance, causal delivery, limits and equivalent source outcomes. Never implement a second hidden revalidation pass/automatic snapshot continuation just to claim streaming.

### Fixture origin and compatibility tests

The first120 complete bars are generated locally by the versioned fixture provider. They are synthetic, reproducible and not downloaded market history: close=100+0.01*i, i=0..119, exact Price9 raw100000000000+10000000*i; O/H/L/C equal, volume1, explicit one-minute intervals and IDs/timing from [execution](execution.md). This deliberately makes every expected mean/difference known independently. Negative/gap/adversarial fixtures are separate declared cases.

Use the same SourceRequest→inspect→validate→immutable snapshot→fresh cursor→publication contract for synthetic and Qaedalus replay providers. The data source implementation changes; SMA/binding/execution does not. Prototype the callback-adapter fit before freezing source declarations; run the following tests before completing Task6 or the dependent execution milestone (actual MarketDataReader tests require Arrow, as specified in [Qaedalus integration](qaedalus-integration.md)):

- Run one identical canonical typed sequence and metadata through an in-memory fixture provider and a fake checked Qaedalus reader/provider; compare output/status/key/availability and original semantic source references, accounting for different provider implementation identities. Use a small Trade sequence supported by the actual reader variant for this bridge test; the120-bar fixture remains separate. The fake verifies the actual callback→cursor adapter mechanism, not real market correctness.
- Reject unknown/mismatched versions/content, unchecked-only reader, missing order/group/initial-state evidence, wrong stream, source mutation, callback lifetime misuse and over-limit materialization before numeric callbacks.
- Split the same prepared input at every transport boundary; neither state/history nor source identity changes from a physical batch split. Actual changed acquisition/selection/order still changes identity; no cross-acquisition merge.
- With storage integration dependencies present, feed existing deterministic persisted acquisitions through the real checked MarketDataReader path and compare its emitted records/order/validation to the adapter's immutable snapshot/cursor. This is a source-bridge integration test, not an implemented complete-bar strategy.

For the eventual SMA on real data: if no explicit ready Bar source exists, typed replay of validated Trades must feed an explicit trade-to-bar reducer with separately specified interval/session/empty/closure/availability/late-data policies. Neither the storage adapter nor core silently converts raw trades or MBO into bars. Specify that domain reducer before its implementation; no claim of persisted Bar support or full backtesting integration follows from this interface design.

[Verified reader header](../../../src/quant/storage/backend.hpp), [data fragments](../../../src/quant/storage/dataset.hpp), [integrity records](../../../src/quant/integrity/model.hpp) and [query planning](../../../src/quant/ingestion/query_plan.hpp) are the integration references.

## Backtesting ownership and host-driven execution

The owner asks whether Lexongine performs backtesting and authorizes the necessary contract/plan adaptations under the established full direction. Selected boundary: Lexongine executes reusable computation graphs inside a Qaedalus backtest; Qaedalus owns the historical experiment and financial simulation. This is consistent with the inspected docs/project/research-backtesting-trading-scope.md at f75cd3c, whose broad responsibilities are accepted but exact first strategy, fill/cost/order/accounting model remain proposals/open domain choices. Do not treat graph completion as evidence of a complete backtester.

| Layer / owner | Responsibility | Explicit boundary |
| --- | --- | --- |
| Qaedalus data infrastructure | ingestion, canonical normalization, storage/query selection, validated replay and reference/evidence | source versions/order/coverage/availability delivered through the source contract above adapter |
| Lexongine reusable engine | typed graph, sources/reducers/adapters/math, startup, fixed-run execution, exact sharing/reuse, immutable publications, execution/resources/evidence | no implicit broker, cash/position ledger, financial fill model, risk default or strategy selection |
| Qaedalus BacktestSession (proposed host integration record) | trial/account ownership, decision function, signal→target→intent→risk/order, execution/cost model, fills, cash/positions, valuation/PnL and financial result acceptance | financial assumptions stay explicitly configured and domain-owned; independent trials never share order/account state implicitly |

Financial mathematical functions can be authored as typed Qaedalus components executed by Lexongine. Ownership of their financial meaning/type/arithmetic/policy stays in Qaedalus. A simulated order submission is a unique effect, not an eligible shared or cached numerical producer. A pure signal is distinct from an order, and a requested order is distinct from a fill.

### One execution primitive for both standalone and hosted use

Add these owned declarations in execution.hpp/evidence.hpp before dependent execution commits; they supplement the existing API, without a second scheduler:

```cpp
Result<StepReceipt> advance_one(RunInstance&) noexcept;
Result<void> fail_host(RunInstance&,const Diagnostic&) noexcept;
Result<void> abort_host(RunInstance&,const Diagnostic&) noexcept;
Result<RunReport> finish(RunInstance&,IntegrationCompletion) noexcept;
Result<RunReport> execute(RunInstance&) noexcept;
```

- StepReceipt fields: status{Processed,Gap,Exhausted,Stopped}, optional current UpdateKey/TemporalExtent/availability, optional gap SequenceScope/reason, bounded immutable current source/observation handles and original provenance, logical reach/publication/advance summary, optional fixed Diagnostic. Processed includes producer startup Warming; the host still receives every market/timeline update needed for simulation. Gap has the explicit SourceGap control and no fabricated value. Exhausted has exact completed scope, not a zero value. Stopped carries the original run cause and forbids more numerical work. These receipt views obey declared lifetime/retention and resource limits; no historical vector or future-reader capability is exposed.
- IntegrationCompletion fields: kind{Completed,Failed,Aborted}, optional fixed Diagnostic, declared host_contract_id/version and immutable host experiment identity reference. It reports the participating host's actual terminal outcome; it is not a substitute for finalizing registered required evidence. Hosted mode and standalone mode are explicit `driver="hosted"|"standalone"` values in XML/run configuration/effective plan, separate from synchronous execution; no hidden controller is selected.
- RunServices owns registered observation adapters/required sinks and any explicit integration lifecycle callbacks before execution. Financial mutable state belongs to BacktestSession, never a numerical kernel capture or undeclared singleton. Host experiment configuration affects run/report identity; it affects computation identity only when declared numerical inputs/semantics actually depend on it.
- advance_one on Created opens/prepares required services and transitions to Running. It processes exactly one declared next source timeline event through the same frozen logical-first-occurrence schedule, maintaining existing state/cursors/alias boundaries. It never reinstantiates per bar or recomputes initialization. Ordinary reads do not drive it. API misuse returns Diagnostic; runtime failure returns Stopped with saved cause.
- Exhausted or Stopped enters AwaitingCompletion (new lifecycle state), forbidding further advancement. advance_one prepares and reserves its receipt/ownership transfer before executing fallible work, so the receipt cannot throw after logical effects/publications. A terminal/end receipt is emitted once; repeated advancement rejects with UpdateProtocol/AlreadyExecuted as appropriate. fail_host/abort_host reject calls after Terminal and cannot reopen an accepted run; on an active participating run they immediately stop further graph scheduling, preserve the primary cause and enter AwaitingCompletion without throwing. Earlier publications/actions remain partial evidence.
- finish checks source scope/readiness and host completion. Completed host status before required scope exhaustion is rejected, not an accepted truncated run. Failed/Aborted never promotes a cache entry. Then it runs the existing required-sink finalization and single acceptance publication protocol. Required financial evidence can be registered as typed domain sinks; no required host/report I/O may occur after accepted cache publication. Multiple finish/execute on a terminal instance rejects.
- execute is the standalone convenience wrapper: repeatedly call advance_one until Exhausted/Stopped, then invoke the same finish with explicit standalone completion. Hosted mode uses repeated advance_one plus finish. An explicit execution mode prevents mixing the two paths in one run. Numerical/status/availability/alias/action behavior must be identical under matching inputs/services; physical driver bookkeeping is reported separately.

### V1 financial state and feedback

Keep portfolio/account feedback outside the feature graph in this bounded engine slice. At each processed complete market update, the host receives the currently available source/features, reconciles previously pending orders/fills under its explicit financial time model, and evaluates the strategy using those features plus that trial's account state. It creates separate order intents/effects, records transitions and advances to the next timeline event. Computing market-only features before that reconciliation is safe because they have no account-state dependency; it does not authorize same-close fills or earlier use of a bar's future close.

Host financial decision/effect processing occurs outside ordinary numeric kernels and is separately identified per trial/account. Existing logical observation callbacks may record observations/queue domain requests at their already accepted logical boundaries; they cannot secretly make feature math depend on captured account state. The host applies financial decisions in its declared domain stage. A valid domain risk rejection/no-fill is an ordinary modeled outcome and does not by itself fail the engine. An exception/invalid transition/required-evidence failure in those participating stages calls fail_host and prevents accepted run/score/cache promotion. Runtime native crash/UB remains outside normal structured failure guarantees.

For example, two trials can share SMA20. TrialA may already own shares, trialB may have none; Qaedalus decides separately for each and records two independent intent occurrences when both generate them. Same prices/indicator values do not establish equal financial state or justify deduplicating orders. Reusing an SMA outcome stream in a later run never reuses orders, fills or a portfolio ledger.

Under Skip, no missing market value creates a fill/valuation/decision. The host receives a gap control event and original elapsed time. Its policy for outstanding orders/marking across gaps must be explicit when the financial backtester is designed; do not infer a tradable price from a retained indicator. Startup Warming similarly suppresses evaluated strategy decisions until ready, but does not erase earlier market events needed to manage existing domain state.

If a later composition requires account-dependent sizing/risk/math inside the graph, it must add a declared immutable per-step account input with trial/account identity, state version/update key, availability and transition provenance. Same-step cyclic graph feedback remains unsupported; carry-over state must cross an explicit next-step boundary. Unknown evolving account-input history cannot satisfy v1's exact-full-scope persistent artifact matching. This extension is identified now but not implemented silently as an ambient account pointer or a new numerical inheritance tree.

### Before-commit checks and milestone naming

1. Compare standalone execute and hosted repeated advance_one on the fixture: identical logical values/status/key/availability/lineage, physical advances and unique action order; no reset/replay per bar, no advance after end/stop, no success after early finish.
2. Use a test-only deterministic host decision rule, two named toy trial states and a unique intent ledger. Both consume one shared indicator, both preserve distinct intents; changing only host trial state changes its decisions without changing pure feature identity. This is an integration-contract probe, not a validated financial accounting model or strategy.
3. Inject host decision/controller failure after a successful graph step and after numerical exhaustion; include required host evidence close failure. Remaining steps stop and final acceptance/cache promotion fails; prior effects are partial evidence. Preserve earlier deterministic failure-prefix rules and reserved diagnostics.
4. Verify warming/gap receipts reach the host, no future-source access leaks, and skipped intervals never fabricate market/financial actions. Source transport splits and wrapper choice cannot reset reducer state.
5. Name the first deliverable accurately: Lexongine computation engine + Qaedalus source/host integration contracts and probes. Full end-to-end backtesting additionally needs a real complete-bar/event path, chosen strategy, explicit execution/cost/risk rules, financial state transitions and independently validated PnL. Those domain components are not supplied by the first indicator demo.

Read source: https://github.com/zenpuddah/quant-project/blob/f75cd3c179f3b070f9a85c054ec3704b89f4cb69/docs/project/research-backtesting-trading-scope.md . This section is a selected architecture/implementation contract under owner delegation; no backtest/engine product implementation is claimed.

## Build prerequisites and truthful completion

The actual MarketDataReader header includes Arrow interchange declarations and checked APIs return arrow::Status. A fake subclass of that actual API still requires Arrow headers/libraries; it is not a dependency-free core test. Keep three distinct targets:

| Target | Dependencies / assertion |
| --- | --- |
| Reusable core, fixture and generic callback probe | C++20 and accepted TinyXML2 for frontend only; no Arrow includes in core. The generic probe tests bounded copying/cursor lifetime, not actual reader integration. |
| Qaedalus reader adapter and actual-API fake-reader test | Explicit Arrow configuration; compiles against the existing MarketDataReader and supported Trade variant. |
| Persisted acquisition integration | Existing Arrow/Parquet and storage dependencies; runs deterministic published acquisition replay through the actual checked reader. |

Use an explicit isolated CMake option `LEXONGINE_QAEDALUS_BRIDGE=ON|OFF`; ON requires supplied prerequisites and creates adapter/test targets, OFF prints and records bridge Blocked/Unverified. This switch supports foundation work; it does not remove the included bridge deliverable or let the full milestone be called complete. No silent dependency download/install or private imitation of the actual reader API. Record native macOS Arrow CONFIG availability separately from earlier PyArrow-linking evidence. The core can pass independently while the source integration remains blocked.

Before completing Task6 and the full included-source milestone, compile/test the actual adapter with its prerequisites. Before final acceptance, verify its deterministic persisted-input integration in a supplied supported environment. A generic probe cannot substitute for either claim. Native macOS same-build plugin round-trip is also required evidence; a Linux-only pass remains partial.
