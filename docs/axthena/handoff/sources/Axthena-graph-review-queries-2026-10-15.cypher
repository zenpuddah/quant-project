// Run ONE numbered query at a time. All reads are scoped to AxHardReview.
// Fictional dates and sources. The 38 Ideas are report-local, not deduplicated.

// Q0 — Loaded node counts. Expected total: 373. See README for per-type counts.
MATCH (n:AxHardReview)
WHERE n.fixture_id = 'axhard-a-20261015'
RETURN [label IN labels(n) WHERE label <> 'AxHardReview'][0] AS type,
       count(*) AS nodes
ORDER BY type;

// Q0b — Loaded relationship count. Expected: 715.
MATCH (:AxHardReview)-[r]->(:AxHardReview)
WHERE r.fixture_id = 'axhard-a-20261015'
RETURN count(r) AS relationships;

// Q1 — Start here: three different shapes of idea/organisation linkage.
// H04: subsidiary O3. H08: joint O1/O2 idea. H17: two separate ideas.
MATCH p=(r:AxHardReview:Report)-[:CONTAINS]->(:AxHardReview:Expression)
        -[:EXPRESSES]->(:AxHardReview:Idea)-[:CONCERNS]->(:AxHardReview:Organisation)
WHERE r.report_id IN ['H04', 'H08', 'H17']
RETURN p;

// Q2 — Joint stock judgment, including its full qualification and exact evidence.
// H08 has two rows. Its condition belongs to the joint idea.
MATCH (r:AxHardReview:Report {report_id:'H08'})-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)
MATCH (e)-[:HAS_JUDGMENT]->(j:AxHardReview:Judgment)-[:TARGETS]->(s:AxHardReview:Stock)
MATCH (e)-[:SUPPORTED_BY]->(p:AxHardReview:Passage)-[:FROM_PARAGRAPH]->(para:AxHardReview:Paragraph)
RETURN i.name AS idea, i.summary AS complete_meaning, s.symbol AS stock,
       j.direction AS direction, j.start AS start, j.end AS end_exclusive,
       collect({paragraph:para.paragraph_id, quote:p.quote}) AS evidence
ORDER BY stock;

// Q3 — H08's organisation and stock-judgment branches.
// Returned rows combine branches for display; they are not stock-to-issuer assignments.
MATCH main=(r:AxHardReview:Report {report_id:'H08'})-[:CONTAINS]->(e:AxHardReview:Expression)
           -[:EXPRESSES]->(i:AxHardReview:Idea)
MATCH subject=(i)-[:CONCERNS]->(:AxHardReview:Organisation)
MATCH forecast=(e)-[:HAS_JUDGMENT]->(:AxHardReview:Judgment)-[:TARGETS]->(:AxHardReview:Stock)
RETURN main, subject, forecast;

// Q4 — Follow H01 back to the complete paragraph and exact span.
// Paragraph text is original fixture evidence; the idea summary is derived.
MATCH (r:AxHardReview:Report {report_id:'H01'})-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)
MATCH (e)-[:ATTRIBUTED_TO]->(s:AxHardReview:Source)
MATCH (e)-[:SUPPORTED_BY]->(p:AxHardReview:Passage)-[:FROM_PARAGRAPH]->(para:AxHardReview:Paragraph)
RETURN s.source_id AS source, i.summary AS summary, para.paragraph_id AS paragraph,
       p.quote AS exact_quote, para.text AS full_paragraph,
       p.start_codepoint AS start_offset, p.end_codepoint AS end_offset_exclusive,
       r.published_on AS publication, r.available_on AS supported_availability,
       r.collected_on AS collection;

// Q5 — Ideas concerning NovaCloud directly. Expected H04,H15,H20,H24,H26.
// No parent-stock link is inferred from ownership.
MATCH p=(r:AxHardReview:Report)-[:CONTAINS]->(:AxHardReview:Expression)
        -[:EXPRESSES]->(:AxHardReview:Idea)-[:CONCERNS]->(o:AxHardReview:Organisation {org_id:'O3'})
OPTIONAL MATCH ownership=(o)-[:SUBSIDIARY_OF]->(:AxHardReview:Organisation)
RETURN p, ownership;

// Q6 — Idea domain versus organisation catalogue domain.
// H10: O5 / SOFTWARE_TOOLS, catalogue MATERIALS. H12: O1 / unspecified domain.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)-[:CONCERNS]->(o:AxHardReview:Organisation)
WHERE r.report_id IN ['H10','H12']
OPTIONAL MATCH (i)-[:ABOUT_DOMAIN]->(d:AxHardReview:Domain)
OPTIONAL MATCH (o)-[:CATALOG_DOMAIN]->(cd:AxHardReview:Domain)
RETURN r.report_id AS report, o.name AS organisation, d.name AS extracted_domain,
       i.domain_state AS domain_state, collect(cd.name) AS catalogue_domains;

// Q7 — Claim and later denial visible by source availability.
// Run with 2026-10-14, then change the date to 2026-10-15.
// Expected: first H18 only; then H18 AND H19. This is not a fitted-model replay.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)
WHERE r.report_id IN ['H18','H19'] AND date(r.available_on) <= date('2026-10-14')
RETURN r.report_id AS report, r.available_on AS available,
       e.kind AS source_classification, e.event_phase AS claimed_phase,
       i.summary AS meaning, r.confirmation_scope AS supplied_confirmation_scope
ORDER BY available, report;

// Q8 — Direction remains usable when its forecast dates are missing.
// Expected H11, H22, H28.2, H34. No default period has been invented.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:HAS_JUDGMENT]->(j:AxHardReview:Judgment)
MATCH (e)-[:EXPRESSES]->(i:AxHardReview:Idea)
WHERE j.window_state = 'MISSING'
RETURN r.report_id AS report, i.name AS idea, j.stock AS stock,
       j.direction AS direction, j.start AS start, j.end AS end,
       i.summary AS complete_meaning
ORDER BY report;

// Q9 — Empty judgments do NOT mean there was no forecast.
// H31 flat; H02/H21 relative performance; H07 withdrawn; H09 business profit.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)
WHERE r.report_id IN ['H02','H07','H09','H21','H31']
OPTIONAL MATCH (e)-[:HAS_JUDGMENT]->(j:AxHardReview:Judgment)
RETURN r.report_id AS report, e.judgment_status AS retained_status,
       collect(j.direction) AS retained_directions, i.summary AS meaning
ORDER BY report;

// Q10 — Processing status stays outside the news meaning.
// H28 COMPLETE + cap omission + 2; H30 PARTIAL + 1; H36 INSUFFICIENT + 0.
MATCH (p:AxHardReview:ProcessingRecord)-[:PROCESSED]->(r:AxHardReview:Report)
WHERE r.report_id IN ['H28','H30','H36']
OPTIONAL MATCH (r)-[:CONTAINS]->(e:AxHardReview:Expression)
RETURN r.report_id AS report, p.processing_status AS status,
       p.cap_omitted AS cap_omitted, count(e) AS retained_expressions
ORDER BY report;

// Q11 — Independent comparison diagnostics; SAME does not merge graph Ideas.
MATCH (c:AxHardReview:ComparisonCase)
WHERE c.case_id IN ['HM03','HM13']
RETURN c.case_id AS comparison, c.left_text AS left_text, c.right_text AS right_text,
       c.decision AS decision, c.basis AS explanation, c.task_scope AS scope
ORDER BY comparison;

// Q12 — Organisation search candidates and final identity decision.
// These lists were supplied in the experiment, not retrieved by this loader.
MATCH (c:AxHardReview:IdentityCase)-[:SELECTED]->(o:AxHardReview:Organisation)
RETURN c.case_id AS case_id, c.mention AS mention, c.name_candidates AS name_candidates,
       c.vector_candidates AS vector_candidates, c.candidate_union AS union_candidates,
       c.candidate_intersection AS intersection_candidates, c.action AS action,
       o.org_id AS selected_id, o.name AS selected_organisation
ORDER BY case_id;

// Q13 — H06 co-occurrence does not create a supply relationship.
MATCH p=(r:AxHardReview:Report {report_id:'H06'})-[:CONTAINS]->(:AxHardReview:Expression)
        -[:EXPRESSES]->(i:AxHardReview:Idea)-[:CONCERNS]->(:AxHardReview:Organisation)
MATCH domain=(i)-[:ABOUT_DOMAIN]->(:AxHardReview:Domain)
RETURN p, domain;

// Q14 — Announcement and completion remain distinct extracted meanings.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:EXPRESSES]->(i:AxHardReview:Idea)
WHERE r.report_id IN ['H13','H14','H24','H27']
RETURN r.report_id AS report, e.kind AS classification, e.event_phase AS claimed_phase,
       i.summary AS meaning, r.confirmation_scope AS supplied_confirmation_scope
ORDER BY report;

// Q15 — Evidence behind every retained UP view. Never discard qualification.
MATCH (r:AxHardReview:Report)-[:CONTAINS]->(e:AxHardReview:Expression)
      -[:HAS_JUDGMENT]->(j:AxHardReview:Judgment {direction:'UP'})
MATCH (e)-[:EXPRESSES]->(i:AxHardReview:Idea)
MATCH (e)-[:SUPPORTED_BY]->(p:AxHardReview:Passage)
RETURN r.report_id AS report, r.source_id AS source, r.available_on AS available,
       j.stock AS stock, j.start AS start, j.end AS end_exclusive,
       j.window_state AS period_status, i.summary AS complete_meaning,
       collect(p.quote) AS exact_evidence
ORDER BY report;

// Q16 — Keep distinguishable anonymous/source identities.
MATCH (p:AxHardReview:Person)
WHERE p.source_id IN ['person:sel','person:selene']
RETURN p.source_id AS identity, p.identity_scope AS identity_scope;

// Q17 — Provenance of extraction, not a historical-model availability claim.
MATCH (p:AxHardReview:ProcessingRecord {report_id:'H01'})-[:IN_RUN]->(run:AxHardReview:ExtractionRun)
RETURN p.output_file AS combined_output, p.output_path AS record_path,
       run.raw_output_file AS raw_batch, run.raw_output_sha256 AS raw_hash,
       run.prompt_file AS instructions, run.prompt_sha256 AS instruction_hash,
       run.experiment_recorded_at_utc AS experiment_recorded,
       run.execution_time AS unknown_execution_time, run.model_snapshot AS unknown_model;
