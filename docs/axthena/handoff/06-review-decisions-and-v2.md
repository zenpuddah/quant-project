# Axthena — final review decisions and deferred work

Review sheet · 15 October 2026. These are proposed choices, not newly accepted decisions. The handoff is complete enough to review; the implementation contract is not yet frozen. Review a group at a time or accept a clearly named bundle. Do not restart discovery or ask the owner to decide every private function/file name.

## D1 — Local architecture bundle

**Already decided:** C++, local computer, persistent evidence, separate collection/processing/reads, conceptual graph.

**Recommendation:** one native C++20 application, CMake/CTest, SQLite structured records, immutable artifact files, nlohmann/json, libcurl and a small CLI with JSON output; deterministic Cypher export for inspection. Pin compatible versions after a target-machine gate. Confirm OS/architecture and available RAM/disk. Exact index/codec optimizations follow measurements.

**Alternative:** Ladybug as the single structured store with the same domain contracts and evidence archive. Do not maintain two authoritative stores. Neo4j was the review surface, not an accepted production backend.

**Trade-off:** the recommendation keeps the runtime small and the graph model explicit in relationships, but requires hand-written parameterized reads. The graph alternative gives native graph query authoring but adds its engine/dialect/native integration constraints. Neither is proved faster for Axthena.

**Blocks:** T1 and concrete DDL/query implementation. Documentation does not wait for this choice.

## D2 — Meaning, time and output-contract bundle

**Already decided:** scoped confirmation, conflict on hold for personal review, direct organisation/domain subjects, at most two Ideas, readable partials, UP/DOWN only, quote exclusion, source-first availability, explicit horizon provenance and source-grounded evidence.

**Recommended proposed defaults to review together:**

1. Exact spans use UTF-8 byte offsets in a versioned normalized-text artifact, linked back to original bytes, with paragraph/occurrence locators. A displayed quote must match exactly.
2. An Idea subject stores an organisation/domain pair. Direct and inferred relevance remain distinguishable with supporting paths.
3. Explicit Event and scoped Claim/Confirmation records accompany source Expressions; typed relationships carry broad dependencies. Do not call the current narrow extraction projection the complete model.
4. Held claims remain visible with both sides to the investigator, and are excluded from an unqualified `confirmed_only` subset. Personal resolution is dated; exact resolution outcomes and qualifying authority/process list must be named.
5. Strict historical reads exclude content whose exact-version availability is unsupported, with explicit exclusion/coverage information. A declared-date exploratory view must be separately selected and labelled. Source-aligned retrospective output never pretends to be a contemporaneously computed signal.
6. Resolved date-only windows use `[start, end)`; no fabricated time-of-day. Preserve qualitative horizon separately from missing horizon. Require the owner to set a fallback duration before using fallback; **no seven-day fallback has been accepted**. Seven calendar days per unqualified source week is already accepted.
7. A Judgment read always carries its full summary, evidence and material qualification text/status. No automatic condition evaluator or reason graph.
8. Proposed operational states distinguish complete, valid partial, insufficient information and failure. Malformed/truncated response containers are quarantined; independently well-formed components may be validated and applied under the selected partial-result rules.

**Still requiring concrete inputs:** the confirmation policy, resolution outcomes, fallback duration, time precision/calendar/cutoff policy and unsupported-date handling. These are not implementation trivia. Use G01–G06 and the AT cases to approve expected outcomes before scoring them.

**Blocks:** T0/T5/T7 and historical/read gates in T9. An explicit scope reduction must be recorded if any accepted V1 concept is deferred.

## D3 — Model transport, retrieval and meaning membership

**Already decided:** existing ChatGPT access for the first experiment; ENG-047 selects automated OpenCode-style model communication and rejects manual per-article exchange; replaceable model communication; name and vector retrieval separately, union in V1, retained intersection metadata, AI final organisation decision; automatic organisation creation after completed no-selection including uncertainty.

**Recommendations:**

- Use automated provider/authentication/request handling patterned after OpenCode. Recommended initial adapter: pinned headless OpenCode CLI or local server, with the existing configured provider. Versioned request/answer files are written automatically; no copy/paste workflow.
- Approve a local embedding package only after tokenizer/pooling parity and name-retrieval tests. ONNX Runtime is a candidate runtime; `multilingual-e5-small` is a candidate to evaluate, not the winner of an Axthena benchmark.
- Start with exact cosine scans and a simple name-similarity baseline. Proposed limits are eight candidates per organisation branch; retain their full deduplicated union, up to sixteen. Choose these limits based on the frozen alias packet; they are not accepted numbers.
- A failed required retrieval branch stops/retries that resolution rather than creating an organisation. Completed uncertain no-selection creates normally. This distinction implements the accepted rule; it does not introduce human identity review.
- For Ideas, reuse only after a supported SAME decision against the canonical complete meaning and material retained variants. Uncertain meaning stays separate; do not merge whole similarity-connected components. Review HM03/HM13 before freezing this boundary.

**Trade-off:** reusing a pinned OpenCode runtime adds one external integration but avoids reimplementing provider/authentication details prematurely. Actual account/model compatibility must be demonstrated. Embedding inference is separate. The first provider/source trial is 20 articles under ENG-048.

**Blocks:** T4 transport details, T6 actual retrieval, T8 grouping and T10 full-corpus processing feasibility.

## D4 — Source packet and historical corpus

**Already decided:** Nvidia and Microsoft, relevant suppliers/dependencies/competition, analyst-prepared initial world configuration, API-first acquisition, twelve consecutive months, minimal cost preference (under $20 preferred, $50 acceptable, potentially $100).

**Needed selection:** provider/access path, exact sources and languages, exact common date bounds, security/listing identifiers, body availability/retention, allowed request volume, source-view definitions, topic/supplier configuration and what the budget includes. The price preference is not permission to buy a subscription.

**Accepted next task (ENG-048):** the first OpenCode task is a small source trial of 20 articles. Inspect actual retained content before selecting the full-year corpus; then the owner-requested 20-article trial, with both stocks where usable coverage permits. Report downloaded and processed coverage separately. Provider capability/pricing must be checked when selecting it; older research prices are not current offers.

**Order:** S0 (20-article source trial) comes first; its sample informs T3's adapter. The larger T10 acquisition is later and is not authorized by the small trial. Fixture replay can support development but cannot replace these acceptance gates.

## D5 — Useful reads and measurable targets

**Already decided:** customizable stock/date reads, the configured market/universe opinion view via prepared direct lookups, explicit source views, manually chosen two-stock view, direct evidence inspection and reliable dependency reads. Traversal limits and configuration remain technical-design choices.

**Recommendation:** approve Q1–Q7 from the specification as the first read surface, including separate coverage/status. Select the market calendar and bar-boundary mapping when needed; daily OHLCV focus does not settle opening/closing timing.

**Targets worksheet to complete before T11:**

| Measurement | Value to select | Measurement rule |
|---|---|---|
| Corpus/workload | Report count, evidence bytes, org/Idea/link counts, languages | Real corpus plus separately labelled synthetic scaling fixture |
| Local query latency | p50/p95 and maximum acceptable slow result by query | Cold/warm separately, same hardware and selected run |
| Retrieval | Candidate recall/false-resolution checks and acceptable work | Distinguish retrieval miss from LLM decision error |
| Preparation | Native/embedding throughput and peak memory | Separate human/remote model waiting |
| Query bounds | Hops, expanded records, result count, timeout | Return explicit truncation/incomplete status |
| Storage | Disk budget, compression goal if justified | Exact evidence round-trip always required |
| Recovery | Restore procedure and acceptable duration | Clean-directory restored query/evidence equality |
| Coverage/cost | Allowed missing bodies/processing gaps and budget scope | Visible omissions; no claim of exhaustive news coverage |

No arbitrary performance number becomes a promise because it appears in a plan. Agree numbers after the pilot establishes scale, but before scoring the final benchmark.

**Blocks:** final query limits and performance/release acceptance, not the initial evidence slice.

## D6 — Approve the specification and execution plan

After recording D1–D5 choices at their appropriate gates, approve the versioned specification, acceptance cases and task order. Implementation starts only after the applicable plan is reviewed and authorized. Changes discovered during implementation get a concise decision record and affected tests; avoid reopening settled discovery topics.

Use this record for each accepted choice:

```text
Decision:
Reason:
Invariant:
Trade-offs:
Implementation scope:
Required tests:
```

Add decision ID/date, status, superseded IDs and evidence/reference links. Preserve the prior wording as history.

## V2 and research backlog

| Deferred item | Preserved motivation / revisit trigger |
|---|---|
| Detailed quoted-speaker attribution | Recover useful quoted judgments without misassigning them to publishers |
| Dedicated reasons/thought-process records and reuse | Compare causal arguments beyond whole-claim meaning once V1 data is useful |
| Active source-edit discovery and revision chains | Expand version knowledge beyond snapshots actually acquired |
| Same-name unrelated-organisation disambiguation | Resolve legal identity ambiguities that V1 keeps provisional |
| Domain-conditioned weights, empirical scoring and ML | Use independently evaluated historical outcomes; no V1 predictive claims |
| Actor/game role classifications | Reconsider only if they add measurable analytical value |
| Automatic surrounding-world discovery | Reduce analyst setup after supported dependency collection works |
| External-event prediction modelling | Represent uncertain future disasters/political events without fabricating occurrences |
| Concurrent reads/live refresh and detailed readiness timing | Support a continuous system after batch correctness and recovery |
| Quant consumer integration and refresh decisions | Specify Qaedalus/Lexongine boundaries separately; preserve project independence |
| Adaptive filter routing, budgets and richer benchmarks | Test quality/cost trade-offs using retained branch outputs and overlap |
| ANN, graph shortcuts, query compilation and specialized storage | Consider only after a measured bottleneck and equal-output baseline |
| Richer agreement measurements and Idea-cap policy | Revisit omitted information and utility using real corpus feedback |

Biology/evolution/compiler analogies remain research inspiration, not evidence of a new algorithm or automatic justification for complexity. The interview value is a coherent C++ system with explicit trade-offs, evidence and measurements. Novelty and predictive edge remain unproven hypotheses.
