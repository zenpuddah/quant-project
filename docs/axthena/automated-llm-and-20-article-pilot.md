# Current task: automated LLM communication and a 20-article source trial

Owner correction, 15 October 2026. Read this before the older handoff. Full six-field decisions are ENG-047/048 in [repository-handoff.md](repository-handoff.md).

**Latest execution refinement (ENG-049):** use `implementation/v1-slices.md`. Source acquisition/inventory is slice 1 and model automation is slice 2; each is tested and confirmed by Badr before the next starts. The operating principles below remain applicable; they do not authorize skipping these checkpoints.

## Accepted direction

The LLM exchange is automated, using the provider/authentication/request pattern of OpenCode. There is no per-article copying between files and the ChatGPT UI. Versioned request, answer and event files remain valuable; the application writes them automatically for evidence and replay.

The first task assigned to the implementation agent is a small news-source trial of **20 articles**. Larger collection, full-year processing and broad production construction follow review of that trial. The prior 20–50 suggestion and manual-model proposal are superseded. Other technology recommendations remain proposals unless separately accepted.

## Recommended first implementation of the model boundary

Reuse a pinned headless OpenCode runtime behind a narrow Axthena adapter. This follows its connection behavior while keeping the C++ domain model, validation and storage independent. Copying/reimplementing the entire coding-agent system is unnecessary for this trial; exact CLI versus local HTTP integration is selected from the installed runtime's working capabilities.

The documented CLI can run non-interactively with an attached input file and a selected model:

```sh
opencode --version
opencode models openai
opencode run --format json --model openai/<available-model-id> --file article-task.json "Process the attached Axthena task under its supplied extraction schema."
```

This is a command-shape example. Substitute an actually available configured model and verify flags against the pinned installed version. Use the supported client to manage authentication/refresh; do not copy authentication tokens into Axthena records. A normal account connection may require a one-time login on the target machine, not human handling for each article. Do not assume credentials are available in a different container/session.

`--format json` emits raw events. The adapter must capture them, determine completion/failure, assemble the completed answer and validate Axthena's extraction schema and evidence. JSON event transport does not establish valid extraction JSON. Record the exact task/input, prompt/schema/configuration versions, provider/model identifiers, attempt/session ID when supplied, raw events, answer and actual processing time. Unknown usage/model details remain unknown. Exclude secrets from all retained artifacts.

Use fresh isolated extraction sessions by default. Do not continue an unrelated coding conversation. Supply source text as data and restrict the extraction agent's capabilities to what the task requires; article text cannot authorize shell writes, unrelated network work or repository changes. This does not require changing the user's global OpenCode permissions.

For a longer-lived adapter, the documented `opencode serve` local API is an alternative. Inspect the pinned runtime's own `/doc` schema before coding request/response field names; website SDK examples can differ across versions. Keep the transport replaceable. Ordinary stored-data queries never call the model.

## First OpenCode task: S0

1. Inspect the configured source access and choose a short recorded date window. EODHD remains a candidate to try, not a proven source or purchase decision. Try to cover Nvidia and Microsoft with approximately balanced representation where the source permits.
2. Target **20 unique retained news articles**, with a hard limit of 20 in this trial. Record requested versus actual count and explain unavailable/duplicate/insufficient material. Do not quietly widen into a year or collect a larger replacement sample. If source access is missing, identify that specific access requirement while completing the independent trial specification.
3. Retain the actual response/body, original link and provider ID, source/publisher, declared publication time, collection time and text completeness. Preserve exact evidence even if later processing fails. A headline or truncated body cannot be presented as the full original.
4. Verify one automated model request against one retained article before executing the rest of the retained set. Automatically save response/events and validate passages, identities, subjects, summaries, judgments/windows and qualifications. Fields not supported by the current contract remain visibly unresolved rather than fabricated.
5. Produce an article inventory, extraction outputs, failure/coverage summary and an inspectable graph/query result where the reviewed contract supports it. Keep operational failures separate from domain data.
6. Review results with Badr before expanding. Measure source-body usability, automation completion, duplicate handling, quote/meaning support and gaps. Twenty reports demonstrate the bounded trial; they do not establish population accuracy, real candidate retrieval, shared-meaning insertion or historical signal availability unless those specific mechanisms actually ran.

No production source download, model invocation or authentication flow was executed while preparing this documentation. The trial is assigned to the next implementation session.

## Primary documentation checked

- [OpenCode CLI](https://opencode.ai/docs/cli/): non-interactive `run`, model/file selection and raw JSON event output.
- [OpenCode providers](https://opencode.ai/docs/providers/): supported account-connection workflow, including the documented ChatGPT connection option.
- [OpenCode server](https://opencode.ai/docs/server/): headless local API and runtime OpenAPI specification.

These establish documented integration options. Compatibility with the user's installed version/account is checked by S0, not inferred from documentation alone.
