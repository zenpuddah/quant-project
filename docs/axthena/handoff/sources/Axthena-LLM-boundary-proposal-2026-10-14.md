# Axthena — proposed LLM communication boundary

Date: 14 October 2026. The requirement to abstract communication before implementation is accepted under ENG-038. The contract below is an advisor proposal for review. No provider, SDK, server, product interface or implementation has been selected.

## Business purpose

The investigator should be able to compare models without changing what an organisation, Idea, stock judgment or source passage means. C++ remains the application language. A later Python validation experiment can use the same logical request/response records, without selecting the production implementation language or adopting a Python framework.

The communication layer sends a prepared task to a selected model and retains what happened. Extraction rules decide what to ask. Validators decide what can be accepted. The information store decides which accepted records are written. These responsibilities remain distinguishable.

A non-generative specialist such as GLiNER is not a general chat model. Its extractor interface can remain separate rather than forcing every model into the LLM generation interface.

## Recommended contract

Use an application-owned request/attempt/result contract with small provider adapters. An adapter translates this contract into the provider's native or compatible API. OpenAI-compatible HTTP can be one adapter family; it is not proof of equivalent behavior across providers.

Only two core operations are proposed: describe a configured model deployment's capabilities, and execute one prepared generation request. Initial scope: retained text, one answer, non-streaming. Optional batch submission can be an extension after the first experiment establishes a need.

| Record | Proposed contents |
|---|---|
| Model deployment profile | Provider/model identity; snapshot or weight revision when exposed; endpoint/runtime/backend/adapter versions; supported constraints and settings; relevant input/output limits. Capabilities can be supported, unsupported or unknown. |
| Logical request | Request ID; exact ordered instructions and evidence; source-version references/digests; requested output contract and version; model/settings configuration; required capabilities; deadline, output and attempt budgets. |
| Send attempt | Fresh attempt ID linked to the request; actual translated request; actual model/endpoint; start/finish times; raw provider response or error; provider request ID, stop reason and usage when supplied. Authentication secrets are excluded. |
| Normalized result | Generated content; completion/refusal/truncation/error status; attempt reference; reported or estimated usage and preserved provider details. This is a candidate output, not accepted knowledge. |

The adapter must not choose canonical organisation identities, decide Idea grouping, confirm facts or write graph records. Those are application policies. The model can propose identities from supplied candidates; the existing organisation creation policy remains automatic when none is selected.

Reject unsupported required capabilities before sending. If the application deliberately permits a weaker generation mode, record that choice and still validate against the original application contract. Silent deletion of output constraints or silent model switching would make the experiment misleading.

A short source-grounded explanation of a match or rejection is useful audit information. This does not require the model's private reasoning or dedicated V1 stock-judgment reason extraction.

## Validation outside the adapter

| Check | Question | Example |
|---|---|---|
| Response completion | Did a complete answer arrive? | HTTP 200 with a refusal or token limit is not a completed extraction. |
| Structure | Does the candidate parse and satisfy the original schema under the selected validator? | A direction value outside UP/DOWN is invalid even if JSON parses. |
| Evidence linkage | Do document IDs, quotes and spans resolve to the retained version? | A passage from another report cannot support this expression. |
| Evidence support and domain rules | Does the passage justify the field and preserve its scope? | Rising profits alone cannot produce a source-stated UP judgment. |
| Application publication | Which validated results are made readable? | Valid partial extraction is readable with unfinished work separately marked. |

Exact substring matching is an evidence-linkage check, not a semantic support test. Offset encoding/unit and repeated-passage disambiguation belong in the extraction contract; byte counting should be done by software against retained text.

Incomplete JSON is different from a complete response containing a valid item and an explicitly unresolved item. Any salvage or repair is a separately recorded operation. Do not manufacture a successful full response by guessing a missing suffix. Detailed salvage/publication policy still requires selection.

## Errors, retries and costs

Keep transport status, provider generation status, structural validity and domain acceptance separate. Preserve unknown provider outcomes. A timeout can leave execution/billing uncertain; missing usage means unknown usage, not free execution.

Proposed execution policy: bounded attempts and elapsed time; provider rate admission; explicit output limits; appropriate handling of retry hints; recorded transient retries. Invalid credentials/configuration/schema are corrective failures. A new model, prompt or output limit produces a new versioned request, rather than an invisible identical retry. If a chosen SDK retries internally, record or disable/account for those retries explicitly.

Cost records distinguish reported token categories, estimates, local compute time and a dated pricing snapshot. Prefix-cache tokens, reasoning/output tokens and cache writes are provider-dependent. Do not select budgets from nominal token prices alone.

An application request ID supports correlation and duplicate suppression. It does not guarantee exactly-once remote generation or charging. Accepted graph writes need their own retry-safe application policy; communication adapters do not solve storage transactions.

## Historical outputs and replay

Retain the original source, any transformed/chunked model input, complete logical request, translated request and returned answer. Capture publication/first-supported-availability, collection, generation and validation times independently. Later extraction must not pretend it was computed on the source publication date.

Record known model/configuration, adapter, prompt, schema, validator and acceptance-policy versions. A hosted alias may change without exposed weight identity; mark this limitation. Local runs additionally record weights, tokenizer/template, quantization and inference runtime when applicable.

Replaying a saved answer under retained local validation versions can reproduce that historical interpretation. Asking the model again is fresh generation and need not return identical bytes. Temperature zero or a seed alone does not establish reproducibility.

## Why one API shape is insufficient: primary evidence

- [Claude compatibility documentation](https://platform.claude.com/docs/en/cli-sdks-libraries/libraries/openai-sdk) says response_format and tool strict are ignored, and system/developer messages are combined. A compatible call can therefore lose requested behavior.
- [OpenAI structured-output documentation](https://developers.openai.com/api/docs/guides/structured-outputs) distinguishes schema constraints from JSON mode and documents refusals/incomplete answers and possible content mistakes.
- [Qwen output documentation](https://www.alibabacloud.com/help/en/model-studio/qwen-structured-output) has model-specific JSON-object and strict-schema support lists. [DeepSeek tool documentation](https://api-docs.deepseek.com/guides/tool_calls/) provides strict schemas through a Beta tool path with supported-feature limits.
- [vLLM structured output](https://docs.vllm.ai/en/latest/features/structured_outputs/) depends on the decoding backend/version; its earlier guided fields were removed in v0.12. [Ollama output documentation](https://docs.ollama.com/capabilities/structured-outputs) distinguishes local support from its cloud limitation.
- [vLLM reproducibility](https://docs.vllm.ai/en/latest/usage/reproducibility/) documents environment/scheduling qualifications. [SGLang deterministic inference](https://docs.sglang.io/docs/advanced_features/deterministic_inference) discusses dynamic-batching effects.

Provider behavior must therefore be checked for the selected endpoint, model and runtime, then captured in a capability profile. These documentary examples are not Axthena adapter tests.

## Alternatives and required validation

Recommended: semantic contract plus native/compatible adapters. It preserves provider-specific capabilities while keeping the business model stable. Trade-off: a little more adapter code and capability bookkeeping later.

Simpler first-test alternative: one explicitly tested OpenAI-compatible subset, preserving raw provider extensions. It can reduce initial effort but must not claim interchangeable strict output when a provider ignores the field. A later native adapter may still be necessary.

Before accepting the implementation design, test the same recorded task through two adapters; compare preserved evidence/order, constraints, outcomes and usage. Add refusal, truncation, timeout/uncertain completion, unsupported-schema, partial-result, retry and unknown-usage cases. Verify that transport success does not publish invalid domain data, repeated application does not duplicate publications, and reads have no generation side effects.

Review choices still needed: final request/result representation, required initial capabilities, exact model/configurations, budgets and validator/offset conventions. No SDK or server has been selected. This is a communication boundary for Axthena, not a general agent workflow framework.
