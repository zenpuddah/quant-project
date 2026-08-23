# Agent Instructions

1. Read `docs/project/context.md` before working.
2. Inspect the relevant architecture documents before editing.
3. Preserve existing and uncommitted user work.
4. Follow the architecture-first workflow: establish responsibilities, boundaries, data flow, and invariants before implementation.
5. Distinguish proposals from accepted decisions in documentation and discussion.
6. Never silently resolve a major architectural trade-off; surface it as a focused question.
7. Record significant accepted decisions and their reasoning in the project documentation.
8. Update `docs/project/context.md` after every meaningful work session.
9. Run relevant verification before declaring implementation complete.
10. Avoid production implementation until the relevant design has been accepted.
11. Prefer focused, reviewable changes and preserve unrelated work.
12. Preserve the canonical C++20/Python, research-first, end-to-end direction; do not let Phase 2 complexity distort Phase 1 prematurely.

CLion is the intended IDE. Keep future tooling and project guidance compatible with CLion, but do not assume a build system, compiler configuration, library, or project layout before it is accepted.

See `docs/architecture/` for detailed design artifacts.
