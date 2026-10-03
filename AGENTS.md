# Agent Instructions

1. Read `docs/project/context.md` before working.
2. Inspect the relevant architecture documents before editing.
3. Read the relevant entries in `docs/project/engineering-book.md` when a task depends on earlier design reasoning.
4. Preserve existing and uncommitted user work.
5. Follow the architecture-first workflow: establish responsibilities, boundaries, data flow, and invariants before implementation.
6. Distinguish proposals from accepted decisions in documentation and discussion.
7. Never silently resolve a major architectural trade-off; surface it as a focused question.
8. Record significant accepted decisions in `docs/architecture/` and record the problem, reasoning, source check, and trade-offs in the engineering book.
9. For market/provider semantics, prefer primary provider/exchange documentation and cross-check mature implementations when useful. Separate source-supported facts from project-created design choices.
10. Keep repository documentation technical. Do not add council/persona/fictional-character framing, motivational commentary, or unrelated study-session material to engineering or architecture documents.
11. Update `docs/project/context.md` after every meaningful work session.
12. Run relevant verification before declaring implementation complete.
13. Avoid production implementation until the relevant design has been accepted.
14. Prefer focused, reviewable changes and preserve unrelated work.
15. Preserve the canonical C++20/Python, research-first, end-to-end direction; do not let Phase 2 complexity distort Phase 1 prematurely.
16. Do not turn a useful mental model into infrastructure before a concrete requirement justifies it.
17. Treat the repository owner as the engineering manager for architecture, product, and major trade-off decisions. Implementation agents execute accepted designs; they do not silently redesign them.
18. If implementation exposes an ambiguity, contradiction, hidden provider requirement, significant performance/ownership trade-off, or need for a new external dependency, stop and ask one focused engineering-manager question before continuing.
19. Do not implement a component marked ghost/deferred merely because doing so is convenient for the current task.
20. For ingestion work, read `docs/architecture/phase1-historical-ingestion.md` and the accepted iteration-close, Databento, and query-planning supplements relevant to the task. `docs/project/opencode-handoff.md` describes the original, already implemented skeleton; its iteration-local restrictions are historical. For the current data-integrity slice, use `docs/project/opencode-data-integrity-handoff-2026-10-03.md`. OpenCode implements and verifies accepted designs; architecture changes must be surfaced for review.
21. For research, backtesting, and trading-domain work, read `docs/project/research-backtesting-trading-scope.md`; distinguish its accepted scope from its proposed implementation target before writing code.
22. Optimize the near-term project for explainable, interview-grade quantitative-finance domain correctness, not cutting-edge production performance or infrastructure. Assess ingestion/storage integrity on engineering grounds; the interview scope does not relax accepted correctness or reproducibility invariants.
23. Keep the first research/backtesting slice transparent: explicit point-in-time data, execution/cost assumptions, order/fill state, portfolio/PnL accounting, validation, and reproducibility.
24. For storage work, read `docs/architecture/phase1-storage-replay.md` and `docs/project/storage-testing-guide.md`; distinguish tested serialization behavior from artifact immutability, metadata/row consistency, and provider-valid ordering guarantees.
25. Read `docs/project/design-decision-review-2026-10-01.md` when touching the reviewed boundaries. It is the historical failure/evidence baseline. Its recommendations are not blanket implementation authority; the owner's later accepted contracts in `docs/architecture/phase1-data-integrity-session-2026-10-03.md` govern closure.
26. For ingestion/storage integrity work, read the accepted 2026-10-03 recap and current OpenCode handoff before implementation. The reviewed design contracts are settled, but physical formats, metadata layouts, validation ownership, retry identity, and publication mechanisms must first be recorded in a bounded implementation specification and plan. Choose routine mechanisms within accepted boundaries; surface new architectural trade-offs rather than reopening settled decisions.
27. Preserve the integrity contracts: a stored row StreamId resolves to an immutable instrument/venue/source tuple; one stream per canonical file; a separate shared acquisition-scoped uint64 ordinal precedes filtering and data-kind splitting; raw/canonical/consumer stages and evidence remain traceable; published versions are immutable; unsupported schemas and unresolved required checks block consumption. Keep IDs/ordinals/evidence outside the 64-byte MboRecord and do not infer provider correctness from timestamp sorting or consecutive sequence numbers.
28. Keep factual DataState distinct from consumer eligibility. The existing acceptance of Degraded must not bypass unresolved ordering, incomplete required groups, or insufficient initial state for order-sensitive replay. Persisted staging and a compact identity catalog do not authorize a general persistent cache, database-backed catalog, automatic repair engine, XML reader framework, or revision-management infrastructure.

CLion is the intended IDE. Keep future tooling and project guidance compatible with CLion, but do not assume a build system, compiler configuration, library, or project layout before it is accepted.

See `docs/architecture/` for accepted design artifacts and `docs/project/engineering-book.md` for the reasoning behind them.
