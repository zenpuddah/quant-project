// AXTHENA MODEL LAB — read-only review queries. ALL fixture data is fictional.
// First run Axthena-model-lab-load.cypher in an empty disposable database.
// Then run ONE numbered query at a time. No APOC/extensions are required.
// Cutoffs below select fictional SOURCE information retrospectively.
// They do not claim that Axthena's 2026 annotations existed in 2025.

// G0 — Optional graph overview of the world, without all evidence records.
// This is the full fictional world, not an as-of query.
MATCH path=(:AxLab)-[link]->(:AxLab)
WHERE type(link) IN ['POINTS_TO','OWNS','OPERATES_IN','COMPETES_WITH',
                    'DEPENDS_ON','CONCERNS','FOLLOWS_ANNOUNCEMENT','REPRESENTS',
                    'HAS_PROCESS','RUNS_PROCESS','USES_RESOURCE','PRODUCES']
RETURN path;

// Q0 — Did the complete fixture load?
// Expected: nodes=174, relationships=324, passed=true.
MATCH (n:AxLab)
WITH count(n) AS nodes
OPTIONAL MATCH (:AxLab)-[r]->(:AxLab)
RETURN nodes, count(r) AS relationships,
       nodes = 174 AND count(r) = 324 AS passed;

// Q1 — Graph picture: three reports, three expressions, one shared idea.
// In Browser, select the Graph result. Expected: three result rows.
MATCH statement = (r:AxLab:Report)-[:CONTAINS]->(x:AxLab:Expression)
                  -[:EXPRESSES]->(i:AxLab:Idea {id:'axlab/idea/partnership'})
MATCH evidence = (x)-[:SUPPORTED_BY]->(:AxLab:Passage)
                 -[:PART_OF]->(:AxLab:EvidenceVersion)
MATCH publication = (r)-[:PUBLISHED_IN]->(:AxLab:Source)
RETURN statement, evidence, publication;

// Q2 — Was reporting confused with endorsement or independent confirmation?
// Expected: 3 reports, 1 documented original information origin.
// North=strong support; company and South=not stated. South is a known copy.
MATCH (r:AxLab:Report)-[:CONTAINS]->(x:AxLab:Expression)
      -[:EXPRESSES]->(:AxLab:Idea {id:'axlab/idea/partnership'})
MATCH (r)-[:PUBLISHED_IN]->(s:AxLab:Source)
MATCH (x)-[:SUPPORTED_BY]->(p:AxLab:Passage)-[:PART_OF]->(v:AxLab:EvidenceVersion)
MATCH (x)-[:INFORMATION_ORIGIN]->(origin:AxLab)
OPTIONAL MATCH (r)-[:REPRODUCES]->(original:AxLab:Report)
RETURN s.name AS publisher, origin.name AS information_origin,
       coalesce(x.agreement_strength,'not stated') AS expressed_agreement,
       original.title AS copied_report, v.sha256 AS content_hash,
       p.text AS exact_passage
ORDER BY publisher;

// Q3 — What does the stock point to? A supplier is not an owned company.
// Expected: issuer NovaChip (2 domains), contributing NovaCloud (1 domain).
// ForgeFoundry/LithoWorks/SoftPeak must not appear as stock-group members.
MATCH (s:AxLab:Stock {ticker:'NOVA'})-[link:POINTS_TO]->(o:AxLab:Organisation)
OPTIONAL MATCH (o)-[:OPERATES_IN]->(d:AxLab:Domain)
RETURN s.ticker AS stock, o.name AS organisation, link.association AS association,
       collect(DISTINCT d.name) AS domains
ORDER BY association;

// Q4 — Which events have supporting source information at each cutoff?
// Expected counts: Mar3 23:00=3; Mar4 08:00=4; Mar4 10:00=5; Mar10 10:00=8.
// Quake occurred Mar3 but source is available Mar4. Production is separate
// from the Mar4 announcement and is only reported on Mar10.
UNWIND ['2025-03-03T23:00:00Z','2025-03-04T08:00:00Z',
        '2025-03-04T10:00:00Z','2025-03-10T10:00:00Z'] AS cutoff
MATCH (x:AxLab:Expression)-[:ABOUT]->(e:AxLab:Event)
MATCH (x)-[:SUPPORTED_BY]->(:AxLab:Passage)-[:PART_OF]->(v:AxLab:EvidenceVersion)
WHERE v.source_available_at <= cutoff
WITH cutoff, collect(DISTINCT e) AS events
RETURN cutoff, size(events) AS event_count,
       [e IN events | {event:e.name, occurrence:e.occurred_at}] AS supported_events
ORDER BY cutoff;

// Q5 — Named and anonymous people retain their own statements and judgments.
// Expected: 4 rows, 3 account identities. UP/DOWN refer only to NOVA stock.
// The same dummy vector is domain-independent, not a measured reputation.
// 'near' keeps missing timing explicit; numerical default duration is unselected.
MATCH (r:AxLab:Report {category:'opinion'})-[:CONTAINS]->(x:AxLab:Expression)
MATCH (x)-[:EXPRESSED_BY]->(a:AxLab:Person)-[:HAS_WEIGHT]->(w:AxLab:PersonWeight)
MATCH (x)-[:HAS_JUDGMENT]->(j:AxLab:Judgment)-[:TARGETS]->(s:AxLab:Stock)
OPTIONAL MATCH (x)-[:ABOUT_DOMAIN]->(d:AxLab:Domain)
RETURN a.name AS person, a.platform_account_id AS account, a.anonymous AS anonymous,
       s.ticker AS stock, d.name AS subject_domain, x.domain_status AS domain_note,
       j.direction AS direction, j.horizon_phrase AS source_timing,
       j.horizon_origin AS timing_origin, j.default_policy AS default_note,
       coalesce(x.agreement_strength,'not stated') AS expressed_agreement,
       [w.credibility,w.influence,w.predictive_record] AS person_vector,
       w.value_status AS vector_status, w.domain_dependent AS domain_dependent
ORDER BY account, source_timing;

// Q6 — Can two personal accounts share meaning without losing identity?
// Expected: 2 expressions, 2 people, 2 passages, 1 UP idea.
// The opposite DOWN view has a separate idea; shared subject is not shared meaning.
MATCH (x:AxLab:Expression)-[:EXPRESSES]->(i:AxLab:Idea {id:'axlab/idea/up-two-weeks'})
MATCH (x)-[:EXPRESSED_BY]->(a:AxLab:Person)
MATCH (x)-[:SUPPORTED_BY]->(p:AxLab:Passage)
RETURN i.summary AS shared_meaning, count(DISTINCT x) AS expressions,
       count(DISTINCT a) AS people, count(DISTINCT p) AS retained_passages,
       count(DISTINCT x)=2 AND count(DISTINCT a)=2 AND count(DISTINCT p)=2 AS passed;

// Q7 — A later conflicting confirmation must not rewrite an earlier answer.
// Expected: at 11:00 [80.0], confirmed_under_fixture_rule;
//           at 13:00 [80.0,82.0] (order unspecified), on_hold.
// These rules/processes are illustrative, not an accepted confirmation policy.
// The affected scope is the revenue figure, not the whole earnings event.
UNWIND ['2025-03-07T11:00:00Z','2025-03-07T13:00:00Z'] AS cutoff
MATCH (f:AxLab:Fact {scope:'NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD'})
      -[:CONFIRMED_BY]->(c:AxLab:Confirmation)-[:SUPPORTED_BY]->(:AxLab:Passage)
      -[:PART_OF]->(v:AxLab:EvidenceVersion)
WHERE v.source_available_at <= cutoff
WITH cutoff, collect(DISTINCT f.value) AS values,
     collect(DISTINCT c.process) AS confirming_processes
RETURN cutoff, values, confirming_processes,
       CASE WHEN size(values)>1 THEN 'on_hold'
            ELSE 'confirmed_under_fixture_rule' END AS derived_status
ORDER BY cutoff;

// Q8 — A potential indirect effect needs its entire supporting chain.
// Expected: Mar4 12:00 eligible=false; Mar5 12:00 eligible=true.
// ForgeFoundry's equipment dependency arrives Mar5, after quake news Mar4.
// The interpretation stays a hypothesis; it supplies no stock-price direction.
UNWIND ['2025-03-04T12:00:00Z','2025-03-05T12:00:00Z'] AS cutoff
MATCH (i:AxLab:Interpretation {id:'axlab/interpretation/quake-nova'})
MATCH (i)-[:SUPPORTED_BY]->(:AxLab:Expression)-[:SUPPORTED_BY]->(:AxLab:Passage)
      -[:PART_OF]->(event_source:AxLab:EvidenceVersion)
MATCH (i)-[:REQUIRES]->(d:AxLab:Dependency)
OPTIONAL MATCH (d)-[:SUPPORTED_BY]->(:AxLab:Expression)
      -[:SUPPORTED_BY]->(:AxLab:Passage)-[:PART_OF]->(dependency_source:AxLab:EvidenceVersion)
WITH cutoff, i, event_source.source_available_at AS event_available, d,
     collect(dependency_source.source_available_at) AS dependency_dates
WITH cutoff, i, event_available,
     collect({dependency:d.id, source_dates:dependency_dates,
              eligible:any(source_date IN dependency_dates WHERE source_date <= cutoff)}) AS required_support
RETURN cutoff,
       event_available <= cutoff AND all(support IN required_support WHERE support.eligible) AS eligible,
       i.summary AS proposed_interpretation, i.status AS status,
       i.causal_stock_direction_established AS causal_direction_established,
       required_support
ORDER BY cutoff;

// Q9 — Dependency paths are bounded, cycle-safe, and source-time filtered.
// Expected: Mar4 12:00 paths=0; Mar5 12:00 paths=1.
// The fixture deliberately contains a ForgeFoundry -> chip-domain cycle.
// Bound=3 is a review-query setting, not a selected production limit.
UNWIND ['2025-03-04T12:00:00Z','2025-03-05T12:00:00Z'] AS cutoff
OPTIONAL MATCH path=(start:AxLab:Domain {id:'axlab/domain/chips'})
                     -[:DEPENDS_ON*1..3]->(finish:AxLab:Resource {id:'axlab/resource/route'})
WHERE all(link IN relationships(path) WHERE link.available_at <= cutoff)
  AND all(n IN nodes(path) WHERE single(m IN nodes(path) WHERE m=n))
RETURN cutoff, count(path) AS paths,
       collect([n IN nodes(path) | n.name]) AS dependency_chains
ORDER BY cutoff;

// Q10 — Source selection changes spread counts without changing evidence.
// Expected: company=1 report, media=2 reports, mixed=3 reports.
// All have only one documented information origin for this shared idea.
// These are selected views, not national consensus or representative feeds.
MATCH (view:AxLab:View)-[:INCLUDES_SOURCE]->(source:AxLab:Source)
MATCH (r:AxLab:Report)-[:PUBLISHED_IN]->(source)
MATCH (r)-[:CONTAINS]->(x:AxLab:Expression)
      -[:EXPRESSES]->(:AxLab:Idea {id:'axlab/idea/partnership'})
MATCH (x)-[:INFORMATION_ORIGIN]->(origin:AxLab)
RETURN view.name AS selected_view, view.version AS version,
       count(DISTINCT r) AS report_count,
       count(DISTINCT origin) AS documented_origin_count
ORDER BY selected_view;

// Q11 — Price observations and directional judgments can be inspected separately.
// Expected: five dummy daily bars. Mar3 has no eligible statements; Mar4-Mar7
// show the two UP and one DOWN judgments available Mar4 15:00.
// A fixed statement-selection cutoff excludes the later unspecified-horizon view.
// No score or causal conclusion follows from this five-day sample.
MATCH (s:AxLab:Stock {ticker:'NOVA'})-[:HAS_PRICE_BAR]->(b:AxLab:PriceBar)
OPTIONAL MATCH (j:AxLab:Judgment)-[:TARGETS]->(s),
               (x:AxLab:Expression)-[:HAS_JUDGMENT]->(j),
               (x)-[:EXPRESSED_BY]->(a:AxLab:Person),
               (j)-[:SUPPORTED_BY]->(:AxLab:Passage)-[:PART_OF]->(v:AxLab:EvidenceVersion)
WHERE v.source_available_at <= '2025-03-04T15:00:00Z'
  AND v.source_available_at <= b.available_at
WITH b, collect(CASE WHEN j IS NULL THEN null ELSE
                {account:a.platform_account_id, direction:j.direction,
                 horizon:j.horizon_phrase} END) AS earlier_statements
RETURN b.date AS trading_date, b.open AS open, b.high AS high, b.low AS low,
       b.close AS close, b.volume AS volume, b.value_status AS price_status,
       earlier_statements
ORDER BY trading_date;

// Q12 — Broad processes expose their inputs and outputs.
// Expected: design -> chips (inputs absent in this configured slice);
//           fabrication -> chips, silicon + lithography equipment;
//           software -> software, electricity.
// These edges are explicit fictional analyst configuration, not extracted facts.
MATCH (p:AxLab:Process)-[:PRODUCES]->(output:AxLab:Product)
OPTIONAL MATCH (p)-[:USES_RESOURCE]->(input:AxLab:Resource)
RETURN p.name AS process, output.name AS output, collect(input.name) AS inputs
ORDER BY process;

// I0 — Fixture integrity: five rows, each passed=true.
// Read these separately from Q0 if hand-edited data changes expected counts.
MATCH (r:AxLab:Report)
WHERE NOT EXISTS { MATCH (r)-[:HAS_EVIDENCE]->(:AxLab:EvidenceVersion) }
RETURN 'report missing retained evidence' AS check, count(r) AS violations, count(r)=0 AS passed
UNION ALL
MATCH (x:AxLab:Expression)
WHERE NOT EXISTS { MATCH (x)-[:SUPPORTED_BY]->(:AxLab:Passage)-[:PART_OF]->(:AxLab:EvidenceVersion) }
RETURN 'expression missing exact support' AS check, count(x) AS violations, count(x)=0 AS passed
UNION ALL
MATCH (f:AxLab:Fact)
WHERE NOT EXISTS { MATCH (f)-[:CONFIRMED_BY]->(:AxLab:Confirmation)-[:SUPPORTED_BY]->(:AxLab:Passage) }
RETURN 'fact missing confirmation process support' AS check, count(f) AS violations, count(f)=0 AS passed
UNION ALL
MATCH (j:AxLab:Judgment)
WHERE j.direction IS NULL OR NOT j.direction IN ['UP','DOWN']
   OR NOT EXISTS { MATCH (j)-[:TARGETS]->(:AxLab:Stock) }
RETURN 'judgment outside stock UP/DOWN scope' AS check, count(j) AS violations, count(j)=0 AS passed
UNION ALL
MATCH (s:AxLab:Stock)-[:POINTS_TO]->(o:AxLab:Organisation)
WHERE o.id IN ['axlab/org/forge','axlab/org/litho','axlab/org/softpeak']
RETURN 'supplier or pending acquisition treated as stock group member' AS check,
       count(o) AS violations, count(o)=0 AS passed;
