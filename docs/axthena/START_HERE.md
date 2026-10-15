# Axthena — start here

Repository handoff · 15 October 2026

**Branch:** `implementation/axthena-v1` in `zenpuddah/quant-project`.

The owner asked to put the consolidated Axthena context on a separate branch so a second agent can carry the work into implementation. This branch starts from `main` at `95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5`; it does not merge the separate Lexongine workstream.

## Read in this order

1. Root `AGENTS.md` and `docs/project/context.md` for repository rules and routing.
2. This file and [repository-handoff.md](repository-handoff.md) for the latest branch-specific instruction.
3. [Scope and decisions](handoff/01-scope-and-decisions.md).
4. [Data and behaviour specification](handoff/02-data-and-behaviour-specification.md).
5. [Architecture proposal](handoff/03-architecture-proposal.md), [acceptance tests](handoff/04-acceptance-and-test-plan.md), and [implementation plan](handoff/05-implementation-plan.md).
6. [Decision groups and V2 backlog](handoff/06-review-decisions-and-v2.md).

Use [IMPLEMENTATION_PROMPT.md](IMPLEMENTATION_PROMPT.md) to launch the second agent. The [complete packet index](handoff/README.md) points to historical contexts, research, original prompts, diagnostic outputs and graph artifacts. Consult historical reports for specific decisions/evidence rather than rereading everything before useful work.

## Repository selection and isolation

The earlier plan says “independent Axthena repository” and “repository location unselected.” Those location statements are superseded: **Axthena now has this separate branch in the shared repository.** Axthena remains a separate project with its own decisions. Physical co-location does not merge its architecture with Qaedalus or Lexongine.

The future paths in handoff T1 and the repository layout are **relative to an isolated Axthena component root**, not the quant repository root. Suggested placement is `projects/axthena/`; record the final placement in T0 before application files. Do not overwrite root build files or put Axthena internals inside `src/quant/`. Existing quant tests/dependencies must remain usable without installing Axthena dependencies.

Existing C++20, Arrow/Parquet and Databento decisions belong to Qaedalus. For Axthena, C++ is accepted; its standard, database, libraries, embeddings and interface retain their handoff selection status. A quant-only deferral of SQLite is not an Axthena backend decision. General correctness, evidence, owner authority and preservation rules still apply.

## What the second agent can do now

Begin T0: reconcile the concrete contract and staged decision groups. Do not ask again whether to read the documents or begin that preparation. Do not reopen accepted C++/local/batch/evidence/UP-DOWN/union requirements.

When a material unselected choice blocks the next task, present the recommended bundle and concrete trade-off to Badr. Record his answer in the six-field format. Branch publication is not silent approval of SQLite, Ladybug, C++20, a paid API, an embedding model, a forecast fallback or a performance number. Execute the reviewed plan when applicable contracts are approved. Continue independent authorized work rather than stopping everything for a later-stage choice.

No simulator, actor-role classifier, ML training, dedicated reason graph, live collection during reads or quant-strategy integration belongs to this V1. Keep the current ChatGPT transport proposal separate from API-first source acquisition and numeric embedding retrieval.

## Other project context

- **Qaedalus:** checked-in `docs/project/context.md` and linked architecture documents describe the inherited main baseline. Pending ingestion/storage work is not Axthena's task.
- **Lexongine:** a separate workstream was observed at [`implementation/lexongine-v1`](https://github.com/zenpuddah/quant-project/tree/implementation/lexongine-v1). Its documentation entry point was verified at [`docs/lexongine/README.md`, commit `61ecf87892a9eebfce397cea522941864d92a6c7`](https://github.com/zenpuddah/quant-project/blob/61ecf87892a9eebfce397cea522941864d92a6c7/docs/lexongine/README.md). This is a dated pointer; inspect current state when integration is requested. Do not merge/cherry-pick that branch just to start Axthena.

## Documentation maintenance

Current branch decisions belong in [repository-handoff.md](repository-handoff.md) and subsequent current Axthena decision/progress documents. Keep prior AX/ENG records under `handoff/sources/` as historical evidence; do not create competing copies in generic project paths.

The imported packet is a repository edition. A few historical source copies omit private-note links and non-technical personal-study framing. [repository-adaptations.json](handoff/repository-adaptations.json) records those edits and original hashes. Original experimental archives/scores are unchanged. `manifest-original.json` describes the pre-import packet; `manifest.json` describes this edition.

No application implementation/runtime acceptance is claimed. Tests are plans and retained experiment evidence until actually implemented and executed.
