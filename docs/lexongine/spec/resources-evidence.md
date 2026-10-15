# Resources, diagnostics and final acceptance

Public host API:

```cpp
Result<ParsedComposition> parse_xml(std::string_view,const ParseLimits&) noexcept;
Result<Composition> resolve_composition(const ParsedComposition&,const Registry&) noexcept;
Result<PrepareResult> prepare(const Composition&,const Registry&,SourceResolver&,
  std::shared_ptr<ResultStore>,const PrepareOptions&) noexcept;
Result<RunInstance> instantiate(std::shared_ptr<const PreparedPlan>,
                              RunServices) noexcept;
Result<RunReport> execute(RunInstance&) noexcept;
Result<std::string> export_dot(const PreparedPlan&,GraphView) noexcept;
Result<std::string> export_plan_xml(const PreparedPlan&) noexcept;
Result<std::string> export_report_xml(const RunReport&) noexcept;
```

RunServices owns resource-account and typed observation adapters, configured RequiredEvidenceSet and integration finalizer; all match frozen plan contracts and are registered before execute. A normal execution failure returns a terminal RunReport with cause/status. Result<RunReport> Diagnostic is reserved for an API/precondition failure that prevents producing that preallocated report (for example re-executing a terminal instance). No required report may be added after execution and retroactively alter acceptance.

RequiredEvidenceSpec={name,format,absolute_path,open_policy CreateNew,max_bytes,max_records,flush_policy,failure Stop}. RequiredEvidenceSet prepares sinks, receives bounded records, finalizes each with checked flush/close and returns EvidenceInventory={name,path,byte_count,sha256,finalized}. The embedded snapshot inventory excludes the snapshot itself and the final acceptance marker. After snapshot finalization, its name/length/digest are added only to the external full inventory and final marker. The marker's inventory excludes itself; no self-referential digest is constructed. Required callbacks: open(spec),write(record_bytes),finalize() return Result; abandon/destroy noexcept. Retention log is its accepted separate sink. Plan/DOT exports chosen for the CLI are finalized before execution; run snapshot and retention log close before final acceptance. File names/paths come from explicit XML/CLI, never silently from run ID.

Selected local commit protocol under the accepted bounded-cache package:

1. Pin validated sources/artifacts; freeze policies/sinks; open required evidence and lock store where enabled. Reserve failure envelope and final return/status storage before numerical work.
2. Execute logical schedule, resolving physical producers once per applicable key. Accumulate/stage full immutable output streams. No new cache entry is eligible.
3. At exact successful scope/readiness closure mark NumericalOutcome Completed, Acceptance Pending. Decide configured cache capacity before starting each new entry write; capacity bypass is not an I/O-error fallback.
4. Finish bounded payloads/manifests and immutable snapshot; validate lengths/digests; close all required logs/exports/streams; prepare and close the temporary acceptance record. All fallible mandatory work occurs here.
5. With new entries, atomically publish the one store-local accepted-run marker as final required I/O. No-new-entry/disabled/bypass runs do not write a store marker; accept after declared evidence finalization using preallocated in-memory status. For a no-new-entry run, an explicitly required standalone persisted acceptance envelope may instead be its sole final I/O. If new cache entries exist, the store marker is the one authority: any outside required report/envelope must be finalized as Pending evidence/link before that marker. Reject a configuration demanding two independent required Accepted publications; an optional postcommit projection is only delivery.
6. Committed→Accepted/Published by nonthrowing transition. NotCommitted→Rejected/NotPublished with cause. Ambiguous publication→bounded locked reconciliation; unresolved→Unconfirmed, no success/score. Recovery may establish acceptance from a fully validated authoritative marker even if the original caller never received acknowledgement. This is different from a proven failed/rejected originating run.
7. No mandatory append/copy/fsync/callback occurs after the confirmed marker. Optional stdout projections have delivery status separate from acceptance. Crash-durable preservation is not promised; malformed present referenced data fails preparation under the accepted corruption policy. Provisional unaccepted files are ineligible. No all-file rollback or transaction is claimed.

Retention format key_value_lines_v1: UTF-8 one event per line, fixed field order `version,event,run,clock,step,allocation,producer,publication,bytes,age_steps,holders,reason`; strings JSON-escaped and quoted, integers canonical decimal; version1. Events allocated/hold_acquired/hold_released/long_retention/outstanding_at_close. Unknown external owner names are `external_unknown`, not invented IDs. Log metadata owns no payload handle. Warning once per allocation at threshold, bounded by explicit quota. Final close snapshots live external holds; their later release updates nonthrowing accounting/pins without writing to a closed mandatory log or changing final acceptance.

## Stable diagnostics, CLI and verification obligations

Diagnostic={FailureCode code; array<char,256> message; uint16 length; bool truncated; optional preassigned logical/request ordinals and DiagnosticKey{uint32 clock_ordinal,uint64 sequence}}. Stable primary codes: InvalidConfig,UnknownDefinition,DuplicateDefinition,UnsupportedContract,GraphCycle,TypeMismatch,SourceInvalid,SourceCoverage,SourceChanged,SourceKnownBoundViolation,HistoryInsufficient,ResourcePlanExceeded,ResourceExceeded,UpdateProtocol,FutureRead,MissingRequired,NumericBound,NumericOverflow,CallbackException,OutputInvalid,EvidenceQuota,EvidenceIO,CacheCorrupt,CacheIO,CacheBusy,CommitUnconfirmed,AlreadyExecuted. Capture primary cause in reserved storage; secondary failures cannot replace it. Avoid allocating arbitrary IDs while handling quota/allocation failure; records resolve preassigned ordinal references later. DiagnosticKey never owns ClockId string; capturing/copying the reserved primary cause is allocation-free.

Selected CLI: `lexongine list`, `describe --operation NAME --version N --implementation LABEL`, `validate --config PATH`, `plan --config PATH --plan PATH --before-dot PATH --after-dot PATH`, `run --config PATH --report PATH`; repeated `--set node.PARAM=VALUE` and `--observe REQUEST_ID` are explicit preparation-time overrides. Invalid/duplicate overrides reject; no runtime parameter mutation. CLI requests supplied evidence paths become frozen required sinks. With new cache entries, --report is a finalized precommit run_snapshot marked Pending and linked by run/commit ID to the store marker; terminal API/stdout projects the final status. It cannot independently claim durable Accepted before the marker. Without new entries a standalone final acceptance envelope is allowed only when explicitly configured; otherwise persisted snapshot plus terminal in-memory status is the declared contract. `--retention-log PATH` overrides the explicit config path with provenance. Sharing/reuse overrides, if supplied, must be explicit valid enum values and exported. No cwd-derived default cache/evidence path.

Exit codes: 0 accepted/all selected requests admitted; 2 syntax/config/preparation rejection; 3 execution or required-finalization failure; 4 API/internal/unsupported platform prerequisite failure; 5 acceptance Unconfirmed; 6 accepted run with explicitly reported rejected requested compositions. A required-value observation failing at runtime is execution failure, not preparation exit2. CLI selection changing requests triggers complete preparation again. `validate` never runs numerical callbacks. Report optional stdout failure is delivery exit3 with accepted state preserved; it is not evidence that the run was rejected.

Contract checks before each task commit: build its named targets; run focused tests against these transitions/reference cases; inspect exact diff for interface/default/identity drift; record command/results/HEAD; update progress. Later tasks cannot compensate by weakening early assertions. See plan task cards for commands and expected outcomes. Do not claim success from an AI review alone. Linux declaration/probe checks validate design examples only; actual macOS dynamic loading, type equality, output lifetime and filesystem adapter checks remain required product verification.

## Lifetime and resource obligations

Every host-managed source/state/scratch/staging/retention/graph/evidence allocation is reserved and charged before allocation. Estimates, configured bounds, current charge and peak are distinct evidence. Shared holders charge one payload allocation once until final release; their metadata is separately accounted. External immutable holders keep the host resource account and relevant module pins alive after a run. No forced invalidation releases a live payload to satisfy a quota.

Host control blocks retain code pins around the complete typed destruction call, including its returning tail. A pin inside a plugin object is insufficient. Destruction, abandon and cleanup do not throw. Deep immutability is a registered type-specific trusted contract, not runtime inspection of arbitrary C++ constness. See [components](components.md).

Retention diagnostics use a separate bounded metadata-only log with explicit paths, limits, flush/overflow/failure policy and warning threshold. Instrumented holder/reason labels identify retention; use_count alone cannot. Emit bounded threshold warnings and a final outstanding-holds snapshot. Logging must not itself own payload handles. A release after the log closes updates lifetime accounting without attempting a write to the closed required sink.

Reported host-managed limits are not a hard process-RSS guarantee for native plugin or Arrow/Parquet internal allocations. Preserve Qaedalus storage's existing publication/fsync contract independently. Lexongine's marker protocol provides process-level accepted eligibility, not an all-file transaction or a power-loss durability promise.
