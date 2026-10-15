// AXTHENA — read-only stress diagnostics for the existing AxLab fixture.
// Run ONE numbered query at a time in Aura Query. These do not modify data.
// Static-reviewed here; not executed in a Cypher engine.
// A warning identifies a representation/test gap; it is not a truth judgment.

// S1 — Which Ideas have no direct subject link of any type?
// Baseline: 15 rows. Not every external-event Idea must concern a company.
MATCH (i:AxLab:Idea)
WHERE NOT EXISTS { MATCH (i)-[]->(:AxLab) }
RETURN i.id AS idea_id, i.summary AS meaning,
       'no direct subject: inspect organisation/domain/event/resource applicability' AS finding;

// S2 — Confirmed news with no Fact support found through its shared Idea.
// Baseline: ForgeFoundry and LithoWorks expressions (2 rows).
// North/South relay a partnership Idea with originating Fact support.
// This tests existence of lineage, not qualification/independence or blanket truth.
MATCH (r:AxLab:Report)-[:CONTAINS]->(x:AxLab:Expression {news_status:'confirmed'})
MATCH (x)-[:EXPRESSES]->(i:AxLab:Idea)
WHERE NOT EXISTS {
  MATCH (:AxLab:Fact)-[:SOURCED_IN]->(:AxLab:Expression)-[:EXPRESSES]->(i)
}
RETURN r.id AS report_id, x.id AS expression_id, i.summary AS meaning,
       'confirmation scope/process not represented via the shared Idea' AS finding;

// S3 — Shared activity records that also carry dependency links.
// Baseline: software Domain shared by NovaChip/NovaCloud; power dependency.
// This is an applicability warning, not proof that this particular link is wrong.
MATCH (o:AxLab:Organisation)-[:OPERATES_IN]->(d:AxLab:Domain)
WITH d, collect(DISTINCT o.name) AS organisations
WHERE size(organisations)>1
MATCH (d)-[:DEPENDS_ON]->(input:AxLab)
RETURN d.id AS domain_id, d.name AS activity, organisations, input.name AS dependency,
       'verify each organisation really has this dependency' AS finding;

// S4 — Does each dependency shortcut resolve to the same supported assertion?
// Baseline: 6 consistent rows. A missing support/date or endpoint mismatch warns.
MATCH (subject:AxLab)-[link:DEPENDS_ON]->(object:AxLab)
OPTIONAL MATCH (d:AxLab:Dependency)-[:SUBJECT]->(subject),
               (d)-[:OBJECT]->(object)
WHERE d.id=link.assertion_id
OPTIONAL MATCH (d)-[:SUPPORTED_BY]->(:AxLab:Expression)
               -[:SUPPORTED_BY]->(:AxLab:Passage)
               -[:PART_OF]->(v:AxLab:EvidenceVersion)
WITH subject, object, link, d, min(v.source_available_at) AS earliest_source_support
RETURN subject.name AS subject, object.name AS object, link.assertion_id AS assertion_id,
       link.available_at AS shortcut_date, earliest_source_support,
       CASE WHEN d IS NULL THEN 'missing assertion or wrong endpoints'
            WHEN earliest_source_support IS NULL THEN 'no retained support'
            WHEN earliest_source_support<>link.available_at THEN 'shortcut/support date mismatch'
            ELSE 'consistent under this fixture alternative-support assumption' END AS finding;

// S5 — Alternative event-source dates that Q8 currently groups separately.
// Baseline: one quake source date. Adding another date exposes the grouping gap.
MATCH (i:AxLab:Interpretation)-[:SUPPORTED_BY]->(:AxLab:Expression)
      -[:SUPPORTED_BY]->(:AxLab:Passage)-[:PART_OF]->(v:AxLab:EvidenceVersion)
WITH i, collect(DISTINCT v.source_available_at) AS event_dates
RETURN i.id AS interpretation_id, event_dates, size(event_dates) AS date_groups,
       CASE WHEN size(event_dates)>1 THEN 'aggregate alternatives once per interpretation/cutoff'
            ELSE 'single source date does not stress alternative grouping' END AS finding;

// S6 — Complete declaration of this lab's three supplier-chain premises.
// Baseline: declaration_complete=true.
// This is a FIXTURE assertion, not a selected production dependency limit.
MATCH (i:AxLab:Interpretation {id:'axlab/interpretation/quake-nova'})
OPTIONAL MATCH (i)-[:REQUIRES]->(d:AxLab:Dependency)
WITH i, collect(DISTINCT d.id) AS actual_ids,
     ['axlab/dependency/nova-forge','axlab/dependency/forge-litho',
      'axlab/dependency/litho-route'] AS expected_ids
RETURN i.id AS interpretation_id, actual_ids,
       size(actual_ids)=size(expected_ids)
       AND all(expected IN expected_ids WHERE expected IN actual_ids) AS declaration_complete;

// S7 — Current exact span reconstruction and repeated full text.
// Baseline: 18 exact spans; all 18 also repeat the entire retained body.
// Offsets lack a declared unit in the lab. ASCII hides codepoint/UTF-8 differences.
MATCH (p:AxLab:Passage)-[:PART_OF]->(v:AxLab:EvidenceVersion)
RETURN count(p) AS spans,
       sum(CASE WHEN substring(v.full_text,p.start,p.end-p.start)=p.text THEN 1 ELSE 0 END) AS exact_spans,
       sum(CASE WHEN p.text=v.full_text THEN 1 ELSE 0 END) AS whole_body_copies;

// S8 — Do Expression summaries merely repeat their shared Idea summaries?
// Baseline: 18 repeated summaries, 18 expressions.
MATCH (x:AxLab:Expression)-[:EXPRESSES]->(i:AxLab:Idea)
RETURN count(x) AS expression_count,
       sum(CASE WHEN x.summary=i.summary THEN 1 ELSE 0 END) AS repeated_summary_count;

// S9 — Which cardinalities are missing from the fixture's coverage?
// Baseline: 18 reports, zero multi-idea reports.
MATCH (r:AxLab:Report)
OPTIONAL MATCH (r)-[:CONTAINS]->(x:AxLab:Expression)
WITH r, count(DISTINCT x) AS expressions
RETURN count(r) AS reports,
       sum(CASE WHEN expressions>1 THEN 1 ELSE 0 END) AS multi_idea_reports;

// S10 — A dated selected view and a corpus-wide revenue discrepancy are different.
// Illustrative diagnostic; does not select the final conflict-read policy.
// At Mar7 13:00 company view=[80]; mixed=[80,82]; corpus_conflict=true for each.
WITH '2025-03-07T13:00:00Z' AS cutoff
MATCH (f:AxLab:Fact {scope:'NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD'})
      -[:CONFIRMED_BY]->(:AxLab:Confirmation)-[:SUPPORTED_BY]->(:AxLab:Passage)
      -[:PART_OF]->(v:AxLab:EvidenceVersion)
WHERE v.source_available_at<=cutoff
WITH cutoff, collect(DISTINCT f.value) AS corpus_values
MATCH (view:AxLab:View)
OPTIONAL MATCH (view)-[:INCLUDES_SOURCE]->(source:AxLab:Source)
               <-[:PUBLISHED_IN]-(report:AxLab:Report)-[:CONTAINS]->(x:AxLab:Expression)
               <-[:SOURCED_IN]-(vf:AxLab:Fact {scope:'NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD'}),
               (vf)-[:CONFIRMED_BY]->(:AxLab:Confirmation)-[:SUPPORTED_BY]->(:AxLab:Passage)
               -[:PART_OF]->(vv:AxLab:EvidenceVersion)
WHERE vv.source_available_at<=cutoff
RETURN view.name AS selected_view, cutoff, collect(DISTINCT vf.value) AS selected_view_values,
       corpus_values, size(corpus_values)>1 AS corpus_conflict;
