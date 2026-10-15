// AXTHENA: REAL-REPORT DESIGN EXAMPLE, 2026-10-14
// Purpose: review the conceptual graph with Badr. No production schema/database selected.
// Suggested dialect: Neo4j Cypher 5+, using standard labels, properties, MERGE and MATCH.
// This file has NOT been executed in Neo4j. Structural consistency was checked.
// Only short exact passages are retained here; full original articles are not bundled.
// Displayed historical source dates do not verify original historical article versions.
// All identifiers and auxiliary record shapes are PROPOSALS for this example.
// Use an EMPTY SCRATCH database if evaluating this file; existing Axthena data is not needed.
// The loading section changes only AxDemo-labelled example nodes; read queries follow.
// Operational collection/extraction metadata are described separately in the review document.
// Re-running the same unchanged loading section should reuse these explicit IDs.
//
// PART 1: LOAD THE ILLUSTRATIVE GRAPH
CREATE CONSTRAINT ax_demo_node_id IF NOT EXISTS
FOR (n:AxDemo) REQUIRE n.id IS UNIQUE;

MERGE (msft:AxDemo:Organisation {id: 'axdemo/msft'})
SET msft += {name: 'Microsoft', kind: 'company'}

MERGE (nvda:AxDemo:Organisation {id: 'axdemo/nvda'})
SET nvda += {name: 'NVIDIA', kind: 'company'}

MERGE (tsmc:AxDemo:Organisation {id: 'axdemo/tsmc'})
SET tsmc += {name: 'TSMC', kind: 'company'}

MERGE (reuters:AxDemo:Organisation {id: 'axdemo/reuters'})
SET reuters += {name: 'Reuters', kind: 'news_outlet'}

MERGE (cowen:AxDemo:Organisation {id: 'axdemo/cowen'})
SET cowen += {name: 'TD Cowen', kind: 'research_institution'}

MERGE (msftStock:AxDemo:Stock {id: 'axdemo/msftStock'})
SET msftStock += {symbol: 'MSFT', exchange: 'NASDAQ', identity_scope: 'traded_asset'}

MERGE (nvdaStock:AxDemo:Stock {id: 'axdemo/nvdaStock'})
SET nvdaStock += {symbol: 'NVDA', exchange: 'NASDAQ', identity_scope: 'traded_asset'}

MERGE (msftDomain:AxDemo:Domain {id: 'axdemo/msftDomain'})
SET msftDomain += {name: 'AI and cloud infrastructure', definition_origin: 'analyst_configured_example', process_description: 'Build and operate infrastructure for AI/cloud workloads', output_description: 'AI/cloud computing capacity'}

MERGE (nvdaDomain:AxDemo:Domain {id: 'axdemo/nvdaDomain'})
SET nvdaDomain += {name: 'AI accelerator platforms', definition_origin: 'analyst_configured_example', process_description: 'Design accelerator platforms and use external manufacturing', output_description: 'AI accelerator platforms'}

MERGE (tsmcDomain:AxDemo:Domain {id: 'axdemo/tsmcDomain'})
SET tsmcDomain += {name: 'Semiconductor manufacturing', definition_origin: 'analyst_configured_example', process_description: 'Manufacture semiconductor wafers', output_description: 'Manufactured wafers'}

MERGE (power:AxDemo:Resource {id: 'axdemo/power'})
SET power += {name: 'Electricity', kind: 'energy'}

MERGE (cooling:AxDemo:Resource {id: 'axdemo/cooling'})
SET cooling += {name: 'Liquid cooling', kind: 'operational_input'}

MERGE (blackwell:AxDemo:Resource {id: 'axdemo/blackwell'})
SET blackwell += {name: 'Blackwell platform', kind: 'technology_product', state_scope: 'announced_product_not_delivery_confirmation'}

MERGE (brad:AxDemo:Person {id: 'axdemo/brad'})
SET brad += {name: 'Brad Smith', identity_basis: 'Microsoft source byline'}

MERGE (harshita:AxDemo:Person {id: 'axdemo/harshita'})
SET harshita += {name: 'Harshita Mary Varghese', identity_basis: 'Reuters reporting credit'}

MERGE (aditya:AxDemo:Person {id: 'axdemo/aditya'})
SET aditya += {name: 'Aditya Soni', identity_basis: 'Reuters byline'}

MERGE (bradWeight:AxDemo:PersonWeight {id: 'axdemo/bradWeight'})
SET bradWeight += {components: ['credibility', 'influence', 'predictive_record'], values: [0.5, 0.5, 0.5], status: 'dummy_example_only', scale_status: 'arbitrary_fixture_not_an_accepted_scale', domain_independent: true, created_on: date('2026-10-14'), version: 1, origin: 'illustrative_fixture_author'}

MERGE (harshitaWeight:AxDemo:PersonWeight {id: 'axdemo/harshitaWeight'})
SET harshitaWeight += {components: ['credibility', 'influence', 'predictive_record'], values: [0.5, 0.5, 0.5], status: 'dummy_example_only', scale_status: 'arbitrary_fixture_not_an_accepted_scale', domain_independent: true, created_on: date('2026-10-14'), version: 1, origin: 'illustrative_fixture_author'}

MERGE (adityaWeight:AxDemo:PersonWeight {id: 'axdemo/adityaWeight'})
SET adityaWeight += {components: ['credibility', 'influence', 'predictive_record'], values: [0.5, 0.5, 0.5], status: 'dummy_example_only', scale_status: 'arbitrary_fixture_not_an_accepted_scale', domain_independent: true, created_on: date('2026-10-14'), version: 1, origin: 'illustrative_fixture_author'}

MERGE (msftSource:AxDemo:Source {id: 'axdemo/msftSource'})
SET msftSource += {name: 'Microsoft corporate blog', kind: 'publication_channel'}

MERGE (nvdaSource:AxDemo:Source {id: 'axdemo/nvdaSource'})
SET nvdaSource += {name: 'NVIDIA newsroom', kind: 'publication_channel'}

MERGE (tsmcSource:AxDemo:Source {id: 'axdemo/tsmcSource'})
SET tsmcSource += {name: 'TSMC investor/news release', kind: 'publication_channel'}

MERGE (reutersSource:AxDemo:Source {id: 'axdemo/reutersSource'})
SET reutersSource += {name: 'Reuters reporting', kind: 'publication_channel'}

MERGE (r1:AxDemo:Report {id: 'axdemo/r1'})
SET r1 += {display_title: 'Microsoft AI policy and planned infrastructure investment', canonical_url: 'https://blogs.microsoft.com/on-the-issues/2025/01/03/the-golden-opportunity-for-american-ai/', source_on: date('2025-01-03'), source_time_precision: 'day', document_kind: 'company_statement', source_ref: 'turn44view0'}

MERGE (r1v:AxDemo:EvidenceVersion {id: 'axdemo/r1v'})
SET r1v += {version_identity: 'observed_excerpt_fixture_2026_10_14', retrieved_on: date('2026-10-14'), source_on: date('2025-01-03'), availability_basis: 'displayed_source_date', original_historical_version_verified: false, full_original_retained: false, retention_scope: 'selected_exact_excerpts_for_design_review', url: 'https://blogs.microsoft.com/on-the-issues/2025/01/03/the-golden-opportunity-for-american-ai/'}

MERGE (r2:AxDemo:Report {id: 'axdemo/r2'})
SET r2 += {display_title: 'Reuters reports Microsoft\'s planned AI infrastructure spending', canonical_url: 'https://www.reuters.com/technology/artificial-intelligence/microsoft-plans-spend-80-bln-ai-enabled-data-centers-fiscal-2025-cnbc-reports-2025-01-03/', source_on: date('2025-01-03'), source_time_precision: 'day', document_kind: 'news_article', source_ref: 'turn44view1'}

MERGE (r2v:AxDemo:EvidenceVersion {id: 'axdemo/r2v'})
SET r2v += {version_identity: 'observed_excerpt_fixture_2026_10_14', retrieved_on: date('2026-10-14'), source_on: date('2025-01-03'), availability_basis: 'displayed_source_date', original_historical_version_verified: false, full_original_retained: false, retention_scope: 'selected_exact_excerpts_for_design_review', url: 'https://www.reuters.com/technology/artificial-intelligence/microsoft-plans-spend-80-bln-ai-enabled-data-centers-fiscal-2025-cnbc-reports-2025-01-03/'}

MERGE (r3:AxDemo:Report {id: 'axdemo/r3'})
SET r3 += {display_title: 'TSMC reports January revenue and earthquake effects', canonical_url: 'https://pr.tsmc.com/english/news/3204', source_on: date('2025-02-10'), source_time_precision: 'day', document_kind: 'company_statement', source_ref: 'turn44view2'}

MERGE (r3v:AxDemo:EvidenceVersion {id: 'axdemo/r3v'})
SET r3v += {version_identity: 'observed_excerpt_fixture_2026_10_14', retrieved_on: date('2026-10-14'), source_on: date('2025-02-10'), availability_basis: 'displayed_source_date', original_historical_version_verified: false, full_original_retained: false, retention_scope: 'selected_exact_excerpts_for_design_review', url: 'https://pr.tsmc.com/english/news/3204'}

MERGE (r4:AxDemo:Report {id: 'axdemo/r4'})
SET r4 += {display_title: 'NVIDIA introduces Blackwell and describes its manufacturing', canonical_url: 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing', source_on: date('2024-03-18'), source_time_precision: 'day', document_kind: 'company_statement', source_ref: 'turn43view2'}

MERGE (r4v:AxDemo:EvidenceVersion {id: 'axdemo/r4v'})
SET r4v += {version_identity: 'observed_excerpt_fixture_2026_10_14', retrieved_on: date('2026-10-14'), source_on: date('2024-03-18'), availability_basis: 'displayed_source_date', original_historical_version_verified: false, full_original_retained: false, retention_scope: 'selected_exact_excerpts_for_design_review', url: 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing'}

MERGE (r5:AxDemo:Report {id: 'axdemo/r5'})
SET r5 += {display_title: 'Reuters on Microsoft\'s leases', canonical_url: 'https://www.reuters.com/technology/microsoft-shelves-ai-data-center-deals-sign-potential-oversupply-analyst-says-2025-02-24/', source_on: date('2025-02-24'), source_time_precision: 'day', document_kind: 'news_article', source_ref: 'turn44view3'}

MERGE (r5v:AxDemo:EvidenceVersion {id: 'axdemo/r5v'})
SET r5v += {version_identity: 'observed_excerpt_fixture_2026_10_14', retrieved_on: date('2026-10-14'), source_on: date('2025-02-24'), availability_basis: 'displayed_source_date', original_historical_version_verified: false, full_original_retained: false, retention_scope: 'selected_exact_excerpts_for_design_review', url: 'https://www.reuters.com/technology/microsoft-shelves-ai-data-center-deals-sign-potential-oversupply-analyst-says-2025-02-24/'}

MERGE (p1:AxDemo:Passage {id: 'axdemo/p1'})
SET p1 += {text: 'Microsoft is on track to invest approximately $80 billion to build out AI-enabled datacenters', locator: 'World-leading AI technology and infrastructure, spending paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view0'}

MERGE (p1resources:AxDemo:Passage {id: 'axdemo/p1resources'})
SET p1resources += {text: 'electricity and liquid cooling', locator: 'World-leading AI technology and infrastructure, construction paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view0'}

MERGE (p1policy:AxDemo:Passage {id: 'axdemo/p1policy'})
SET p1policy += {text: 'a three-part vision', locator: 'opening policy vision', selection_status: 'exact_short_excerpt', source_ref: 'turn44view0'}

MERGE (p2:AxDemo:Passage {id: 'axdemo/p2'})
SET p2 += {text: 'planning to invest about $80 billion in fiscal 2025 on developing data centers to train artificial intelligence (AI) models', locator: 'opening reporting paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view1'}

MERGE (p3revenue:AxDemo:Passage {id: 'axdemo/p3revenue'})
SET p3revenue += {text: 'revenue for January 2025 was approximately NT$293.29 billion', locator: 'first release paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view2'}

MERGE (p3scrap:AxDemo:Passage {id: 'axdemo/p3scrap'})
SET p3scrap += {text: 'A certain number of wafers in process were impacted and had to be scrapped', locator: 'earthquake paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view2'}

MERGE (p4announce:AxDemo:Passage {id: 'axdemo/p4announce'})
SET p4announce += {text: 'NVIDIA today announced that the NVIDIA Blackwell platform has arrived', locator: 'opening announcement paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn43view2'}

MERGE (p4tsmc:AxDemo:Passage {id: 'axdemo/p4tsmc'})
SET p4tsmc += {text: 'Blackwell-architecture GPUs are manufactured using a custom-built 4NP TSMC process', locator: 'World\'s Most Powerful Chip bullet', selection_status: 'exact_short_excerpt', source_ref: 'turn43view2'}

MERGE (p5lease:AxDemo:Passage {id: 'axdemo/p5lease'})
SET p5lease += {text: 'scrapped leases for sizeable data center capacity', locator: 'second reporting paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view3'}

MERGE (p5response:AxDemo:Passage {id: 'axdemo/p5response'})
SET p5response += {text: 'this fiscal year remains on track', locator: 'Microsoft spokesperson response paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view3'}

MERGE (p5price:AxDemo:Passage {id: 'axdemo/p5price'})
SET p5price += {text: 'the stock lost 1% on Monday', locator: 'reported closing movements paragraph', selection_status: 'exact_short_excerpt', source_ref: 'turn44view3'}

MERGE (budgetIdea:AxDemo:Idea {id: 'axdemo/budgetIdea'})
SET budgetIdea += {summary: 'Microsoft announced a plan for approximately USD 80bn of FY2025 AI-enabled datacentre investment.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'announced_plan', amount: 80000000000, currency: 'USD', amount_qualifier: 'approximately', period_description: 'Microsoft FY2025', realised_spending_verified: false}

MERGE (policyIdea:AxDemo:Idea {id: 'axdemo/policyIdea'})
SET policyIdea += {summary: 'Microsoft advocates infrastructure investment, AI skills and international AI exports.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'corporate_policy_position'}

MERGE (revenueIdea:AxDemo:Idea {id: 'axdemo/revenueIdea'})
SET revenueIdea += {summary: 'TSMC reported January 2025 consolidated revenue of approximately TWD 293.29bn.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'company_reported_metric', value: 293290000000, currency: 'TWD', period_description: 'January 2025'}

MERGE (scrapIdea:AxDemo:Idea {id: 'axdemo/scrapIdea'})
SET scrapIdea += {summary: 'TSMC reported earthquake-related wafer scrapping.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'reported_operational_effect', affected_specific_product: 'not_identified'}

MERGE (blackwellIdea:AxDemo:Idea {id: 'axdemo/blackwellIdea'})
SET blackwellIdea += {summary: 'NVIDIA announced its Blackwell accelerator platform.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'technology_announcement', delivery_start_verified: false}

MERGE (leaseIdea:AxDemo:Idea {id: 'axdemo/leaseIdea'})
SET leaseIdea += {summary: 'TD Cowen reported Microsoft lease cancellations.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'reported_claim', qualifying_confirmation_status: 'not_obtained_in_fixture'}

MERGE (reaffirmIdea:AxDemo:Idea {id: 'axdemo/reaffirmIdea'})
SET reaffirmIdea += {summary: 'Microsoft reiterated its FY2025 investment plan.', normalisation_status: 'assistant_proposed_for_review', processing_ref: 'example-extraction-2026-10-14-v1', content_kind: 'reported_company_response', not_equivalent_to: 'proof_that_no_leases_were_cancelled'}

MERGE (e1budget:AxDemo:Expression {id: 'axdemo/e1budget'})
SET e1budget += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'company_statement'}

MERGE (e1policy:AxDemo:Expression {id: 'axdemo/e1policy'})
SET e1policy += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'company_position'}

MERGE (e2budget:AxDemo:Expression {id: 'axdemo/e2budget'})
SET e2budget += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'news', news_status: 'confirmed', confirmation_scope: 'Microsoft_announced_the_plan_not_spending_completion'}

MERGE (e3revenue:AxDemo:Expression {id: 'axdemo/e3revenue'})
SET e3revenue += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'company_statement'}

MERGE (e3scrap:AxDemo:Expression {id: 'axdemo/e3scrap'})
SET e3scrap += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'company_statement'}

MERGE (e4blackwell:AxDemo:Expression {id: 'axdemo/e4blackwell'})
SET e4blackwell += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'company_statement'}

MERGE (e5lease:AxDemo:Expression {id: 'axdemo/e5lease'})
SET e5lease += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'news', news_status: 'rumoured', classification_status: 'proposed_pending_qualifying_confirmation'}

MERGE (e5response:AxDemo:Expression {id: 'axdemo/e5response'})
SET e5response += {agreement_status: 'not_assessed_reporting_does_not_imply_endorsement', judgment_status: 'no_supported_stock_UP_DOWN', extracted_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', information_kind: 'news', confirmation_scope: 'company_response_was_reported_not_lease_outcome', news_status_assignment: 'not_decided_requires_source_confirmation_rule', classification_status: 'illustrative_pending_rule_not_publish_ready'}

MERGE (spendingAnnouncement:AxDemo:Event {id: 'axdemo/spendingAnnouncement'})
SET spendingAnnouncement += {kind: 'company_announcement', name: 'Microsoft\'s disclosed FY2025 spending plan', occurred_on: date('2025-01-03'), event_time_precision: 'day', evidence_status: 'source_reported'}

MERGE (tsmcRelease:AxDemo:Event {id: 'axdemo/tsmcRelease'})
SET tsmcRelease += {kind: 'company_revenue_announcement', name: 'TSMC monthly revenue disclosure', occurred_on: date('2025-02-10'), event_time_precision: 'day', evidence_status: 'source_reported'}

MERGE (earthquake:AxDemo:Event {id: 'axdemo/earthquake'})
SET earthquake += {kind: 'earthquake', name: 'Taiwan earthquake described by TSMC', occurred_on: date('2025-01-21'), event_time_precision: 'day', evidence_status: 'reported_by_TSMC_not_separately_institutionally_verified'}

MERGE (blackwellAnnouncement:AxDemo:Event {id: 'axdemo/blackwellAnnouncement'})
SET blackwellAnnouncement += {kind: 'technology_announcement', name: 'Blackwell platform announcement', occurred_on: date('2024-03-18'), event_time_precision: 'day', evidence_status: 'source_reported'}

MERGE (leaseEvent:AxDemo:Event {id: 'axdemo/leaseEvent'})
SET leaseEvent += {kind: 'reported_lease_cancellations', name: 'Reported lease cancellations', event_date_status: 'not_specified_in_retrieved_reporting', evidence_status: 'source_reported'}

MERGE (responseEvent:AxDemo:Event {id: 'axdemo/responseEvent'})
SET responseEvent += {kind: 'company_response', name: 'Company response', occurred_on: date('2025-02-24'), event_time_precision: 'day', evidence_status: 'source_reported'}

MERGE (budgetFact:AxDemo:Fact {id: 'axdemo/budgetFact'})
SET budgetFact += {text: 'Microsoft publicly announced the planned investment; completion is not confirmed.', confirmation_scope: 'precise_company_disclosure', content_independently_verified: false, classification_status: 'company_disclosure_scope_for_example'}

MERGE (budgetFactConfirmation:AxDemo:Confirmation {id: 'axdemo/budgetFactConfirmation'})
SET budgetFactConfirmation += {process: 'direct_named_company_public_disclosure', process_selection_status: 'illustrative_application_of_accepted_business_concept', scope: 'company_disclosed_the_statement', available_on: date('2025-01-03')}

MERGE (revenueFact:AxDemo:Fact {id: 'axdemo/revenueFact'})
SET revenueFact += {text: 'TSMC publicly disclosed its January revenue figure.', confirmation_scope: 'precise_company_disclosure', content_independently_verified: false, classification_status: 'company_disclosure_scope_for_example'}

MERGE (revenueFactConfirmation:AxDemo:Confirmation {id: 'axdemo/revenueFactConfirmation'})
SET revenueFactConfirmation += {process: 'direct_named_company_public_disclosure', process_selection_status: 'illustrative_application_of_accepted_business_concept', scope: 'company_disclosed_the_statement', available_on: date('2025-02-10')}

MERGE (scrapFact:AxDemo:Fact {id: 'axdemo/scrapFact'})
SET scrapFact += {text: 'TSMC publicly reported earthquake-related wafer scrapping.', confirmation_scope: 'precise_company_disclosure', content_independently_verified: false, classification_status: 'company_disclosure_scope_for_example'}

MERGE (scrapFactConfirmation:AxDemo:Confirmation {id: 'axdemo/scrapFactConfirmation'})
SET scrapFactConfirmation += {process: 'direct_named_company_public_disclosure', process_selection_status: 'illustrative_application_of_accepted_business_concept', scope: 'company_disclosed_the_statement', available_on: date('2025-02-10')}

MERGE (blackwellFact:AxDemo:Fact {id: 'axdemo/blackwellFact'})
SET blackwellFact += {text: 'NVIDIA publicly announced Blackwell.', confirmation_scope: 'precise_company_disclosure', content_independently_verified: false, classification_status: 'company_disclosure_scope_for_example'}

MERGE (blackwellFactConfirmation:AxDemo:Confirmation {id: 'axdemo/blackwellFactConfirmation'})
SET blackwellFactConfirmation += {process: 'direct_named_company_public_disclosure', process_selection_status: 'illustrative_application_of_accepted_business_concept', scope: 'company_disclosed_the_statement', available_on: date('2024-03-18')}

MERGE (chipDependency:AxDemo:Dependency {id: 'axdemo/chipDependency'})
SET chipDependency += {source_on: date('2024-03-18'), evidence_kind: 'source_assertion', interpretation_origin: 'analyst_configured_evidenced_example', valid_until_status: 'not_established', meaning: 'manufacturing_dependency', product_scope: 'Blackwell_architecture_as_described_by_NVIDIA', state_scope: 'source_described_dependency_not_proof_of_delivery_or_current_continuity'}

MERGE (powerDependency:AxDemo:Dependency {id: 'axdemo/powerDependency'})
SET powerDependency += {source_on: date('2025-01-03'), evidence_kind: 'source_assertion', interpretation_origin: 'analyst_configured_evidenced_example', valid_until_status: 'not_established', meaning: 'operational_input', scope: 'broad_AI_datacentre_infrastructure'}

MERGE (coolingDependency:AxDemo:Dependency {id: 'axdemo/coolingDependency'})
SET coolingDependency += {source_on: date('2025-01-03'), evidence_kind: 'source_assertion', interpretation_origin: 'analyst_configured_evidenced_example', valid_until_status: 'not_established', meaning: 'described_infrastructure_input', scope: 'broad_AI_datacentre_infrastructure', universal_requirement_established: false}

MERGE (quakeRelevance:AxDemo:Interpretation {id: 'axdemo/quakeRelevance'})
SET quakeRelevance += {summary: 'Potential relevance to NVIDIA through the stated TSMC manufacturing dependency; affected Blackwell production is unknown.', kind: 'inferred_relevance', effect_status: 'potential_only', reported_by_source: false, generated_on: date('2026-10-14'), processing_ref: 'example-extraction-2026-10-14-v1', observed_NVIDIA_effect_confirmed: false}

MERGE (priceResponse:AxDemo:ReportedResponse {id: 'axdemo/priceResponse'})
SET priceResponse += {change_pct: -1, observation_on: date('2025-02-24'), description: 'Reported MSFT daily change', evidence_kind: 'source_assertion', validated_against_OHLCV: false, not_a_forecast: true}

MERGE (officialView:AxDemo:View {id: 'axdemo/officialView'})
SET officialView += {name: 'Selected company sources', version: 1, defined_on: date('2026-10-14'), interpretation_description: 'Company-origin disclosures with their stated scope', selection_scope: 'these_explicit_channels_only', historical_view_available_in_2025: false}

MERGE (mixedView:AxDemo:View {id: 'axdemo/mixedView'})
SET mixedView += {name: 'Selected company sources plus Reuters', version: 1, defined_on: date('2026-10-14'), interpretation_description: 'Compare organisational disclosure and selected external reporting', selection_scope: 'these_explicit_channels_only', historical_view_available_in_2025: false}

MERGE (msftStock)-[:POINTS_TO {id: 'axdemo/edge/msftStock/POINTS_TO/msft', mapping_scope: 'organisation_association_example'}]->(msft)
MERGE (nvdaStock)-[:POINTS_TO {id: 'axdemo/edge/nvdaStock/POINTS_TO/nvda', mapping_scope: 'organisation_association_example'}]->(nvda)
MERGE (msftDomain)-[:DOMAIN_OF {id: 'axdemo/edge/msftDomain/DOMAIN_OF/msft'}]->(msft)
MERGE (nvdaDomain)-[:DOMAIN_OF {id: 'axdemo/edge/nvdaDomain/DOMAIN_OF/nvda'}]->(nvda)
MERGE (tsmcDomain)-[:DOMAIN_OF {id: 'axdemo/edge/tsmcDomain/DOMAIN_OF/tsmc'}]->(tsmc)
MERGE (brad)-[:AFFILIATED_WITH {id: 'axdemo/edge/brad/AFFILIATED_WITH/msft', source_ref: 'axdemo/r1', basis: 'Vice Chair and President in byline', source_on: date('2025-01-03')}]->(msft)
MERGE (harshita)-[:AFFILIATED_WITH {id: 'axdemo/edge/harshita/AFFILIATED_WITH/reuters', source_ref: 'axdemo/r2', basis: 'reporting credit', source_on: date('2025-01-03')}]->(reuters)
MERGE (aditya)-[:AFFILIATED_WITH {id: 'axdemo/edge/aditya/AFFILIATED_WITH/reuters', source_ref: 'axdemo/r5', basis: 'byline', source_on: date('2025-02-24')}]->(reuters)
MERGE (bradWeight)-[:FOR_PERSON {id: 'axdemo/edge/bradWeight/FOR_PERSON/brad'}]->(brad)
MERGE (harshitaWeight)-[:FOR_PERSON {id: 'axdemo/edge/harshitaWeight/FOR_PERSON/harshita'}]->(harshita)
MERGE (adityaWeight)-[:FOR_PERSON {id: 'axdemo/edge/adityaWeight/FOR_PERSON/aditya'}]->(aditya)
MERGE (msftSource)-[:PUBLISHED_BY {id: 'axdemo/edge/msftSource/PUBLISHED_BY/msft'}]->(msft)
MERGE (nvdaSource)-[:PUBLISHED_BY {id: 'axdemo/edge/nvdaSource/PUBLISHED_BY/nvda'}]->(nvda)
MERGE (tsmcSource)-[:PUBLISHED_BY {id: 'axdemo/edge/tsmcSource/PUBLISHED_BY/tsmc'}]->(tsmc)
MERGE (reutersSource)-[:PUBLISHED_BY {id: 'axdemo/edge/reutersSource/PUBLISHED_BY/reuters'}]->(reuters)
MERGE (r1)-[:HAS_VERSION {id: 'axdemo/edge/r1/HAS_VERSION/r1v'}]->(r1v)
MERGE (r1)-[:PUBLISHED_IN {id: 'axdemo/edge/r1/PUBLISHED_IN/msftSource'}]->(msftSource)
MERGE (r1)-[:RESPONSIBLE_PERSON {id: 'axdemo/edge/r1/RESPONSIBLE_PERSON/brad', meaning: 'author_or_reporting_credit_not_personal_opinion'}]->(brad)
MERGE (r2)-[:HAS_VERSION {id: 'axdemo/edge/r2/HAS_VERSION/r2v'}]->(r2v)
MERGE (r2)-[:PUBLISHED_IN {id: 'axdemo/edge/r2/PUBLISHED_IN/reutersSource'}]->(reutersSource)
MERGE (r2)-[:RESPONSIBLE_PERSON {id: 'axdemo/edge/r2/RESPONSIBLE_PERSON/harshita', meaning: 'author_or_reporting_credit_not_personal_opinion'}]->(harshita)
MERGE (r3)-[:HAS_VERSION {id: 'axdemo/edge/r3/HAS_VERSION/r3v'}]->(r3v)
MERGE (r3)-[:PUBLISHED_IN {id: 'axdemo/edge/r3/PUBLISHED_IN/tsmcSource'}]->(tsmcSource)
MERGE (r4)-[:HAS_VERSION {id: 'axdemo/edge/r4/HAS_VERSION/r4v'}]->(r4v)
MERGE (r4)-[:PUBLISHED_IN {id: 'axdemo/edge/r4/PUBLISHED_IN/nvdaSource'}]->(nvdaSource)
MERGE (r5)-[:HAS_VERSION {id: 'axdemo/edge/r5/HAS_VERSION/r5v'}]->(r5v)
MERGE (r5)-[:PUBLISHED_IN {id: 'axdemo/edge/r5/PUBLISHED_IN/reutersSource'}]->(reutersSource)
MERGE (r5)-[:RESPONSIBLE_PERSON {id: 'axdemo/edge/r5/RESPONSIBLE_PERSON/aditya', meaning: 'author_or_reporting_credit_not_personal_opinion'}]->(aditya)
MERGE (r1v)-[:HAS_PASSAGE {id: 'axdemo/edge/r1v/HAS_PASSAGE/p1'}]->(p1)
MERGE (r1v)-[:HAS_PASSAGE {id: 'axdemo/edge/r1v/HAS_PASSAGE/p1resources'}]->(p1resources)
MERGE (r1v)-[:HAS_PASSAGE {id: 'axdemo/edge/r1v/HAS_PASSAGE/p1policy'}]->(p1policy)
MERGE (r2v)-[:HAS_PASSAGE {id: 'axdemo/edge/r2v/HAS_PASSAGE/p2'}]->(p2)
MERGE (r3v)-[:HAS_PASSAGE {id: 'axdemo/edge/r3v/HAS_PASSAGE/p3revenue'}]->(p3revenue)
MERGE (r3v)-[:HAS_PASSAGE {id: 'axdemo/edge/r3v/HAS_PASSAGE/p3scrap'}]->(p3scrap)
MERGE (r4v)-[:HAS_PASSAGE {id: 'axdemo/edge/r4v/HAS_PASSAGE/p4announce'}]->(p4announce)
MERGE (r4v)-[:HAS_PASSAGE {id: 'axdemo/edge/r4v/HAS_PASSAGE/p4tsmc'}]->(p4tsmc)
MERGE (r5v)-[:HAS_PASSAGE {id: 'axdemo/edge/r5v/HAS_PASSAGE/p5lease'}]->(p5lease)
MERGE (r5v)-[:HAS_PASSAGE {id: 'axdemo/edge/r5v/HAS_PASSAGE/p5response'}]->(p5response)
MERGE (r5v)-[:HAS_PASSAGE {id: 'axdemo/edge/r5v/HAS_PASSAGE/p5price'}]->(p5price)
MERGE (budgetIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/budgetIdea/CONCERNS_DOMAIN/msftDomain'}]->(msftDomain)
MERGE (policyIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/policyIdea/CONCERNS_DOMAIN/msftDomain'}]->(msftDomain)
MERGE (revenueIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/revenueIdea/CONCERNS_DOMAIN/tsmcDomain'}]->(tsmcDomain)
MERGE (scrapIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/scrapIdea/CONCERNS_DOMAIN/tsmcDomain'}]->(tsmcDomain)
MERGE (blackwellIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/blackwellIdea/CONCERNS_DOMAIN/nvdaDomain'}]->(nvdaDomain)
MERGE (leaseIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/leaseIdea/CONCERNS_DOMAIN/msftDomain'}]->(msftDomain)
MERGE (reaffirmIdea)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/reaffirmIdea/CONCERNS_DOMAIN/msftDomain'}]->(msftDomain)
MERGE (r1)-[:CONTAINS {id: 'axdemo/edge/r1/CONTAINS/e1budget'}]->(e1budget)
MERGE (e1budget)-[:EXPRESSES {id: 'axdemo/edge/e1budget/EXPRESSES/budgetIdea'}]->(budgetIdea)
MERGE (e1budget)-[:SUPPORTED_BY {id: 'axdemo/edge/e1budget/SUPPORTED_BY/p1'}]->(p1)
MERGE (e1budget)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e1budget/ATTRIBUTED_TO/msft'}]->(msft)
MERGE (r1)-[:CONTAINS {id: 'axdemo/edge/r1/CONTAINS/e1policy'}]->(e1policy)
MERGE (e1policy)-[:EXPRESSES {id: 'axdemo/edge/e1policy/EXPRESSES/policyIdea'}]->(policyIdea)
MERGE (e1policy)-[:SUPPORTED_BY {id: 'axdemo/edge/e1policy/SUPPORTED_BY/p1policy'}]->(p1policy)
MERGE (e1policy)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e1policy/ATTRIBUTED_TO/msft'}]->(msft)
MERGE (r2)-[:CONTAINS {id: 'axdemo/edge/r2/CONTAINS/e2budget'}]->(e2budget)
MERGE (e2budget)-[:EXPRESSES {id: 'axdemo/edge/e2budget/EXPRESSES/budgetIdea'}]->(budgetIdea)
MERGE (e2budget)-[:SUPPORTED_BY {id: 'axdemo/edge/e2budget/SUPPORTED_BY/p2'}]->(p2)
MERGE (e2budget)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e2budget/ATTRIBUTED_TO/reuters'}]->(reuters)
MERGE (r3)-[:CONTAINS {id: 'axdemo/edge/r3/CONTAINS/e3revenue'}]->(e3revenue)
MERGE (e3revenue)-[:EXPRESSES {id: 'axdemo/edge/e3revenue/EXPRESSES/revenueIdea'}]->(revenueIdea)
MERGE (e3revenue)-[:SUPPORTED_BY {id: 'axdemo/edge/e3revenue/SUPPORTED_BY/p3revenue'}]->(p3revenue)
MERGE (e3revenue)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e3revenue/ATTRIBUTED_TO/tsmc'}]->(tsmc)
MERGE (r3)-[:CONTAINS {id: 'axdemo/edge/r3/CONTAINS/e3scrap'}]->(e3scrap)
MERGE (e3scrap)-[:EXPRESSES {id: 'axdemo/edge/e3scrap/EXPRESSES/scrapIdea'}]->(scrapIdea)
MERGE (e3scrap)-[:SUPPORTED_BY {id: 'axdemo/edge/e3scrap/SUPPORTED_BY/p3scrap'}]->(p3scrap)
MERGE (e3scrap)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e3scrap/ATTRIBUTED_TO/tsmc'}]->(tsmc)
MERGE (r4)-[:CONTAINS {id: 'axdemo/edge/r4/CONTAINS/e4blackwell'}]->(e4blackwell)
MERGE (e4blackwell)-[:EXPRESSES {id: 'axdemo/edge/e4blackwell/EXPRESSES/blackwellIdea'}]->(blackwellIdea)
MERGE (e4blackwell)-[:SUPPORTED_BY {id: 'axdemo/edge/e4blackwell/SUPPORTED_BY/p4announce'}]->(p4announce)
MERGE (e4blackwell)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e4blackwell/ATTRIBUTED_TO/nvda'}]->(nvda)
MERGE (r5)-[:CONTAINS {id: 'axdemo/edge/r5/CONTAINS/e5lease'}]->(e5lease)
MERGE (e5lease)-[:EXPRESSES {id: 'axdemo/edge/e5lease/EXPRESSES/leaseIdea'}]->(leaseIdea)
MERGE (e5lease)-[:SUPPORTED_BY {id: 'axdemo/edge/e5lease/SUPPORTED_BY/p5lease'}]->(p5lease)
MERGE (e5lease)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e5lease/ATTRIBUTED_TO/reuters'}]->(reuters)
MERGE (r5)-[:CONTAINS {id: 'axdemo/edge/r5/CONTAINS/e5response'}]->(e5response)
MERGE (e5response)-[:EXPRESSES {id: 'axdemo/edge/e5response/EXPRESSES/reaffirmIdea'}]->(reaffirmIdea)
MERGE (e5response)-[:SUPPORTED_BY {id: 'axdemo/edge/e5response/SUPPORTED_BY/p5response'}]->(p5response)
MERGE (e5response)-[:ATTRIBUTED_TO {id: 'axdemo/edge/e5response/ATTRIBUTED_TO/reuters'}]->(reuters)
MERGE (e1budget)-[:RESPONSIBLE_PERSON {id: 'axdemo/edge/e1budget/RESPONSIBLE_PERSON/brad'}]->(brad)
MERGE (e1policy)-[:RESPONSIBLE_PERSON {id: 'axdemo/edge/e1policy/RESPONSIBLE_PERSON/brad'}]->(brad)
MERGE (r2)-[:REFERS_TO_ORIGIN_REPORT {id: 'axdemo/edge/r2/REFERS_TO_ORIGIN_REPORT/r1', mapping_status: 'proposed_source_attribution_match', meaning: 'same_company_announcement_not_independent_confirmation', copying_proven: false}]->(r1)
MERGE (spendingAnnouncement)-[:CONCERNS {id: 'axdemo/edge/spendingAnnouncement/CONCERNS/msft'}]->(msft)
MERGE (budgetIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/budgetIdea/DESCRIBES_EVENT/spendingAnnouncement'}]->(spendingAnnouncement)
MERGE (tsmcRelease)-[:CONCERNS {id: 'axdemo/edge/tsmcRelease/CONCERNS/tsmc'}]->(tsmc)
MERGE (revenueIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/revenueIdea/DESCRIBES_EVENT/tsmcRelease'}]->(tsmcRelease)
MERGE (earthquake)-[:CONCERNS {id: 'axdemo/edge/earthquake/CONCERNS/tsmc'}]->(tsmc)
MERGE (scrapIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/scrapIdea/DESCRIBES_EVENT/earthquake'}]->(earthquake)
MERGE (blackwellAnnouncement)-[:CONCERNS {id: 'axdemo/edge/blackwellAnnouncement/CONCERNS/nvda'}]->(nvda)
MERGE (blackwellIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/blackwellIdea/DESCRIBES_EVENT/blackwellAnnouncement'}]->(blackwellAnnouncement)
MERGE (leaseEvent)-[:CONCERNS {id: 'axdemo/edge/leaseEvent/CONCERNS/msft'}]->(msft)
MERGE (leaseIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/leaseIdea/DESCRIBES_EVENT/leaseEvent'}]->(leaseEvent)
MERGE (responseEvent)-[:CONCERNS {id: 'axdemo/edge/responseEvent/CONCERNS/msft'}]->(msft)
MERGE (reaffirmIdea)-[:DESCRIBES_EVENT {id: 'axdemo/edge/reaffirmIdea/DESCRIBES_EVENT/responseEvent'}]->(responseEvent)
MERGE (blackwellAnnouncement)-[:CONCERNS_RESOURCE {id: 'axdemo/edge/blackwellAnnouncement/CONCERNS_RESOURCE/blackwell'}]->(blackwell)
MERGE (budgetFact)-[:ABOUT_IDEA {id: 'axdemo/edge/budgetFact/ABOUT_IDEA/budgetIdea'}]->(budgetIdea)
MERGE (budgetFact)-[:ABOUT_EVENT {id: 'axdemo/edge/budgetFact/ABOUT_EVENT/spendingAnnouncement'}]->(spendingAnnouncement)
MERGE (budgetFactConfirmation)-[:CONFIRMS {id: 'axdemo/edge/budgetFactConfirmation/CONFIRMS/budgetFact'}]->(budgetFact)
MERGE (budgetFactConfirmation)-[:SUPPORTED_BY {id: 'axdemo/edge/budgetFactConfirmation/SUPPORTED_BY/p1'}]->(p1)
MERGE (budgetFactConfirmation)-[:EXTERNAL_ORIGIN {id: 'axdemo/edge/budgetFactConfirmation/EXTERNAL_ORIGIN/msft'}]->(msft)
MERGE (revenueFact)-[:ABOUT_IDEA {id: 'axdemo/edge/revenueFact/ABOUT_IDEA/revenueIdea'}]->(revenueIdea)
MERGE (revenueFact)-[:ABOUT_EVENT {id: 'axdemo/edge/revenueFact/ABOUT_EVENT/tsmcRelease'}]->(tsmcRelease)
MERGE (revenueFactConfirmation)-[:CONFIRMS {id: 'axdemo/edge/revenueFactConfirmation/CONFIRMS/revenueFact'}]->(revenueFact)
MERGE (revenueFactConfirmation)-[:SUPPORTED_BY {id: 'axdemo/edge/revenueFactConfirmation/SUPPORTED_BY/p3revenue'}]->(p3revenue)
MERGE (revenueFactConfirmation)-[:EXTERNAL_ORIGIN {id: 'axdemo/edge/revenueFactConfirmation/EXTERNAL_ORIGIN/tsmc'}]->(tsmc)
MERGE (scrapFact)-[:ABOUT_IDEA {id: 'axdemo/edge/scrapFact/ABOUT_IDEA/scrapIdea'}]->(scrapIdea)
MERGE (scrapFact)-[:ABOUT_EVENT {id: 'axdemo/edge/scrapFact/ABOUT_EVENT/earthquake'}]->(earthquake)
MERGE (scrapFactConfirmation)-[:CONFIRMS {id: 'axdemo/edge/scrapFactConfirmation/CONFIRMS/scrapFact'}]->(scrapFact)
MERGE (scrapFactConfirmation)-[:SUPPORTED_BY {id: 'axdemo/edge/scrapFactConfirmation/SUPPORTED_BY/p3scrap'}]->(p3scrap)
MERGE (scrapFactConfirmation)-[:EXTERNAL_ORIGIN {id: 'axdemo/edge/scrapFactConfirmation/EXTERNAL_ORIGIN/tsmc'}]->(tsmc)
MERGE (blackwellFact)-[:ABOUT_IDEA {id: 'axdemo/edge/blackwellFact/ABOUT_IDEA/blackwellIdea'}]->(blackwellIdea)
MERGE (blackwellFact)-[:ABOUT_EVENT {id: 'axdemo/edge/blackwellFact/ABOUT_EVENT/blackwellAnnouncement'}]->(blackwellAnnouncement)
MERGE (blackwellFactConfirmation)-[:CONFIRMS {id: 'axdemo/edge/blackwellFactConfirmation/CONFIRMS/blackwellFact'}]->(blackwellFact)
MERGE (blackwellFactConfirmation)-[:SUPPORTED_BY {id: 'axdemo/edge/blackwellFactConfirmation/SUPPORTED_BY/p4announce'}]->(p4announce)
MERGE (blackwellFactConfirmation)-[:EXTERNAL_ORIGIN {id: 'axdemo/edge/blackwellFactConfirmation/EXTERNAL_ORIGIN/nvda'}]->(nvda)
MERGE (e2budget)-[:CONFIRMED_BY {id: 'axdemo/edge/e2budget/CONFIRMED_BY/budgetFactConfirmation'}]->(budgetFactConfirmation)
MERGE (nvdaDomain)-[:HAS_DEPENDENCY {id: 'axdemo/edge/nvdaDomain/HAS_DEPENDENCY/chipDependency'}]->(chipDependency)
MERGE (chipDependency)-[:ON {id: 'axdemo/edge/chipDependency/ON/tsmc'}]->(tsmc)
MERGE (chipDependency)-[:SUPPORTED_BY {id: 'axdemo/edge/chipDependency/SUPPORTED_BY/p4tsmc'}]->(p4tsmc)
MERGE (msftDomain)-[:HAS_DEPENDENCY {id: 'axdemo/edge/msftDomain/HAS_DEPENDENCY/powerDependency'}]->(powerDependency)
MERGE (powerDependency)-[:ON {id: 'axdemo/edge/powerDependency/ON/power'}]->(power)
MERGE (powerDependency)-[:SUPPORTED_BY {id: 'axdemo/edge/powerDependency/SUPPORTED_BY/p1resources'}]->(p1resources)
MERGE (msftDomain)-[:HAS_DEPENDENCY {id: 'axdemo/edge/msftDomain/HAS_DEPENDENCY/coolingDependency'}]->(coolingDependency)
MERGE (coolingDependency)-[:ON {id: 'axdemo/edge/coolingDependency/ON/cooling'}]->(cooling)
MERGE (coolingDependency)-[:SUPPORTED_BY {id: 'axdemo/edge/coolingDependency/SUPPORTED_BY/p1resources'}]->(p1resources)
MERGE (earthquake)-[:HAS_RELEVANCE_INTERPRETATION {id: 'axdemo/edge/earthquake/HAS_RELEVANCE_INTERPRETATION/quakeRelevance'}]->(quakeRelevance)
MERGE (quakeRelevance)-[:CONCERNS_DOMAIN {id: 'axdemo/edge/quakeRelevance/CONCERNS_DOMAIN/nvdaDomain'}]->(nvdaDomain)
MERGE (quakeRelevance)-[:USES_DEPENDENCY {id: 'axdemo/edge/quakeRelevance/USES_DEPENDENCY/chipDependency'}]->(chipDependency)
MERGE (quakeRelevance)-[:USES_IDEA {id: 'axdemo/edge/quakeRelevance/USES_IDEA/scrapIdea'}]->(scrapIdea)
MERGE (quakeRelevance)-[:SUPPORTED_BY {id: 'axdemo/edge/quakeRelevance/SUPPORTED_BY/p3scrap'}]->(p3scrap)
MERGE (quakeRelevance)-[:SUPPORTED_BY {id: 'axdemo/edge/quakeRelevance/SUPPORTED_BY/p4tsmc'}]->(p4tsmc)
MERGE (priceResponse)-[:FOR_STOCK {id: 'axdemo/edge/priceResponse/FOR_STOCK/msftStock'}]->(msftStock)
MERGE (priceResponse)-[:SUPPORTED_BY {id: 'axdemo/edge/priceResponse/SUPPORTED_BY/p5price'}]->(p5price)
MERGE (r5)-[:REPORTS_RESPONSE {id: 'axdemo/edge/r5/REPORTS_RESPONSE/priceResponse'}]->(priceResponse)
MERGE (officialView)-[:SELECTS_SOURCE {id: 'axdemo/edge/officialView/SELECTS_SOURCE/msftSource'}]->(msftSource)
MERGE (mixedView)-[:SELECTS_SOURCE {id: 'axdemo/edge/mixedView/SELECTS_SOURCE/msftSource'}]->(msftSource)
MERGE (officialView)-[:SELECTS_SOURCE {id: 'axdemo/edge/officialView/SELECTS_SOURCE/tsmcSource'}]->(tsmcSource)
MERGE (mixedView)-[:SELECTS_SOURCE {id: 'axdemo/edge/mixedView/SELECTS_SOURCE/tsmcSource'}]->(tsmcSource)
MERGE (officialView)-[:SELECTS_SOURCE {id: 'axdemo/edge/officialView/SELECTS_SOURCE/nvdaSource'}]->(nvdaSource)
MERGE (mixedView)-[:SELECTS_SOURCE {id: 'axdemo/edge/mixedView/SELECTS_SOURCE/nvdaSource'}]->(nvdaSource)
MERGE (mixedView)-[:SELECTS_SOURCE {id: 'axdemo/edge/mixedView/SELECTS_SOURCE/reutersSource'}]->(reutersSource)
MERGE (e1budget)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e1budget/HAS_INFORMATION_ORIGIN/msft', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(msft)
MERGE (e1policy)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e1policy/HAS_INFORMATION_ORIGIN/msft', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(msft)
MERGE (e2budget)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e2budget/HAS_INFORMATION_ORIGIN/msft', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(msft)
MERGE (e3revenue)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e3revenue/HAS_INFORMATION_ORIGIN/tsmc', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(tsmc)
MERGE (e3scrap)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e3scrap/HAS_INFORMATION_ORIGIN/tsmc', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(tsmc)
MERGE (e4blackwell)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e4blackwell/HAS_INFORMATION_ORIGIN/nvda', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(nvda)
MERGE (e5lease)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e5lease/HAS_INFORMATION_ORIGIN/cowen', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(cowen)
MERGE (e5response)-[:HAS_INFORMATION_ORIGIN {id: 'axdemo/edge/e5response/HAS_INFORMATION_ORIGIN/msft', origin_basis: 'source_attribution_for_this_expression', origin_mapping_status: 'analyst_mapping_for_example'}]->(msft)
RETURN 'Design fixture loaded' AS result;

// PART 2: READ QUERIES -- run individually after the loading section.
// Expected results in comments are derived by inspection, not live database execution.

// Q1: Two reports can express one idea without becoming two independent origins
// Expected by inspection: The budget idea: 2 reports, 2 publisher channels, 1 named originating organisation.
MATCH (rep:AxDemo:Report)-[:CONTAINS]->(ex:AxDemo:Expression)
      -[:EXPRESSES]->(idea:AxDemo:Idea {id: 'axdemo/budgetIdea'})
MATCH (rep)-[:PUBLISHED_IN]->(src:AxDemo:Source)
MATCH (ex)-[:HAS_INFORMATION_ORIGIN]->(origin:AxDemo:Organisation)
RETURN idea.summary AS meaning,
       count(DISTINCT rep) AS report_count,
       count(DISTINCT src) AS publisher_channels,
       count(DISTINCT origin) AS named_origins;

// Q2: Inspect each expression, its responsible person and its exact retained passage
// Expected by inspection: Separate Microsoft and Reuters expressions; Reuters has a reporting credit, not a fabricated personal opinion.
MATCH (rep:AxDemo:Report)-[:CONTAINS]->(ex:AxDemo:Expression)
      -[:EXPRESSES]->(idea:AxDemo:Idea {id: 'axdemo/budgetIdea'})
MATCH (rep)-[:PUBLISHED_IN]->(src:AxDemo:Source)
MATCH (ex)-[:SUPPORTED_BY]->(p:AxDemo:Passage)
MATCH (ev:AxDemo:EvidenceVersion)-[:HAS_PASSAGE]->(p)
OPTIONAL MATCH (rep)-[:RESPONSIBLE_PERSON]->(person:AxDemo:Person)
RETURN src.name AS source, rep.source_on AS source_day,
       person.name AS responsible_person, ex.information_kind AS category,
       ex.news_status AS news_status, ex.agreement_status AS agreement,
       p.text AS exact_excerpt, p.locator AS location,
       ev.url AS evidence_url, ev.full_original_retained AS full_original_retained;

// Q3: A January event can have February source information
// Expected by inspection: At a January 24 cutoff, no quake idea from this particular February 10 report; at February 10, one.
UNWIND [date('2025-01-24'), date('2025-02-10')] AS cutoff
OPTIONAL MATCH (rep:AxDemo:Report)-[:CONTAINS]->(:AxDemo:Expression)
               -[:EXPRESSES]->(idea:AxDemo:Idea)-[:DESCRIBES_EVENT]->
               (event:AxDemo:Event {id: 'axdemo/earthquake'})
WHERE rep.source_on <= cutoff
RETURN cutoff, count(DISTINCT idea) AS source_dated_ideas_in_packet;
// This is a DISPLAYED-SOURCE-DATE design query, not certified historical backtest eligibility.
// It does not claim there was no January reporting elsewhere.

// Q4: Show an evidenced supplier path and a separate interpretation
// Expected by inspection: NVIDIA AI accelerator domain -> stated Blackwell manufacturing dependency -> TSMC -> reported earthquake.
MATCH (stock:AxDemo:Stock {symbol: 'NVDA'})-[:POINTS_TO]->(org:AxDemo:Organisation)
MATCH (domain:AxDemo:Domain)-[:DOMAIN_OF]->(org)
MATCH (domain)-[:HAS_DEPENDENCY]->(dep:AxDemo:Dependency)-[:ON]->(supplier:AxDemo:Organisation)
MATCH (event:AxDemo:Event)-[:CONCERNS]->(supplier)
MATCH (event)-[:HAS_RELEVANCE_INTERPRETATION]->(interpretation:AxDemo:Interpretation)
      -[:USES_DEPENDENCY]->(dep)
MATCH (interpretation)-[:USES_IDEA]->(reportedIdea:AxDemo:Idea)
MATCH (rep:AxDemo:Report)-[:CONTAINS]->(:AxDemo:Expression)-[:EXPRESSES]->(reportedIdea)
MATCH (dep)-[:SUPPORTED_BY]->(dependencyPassage:AxDemo:Passage)
MATCH (interpretation)-[:SUPPORTED_BY]->(impactPassage:AxDemo:Passage)
WHERE rep.source_on <= date('2025-02-10')
  AND dep.source_on <= date('2025-02-10')
  AND impactPassage.id = 'axdemo/p3scrap'
RETURN stock.symbol, domain.name AS domain, dep.product_scope AS dependency_scope,
       supplier.name, event.occurred_on AS event_day, rep.source_on AS report_day,
       interpretation.effect_status, interpretation.summary,
       dependencyPassage.text AS dependency_evidence,
       impactPassage.text AS reported_effect_evidence,
       interpretation.generated_on AS interpretation_created;
// Only one configured dependency is followed here. No global traversal limit is selected.

// Q5: Resources belong to a particular domain
// Expected by inspection: Microsoft AI/cloud domain -> electricity and liquid cooling, with evidence and scope.
MATCH (:AxDemo:Stock {symbol: 'MSFT'})-[:POINTS_TO]->(org:AxDemo:Organisation)
MATCH (domain:AxDemo:Domain)-[:DOMAIN_OF]->(org)
MATCH (domain)-[:HAS_DEPENDENCY]->(dep:AxDemo:Dependency)-[:ON]->(resource:AxDemo:Resource)
MATCH (dep)-[:SUPPORTED_BY]->(p:AxDemo:Passage)
RETURN domain.name, resource.name, dep.meaning, dep.scope,
       dep.universal_requirement_established, p.text, p.locator;

// Q6: A fact stays separate from its report and confirmation process
// Expected by inspection: Company-disclosure-scoped facts with exact supporting source, not proof that every forward-looking outcome happened.
MATCH (confirmation:AxDemo:Confirmation)-[:CONFIRMS]->(fact:AxDemo:Fact)
MATCH (confirmation)-[:EXTERNAL_ORIGIN]->(origin:AxDemo:Organisation)
MATCH (confirmation)-[:SUPPORTED_BY]->(p:AxDemo:Passage)
MATCH (rep:AxDemo:Report)-[:HAS_VERSION]->(ev:AxDemo:EvidenceVersion)-[:HAS_PASSAGE]->(p)
RETURN fact.text, confirmation.scope, confirmation.process, origin.name,
       confirmation.available_on, rep.canonical_url, p.locator,
       fact.content_independently_verified;

// Q7: Views select explicit source channels over shared ideas
// Expected by inspection: The budget idea has 1 expression in the selected-company view and 2 in the mixed view.
MATCH (view:AxDemo:View)-[:SELECTS_SOURCE]->(src:AxDemo:Source)
MATCH (rep:AxDemo:Report)-[:PUBLISHED_IN]->(src)
MATCH (rep)-[:CONTAINS]->(ex:AxDemo:Expression)-[:EXPRESSES]->
      (idea:AxDemo:Idea {id: 'axdemo/budgetIdea'})
RETURN view.name, view.version, view.defined_on,
       count(DISTINCT ex) AS expressions, collect(DISTINCT src.name) AS selected_sources;
// These view definitions were created for today's retrospective review, not in 2025.

// Q8: Observed/reported price change is not a forecast
// Expected by inspection: The Reuters-reported daily MSFT move appears separately; stock UP/DOWN judgments count is zero.
MATCH (move:AxDemo:ReportedResponse)-[:FOR_STOCK]->(stock:AxDemo:Stock)
MATCH (move)-[:SUPPORTED_BY]->(p:AxDemo:Passage)
RETURN stock.symbol, move.observation_on, move.change_pct,
       move.evidence_kind, move.validated_against_OHLCV, move.not_a_forecast, p.text;

MATCH (j:AxDemo:Judgment)
RETURN count(j) AS supported_directional_judgments;
// No Judgment node is invented from business growth, lease concerns or an observed fall.

// Q9: Surface undecided classifications instead of silently filling them
// Expected by inspection: The Reuters-relayed company response has an explicitly undecided news classification.
MATCH (rep:AxDemo:Report)-[:CONTAINS]->(ex:AxDemo:Expression)
WHERE ex.news_status_assignment IS NOT NULL
RETURN rep.display_title, ex.id, ex.news_status_assignment, ex.classification_status;

// Q10: Inspect the graph in a graph-capable Cypher viewer
// Expected by inspection: All 80 example nodes and 148 example relationships; operational jobs are not domain nodes.
MATCH (a:AxDemo)-[r]->(b:AxDemo)
RETURN a, r, b;
