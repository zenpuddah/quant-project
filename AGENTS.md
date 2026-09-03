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
20. For the current ingestion work, read `docs/architecture/phase1-historical-ingestion.md` and `docs/project/opencode-handoff.md` before writing code. OpenCode's role is implementation and verification of that accepted slice; architecture changes must be surfaced for review.

CLion is the intended IDE. Keep future tooling and project guidance compatible with CLion, but do not assume a build system, compiler configuration, library, or project layout before it is accepted.

See `docs/architecture/` for accepted design artifacts and `docs/project/engineering-book.md` for the reasoning behind them.
