> Research archive: optional. Use [the consolidated handoff](../README.md) for implementation authority. Earlier proposed/pending wording is historical and cannot reopen accepted decisions.

# Lexongine primary research reference index

Date: 2026-10-14. This index supports the proposed v1 design and later focused research. The pass examined 49 primary source entries through selected technical passages, code or author text, using independent research strands. Reading depth is explicit; this is not a claim to have read every page. ONNX is indexed once. Entries are documents/works or clearly identified source groups, not independent experiments. Open-source analogues were investigated first.

## Fast access

| Question | Entries | V1 consequence |
| --- | --- | --- |
| Combine requests | OS01–OS02, OS07, C10 | Explicit references, one prepared graph |
| Eligible exact sharing | G01, C01–C02, OS06 | Full equality plus effect/state legality |
| Every input update | G02–G04, G07–G08, OS03–OS04 | Event identity/firing/closure; no value cutoff |
| Memory and schedule | OS12, G05–G06, C08–C09 | Separate retention, measure trade-offs |
| Compiler semantic risks | C01–C03, C07, OS06, OS10 | Preserve errors/numerics/activation |
| Inspectable configuration | OS01, OS08–OS09, C05–C06, N08–N09 | Owned schema, typed description, strict adapter |
| Arithmetic and ABI | N01–N07 | Explicit bounds/rounding; trusted same-build plugins |
| Biology and neuroscience | X01–X06 | Reuse and separation of levels, bounded analogy |
| Scientific/statistical meaning | X07–X08, R01–R02 | Causal/dependency graphs differ; preserve trials |
| Valid cross-run result reuse | OS02, OS04, N11 | Full contract/scope validation, bounded artifacts, temporal replay; outputs are not state |

## Reading limitations and next research

Kahn 1962 technical PDF was unavailable; metadata/abstract only at [Primary source](https://doi.org/10.1145/368996.369025), excluded from the 49 readings. Use G04/G09 for actually-read scheduling/cycle context. The conventional indegree topological algorithm remains an engineering choice.

The original 1961 Jacob–Monod paper was unavailable. X01 uses Monod's 1965 lecture reproduction. Primary texts read through university/author/mirror copies identify that route. FlumeJava official PDF redirects were unreliable; C10 records an author-uploaded copy and primary publication page. §4.6 calls additional duplicate-operation CSE future work; do not cite it as solved generic UDF sharing.

Stable/main documentation can change; pin implementation dependencies and semantics. The next research should answer a concrete need: real trade-to-bar completion/availability and empty/session policy; measured sparse scheduling or matrix retention; portable ABI/isolation; ML state/checkpoints; or proved numerical rewrite rules. Advanced papers do not commit v1 to their machinery.

## Annotated entries

The initial research pass contains 49 entries below. The owner's macOS choice adds platform follow-up group N10; the accepted v1 cross-run reuse adds cache follow-up group N11. The AI implementation-readiness pass adds five entries/groups A01–A05 below. Current index total: 56 entries. Follow-up groups contain explicitly listed official sources; they are not independent experiments. The implementation-hazard follow-up extends readings within the existing groups; repeated reads and supporting documents do not create additional numbered entries.

### OS01 Dask task-graph specification

**Primary source:** [Primary source](https://docs.dask.org/en/stable/spec.html)

**Reading depth:** definitions, task/data/alias/list representations, argument resolution, multiple requested keys, and the explicit explanation of why legacy tuple representation was replaced; lines 219–335.

**Summary:** Dask models tasks and dependencies as a DAG mapped by keys. Its current representation distinguishes tasks, literal data, aliases, and task references. A scheduler resolves references to concrete values before calling a function. Multiple output keys can be requested together. Legacy tuple graphs could confuse a literal string with a task key, required context-sensitive recursive interpretation, and could produce accidental substitutions; explicit references avoid that ambiguity.

**Use and limit:** distinct representations for literal config values and port references; stable identifiers; one prepared graph serving several named outputs.

### OS02 Dask delayed API: identity and purity

**Primary source:** [Primary source](https://docs.dask.org/en/stable/delayed-api.html)

**Reading depth:** key uniqueness, purity argument, pure/impure call examples, explicit key names, stateful attribute counterexample; lines 251–411.

**Summary:** Pure calls use argument hashing for consistent keys; impure calls ordinarily receive distinct keys. Explicitly assigning the same key tells Dask that calls have the same result, making name correctness the user's responsibility. Purity assumes outputs depend only on inputs, without global state. Defaults differ between ordinary calls, attribute/operator proxies, and methods; the documented incrementing property demonstrates why purity assumptions matter.

**Use and limit:** purity-gated deterministic interning and distinct occurrence identities for unshareable calls.

### OS03 Apache Beam programming guide: state and timers

**Primary source:** [Primary source](https://beam.apache.org/documentation/programming-guide/)

**Reading depth:** state and timers introduction, keyed/window scope, declaration/naming, ordering warning, and state garbage-collection linkage; section 11, particularly lines 5172–5179 and 6091.

**Summary:** Beam's state is scoped to the current processing key and window. A state name belongs to a particular ParDo and does not identify another graph node's state. Windows determine empty initial state and eventual reclamation. The guide explicitly warns that input elements have no guaranteed order; its DirectRunner can shuffle them to expose order assumptions. Stateful processing is a stronger contract than applying a stateless transform to a collection.

**Use and limit:** declare state scope, lifecycle, and temporal policy as first-class metadata. Order-sensitive reducers need an explicit order contract.

### OS04 Apache Flink stateful-stream-processing concepts

**Primary source:** [Primary source](https://nightlies.apache.org/flink/flink-docs-stable/docs/concepts/stateful-stream-processing/)

**Reading depth:** keyed state, checkpoints, source replay, barriers, multi-input alignment, snapshotting operator state, recovery, batch exceptions; lines 438–553.

**Summary:** Flink's keyed state follows the partitioned stream and access is restricted to the current event's key. Consistent recovery combines source positions with operator state. For multiple inputs, checkpoint barriers identify a common cut; operators avoid mixing records on opposite sides of that cut. Snapshots include source offsets and operator state references. Bounded batch recovery instead replays full streams without regular checkpoints.

**Use and limit:** a resumed reducer needs both its state and the exact input/history position; multi-source updates need a declared common epoch or cut.

### OS05 Arrow Acero C++ user's guide

**Primary source:** [Primary source](https://arrow.apache.org/docs/cpp/acero/user_guide.html)

**Reading depth:** declaration-to-plan workflow, factory/options tables, source/project/aggregate/sink examples, reader backpressure, explicit validation/start/export code, sink and materialization limitations; lines 986–1130, 1338–1352, 1471–1502.

**Summary:** Acero separates declarative graph descriptions from executable plan nodes. Factory names and options specify sources, computation, arrangement, and sinks. Advanced execution code validates the plan, prints it, and starts production. A reader can impose backpressure; destruction can block until production completes. Some operators materialize their input, and the guide prescribes one terminal sink for a plan.

**Use and limit:** separate description, validation/export, and run phases; explicit factory/options metadata and output schemas.

### OS06 DataFusion common-subexpression-elimination source

**Primary source:** [Primary source](https://github.com/apache/datafusion/blob/main/datafusion/optimizer/src/common_subexpr_eliminate.rs)

**Reading depth:** rule explanation and examples, unary/window/aggregate extraction, CSE controller's conditional children, candidate validity, ignored expressions, and schema restoration. The GitHub extractor exposes a truncated tail; inspected passages cover the main rewrite and eligibility logic, not the complete test suite.

**Summary:** The rule extracts repeated expressions into an explicit projection and redirects uses to its column. Candidate validation excludes volatile nodes and lambdas. The controller distinguishes definitely executed children from conditional ones, including Boolean short-circuiting, CASE, and aggregate FILTER. Comments explain that moving arguments below a filter can expose errors on rejected rows. Other comments document a rewrite-loop hazard when CSE fights leaf-projection duplication. Rewrites restore the original schema when needed.

**Use and limit:** explicit reuse nodes, effect gating, conditional-execution domains, and contract-preserving rewrites.

### OS07 Polars `collect_all`

**Primary source:** [Primary source](https://docs.pola.rs/api/python/stable/reference/api/polars.collect_all.html)

**Reading depth:** full API entry, optimization behavior, engine selection/fallback, instability warnings, result ordering; lines 1568–1633.

**Summary:** `collect_all` accepts several LazyFrames, combines or parallelizes their computations, and applies common-subplan elimination to the combined plan. This is a direct precedent for planning several diverging output requests together. Returned frames preserve request order. Engine selection can depend on configuration or environment variables and can fall back to another engine. Some optimization and lazy behavior is explicitly unstable.

**Use and limit:** merge requested output graphs before finding reusable subplans; maintain output-to-request mapping.

### OS08 PyTorch export IR specification (with FX comparison)

**Primary source:** [Primary source](https://docs.pytorch.org/docs/main/user_guide/torch_compiler/export/ir_spec.html)

**Reading depth:** ExportedProgram bundle, graph signature, state dictionary/range constraints, graph and node schemas, functional operators, restrictions compared with vanilla FX, metadata and placeholders; lines 438–604.

**Summary:** ExportedProgram bundles a DAG, signature, state dictionary, and shape constraints. Parameters and buffers are lifted to inputs and their use/mutation is tracked in the signature. Operator calls have predefined schemas and functional requirements. Vanilla FX permits arbitrary callable/attribute access; Export IR restricts these and provides stronger metadata guarantees. Export placeholders can still carry defaults, which would need stricter treatment here.

**Use and limit:** turn hidden object state into named, inspectable inputs; require operator schemas; record provenance and output metadata in a prepared artifact.

### OS09 ONNX IR specification

**Primary source:** [Primary source](https://onnx.ai/onnx/repo-docs/IR.html)

**Reading depth:** versioning, models/operator-set identifiers/operators, distinction between inputs/attributes, graph serialization, namespace/SSA and topological validation; lines 1442–1649.

**Summary:** ONNX separately versions its IR and operator sets. Models identify required operator sets, giving operations a semantic namespace/version. Graphs use topologically ordered nodes, unique SSA output names, and operator-signature constraints. Runtime inputs differ from static attributes. Initializers may act as defaults when they share graph-input names. The graph abstraction is explicitly side-effect-free.

**Use and limit:** versioned operator contracts; explicit static-versus-runtime values; SSA outputs; validation of arity, types, dependencies, and serialization.

### OS10 TensorFlow introduction to graphs / `tf.function`

**Primary source:** [Primary source](https://www.tensorflow.org/guide/intro_to_graphs)

**Reading depth:** concrete signatures/captures example, eager-versus-graph behavior, Python side effects, non-strict execution, unused failing operation counterexample, best practices, tracing/performance trade-offs; lines 721–929.

**Summary:** Graph execution differs from eager execution: it preserves returned values and documented graph effects, while an unused operation may be skipped even when it would raise an error. Python side effects occur at tracing time, not necessarily at every graph execution. The guide warns against depending on outer Python variables. Graph building has overhead and retracing can erase benefits for small operations.

**Use and limit:** distinguish preparation from runtime execution; inspect full signatures; amortize graph preparation.

### OS11 The Click Modular Router, authors' TOCS paper

**Primary source:** [Primary source](https://pdos.csail.mit.edu/papers/click:tocs00/paper.pdf)

**Reading depth:** architecture, push/pull ports and initialization checks, explicit queues, flow-based context, declarative compound elements, installation, implementation and limitations; sections 2–2.8, printed pages 3–11 (PDF indices 2–10). Performance evaluation was not used as evidence.

**Summary:** Click composes small stateful processing elements through ports and declarative connections. Push/pull compatibility and unique connection constraints are checked at initialization. Compound configuration fragments expand into primitive elements. Queues are explicit. However, elements can discover other dependencies through flow-based context, and implementation uses an Element subclass hierarchy with virtual methods. Installation and state transfer have their own lifecycle.

**Use and limit:** named ports, connection contracts, validation before activation, reusable declarative subgraphs expanded during preparation.

### OS12 Halide scheduling multi-stage pipelines, official tutorial 8

**Primary source:** [Primary source](https://halide-lang.org/docs/tutorial/lesson_08_scheduling_2.html)

**Reading depth:** C++ producer/consumer definitions, default inlining, compute_root, compute_at/store_root, trace results and equivalent loops, operation/storage counts, scheduling trade-offs and guidance; lines 35–1218. Duplicated Python translation not counted as additional evidence.

**Summary:** Halide separates a pipeline's computation from its schedule. The tutorial contrasts inlining with materialization, then independently places storage and computation. In its example, full inlining evaluates sine 64 times without intermediate storage; compute_root uses 25 sine calls but 25 temporary floats and more memory traffic. It argues for empirical schedule comparison across redundant work, bandwidth, and parallelism, while preserving algorithm meaning.

**Use and limit:** keep logical identity separate from physical storage/liveness policy; measure sharing benefits and retention costs; export the physical plan.

### G01 Filliâtre & Conchon, *Type-Safe Modular Hash-Consing*, ML 2006

**Primary source:** [Author PDF](https://usr.lmf.cnrs.fr/~jcf/ftp/publis/hash-consing2.pdf)

**Reading depth:** Introduction and §§2.1–2.3, pp. 1–3; private tagged node type, supplied equality/hash law, smart constructors, bottom-up child identity, weak-table implementation

**Summary:** Maximal structural sharing follows from routing construction through a single interning table with the chosen equality. Hash must respect equality. Unique tags and physical identity become useful after this invariant is established. Weak references permit reclaiming otherwise unreachable interned terms. These are claims about the paper's immutable terms, not a license to merge arbitrary mutable computations.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G02 Acar, Blume & Donham, *A Consistent Semantics of Self-Adjusting Computation*, full version 2011 / JFP 2013

**Primary source:** [Author-submitted arXiv PDF](https://arxiv.org/pdf/1106.0478)

**Reading depth:** Introduction, language/store description §§2.1–2.2, selected change-propagation proof discussion, §6 implementation strategy, pp. 1–5, 20, 23; not the 60+ page Twelf appendix

**Summary:** Memoized traces are adapted under mutation rather than merely returning old values. The semantics prove consistency and agreement with a pure interpretation under their well-formedness conditions. The conservative implementation requires fresh allocated locations, resident traces, no trace returned twice, and tagged function comparison. This model's correctness theorem does not directly establish correctness for event-sensitive state machines.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G03 Hammer, Phang, Hicks & Foster, *Adapton: Composable, Demand-Driven Incremental Computation*, PLDI 2014 (linked author submission)

**Primary source:** [Author PDF linked by publication page](https://www.cs.umd.edu/~mwh/papers/adapton-submit.pdf)

**Reading depth:** §5.1 and Algorithm 1, p. 7; memo constructor/table paragraph, bidirectional dependency representation, dirty/clean invariant and equality cutoff

**Summary:** Adapton separates invalidation from demand-triggered propagation. Its acyclic demanded computation graph stores ordered dependency edges labeled with values; propagation reevaluates when a target's value differs from the edge label. Memo tables and irrelevant edges can use weak references. This value cutoff is the critical non-transferable detail for Lexongine's equal-valued events. The linked PDF is a submission dated 2013, not asserted to be the final proceedings text.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G04 Mokhov, Mitchell & Peyton Jones, *Build Systems à la Carte: Theory and Practice*, JFP 2020

**Primary source:** [Author PDF](https://ndmitchell.com/downloads/paper-build_systems_a_la_carte_theory_and_practice-21_apr_2020.pdf)

**Reading depth:** §3.6 correctness statement; §§4.1–4.3 scheduler taxonomy; §§5.1–5.2 dirty bits, traces, early cutoff; pp. 15, 20–25

**Summary:** The paper separates dependency order (scheduler) from whether work is needed (rebuilder). A static topological scheduler can prevalidate missing keys/cycles but needs dependencies in advance. Restarting and suspending schedulers address dynamic dependencies with different costs. A dirty bit can lose necessary information when targets change; successive execution numbers lead to step traces. Their build semantics focus on values being up to date, not preservation of every input event.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G05 Hong & Kung, *I/O Complexity: The Red-Blue Pebble Game*, STOC 1981

**Primary source:** [Author-hosted PDF](https://www.eecs.harvard.edu/~htk/publication/1981-stoc-hong-kung.pdf)

**Reading depth:** §2 game rules R1–R4 and memory interpretation; §3 S-partition definition and Theorem 3.1/proof construction, pp. 2–3

**Summary:** The DAG pebble model couples dependency execution, retained intermediates, memory size, and transfers between memory levels. Computing a node requires its predecessors in fast memory. S-partitioning relates any complete calculation to I/O lower bounds. This is a two-level word-memory model; it does not directly supply byte bounds, an optimal practical scheduler, or a persistence feature for Lexongine.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G06 Papp & Wattenhofer, *On the Hardness of Red-Blue Pebble Games*, SPAA 2020 / extended arXiv

**Primary source:** [Author-submitted PDF](https://arxiv.org/pdf/2005.08609)

**Reading depth:** §§1 and 3 model/bounds; §8 greedy heuristics, Theorem 4 and construction through the first choice analysis, pp. 1–2, 9–10; not all reduction proofs

**Summary:** Several pebble variants are computationally hard. In the oneshot model, local greedy choices based on resident inputs can produce asymptotically worse transfer cost than the optimum. Their construction combines apparently attractive shared input groups with dependencies that prevent the greedy order from exploiting longer reuse chains. These results concern their formal models, so they motivate caution rather than proving Lexongine's weighted, stateful scheduling problem has the identical complexity.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G07 Murray et al., *Naiad: A Timely Dataflow System*, SOSP 2013

**Primary source:** [Proceedings PDF](https://sigops.org/s/conferences/sosp/2013/papers/p439-murray.pdf)

**Reading depth:** §§2.1–2.3, pp. 2–4; epoch closure, nested-loop timestamps, ONRECV/ONNOTIFY, monotone time, pointstamps, active counts/frontier; selected state-purging discussion §2.4

**Summary:** A producer explicitly closes an epoch; an empty current queue is insufficient proof that no further message can occur. Stateful vertices receive timestamped events and completion notifications. Notifications become safe when no outstanding event could generate an earlier relevant message, tracked using graph/time reachability and counts. Structured cycles require advancing loop coordinates. Lexongine's acyclic synchronous v1 can use a much simpler closure contract; distributed frontiers are unnecessary.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G08 Lee & Messerschmitt, *Static Scheduling of Synchronous Data Flow Programs for Digital Signal Processing*, IEEE TC 1987

**Primary source:** [University-hosted primary paper](https://bears.ece.ucsb.edu/class/ece253/papers/lee_sdf87.pdf)

**Reading depth:** §§II–III definitions; §IV admissible schedules, buffer balance, Class S runnable rule and Theorem 3, Fig. 7, pp. 2–7

**Summary:** SDF fixes production/consumption rates in advance, permitting static scheduling. Admissibility includes nonnegative, bounded buffers; a balanced repetition vector alone is insufficient when delays cannot enable firing. Runnable-node simulation finds an admissible period when one exists under the paper's assumptions. A single topological graph order does not determine token consumption or firing count for general multirate streams. Lexongine need not import cyclic SDF scheduling.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### G09 Tarjan, *Depth-First Search and Linear Graph Algorithms*, SIAM J. Comput. 1972

**Primary source:** [University-hosted primary paper](https://www.cs.cmu.edu/~cdm/resources/Tarjan1972-sccs.pdf)

**Reading depth:** §2 adjacency/DFS representation; §4 strong connectivity, LOWLINK/stack algorithm, Theorems 13–14, pp. 2–3, 10–14

**Summary:** Strongly connected components can be found in linear graph time/space with DFS, numbering, low links, and an active stack. A graph may have many SCCs; singleton SCCs require a self-loop check to identify a cycle. This supplies a practical validation/diagnostic tool, not a semantics for executing a cyclic stateful graph.

**Use and limit:** Transfer only under the declared event/state contracts; no optimal schedule is established for Lexongine.

### C01 MLIR, Side Effects & Speculation.

**Primary source:** URL: [Primary source](https://mlir.llvm.org/docs/Rationale/SideEffectsAndSpeculation/) .

**Reading depth:** entire substantive rationale, Overview, Categorization, Modeling, and two examples, lines 20–121.

**Summary:** MLIR separates mutable-resource effects from undefined behavior/nontermination and uses distinct interfaces for memory effects and speculation. An effect-free operation is not automatically safe to move or introduce. Unknown implicit behavior requires conservative treatment. The document explicitly limits this rationale to CFG regions and leaves graph-region effect modeling unspecified. Lexongine should define its own synchronous/effect contract rather than treating MLIR graph CSE as an off-the-shelf proof. Memory allocation used privately inside a pure implementation is distinct from observable application effects, but must still obey the kernel/runtime contract.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C02 MLIR upstream CSE implementation, lib/Transforms/Utils/CSE.cpp.

**Primary source:** URL: [Primary source](https://mlir.llvm.org/doxygen/Utils_2CSE_8cpp_source.html) .

**Reading depth:** `SimpleOperationInfo` hashing/equality, source lines 28–44; `hasOtherSideEffectingOpInBetween`, lines 168–246; `simplifyOperation`, lines 249–295; selected traversal/scoping behavior.

**Summary:** Hashing finds candidates; `OperationEquivalence::isEquivalentTo` checks equality, ignoring diagnostic locations. The implementation separately handles effect-free operations and a restricted read-only case, rejecting unknown or conflicting writes between reads. Scoping/dominance and region constraints matter. This is evidence for separating identity lookup from legality, not for borrowing every transformation or assuming all stateful graphs are eligible. Lexongine can use a simpler bottom-up table on a verified fixed graph, with explicit share eligibility and full equality after collisions.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C03 LLVM Language Reference, floating-point environment, semantics, fast-math flags.

**Primary source:** URL: [Primary source](https://llvm.org/docs/LangRef.html#floating-point-environment) and [Primary source](https://llvm.org/docs/LangRef.html#fast-math-flags) .

**Reading depth:** lines 2328–2420, including `nnan`, `ninf`, `nsz`, rewrite flag intersection, `arcp`, `contract`, `afn`, `reassoc`.

**Summary:** LLVM's ordinary floating-point model assumes disabled traps, unobservable status flags, round-to-nearest, and preserved subnormals; constrained operations support different contracts. Fast-math flags permit otherwise unsafe changes, including signed-zero relaxation, contraction, approximate functions, and reassociation. This supports making numerical semantics explicit. Mathematical equality is insufficient for exact results. V1 should preserve ordered inputs and operation trees; compiler flags, reduction algorithm, missing-value policy, and rounding/NaN assumptions must not silently differ between supposedly identical kernels.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C05 MLIR Operation Definition Specification (ODS).

**Primary source:** URL: [Primary source](https://mlir.llvm.org/docs/DefiningDialects/Operations/) .

**Reading depth:** Motivation/Benefits, operation name, operands/attributes/properties, results, custom verification and verification ordering; lines 61–164, 258–287, 447–470.

**Summary:** ODS centralizes operation facts, named typed accessors, constraints, parsing/printing, and verification. It distinguishes runtime operands from constant semantic attributes/properties and orders verification so custom checks can rely on earlier invariants. This supports a registry/schema as one source of truth for XML parsing, inspection, typing, identity, and binding. Borrow this design principle with ordinary C++ metadata or generated records; adopting TableGen, dialect classes, or MLIR infrastructure is unnecessary for v1.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C06 MLIR Language Reference.

**Primary source:** URL: [Primary source](https://mlir.llvm.org/docs/LangRef/) .

**Reading depth:** operation representation, graph regions, open type system, properties/attributes; lines 198–210, 328–351, 439–455; token warning lines 428–434.

**Summary:** An operation can have multiple typed results, ordered operands, semantic properties, and separately handled metadata. Graph regions allow cycles and make textual operation ordering semantically insignificant; their enclosing operation defines meaning. MLIR's token presence alone does not change standard CSE/DCE/hoisting rules. Lexongine therefore needs an explicitly defined synchronous graph semantics and effect ordering, not just a graph container or token-looking port. Open nominal types fit series/matrix/model/custom values without requiring a shared inherited computation class.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C07 Willsey et al., egg: Fast and Extensible Equality Saturation, POPL 2021.

**Primary source:** URL: [Primary source](https://arxiv.org/pdf/2004.03082) .

**Reading depth:** §2.1 e-graph definitions, §2.2 equality-saturation workflow/phase ordering, §3 phase-split rebuilding, §4.1 analyses, §4.2 conditional rewrites, §4.3 extraction.

**Summary:** An e-graph stores asserted equivalence classes; saturation adds terms using supplied rules and extraction chooses by a cost function. Conditional rewrites need semantic analyses (for example, dividing a value by itself requires preconditions). Rebuilding maintains invariants efficiently. This is a useful deferred contrast: exact hash-consing needs neither multiple alternatives nor rule-driven equivalence. V1 should use no algebraic rewrite rules or extraction search. Later equality saturation would require a bounded vocabulary, proved numerical rules, effects/state restrictions, and a realistic shared-DAG cost model.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C08 Ragan-Kelley et al., Halide: Decoupling Algorithms from Schedules for High-Performance Image Processing, CACM 2018.

**Primary source:** URL: [Primary source](https://andrew.adams.pub/halide_cacm.pdf) .

**Reading depth:** §2, pp.108–109; §3 introduction and §3.1/3.2, pp.109–110; selected §4, p.111.

**Summary:** Halide represents computation as a side-effect-free DAG constructed through staged C++, then describes execution order, storage, interleaving, and recomputation separately. Private bounded updates can be encapsulated behind pure function semantics; update iterations may only be reorganized where noninteraction is proved. Borrow the semantic/physical boundary, including the idea that implementation mutation can realize a pure result. Caveat: analyzable array/image functions and bounded updates do not establish purity or safe transformation of arbitrary callbacks or changing portfolio state.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C09 Chen et al., TVM: An Automated End-to-End Optimizing Compiler for Deep Learning, OSDI 2018.

**Primary source:** URL: [Primary source](https://www.usenix.org/system/files/osdi18-chen.pdf) .

**Reading depth:** §2/Figure 2 and §3, pp.579–581; §4.1/Figures 5–6, pp.582–583.

**Summary:** TVM separates graph-level dependency optimization from operator-level code generation. Tensor expressions specify shape/computation; schedules choose loop mapping while preserving the defined logical equivalence. Static memory planning and typed shape specificity aid preparation. Lexongine can independently normalize/share its graph and bind typed kernels/slots. Caveat: opaque graph operators are not automatically analyzable tensor expressions. Learned schedule search, tensorization, GPU synchronization, multiple backends, and the entire TVM stack are unnecessary for the proposed fixed C++ engine.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### C10 Chambers et al., FlumeJava: Easy, Efficient Data-Parallel Pipelines, PLDI 2010.

**Primary source:** Canonical URL: [Primary source](https://research.google.com/pubs/archive/35650.pdf) ; primary publication page: [Primary source](https://research.google/pubs/flumejava-easy-efficient-data-parallel-pipelines/) ; author-uploaded full-paper copy used when the canonical PDF redirect failed: [Primary source](https://www.researchgate.net/publication/220752324_FlumeJava_Easy_Efficient_Data-Parallel_Pipelines) .

**Reading depth:** §3.3, pp.366–367; §4/4.1, pp.367–368; §4.6/5, p.371.

**Summary:** Calls create a deferred execution-plan DAG that is optimized before execution; independent passes fuse producers/consumers and siblings. Sibling fusion reads shared input once but computes all fused results. The optimizer neither analyzes nor rewrites user-function code. Crucially, §4.6 lists additional common-subexpression elimination of duplicate operations as future work. Cite this as staged plan/fusion precedent, not as an implemented generic UDF dedup algorithm. Lexongine must define its own exact-sharing contract.

**Use and limit:** Borrow the contract/IR principle; full compiler backends and algebraic rewrites are deferred.

### N01 Nicholas J. Higham, The Accuracy of Floating Point Summation, SIAM J. Sci. Comput.14(4),783–799,1993.

**Primary source:** URL: [Primary source](https://nhigham.com/wp-content/uploads/2023/10/high93s.pdf) . 

**Reading depth:** Read introduction, recursive-ordering error analysis and cancellation example (pp783–787), and conclusions (p797); also inspected pairwise/compensated comparison excerpts.

**Summary:** summation method/order can change accuracy; pairwise and compensated methods improve certain worst-case bounds but no examined method is uniformly superior. Higher precision can be an appropriate alternative.

**Use and limit:** do not justify a universal numeric kernel or exactness claim from a familiar floating algorithm.

### N02 David Goldberg, What Every Computer Scientist Should Know About Floating-Point Arithmetic, ACM Computing Surveys1991, Oracle authorized edited reprint.

**Primary source:** URL: [Primary source](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html) . 

**Reading depth:** Read Rounding Error/Exactly Rounded Operations, Theorem5 and signed cancellation examples.

**Summary:** rounding and tie rules must be explicit; guard digits are distinct from exactly rounded operations; tie-to-even can avoid a repeated-operation drift illustrated for a directional tie rule.

**Use and limit:** recommend an explicitly named integer publication rule, with no claim it solves every algorithm.

### N03 C++ working draft: arithmetic, division/remainder, lifetime, cv qualification, from_chars.

**Primary source:** URLs: [Primary source](https://eel.is/c++draft/expr.pre) ; [Primary source](https://eel.is/c++draft/expr.mul) ; [Primary source](https://eel.is/c++draft/basic.life) ; [Primary source](https://eel.is/c++draft/dcl.type.cv) ; [Primary source](https://eel.is/c++draft/charconv.from.chars) . 

**Reading depth:** Read the relevant full clauses and examples.

**Summary:** unrepresentable signed arithmetic is undefined; integral division truncates toward zero; reference access requires a live object; const access does not stop another mutable path; from_chars returns range/pattern errors and the end of matched input.

**Use and limit:** checks before arithmetic, explicit signed rounding, owning lifetimes, honest immutability and full numeric consumption. This current draft is not an ISO publication or a claim that the engine targets its future language revision.

### N04 GCC manual,128-bit integers.

**Primary source:** URL: [Primary source](https://gcc.gnu.org/onlinedocs/gcc-16.1.0/gcc/_005f_005fint128.html) . 

**Reading depth:** Read entire short section.

**Summary:** `__int128` is a GCC extension supported on targets with a sufficiently wide integer mode.

**Use and limit:** native128 is an explicitly supported-target option, not portable C++20. Its actual target availability and build flags must be verified if chosen.

### N05 GCC libstdc++ manual, Dual ABI.

**Primary source:** URL: [Primary source](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html) . 

**Reading depth:** Read the complete short page, including `_GLIBCXX_USE_CXX11_ABI` independence from `-std` and exception/layout examples.

**Summary:** old/new string/list implementations can coexist; per-translation-unit ABI macros affect declarations independently of language dialect.

**Use and limit:** a C-linkage entry does not make C++ arguments portable; require a narrow same-build compatibility envelope.

### N06 Linux man-pages upstream, dlopen/dlclose.

**Primary source:** URL: [Primary source](https://man7.org/linux/man-pages/man3/dlopen.3.html) . 

**Reading depth:** Read path/dependency loading, NOW/LOCAL flags, reference counts/dlclose, constructors/finalizers and namespace notes.

**Summary:** eager resolution can fail before dlopen returns; constructors already execute during load; unloading depends on references and can run module destructors. Symbol namespaces constrain lookup rather than arbitrary memory access.

**Use and limit:** prepare-time loading, module pins through output destruction, and no hot unload or sandbox claim. POSIX URL fetch failed; this Linux implementation documentation was actually read.

### N07 Microsoft Learn, Dynamic-Link Library Security.

**Primary source:** URL: [Primary source](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-security) . 

**Reading depth:** Read threat example and loading/path recommendations.

**Summary:** unconstrained DLL search can load attacker-controlled binaries; malicious loaded DLL code runs within the application with the user's privileges. Fully qualified paths and controlled lookup reduce search-path attacks.

**Use and limit:** explicit module selection is useful, but it cannot establish safety of arbitrary native plugin code. This is Windows-specific evidence for the same-process trust limitation, not a Linux loader recipe.

### N08 pugixml1.16 official manual.

**Primary source:** URL: [Primary source](https://pugixml.org/docs/manual.html) . 

**Reading depth:** Read overview, memory management, loading/result/parse options, W3C conformance, attribute conversions, modification/const-handle and lifetime sections.

**Summary:** non-validating DOM; some malformed XML including duplicate attributes/unknown references/Unicode is accepted; handles depend on document lifetime and const handles do not create deep immutability.

**Use and limit:** strict application validation and descriptor copying remain necessary. No installation/performance measurement here.

### N09 TinyXML-2 official docs and pinned11.0.0 source.

**Primary source:** URLs: [Primary source](https://leethomason.github.io/tinyxml2/) ; [Primary source](https://github.com/leethomason/tinyxml2/blob/11.0.0/readme.md) ; [Primary source](https://github.com/leethomason/tinyxml2/blob/11.0.0/tinyxml2.cpp) ; [Primary source](https://github.com/leethomason/tinyxml2/blob/11.0.0/tinyxml2.h) ; [Primary source](https://github.com/leethomason/tinyxml2/blob/11.0.0/xmltest.cpp) . 

**Reading depth:** Read official docs and pinned source sections for duplicate attributes, conversion functions, entities, unknown/DTD nodes and depth; inspected the upstream duplicate test.

**Summary:** simple DOM/parser with line diagnostics; rejects duplicate attributes in inspected code; no DTD semantics; unknown entity handling and scanf conversions are permissive; depth limit500 is not a byte bound.

**Use and limit:** recommended isolated parser plus strict adapter. Official online docs are marked10.0.0; source facts above come from11.0.0 fetched via GitHub connector (cpp blob `66ef0c962eea6f915ced9b26df1cd28f0120928c`, header `8179f57b42cac37c6abd3c9458d32632b3b85896`, test `f7408d159e96c74551b07d9a8b4db509e67b5707`).

### X01 Jacques Monod (1965), From Enzymatic Adaptation to Allosteric Transitions

**Primary source:** Original: Nobel Lecture, December 11, 1965; official URL: [Primary source](https://www.nobelprize.org/uploads/2018/06/monod-lecture.pdf)

Accessible primary-text reproduction read: [Primary source](https://paperzz.com/doc/9405544/from-enzymatic-adaptation-to-allosteric-transitions)

**Reading depth:** regulation/repressor experiments, distinction between inducer and substrate, operon coordination, relay/allostery, and explicit model limitations; reproduction lines 389–685.

**Summary:** Monod recounts how genetic experiments distinguished the structure of an enzyme from regulation of its synthesis. An inducer can act through a repressor as a signal rather than participating in the enzyme's reaction. Allosteric interactions provide indirect coordination of biochemical activity. He also cautions that an explanation able to accommodate almost any phenomenon needs restrictive assumptions and experimental tests; the symmetric-state model is an approximation, not every regulatory system's unique mechanism.

**Use and limit:** Analogy/inference only: separate instruction/configuration from the actual computation; demand falsifiable constraints rather than an all-explaining architecture metaphor.

### X02 François Jacob (1977), Evolution and Tinkering

**Primary source:** Original paper: Science 196(4295), 1161–1166; DOI [Primary source](https://doi.org/10.1126/science.860134)

University PDF: [Primary source](https://williams.chemistry.gatech.edu/course_Information/6572/papers/jacob_evolution_tinkering_1977.pdf)

Accessible primary transcript read: [Primary source](https://studylib.net/doc/11829055/evolution-and-tinkering-fran%C3%A7ois-jacob-science)

**Reading depth:** Natural Selection, Engineer and Tinkerer, Evolution as Tinkering, Molecular Tinkering; transcript lines 354–648. PDF text and one screenshot retrieval were unreliable; substantive reading used the reproduced original text.

**Summary:** Jacob describes novelty through alteration and recombination of existing material rather than construction from a predetermined plan. Historical constraints explain workable, imperfect solutions and varied answers to similar problems. At the molecular level, common building blocks and changes in their organization and regulation can produce diversity. Crucially, he warns that selection at one level is not a general recipe for all forms of evolution: the constraints and rules differ across levels.

**Use and limit:** Analogy/inference only: search first for reusable parts and composition, while preserving the freedom to introduce a genuinely needed new primitive; historical reuse is no proof of engineering optimality.

### X03 John Gerhart and Marc Kirschner (2007), The Theory of Facilitated Variation

**Primary source:** Original: PNAS 104(Suppl 1), 8582–8589; DOI [Primary source](https://doi.org/10.1073/pnas.0701035104)

Canonical open article: [Primary source](https://pmc.ncbi.nlm.nih.gov/articles/PMC1876433/)

PDF read: [Primary source](https://www.marmgroup.eu/wp-content/uploads/2019/03/Gerhart_Kirschner_PNAS_2007.pdf)

**Reading depth:** introduction, Weak Regulatory Linkage, Exploratory Processes, Robustness and Adaptability, Compartmentation, and initial Experimental Evidence; pp. 8582, 8584–8587.

**Summary:** Their theory proposes that regulatory changes redeploy conserved core processes in different combinations, places, times, amounts, and states. Weak regulatory linkage means that a relatively simple signal selects capabilities already present in the responding process through an intermediary; it does not fully instruct their construction. Compartmentation reduces interference between simultaneous uses. Exploratory processes generate possibilities and stabilize selected outputs. These are proposed biological mechanisms for viable variation, supported by examples and framed with testable predictions.

**Use and limit:** Analogy/inference only: expose controlled combinations of well-tested capabilities and explicit adapters; isolate consumers of shared outputs. “Weak linkage” is not an argument for weak software typing.

### X04 Uri Alon (2007), Network Motifs: Theory and Experimental Approaches

**Primary source:** Original: Nature Reviews Genetics 8, 450–461; DOI [Primary source](https://doi.org/10.1038/nrg2102)

Primary lab entry: [Primary source](https://www.weizmann.ac.il/mcb/alon/network-motifs)

Paper read: [Primary source](https://mechanism.ucsd.edu/bill/teaching/w16/cogs200/alon.networkmotifsTheoryandexperiment.2007.pdf)

**Reading depth:** introduction/simple regulation and negative autoregulation; feedforward-loop input functions; interlocked developmental circuit; convergent evolution and experimental limits; pp. 450–452, 457–459.

**Summary:** Recurring regulatory subgraphs can implement information-processing functions studied by models and living-cell experiments. The coherent feedforward loop's behavior depends on how inputs combine: with AND logic it can detect persistence through a sign-sensitive delay. Positive feedback can encode memory, and interconnected motifs can compose temporal programs. Graph shape alone therefore does not specify behavior. Alon stresses further experimental testing, particularly when transferring motif functions between systems or understanding larger, denser networks.

**Use and limit:** Analogy/inference only: a recipe must include operation, input combination, parameters, and contract, not merely topology; static DAG reuse is different from biological dynamical feedback.

### X05 David Marr (1982; 2010 reissue), Vision, chapter 1 excerpt

**Primary source:** Publisher: [Primary source](https://mitpress.mit.edu/9780262514620/vision/)

Primary book excerpt read: [Primary source](https://qiongzhang.github.io/Marr.pdf)

**Reading depth:** Understanding Complex Information-Processing Systems, Representation and Description, Process, The Three Levels; original book pp. 19–25 (PDF pp. 21–27).

**Summary:** Marr separates the goal and logic of a computation from representations and algorithms, and those from physical realization. Representations make some information explicit while making other information harder to recover. Algorithms vary in efficiency, robustness, and suitability for hardware. The three levels interact but are only loosely coupled; explanations and claims must be made at an appropriate level rather than inferred directly from another level.

**Use and limit:** Analogy/inference only: mathematical contracts, typed logical graphs, and physical schedules deserve separate explanations and validation.

### X06 Richard Sutton (2019), The Bitter Lesson

**Primary source:** Author's original: [Primary source](https://www.incompleteideas.net/IncIdeas/BitterLesson.html)

Complete primary essay read from university PDF copy: [Primary source](https://www.cs.utexas.edu/~eunsol/courses/data/bitter_lesson.pdf)

**Reading depth:** complete essay, both pages.

**Summary:** Sutton argues from examples in game play, speech, and vision that general methods benefiting from growing computation, especially search and learning, have delivered large long-term gains over much manually encoded domain knowledge. He emphasizes methods able to discover approximations rather than permanently building in human discoveries. This is a historical argument about AI research priorities, not a theorem that every domain-specific algorithm, contract, or optimization is inferior.

**Use and limit:** Analogy/inference only: keep the execution substrate reusable and resist large handcrafted taxonomies and clever heuristics that block scale; choose actual algorithmic optimizations from measured costs.

### X07 Judea Pearl (2009), Causal Inference in Statistics: An Overview

**Primary source:** Original: Statistics Surveys 3, 96–146; DOI [Primary source](https://doi.org/10.1214/09-SS057)

University archive: [Primary source](https://escholarship.org/uc/item/36w8n7pg)

Primary paper read: [Primary source](https://escholarship.org/content/qt36w8n7pg/qt36w8n7pg.pdf)

**Reading depth:** introduction; structural invariance and interventions; identification definition and simple derivation; explicit-assumption discussion; pp. 96–99, 105–110, 118–120. Did not read the full 52-page survey.

**Summary:** Causal queries need assumptions about the data-generating process beyond an observed distribution. Structural models distinguish observation from intervention by defining what mechanism an intervention replaces. Identifiability asks whether all models consistent with stated assumptions and the same observational distribution agree on the causal quantity. Some assumptions have jointly testable implications, but correct computation alone cannot establish their truth or turn an associational statistic into a causal effect.

**Use and limit:** Analogy/inference only: a graph of computational dependencies is not a causal graph; result meaning and assumptions need explicit contracts.

### X08 George E. P. Box (1976), Science and Statistics

**Primary source:** Original: JASA 71(356), 791–799; DOI [Primary source](https://doi.org/10.1080/01621459.1976.10480949)

Primary paper read: [Primary source](https://www-sop.inria.fr/members/Ian.Jermyn/philosophy/writings/Boxonmaths.pdf)

**Reading depth:** scientific-method discussion (iteration, flexibility, parsimony, selective worry, mathematics) and Fisher polynomial/residual-analysis example; original pp. 791–794.

**Summary:** Box frames scientific learning as iteration between tentative theory and practical evidence. Models should be economical and judged against important inadequacies rather than embellished indefinitely. Mathematical consequences can be rigorous even when premises approximate reality. In the residual-analysis example, the analyst changes from a model's sponsor to its critic, checking discrepancies rather than treating a fitted answer as evidence of adequacy.

**Use and limit:** Analogy/inference only: evaluate an engine model against concrete workloads and return relevant bounded diagnostics alongside numerical answers.

### R01 Bailey, Borwein, López de Prado and Zhu, The Probability of Backtest Overfitting, revised author version 2015

**Primary source:** [Primary source](https://www.davidhbailey.com/dhbpapers/backtest-prob.pdf)

**Reading depth:** Abstract; introduction pp. 2–7; attempted-trial discussion pp. 3–4; matrix requirements p. 10. Selected sections, not all 34 pages.

**Summary:** Repeated strategy selection on the same finite data creates false-positive and overfitting risk. The paper proposes a framework and an illustrative CSCV method, emphasizing the often-unreported number of trials. Its performance matrix requires synchronous observations across trials; correct numerical backtesting alone does not control selection bias.

**Use and limit:** Preserve logical trial identities/configurations after computation sharing. Statistical research validation belongs to Qaedalus.

### R02 Sculley et al., Hidden Technical Debt in Machine Learning Systems, NeurIPS 2015

**Primary source:** [Primary source](https://papers.neurips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems.pdf)

**Reading depth:** Abstract/introduction, undeclared consumers and unstable data dependencies pp. 1–3. Selected sections.

**Summary:** The paper identifies entanglement, undeclared consumers, unstable data dependencies, feedback and configuration debt in ML systems. A frozen upstream signal version can reduce silent semantic change but introduces maintenance and staleness costs. Model code is only part of a functioning system.

**Use and limit:** Declare data/model/preprocessing versions and consumers; revisit training/inference/online state when ML begins.

### N10 macOS loader and CMake target paths

**Primary sources:** [Apple Dynamic Library Usage Guidelines](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryUsageGuidelines.html); [CMake target artifact expressions](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html); [CMAKE_DL_LIBS](https://cmake.org/cmake/help/latest/variable/CMAKE_DL_LIBS.html).

**Reading depth:** Apple opening/reference counts and symbol lookup sections, including local scope and immediate binding; CMake TARGET_FILE artifact/dependency clauses and complete short CMAKE_DL_LIBS entry.

**Summary:** Apple exposes dlopen/dlsym/dlclose handles, balanced open/close counts and potential unloading at zero references. CMake supplies generated binary paths and platform-specific loader link libraries; macOS uses implicit loader linkage. A target path expression alone does not generally establish its build dependency.

**Use and limit:** macOS is owner-selected. Isolate the loader, pin modules through their last dependent object/callback, use target-generated paths and explicit build dependencies. These documents do not establish a stable C++ ABI, sandbox, signing policy or tested Lexongine build.

### N11 Result-cache contracts and bounded retention — 2026-10-14 follow-up

**Primary sources:** [Bazel remote and disk caching](https://bazel.build/remote/caching); [Dask opportunistic caching](https://docs.dask.org/en/stable/caching.html).

**Reading depth:** Bazel action/result separation, read/write modes, disk storage and known issues (input mutation and untracked external tools), lines95–128 and289–311. Dask motivation, simultaneous sharing versus future reuse, bounded task caching and object-size limitations, lines220–309.

**Summary:** Bazel keeps computation-key result metadata separate from output content; reproducibility can fail when sources change during work or relevant tools are omitted from identity. Dask presents experimental bounded intermediate-task retention in interactive sessions, favoring costly, compact, reused tasks; inaccurate object-size accounting can exceed the intended memory cap.

**Use and limit:** These support distinct semantic identity/integrity checks, immutable validated sources, complete build/operation contracts and explicit resource accounting. Lexongine's temporal outcome replay, exact full-scope restriction, success-marker promotion and state reconstruction are advisor proposals derived for this project, not guarantees supplied by these frameworks. Automatic validated cross-run reuse is owner-accepted for v1. No adoption of Bazel, Dask, global caching, implicit eviction or a distributed cache is selected.

## AI implementation-readiness follow-up — 2026-10-14

### A01 OpenCode rules and agents

**Primary sources:** [Rules](https://opencode.ai/docs/rules/); [Agents](https://opencode.ai/docs/agents/).

**Reading depth:** Project/global precedence, external references/instructions loading, Build/Plan, custom permissions and compaction.

**Lesson and limit:** A named file reference is not automatically loaded; inspect installed version/config and use focused task references. A Plan label alone does not establish write isolation. Runtime documentation does not prove compliance in a particular session.

### A02 Anthropic effective context engineering

**Primary source:** [Engineering article](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).

**Reading depth:** Clear instructions/examples, retrieval and long-horizon compaction/notes.

**Lesson and limit:** Supply representative examples and relevant contracts; adjust after observed task failures. Vendor engineering guidance does not establish an optimal prompt or a Lexongine performance result.

### A03 Anthropic effective harnesses for long-running agents

**Primary source:** [Engineering article](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

**Reading depth:** Initializer/coding workflow, feature lists, premature completion, testing and session recovery.

**Lesson and limit:** Use coherent increments, actual verification and durable next-step state. The experiment concerns web apps; applying the method to C++ is a project inference, not evidence that additional agents always help.

### A04 Gloaguen et al., Evaluating AGENTS.md, 2026

**Primary source:** [Version1 paper](https://arxiv.org/html/2602.11988v1).

**Reading depth:** Abstract/introduction, main context-file results and limitations.

**Lesson and limit:** Extra generated context files can increase cost and reduce success in studied settings; human-written context differs. The benchmark is heavily Python issue resolution. Keep necessary rules concise and evaluate our own workflow; do not infer a C++ success rate.

### A05 Liu et al., Lost in the Middle, TACL 2024

**Primary source:** [Author paper/abstract](https://aclanthology.org/2024.tacl-1.9/).

**Reading depth:** Published abstract and bibliographic metadata.

**Lesson and limit:** Retrieval/QA performance depended on information position in studied long contexts. This supports checking context usage, not a performance claim about current OpenCode coding agents.

The applied recommendations and one owner batch are in lexongine-ai-implementation-readiness-2026-10-14.md; numeric/boundary references are in lexongine-ai-reference-examples-2026-10-14.json. They are proposals and reference expectations, not product-test results.

## Implementation-hazard follow-up — 2026-10-14

This focused pass checked interactions between existing v1 contracts. The source facts and project deductions below are separate. It supplies engineering corrections and reference cases, not product implementation, passed repository tests or proof that an upstream system establishes Lexongine's semantics. The index remains 56 entries/groups.

**Scheduling and effects — C01–C02, OS09.** Re-read [MLIR effects/speculation](https://mlir.llvm.org/docs/Rationale/SideEffectsAndSpeculation/) Overview/Categorization/Modeling; [current Utils/CSE.cpp](https://mlir.llvm.org/doxygen/Utils_2CSE_8cpp_source.html) source lines125–165,249–295,333–397; its [short pass wrapper](https://github.com/llvm/llvm-project/blob/main/mlir/lib/Transforms/CSE.cpp); [effect interfaces](https://mlir.llvm.org/doxygen/SideEffectInterfaces_8h_source.html) lines549–583; and [ONNX Model Semantics/Graphs](https://onnx.ai/onnx/repo-docs/IR.html).

**Research:** MLIR distinguishes memory freedom from speculation; its CSE duplicate path checks memory effects and uses scoped/dominance-aware replacement rather than a general reordering pass. The wrapper preserves dominance because it deletes without moving operations between blocks. Its effects rationale applies to CFG regions and leaves graph regions unfinished. ONNX's topological graph contract is expressly side-effect-free.

**Design inference:** Freeze the logical topological schedule before sharing, execute a physical producer at its first logical occurrence, and retain later logical read/observer boundaries. Structural congruence makes that projection topological; independently sorting the merged graph can reorder unique actions or move a failure ahead of an earlier partial effect. Preserve logical reached/aborted status independently of physical result existence. Compare deterministic contract-failure prefixes under equivalent admitted conditions; physical allocation/evidence/cache failures may differ when optimization changes work.

**Checked typed erasure and module lifetime — N03, N05–N06, N10.** The binding audit inspected C++20 [N4861](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/n4861.pdf) [type.info] and [any.nonmembers], PDF pp.519,611–616; corroborating short current clauses [type.info](https://eel.is/c++draft/type.info) and [any.nonmembers](https://eel.is/c++draft/any.nonmembers); targeted handler/type-comparison passages in libc++ [any](https://github.com/llvm/llvm-project/blob/main/libcxx/include/any) and [typeinfo](https://github.com/llvm/llvm-project/blob/main/libcxx/include/typeinfo); and the short [visibility design](https://libcxx.llvm.org/DesignDocs/VisibilityMacros.html). Loader evidence remains N10's Apple source.

**Research:** Pointer-form any_cast is noexcept and returns null for a mismatched contained type. type_info equality identifies a type; its names/hashes are not stable cross-program identities. libc++ contains type-specific erased handlers and platform-sensitive RTTI comparison, including Apple arm64 behavior. These source implementations are not a portable C++ plugin ABI guarantee.

**Design inference:** Require both semantic type meaning and a checked actual C++ witness; nominal strings/size/alignment cannot authorize a cast. Keep module pins alive through callbacks, erased managers, payload destruction and control-block destruction, including the return from plugin code; host-owned destruction dispatch/control blocks avoid dropping the last pin inside still-running plugin cleanup. Verify visibility and wrong-type cases on the selected macOS build. This is a trusted same-build bridge, not isolation or a stable ABI.

**Implementation identity and cache hermeticity — N11.** Re-read [Bazel remote/disk caching](https://bazel.build/remote/caching) action/result separation, writer permissions and known issues; extend this group with [Hermeticity](https://bazel.build/basics/hermeticity) Overview and non-hermeticity/troubleshooting sections. The cache audit read the listed cache passages; this follow-up inspected the short hermeticity page.

**Research:** Bazel treats tools and dependencies as relevant inputs, separates action-result metadata from output content, and warns about source mutation, undeclared external tools and cache writers.

**Design inference:** Separate SDK/ABI compatibility from actual implementation identity. Bind validated immutable input bytes; include host/module/dependency content and build-manifest identities in reuse keys rather than trusting an unchanged operation version or author build label. SHA-256 detects changed bytes, not honest computation by an arbitrary writer. Exact outcome replay, full-scope matching and reconstructed working state remain project rules.

**Acceptance visibility versus crash durability — N11, with N10 platform verification.** Supporting primary sources: POSIX Issue8 [rename](https://pubs.opengroup.org/onlinepubs/9799919799/functions/rename.html), [General Concepts §4.4 and storage/crash rules](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html), and [directory-durability rationale](https://pubs.opengroup.org/onlinepubs/9799919799/xrat/V4_xbd_chap01.html). Reading used cached primary search passages; direct pages returned403, so a complete live-page read is not claimed. The cache audit also inspected selected hardware-assumption, commit-point, multi-file and crash-test passages of [SQLite Atomic Commit](https://www.sqlite.org/atomiccommit.html), not its implementation.

**Research:** POSIX directory operations are atomic/serializable in the running system; persistence after a crash is a separate matter. The rename target-unaffected failure guarantee excludes EIO. SQLite documents an explicit commit point and multi-file/crash protocol; a collection of ordinary file writes is not automatically one transaction.

**Design inference:** Distinguish numerical completion from final acceptance. Complete all mandatory payload/evidence/log writes and closes before the final acceptance marker; perform no later mandatory operation that can retroactively fail that acceptance. Require the marker plus validated referenced files for reuse. Resolve ambiguous commit errors under the selected adapter's lock/recovery contract rather than assuming a failed rename proves marker absence. V1 does not promise crash-durable preservation, a multi-file transaction or exactly-once success notification, and does not adopt SQLite.

**Temporal lineage and current publication — OS03–OS04, G07.** Extend the existing stream-time groups with the [Dataflow Model author paper](https://www.vldb.org/pvldb/vol8/p1792-Akidau.pdf), selected pp.2–4, and [Flink2.2 Timely Stream Processing](https://nightlies.apache.org/flink/flink-docs-release-2.2/docs/concepts/time/), notions-of-time/watermark/window passages, read by the temporal audit.

**Research:** Event occurrence, operator processing and output triggering are distinct dimensions; physical buffering does not itself establish decision-time eligibility.

**Design inference:** Keep producer UpdateContext independent of consumer evaluation phase; RequestContext owns each mask. A phase-sensitive kernel needs an explicit semantic phase input. Lag keeps old-parent timing as lineage, while the new publication's availability includes current activation and all required dependencies; cache delivery follows the same boundary. These sources do not prescribe Lexongine's maximum-availability rule, fixed-count lag or finite synchronous closure.
