# Project documentation

Three projects share this repository. Read the current context before historical task instructions.

| Project | Responsibility | Current entry point |
| --- | --- | --- |
| Qaedalus, formerly Quadeplus | Market data, research and financial backtesting | [Shared context](project/context.md), [integrity specification](architecture/phase1-data-integrity-implementation.md), [backtesting scope](project/research-backtesting-trading-scope.md) |
| Lexongine, formerly Legongine | Reusable computation, composition and execution | [Lexongine context](project/lexongine-context.md), [implementation handoff](lexongine/README.md) |
| Axthena, formerly Athena | News, events, actors and information evidence | Direction recorded in [shared context](project/context.md); no dedicated verified implementation in the inspected baseline |

Existing `docs/architecture/` and dated `docs/project/` files retain their Qaedalus paths and provenance. New Lexongine documents use a project directory, with separate specifications, implementation instructions, examples and research. Use this pattern for future Axthena documentation when its scope is defined; do not create an empty speculative architecture now.

An accepted design, an implementation plan and a historical passing test transcript are different evidence. Current progress records state the exact checkout, commands and scope actually verified.
