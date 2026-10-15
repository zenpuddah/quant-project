# Axthena — research catalogue

Research date: 14 October 2026. Status: advisory research; no architecture choice accepted by this report. Links identify primary works or their official documentation. Live documentation is dated by inspection, not assigned an invented publication year.

Read with [the three-round review](Axthena-three-round-design-review-2026-10-14.md) and [the proposed plan](Axthena-proposed-implementation-plan-2026-10-14.md). Existing requirements remain in [Axthena-context.md](Axthena-context.md) and [Axthena-engineering-context.md](Axthena-engineering-context.md).

## Fast access

| Need | Start here | Application |
|---|---|---|
| Closest existing systems | O01–O04 | Borrow patterns; inspect authority and history assumptions. |
| Local graph storage | O05–O08 | Compare operational effort and real queries. |
| Evidence and qualified statements | G01–G04 | Preserve assertions, scope and derivations. |
| Time and matching | G05–G07 | Separate clocks; avoid irreversible false merges. |
| Counting and dependence | G08–G09, S01–S02 | A derivation, publication and independent observation differ. |
| Extraction uncertainty | S03–S04 | Abstain and check support, not just schema. |
| Efficient processing | C01–C03, C07–C11 | Reuse exact work; bound execution and costs. |
| Compiler ideas | C04–C06 | Typed stages and representations, without a compiler framework. |
| Configuration and flexibility analogies | B01–B06 | Stable core, bounded variation, replaceable adapters. |
| Engineering explanation method | P01–P02 | Trace components, constraints, invariants and tests; personal study references omitted. |

Depth labels: **reviewed** means the relevant primary text, documentation or sections were inspected; it does not mean every page of a book was read. **Abstract** limits the conclusion to the original abstract. **Lead** means a bibliographic resource for another round, not evidence used to select this architecture. **Proposal** is our application of a source, not something its authors proved about Axthena.

## Open-source precedents — researched first

### O01 — Graphiti

Zep and contributors; live repository. [Source](https://github.com/getzep/graphiti). **Reviewed; reference pattern.** Apache-2.0 temporal graph framework linking derived relationships to input episodes. It supports configurable entity types and retrieval. Useful for tracing extracted information to evidence. Its graph terminology and automated contradiction handling do not implement Axthena’s external confirmation rule. OSS Graphiti and proprietary hosted Zep are different products. Kuzu support is deprecated. Do not transfer vendor latency claims to Axthena.

### O02 — Zep: A Temporal Knowledge Graph Architecture for Agent Memory

Preston Rasmussen, Pavlo Paliychuk, Travis Beauvais, Jack Ryan and Daniel Chalef, 2025. [Version 1](https://arxiv.org/html/2501.13956v1). **Reviewed, §§2–4; reference with rejected default.** Episode, entity and community layers offer useful provenance and time ideas. Section 2.2.3 prioritises newly ingested information for LLM-driven edge invalidation. Axthena must reject that authority rule: newly downloaded material can be an old rumour. The experiments concern conversation memory, not confirmation of financial information.

### O03 — Microsoft GraphRAG

Microsoft contributors; first release 2024. [Repository](https://github.com/microsoft/graphrag), [indexing dataflow](https://microsoft.github.io/graphrag/index/default_dataflow/), [Edge et al., original paper](https://arxiv.org/abs/2404.16130). **Reviewed repository/dataflow; reference pattern.** Text units, extracted entities and graph summaries illustrate separate processing products. The current repository is largely in maintenance mode; MIT licensed. Summaries and endpoint-based merging must not erase source-specific expression or claim scope. Community summarisation is a later option, not a prerequisite for V1 evidence queries.

### O04 — KAG / OpenSPG

Lei Liang, Mengshu Sun, Zhengke Gui and colleagues, 2024; contributors. [KAG repository](https://github.com/OpenSPG/KAG), [paper v3](https://arxiv.org/html/2409.13731v3), [deployment source](https://raw.githubusercontent.com/OpenSPG/openspg/master/dev/release/docker-compose-west.yml). **Reviewed; reference pattern.** Apache-2.0; schema-guided knowledge construction, graph/chunk links and logical operations. Useful inspiration for structured queries and evidence retrieval. The default multi-service deployment and model-call overhead exceed this MVP’s needs. Builder/solver concepts do not require adopting its model training. Schema consistency does not establish factual correctness.

### O05 — Ladybug and the Kuzu lineage

LadybugDB contributors, live 2026. [Repository](https://github.com/LadybugDB/ladybug), [releases](https://github.com/LadybugDB/ladybug/releases), [concurrency](https://docs.ladybugdb.com/concurrency/), [archived Kuzu](https://github.com/kuzudb/kuzu). **Reviewed; leading backend candidate.** MIT embedded property graph with Cypher and Python bindings; release 0.21.2 is dated 1 October 2026. On-disk use permits one read/write database object or multiple read-only objects. This suits phase-separated preparation and reading. Kuzu was archived on 10 October 2025. Ladybug’s recovery, migrations and actual dialect compatibility still require a small conformance test.

### O06 — Neo4j Community

Neo4j contributors, current documentation. [Editions](https://neo4j.com/docs/operations-manual/current/introduction/), [users](https://neo4j.com/docs/operations-manual/current/authentication-authorization/manage-users/), [settings](https://neo4j.com/docs/operations-manual/current/configuration/configuration-settings/), [offline backup](https://neo4j.com/docs/operations-manual/current/backup-restore/offline-backup/). **Reviewed; alternative backend.** GPLv3 Community supports single-instance Cypher and transactions. It adds a local service. Community users have implied administrator privileges; a driver read session is not a restricted reader account. Current read-only default setting is `server.databases.default_to_read_only`. Additional databases, richer constraints and online backup have edition limits. Account for these when comparing deployment effort.

### O07 — SQLite

SQLite authors, current documentation. [Appropriate uses](https://sqlite.org/whentouse.html), [recursive graph queries](https://sqlite.org/lang_with.html), [URI/read-only access](https://sqlite.org/uri.html). **Reviewed; alternative backend.** Public-domain embedded transactional storage can represent the complete logical graph. Recursive queries can traverse relationships. Local deployment is simple, but the investigator’s evidence-qualified paths need deliberate SQL or application traversal. One-computer use alone is insufficient reason to choose it. A second graph projection would add synchronization work; do not introduce it without a demonstrated need.

### O08 — DuckDB

Mark Raasveldt and Hannes Mühleisen, 2019; DuckDB contributors. [Original paper](https://hannes.muehleisen.org/publications/SIGMOD2019-demo-duckdb.pdf), [current internals](https://duckdb.org/docs/current/internals/overview), [concurrency](https://duckdb.org/docs/current/connect/concurrency). **Reviewed; analytical alternative/later export tool.** Embedded analytical SQL suits tabular filtering and aggregates. Current documentation describes push-based vectorised execution, differing from the original paper’s execution description. It can be the sole structured store if numerical work dominates. It is not needed alongside a graph store for V1’s initial counts and JSON export.

## Graphs, evidence and identity

### G01 — W3C PROV-DM

Luc Moreau and Paolo Missier, editors, 2013. [Recommendation](https://www.w3.org/TR/prov-dm/). **Reviewed; apply now.** Entities, activities and responsible agents provide a vocabulary for evidence, extraction and decisions. Use a compact Axthena contract inspired by these distinctions. Provenance helps assess a record; it does not certify its truth. Full RDF/OWL or standard-wide implementation is unnecessary for this MVP.

### G02 — W3C PROV Constraints

James Cheney, Paolo Missier and Luc Moreau, editors; Tom De Nies, contributor, 2013. [Recommendation](https://www.w3.org/TR/prov-constraints/). **Reviewed; apply now.** Temporal and structural constraints motivate validation of generation, usage and derivation histories. Check that every published output has resolvable inputs and correctly ordered processing records. Consistent lineage can still contain a wrong extraction. Do not report graph integrity as factual accuracy.

### G03 — Qualified Wikidata statements

Fredo Erxleben, Michael Günther, Markus Krötzsch, Julian Mendez and Denny Vrandečić, 2014. [Original paper](https://iccl.inf.tu-dresden.de/w/images/3/3a/Wikidata-RDF-export-2014.pdf). **Reviewed; apply now.** Statement references and qualifiers preserve scope. For Axthena, currency, period, business unit, geography and conditional wording can determine whether two claims actually conflict. A convenient direct graph edge should not discard those qualifications. Wikidata’s ranks do not substitute for Axthena’s confirmation process.

### G04 — Knowledge Graphs

Aidan Hogan and colleagues, 2021. [Survey and version history](https://arxiv.org/abs/2003.02320). **Reviewed relevant sections; apply now.** Distinguishes graph data models, identity, schema, context and query reasoning. Use typed relationships and explicit identities. Sharing an idea is different from resolving two names to one organisation. The survey supplies a design vocabulary, not a stock-specific ontology or proof that one graph engine is fastest.

### G05 — Temporal Data Management

Christian S. Jensen and Richard T. Snodgrass, 1999. [Original article](https://www2.cs.arizona.edu/~rts/pubs/TKDEJan99.pdf). **Reviewed; apply now.** Valid time and transaction time distinguish what data says about the world from when the system recorded it. Axthena also needs source-version availability. An event date, publication date, capture date and decision date cannot be interchangeable. Borrow the distinctions without adding a full real-time temporal database subsystem in V1.

### G06 — A Theory for Record Linkage

Ivan P. Fellegi and Alan B. Sunter, 1969. [Original paper](https://www.cs.cornell.edu/~shmat/courses/cs6434/fellegi-sunter.pdf). **Reviewed; conceptual application.** Matching can end in match, nonmatch or unresolved. Preserve uncertainty instead of merging ambiguous accounts or organisations. Its statistical results depend on assumptions; no probabilistic identity model is proposed for V1. Platform-native account IDs and analyst-reviewed entity mappings are simpler initial mechanisms.

### G07 — Swoosh: a Generic Approach to Entity Resolution

Omar Benjelloun, Hector Garcia-Molina, David Menestrina, Qi Su, Steven E. Whang and Jennifer Widom; online 2008, journal 2009. [Publisher record](https://doi.org/10.1007/s00778-008-0098-x). **Reviewed; apply the boundary.** Matching and merging are different operations, with properties that affect resolution behaviour. Keep candidate similarity separate from accepted, reversible associations. Embedding proximity is not a transitive proof of identity or proposition equivalence. Do not introduce Swoosh as an implementation dependency.

### G08 — Provenance Semirings

Todd J. Green, Grigoris Karvounarakis and Val Tannen, 2007. [Original paper](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf). **Reviewed; apply the distinction.** Alternative derivations differ from inputs jointly required by a derivation. Preserve explicit supporting-record IDs for a relevance path. Counting paths is not counting independent evidence. A semiring implementation is unnecessary; simple lineage records suffice for the first queries. The core results concern positive relational algebra, not every possible historical query.

### G09 — Integrating Conflicting Data: The Role of Source Dependence

Xin Luna Dong, Laure Berti-Equille and Divesh Srivastava, 2009. [Original paper](https://www.lunadong.com/publication/dependence_vldb.pdf). **Reviewed; apply warning, reject automatic truth voting.** Copying and common origins undermine naïve majority voting. Store documented lineage per expression, since one article can relay several origins. Use publication counts and documented-origin counts separately. The paper’s automated truth discovery relies on a particular data setting; it is not Axthena’s external confirmation policy.

### G10 — Graph Theory

Reinhard Diestel. [Author’s site](https://diestel-graph-theory.com/), [preview](https://diestel-graph-theory.com/basic.html). **Lead; foundational reading.** Consult paths, cycles and connectivity when formalising traversal. This review verified the author’s resource, not the whole book. Axthena’s proposed bounded traversal is an engineering design requiring tests; it is not justified by a claim that the business graph is acyclic.

## Statistics and applied ML boundaries

### S01 — Causal Inference in Statistics: An Overview

Judea Pearl, 2009. [Original article](https://ftp.cs.ucla.edu/pub/stat_ser/r350.pdf). **Reviewed relevant sections; apply boundary now.** Causal questions require assumptions and identification beyond observed associations. An evidenced supplier path supplies context; a later price movement does not prove the event caused it. V1 records assertions, potential effects and observations separately. Estimating market causality is deferred.

### S02 — Strictly Proper Scoring Rules, Prediction, and Estimation

Tilmann Gneiting and Adrian E. Raftery, 2007. [Original paper](https://sites.stat.washington.edu/raftery/Research/PDF/Gneiting2007jasa.pdf). **Reviewed; later measurement.** Proper scores are relevant to explicit probabilistic forecasts with defined outcomes. An UP/DOWN label without probability is not that forecast. LLM extraction confidence, agreement strength and dummy person values must not become a market probability. Keep this reference for later quant evaluation, not a new V1 scoring model.

### S03 — On the Foundations of Noise-free Selective Classification

Ran El-Yaniv and Yair Wiener, 2010. [JMLR article](https://www.jmlr.org/papers/v11/el-yaniv10a.html), [full paper](https://www.jmlr.org/papers/volume11/el-yaniv10a/el-yaniv10a.pdf). **Reviewed; apply abstention concept.** A reject option trades coverage against errors. Axthena needs explicit insufficiency outcomes rather than forced labels. Its theoretical noiseless assumptions do not hold automatically for an LLM. Use deterministic required-information rules and manual quality checks, without claiming a proven extraction-error bound.

### S04 — Enabling Large Language Models to Generate Text with Citations

Tianyu Gao, Howard Yen, Jiatong Yu and Danqi Chen, 2023. [ALCE paper](https://aclanthology.org/2023.emnlp-main.398/). **Reviewed; apply evaluation distinction.** Citation presence, support and correctness are different checks. Validate exact spans mechanically, then assess whether the text actually supports the extracted subject, direction, scope and voice. The benchmark is not an Axthena test result. A short representative extraction review is quality assurance, not predictive-model training.

### S05 — The Elements of Statistical Learning, second edition

Trevor Hastie, Robert Tibshirani and Jerome Friedman, 2009. [Publisher](https://link.springer.com/book/10.1007/978-0-387-84858-7), [author resource](https://hastie.su.domains/ElemStatLearn/main.html). **Lead.** Bibliography and subject matter verified; author download routes were unavailable during this review. Model assessment/selection is a useful later study topic. No architecture recommendation here relies on an unread chapter, and no empirical person model or predictive training enters V1.

## Computation and compilation

### C01 — The Volcano Optimizer Generator

Goetz Graefe and William J. McKenna, 1993. [Original paper](https://www.engineering.upenn.edu/~zives/03s/cis650/P209.PDF). **Reviewed; borrow structure.** Logical operations and their execution methods are different. Make collection, normalisation, extraction, validation and querying explicit operations. Leave physical query optimisation to the selected engine. Its plan search is not evidence corroboration or semantic clustering.

### C02 — The Cascades Framework for Query Optimization

Goetz Graefe, 1995. [Original paper](https://15721.courses.cs.cmu.edu/spring2020/papers/19-optimizer1/graefe-ieee1995.pdf). **Reviewed; borrow bounded work.** Memoisation and scheduling avoid repeated search. Use explicit task identity, dependencies and work limits. A custom cost-based optimiser offers too little justified benefit at this scope. Reconsider only after a measured bottleneck and meaningful alternative plans exist.

### C03 — Apache Calcite

Edmon Begoli, Jesús Camacho Rodríguez, Julian Hyde, Michael J. Mior and Daniel Lemire, 2018. [Original paper](https://arxiv.org/abs/1802.10233). **Reviewed; borrow adapters.** Adapters and a common representation separate source-specific access from shared processing. One provider adapter and curated primary-source access suffice initially. Calcite itself and federated live queries are unnecessary. Database CPU/I/O estimates do not automatically account for LLM dollar costs.

### C04 — LLVM

Chris Lattner and Vikram Adve, 2004. [Original publication](https://llvm.org/pubs/2004-01-30-CGO-LLVM.html). **Reviewed; borrow typed representations.** A common typed representation supports several transformations. Axthena can validate ordinary typed records between stages. It does not need machine-code generation or LLVM. Compiler correctness cannot certify the truth of source assertions.

### C05 — MLIR

Chris Lattner and colleagues, 2021; preprint 2020. [Official publication list](https://mlir.llvm.org/pubs/), [paper](https://arxiv.org/abs/2002.11054). **Reviewed; borrow multiple levels.** Different abstraction levels can retain the information each transformation needs. Keep raw evidence, source-grounded extraction and reviewed graph records separate. Ordinary functions and schemas provide this benefit in V1; adopting MLIR would add unnecessary infrastructure.

### C06 — egg: Fast and Extensible Equality Saturation

Max Willsey, Chandrakana Nandi, Yisu Remy Wang, Oliver Flatt, Zachary Tatlock and Pavel Panchekha, 2021. [Original paper](https://arxiv.org/abs/2004.03082). **Reviewed; later/rejected for grouping.** E-graphs represent equivalences supplied by rewrite rules. Similar news wording does not prove semantic equivalence. Do not use equality saturation to merge opinions or factual claims. It may become relevant only if a future exact query algebra needs many verified rewrites.

### C07 — Build Systems à la Carte

Andrey Mokhov, Neil Mitchell and Simon Peyton Jones, 2018. [Original paper](https://simon.peytonjones.org/assets/pdfs/build-systems-original.pdf). **Reviewed, especially §6.4; apply now.** Separate scheduling from deciding what must be rebuilt. Cache by actual dependencies. Nondeterministic intermediate results can create inconsistent builds if downstream caches ignore the intermediate output actually consumed. An LLM request identity is therefore distinct from its response identity. This is the strongest reference for Axthena’s processing reuse.

### C08 — The Purely Functional Software Deployment Model

Eelco Dolstra, 2006. [Author’s thesis record](https://research-portal.uu.nl/en/publications/the-purely-functional-software-deployment-model/). **Reviewed record/design principle; borrow immutability.** Explicit dependencies and immutable components support reproducible reuse. Axthena must capture external API bodies and model responses, because neither external service is a pure function of the request. Do not require Nix to adopt dependency-aware records.

### C09 — Apache Arrow Columnar Format

Apache Arrow contributors, live specification. [Specification](https://arrow.apache.org/docs/format/Columnar.html). **Reviewed; later interchange.** Columnar memory layouts support bulk interchange and vectorised processing. Useful if large tabular exports justify it. Arrow is not the original-evidence archive, and zero-copy depends on compatible interfaces. Ordinary JSON is sufficient for the first small program-facing queries.

### C10 — Apache Parquet Concepts

Apache Parquet contributors, current documentation. [Concepts](https://parquet.apache.org/docs/concepts/). **Reviewed; later export.** Row groups, column chunks and pages support compressed tabular storage. A possible format for later numerical research exports. Do not add one tiny Parquet file per article or a second authoritative analytical database in V1.

### C11 — Zstandard

Yann Collet and Murray Kucherawy, RFC 8878, 2021; Zstandard contributors. [RFC](https://www.rfc-editor.org/info/rfc8878/), [official implementation](https://github.com/facebook/zstd). **Reviewed; candidate archive codec.** Lossless compression preserves original bytes after decompression. Identify evidence by its uncompressed-byte hash, independent of codec settings. Compression is neither semantic grouping nor source authentication. Verify round-trip integrity and actual storage/CPU costs; RFC 8878 also has a later update, RFC 9659.

## Creative scientific transfers

These are hypotheses and analogies, not biological proofs of software performance. Each transfer must independently earn its place through Axthena’s requirements and tests.

### B01 — The Theory of Facilitated Variation

John Gerhart and Marc Kirschner, 2007. [Original paper](https://www.pnas.org/doi/10.1073/pnas.0701035104). **Reviewed; analogy.** Conserved core processes can be recombined and regulated in different contexts. Proposal: keep evidence/identity/time contracts stable while configuring source selection, extraction rules and views. This supports bounded configuration around a stable core. It does not justify evolutionary optimisation, arbitrary plugin execution or an automatically changing ontology in V1.

### B02 — Degeneracy and Complexity in Biological Systems

Gerald M. Edelman and Joseph A. Gally, 2001. [Original abstract](https://pubmed.ncbi.nlm.nih.gov/11698650/). **Abstract; analogy.** Different structures can perform a function, depending on context. Proposal: different providers can satisfy the same acquisition contract if their actual evidence meets it. “Replaceable adapter” does not mean equivalent source coverage or quality. Do not pay for several redundant providers or LLM ensembles without a demonstrated need.

### B03 — Cascade Models of Synaptically Stored Memories

Stefano Fusi, Patrick J. Drew and L. F. Abbott, 2005. [Original paper](https://www.rctn.org/cadieu/pdf/FusiNeuron05.pdf). **Reviewed; analogy with a rejected transfer.** Multiple plasticity timescales motivate thinking about stable retained evidence and disposable fast-access structures separately. Software evidence does not need neural decay. Reject biological forgetting for source retention: an unpinned query cache can be discarded, but the evidence behind a retained output must survive.

### B04 — Bow Ties, Metabolism and Disease

Marie Csete and John Doyle, 2004. [Author’s publication record](https://doyle.caltech.edu/File%3ATrends04.pdf), [original abstract](https://pubmed.ncbi.nlm.nih.gov/15331224/). **Abstract/publication record; analogy.** Diverse inputs and outputs can meet through a constrained core. Proposal: several source formats feed a small evidence contract, serving human inspection and machine queries. The narrow core can also become a bottleneck or lose meaning. Preserve source-specific material outside it and test dropped qualifiers. No claim of globally optimal architecture follows.

### B05 — An Introduction to Cybernetics

W. Ross Ashby, 1956; authorised digital edition. [Book](https://ashby.info/Ashby-Introduction-to-Cybernetics.pdf). **Reviewed relevant portions, especially ch.11; analogy.** Regulation must distinguish the situations requiring different responses. Proposal: distinguish unavailable, failed, insufficient and successfully empty inputs rather than force one status. A finite typed configuration should support the required cases and reject unsupported ones. No adaptive control system is needed in V1.

### B06 — The Architecture of Complexity

Herbert A. Simon, 1962. [Original article hosted by CMU](https://www.andrew.cmu.edu/course/15-440/assets/READINGS/simon-architecture-of-complexity-1962.pdf). **Lead.** The primary article’s bibliographic trace was found, but full retrieval failed. Near-decomposability is a promising later lens for processing boundaries. This review’s module recommendation rests on explicit Axthena failure/reuse needs and compiler/build-system sources, not a pretence of reading this unavailable text.

### B07 — Non-technical reference omitted

Personal-study research is omitted from this repository edition. It is not part of the implementation authority.

## Acquisition feasibility

### D01 — EODHD Financial News API

EODHD, current official documentation. [News](https://eodhd.com/financial-apis/stock-market-financial-news-api), [limits](https://eodhd.com/financial-apis/api-limits), [pricing](https://eodhd.com/pricing). **Reviewed documentation; sample still required.** Documentation exposes date filtering, pagination up to 1,000 items, a body field and original link. News requests cost five API-call credits; free documentation advertises past-year access, 20 daily credits and a welcome allowance. The news page displays a USD starting price while the retrieved pricing page displays EUR. Verify actual currency/plan, NVDA/MSFT access, historical wording and retention before committing. No authenticated target-stock sample or purchase was made.

### D02 — SEC EDGAR

U.S. Securities and Exchange Commission, official access documentation. [Access](https://www.sec.gov/search-filings/edgar-search-assistance/accessing-edgar-data). **Reviewed; primary evidence candidate.** Historical filings are freely downloadable, with explicit access rules and stable filing identifiers. Issuer identity and disclosed financial statements can be checked against primary records. SEC documents themselves warn about corrections and limitations of ticker mappings. EDGAR is not a complete news/opinion archive or proof that all disclosed contents are true.

## P01–P02 — Personal study inputs omitted

Private-note links and personal-study framing are omitted from this repository edition. The technical method retained here is to identify components, relationships, constraints and local decision information, then test invariants and counterexamples.

## Entry point for another research round

1. Give the next researcher this catalogue, the current business/engineering contexts and the three-round review. Do not treat the frozen earlier reviews as the latest requirements.
2. Investigate a specific unresolved question: backend recovery/dialect on the target machine; authenticated historical text quality; or exact confirmation/grouping policy. Ask for a bounded sample and a falsifiable comparison.
3. Verify live repository status, release, documentation version and provider prices again before adoption. Archive the actual chosen source contracts and tested versions in the eventual project.
4. For each new recommendation, record supporting catalogue IDs, counterexample, acceptance test, confidence and owner decision. Promote it to accepted only when Badr accepts it.
5. Study G10/S05/B06 if their original texts become needed; do not cite their unread contents as established evidence.

This research supplies architectural reasoning. It supplies no Axthena runtime benchmark, extraction accuracy estimate, predictive edge, complete historical corpus or causal result.
