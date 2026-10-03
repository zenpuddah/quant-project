# Design Decision Coverage Review — 2026-10-01

## Status and conclusion

- **Review:** Checked the working tree based on commit `76e66a6`, including the uncommitted owner testing guide/manual example.
- **Finding:** Most first-slice design choices for canonical data, historical ingestion, query planning, and basic storage/replay are documented and represented in code.
- **Finding:** Happy-path round trips work, but artifact immutability and the row-to-metadata validation contract are not closed. Passing the present tests is not proof of all accepted invariants.
- **Proposal:** Resolve the focused storage closure issues below before treating persisted datasets as authoritative inputs to a research/backtest slice.
- **Boundary:** Recommendations in this review are not accepted designs and do not authorize production changes. Learning and architecture discussion can continue while these questions are resolved.
- **Accepted follow-up — 2026-10-03:** The owner settled the reviewed ingestion/storage design contracts in `docs/architecture/phase1-data-integrity-session-2026-10-03.md`. That later document governs the closure design; this review retains the original reproduced behavior and proposals. The new guarantees still need implementation and regression verification. The current task is described in `docs/project/opencode-data-integrity-handoff-2026-10-03.md`.

## Decision coverage

“Implemented” refers to the current bounded slice, not the entire Phase 1 platform. “Partial” distinguishes representation/preservation from an enforced invariant.

| Responsibility / decision | Status | Implementation and evidence |
|---|---|---|
| Canonical identity separate from provider IDs/symbols | Implemented in ingestion; partial across storage | `value_types.hpp`, `instrument_mapping.hpp`, Databento metadata sidecar; storage labeling gap in finding 2 |
| Venue/source identity separate from instrument | Implemented | Nonzero compact IDs, reference tables, one `MboBuffer` per stream; multi-scope ingestion tests |
| Point-in-time reference/mapping validity | Implemented for valid-time lookup | `ReferenceHistory::at`, mapping interval splitting, half-open boundary tests; research information-availability semantics remain to be designed |
| Exact prices, quantities, and money | Implemented for values | Scales 9/6/2, exact normalization, checked same-scale arithmetic; price × quantity and accounting rounding explicitly deferred |
| 64-byte, 64-byte-aligned MBO record | Implemented and checked | Layout assertions, typed `MboBuffer` writers, presence masks, data-model and storage round trips |
| MBO mutation distinct from market Trade/OrderExecution | Implemented | Databento Trade/Fill do not append book mutations; Cancel does; deterministic translation assertions |
| Event time versus source receive time | Implemented for accepted first provider | Dual query constraints, explicit fetch derivation/strict policy, event-time mappings, receive-only rejection |
| Canonical query/provider boundary | Implemented for first provider | `ProviderPort`, official SDK only in the adapter, no SDK request types in query/domain; generalizing receive-time fetch planning to other providers remains future work |
| Shared explain/execution decisions | Implemented and tested | `QueryPlanner` used by `explain` and `ingest`; fake-provider calls match the explained plan |
| Scoped quality distinct from consumer usability | Implemented and tested | `DataStateReducer`, scoped segments, default/custom usability policies, evidence-free Unknown unresolved |
| Provider/API failure distinct from market-data facts | Implemented first behavior; partial policy | Provider exceptions propagate rather than becoming Missing; retries and structured partial-operation failure envelopes remain deferred |
| Batch-first synchronous ingestion | Implemented within accepted development limit | One provider request → one materialized `ProviderBatch`; genuinely bounded multi-batch ingestion is not implemented |
| Recovery and caching remain ghost/no-op seams | Implemented as specified | Structured `RecoveryContext`/`RecoveryPlan`, `NoopRecoveryPolicy`, `NoopCache`; non-full-miss cache results explicitly unsupported |
| Arrow interchange / Parquet persistence / reader boundary | Implemented and happy-path tested | MBO/Trade/OrderExecution schemas/codecs, Full/Replay projection, `MarketDataReader`, `StorageBackend`, `ParquetStorageBackend` |
| Dataset-local metadata with artifact, reference metadata external | Partial | IDs, range, acquisition mode, versions, quality-reference strings, range-aware source artifacts and optional supplied checksum persist; full ingestion evidence/reference persistence has no integration contract yet |
| Source order preserved without timestamp sorting/global ordering | Partial | Array/file iteration preserves caller row order; sequence/channel/flags retained; no general provider-valid ordering validator or cross-kind/multi-fragment replay merge |
| Immutable observed history | Not enforced by Parquet writer | Finding 1: same-identity writes replace the original artifact |
| C++/Python research-first, interview-grade scope | Accepted scope; implementation deferred | Existing C++ foundation and independent Python inspection; scope document keeps strategy, execution, accounting and research decisions open |
| CLion-compatible isolated dependency targets | Implemented; native package verification pending | Databento pinned SDK target, storage environment-provided Arrow/Parquet target; no root CMake migration |

## Findings needing closure

### 1. High priority — Existing fragments can be silently overwritten

**Evidence:** `parquet_backend.hpp:310-324` derives a deterministic filename from kind, stream, range, schema version and optional supplied checksum. `write` opens the final path at line 407 with no create-only/existing-artifact policy or staging/publication step.

A scratch probe wrote a price-100 event, then price 101 with the same metadata. Both writes succeeded and returned the same locator. Reading through the original `DataFragment` returned price 101:

```text
overwrite: same_locator=1 original_fragment_price_raw=101000000000 (original=100000000000)
```

**Conflict:** `phase1-data-model.md` explicitly requires that observed history is not silently overwritten. Schema/checksum token sanitization can also map distinct strings onto the same filename; the current optional checksum is not computed or verified by storage.

**Open decision:** Artifact identity, repeated-write/idempotency behavior, and failed-write publication semantics.

**Proposal:** Keep the first policy small: immutable published artifacts, reject an existing destination, and publish only after a successful staged write. An intentional new observation/revision must receive a distinct accepted identity. This does not require implementing FGIT, a database, or a generalized catalog.

### 2. High priority — Rows and declared stream/range can disagree

**Evidence:** `write` validates metadata and column schemas, but not their relationship to row values. `to_arrow(MboBuffer)` removes stream context from the rows; Trade/OrderExecution encoders also omit header identity without checking that inputs share one stream. Readers recreate identity from the supplied/persisted stream.

Scratch probes observed:

```text
range: declared=[200,205) replay_event_time=100
identity: input_instrument=42 replay_instrument=99
mixed_trades: input_second_instrument=99 restored_second_instrument=42
```

**Impact:** A correct serialization round trip can still carry incorrect identity or range claims. Comparing fragment metadata with footer metadata checks two labels, not whether either matches the original observations.

**Open decision:** Which boundary owns stream grouping, binding Arrow batches to stream identity, and validating event-time membership in the declared half-open range? The generic writer cannot recover identity that was already discarded by an encoder.

**Proposal:** Explicitly bind batch scope before identity is removed, reject mixed-scope inputs, and validate row/range membership before publication. Keep one stream per fragment. Choose the smallest accepted codec/writer contract rather than inventing an ingestion persistence service implicitly.

### 3. Medium priority — Canonical row validation is incomplete at storage boundaries

**Evidence:** Schema checks validate names/types/nullability. Decoder constructors catch some invalid values, and MBO append checks action shape. However, neither the Trade encoder nor decoder invokes the existing positive-trade-quantity validation in `data/validation.hpp`; writer validation is schema-level.

The probe persisted and replayed a zero-quantity Trade even though the canonical validator rejects it:

```text
zero_trade: canonical_validator_rejects=1 replay_quantity_raw=0
```

**Open decision:** Is storage guaranteed to receive validated canonical batches, or must codec/write/read boundaries enforce canonical validity? If caller validation is the precondition, it must be explicit and reliably bound to the persisted data.

**Follow-up after acceptance:** Cover positive Trade/OrderExecution quantities, malformed batch structure, inconsistent MBO physical/control fields, and rejection before leaving a published artifact. Do not redefine financial semantics or widen `MboRecord`.

### 4. Medium priority — Schema version is preserved but not a compatibility gate

**Evidence:** `DatasetLocalMetadata` requires only a nonempty version; the decoder selects its current schema from `DataKind`. A probe labeled current columns `canonical-v999`; write and replay both succeeded:

```text
version: schema=canonical-v999 decoded_events=1
```

**Open decision:** Supported version identifiers and behavior when a fragment declares an unsupported version. Matching a requested label with the footer is not a decoder compatibility check.

**Proposal:** Document the first supported encoding/version and fail explicitly on unsupported versions. Migration remains deferred; a version registry/framework is unnecessary for one accepted encoding.

### 5. Integration gap — Ingestion evidence is not yet carried end-to-end into storage

**Evidence:** `IngestionMetadata` retains query, ingestion time, scoped quality/state, provider record sidecars, and provider batch conditions. `DatasetLocalMetadata` stores a smaller set and opaque quality references. There is no tested `IngestionResult` → grouped fragments + retained evidence path. The current Databento adapter also does not populate `source_artifacts` merely because the result type can hold them.

**Assessment:** This is an intentionally separate storage foundation, not an accepted ingestion redesign. The manual example proves synthetic canonical storage, not full Databento → persisted reproducible research data.

**Open decisions when connecting the slices:** Evidence/artifact identity, scoped reference resolution, provider sidecar retention, and which immutable dataset/run inputs a researcher selects. Preserve actual evidence; do not fabricate provenance or treat quality-reference strings as stored quality observations.

### 6. Partial invariant — Provider-valid ordering is not fully checked

**Evidence:** The provider/ingestor preserve record iteration order and ordering fields. The Parquet reader follows row order. The smoke reports sequence min/max and observed channels; it does not verify feed-valid sequence progression. Provider bad-book flags can produce quality evidence, but there is no generic sequence-order/gap checker.

**Open decision before order-sensitive consumers:** State the source-order precondition and who checks feed-specific validity. Sequence resets, repeated sequence values, channels, filtered records, and cross-kind ordering require source semantics; generic timestamp sorting or “every number must increase by one” is not a valid substitute.

**Existing known follow-up:** Databento daily condition boundaries remain unresolved. The adapter reduces returned daily conditions over the request segment; the prior smoke observed an extra condition date. Resolve the date inclusion/scope detail before expanding that quality interpretation to longer ranges.

## Decisions that should remain open for the next slice

These are not defects in the current data foundation. They need an accepted minimal research/backtest design:

1. **Experiment:** first hypothesis/strategy, universe, frequency and benchmark.
2. **Research data:** Trades/Bars/BBO input, bar construction, session/calendar/timezone rules, missing intervals and warm-up behavior. A single-venue feed is not automatically consolidated market data.
3. **Information timing:** event/receive/availability versus decision clock; when a completed bar becomes usable; execution after the decision. Reference validity lookup alone does not prove publication-time availability.
4. **Execution:** order lifecycle, market/limit scope, fill price/timing, fees/spread/slippage, and any explicitly excluded partial-fill behavior.
5. **Accounting/risk:** initial cash, long/short and leverage scope, exposure limits, position cost basis, realized/unrealized PnL, mark policy, currency and exact price × quantity → Money rounding/overflow rules.
6. **Equity assumptions:** corporate actions, adjusted versus raw prices, overnight holdings and financing/borrow requirements if applicable to the chosen experiment.
7. **Validation/reproducibility:** chronological splits/walk-forward, no leakage, cost sensitivity, metrics and annualization assumptions, frozen data/config/code identities and any random seed.
8. **Python/C++ boundary:** how Python research consumes data and how accepted logic/configuration is exercised by C++ backtesting. Parquet inspection is available; a binding/research API is not implemented.

Do not solve these by adding a matching engine, distributed infrastructure, an ML platform, live execution, or a large strategy library. The accepted objective remains a transparent, interview-grade vertical slice.

## AGENTS.md / documentation review

- Existing instructions cover architecture-first work, owner acceptance, provider-source checks, preservation of user work, verification, CLion compatibility, and the interview-grade scope.
- The original ingestion handoff contains historical “no SDK/storage” restrictions. Those describe its original slice; later accepted Databento, query-planning and storage documents define subsequent slices. Agents need to read the supplements rather than treat historical status lists as the current global project state.
- Added explicit storage-document/testing-guide and decision-review pointers to `AGENTS.md`. Open findings remain proposals; no new artifact/validation policy was silently accepted.
- Older architecture documents intentionally retain iteration-local deferred/open lists. This review and project context identify decisions now covered by later slices without rewriting their historical reasoning.

## Verification and source check

- **Fresh verification:** All eight dependency-free C++20 test executables pass with warnings-as-errors.
- **Fresh verification:** Both storage CTest targets pass using the existing temporary PyArrow 21 package shim. Native Arrow/Parquet CMake package discovery remains unverified on this machine.
- **Fresh reproduction:** A temporary, strict-compiled C++ probe exercised overwrite, range mismatch, identity relabeling, mixed-stream Trade conversion, unsupported version labeling and zero-quantity Trade persistence. The results above demonstrate missing checks; they are not passing invariant tests.
- **Prior evidence:** Manual synthetic round trip and independent Python inspection passed. The committed Databento translation tests and earlier credentialed smoke were inspected as existing evidence, not rerun against the live API in this audit.
- **Sources:** Repository code, assertions, accepted architecture documents and engineering-book entries. No new provider/exchange semantics were assumed; source-dependent ordering/condition details remain explicitly open. Publication/version/validation recommendations are project proposals.

## Suggested next review order

1. Accept the artifact immutability/repeated-write policy.
2. Accept the scope/range/canonical-row validation ownership contract and supported version behavior.
3. Implement only the accepted closure changes and add regression tests for the reproduced failures.
4. Decide the smallest data/evidence bridge required by the first research experiment.
5. Accept the first research/backtest design and then implement it.
