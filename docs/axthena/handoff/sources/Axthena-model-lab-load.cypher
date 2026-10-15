// AXTHENA MODEL LAB v2 — ALL DATA IS FICTIONAL, INCLUDING PRICES AND PEOPLE.
// A model-review fixture only. It does not choose the production database or start C++ implementation.
// Neo4j Cypher 5-compatible syntax; no APOC/extensions. One complete load statement.
// Use an empty disposable database. Run this entire file once; same-file reload is idempotent there.
// Raw fictional text is fully retained. LLM extraction was not run.
// Dates are uniform UTC ISO strings for transparent fixture comparisons, not a final storage-type decision.
// Facts have scoped synthetic external confirmations. Query status at a cutoff; do not backdate current conflict.
// Node identities, relation names and auxiliary nodes remain model proposals for owner review.

MERGE (n0:AxLab:Organisation {id: "axlab/org/nova"})
ON CREATE SET n0 += {synthetic: true, name: "NovaChip"}
MERGE (n1:AxLab:Organisation {id: "axlab/org/cloud"})
ON CREATE SET n1 += {synthetic: true, name: "NovaCloud (subsidiary)"}
MERGE (n2:AxLab:Organisation {id: "axlab/org/forge"})
ON CREATE SET n2 += {synthetic: true, name: "ForgeFoundry"}
MERGE (n3:AxLab:Organisation {id: "axlab/org/litho"})
ON CREATE SET n3 += {synthetic: true, name: "LithoWorks"}
MERGE (n4:AxLab:Organisation {id: "axlab/org/dragon"})
ON CREATE SET n4 += {synthetic: true, name: "DragonLogic (competitor)"}
MERGE (n5:AxLab:Organisation {id: "axlab/org/softpeak"})
ON CREATE SET n5 += {synthetic: true, name: "SoftPeak (acquisition target)"}
MERGE (n6:AxLab:Organisation {id: "axlab/org/north"})
ON CREATE SET n6 += {synthetic: true, name: "North Business Journal"}
MERGE (n7:AxLab:Organisation {id: "axlab/org/south"})
ON CREATE SET n7 += {synthetic: true, name: "South Business Journal"}
MERGE (n8:AxLab:Organisation {id: "axlab/org/route"})
ON CREATE SET n8 += {synthetic: true, name: "Route Authority"}
MERGE (n9:AxLab:Organisation {id: "axlab/org/seismic"})
ON CREATE SET n9 += {synthetic: true, name: "Seismic Institute"}
MERGE (n10:AxLab:Organisation {id: "axlab/org/audit"})
ON CREATE SET n10 += {synthetic: true, name: "Independent Audit Office"}
MERGE (n11:AxLab:Stock {id: "axlab/stock/NOVA"})
ON CREATE SET n11 += {synthetic: true, ticker: "NOVA", exchange: "FICTIONAL", name: "NovaChip ordinary shares"}
MERGE (n12:AxLab:Domain {id: "axlab/domain/chips"})
ON CREATE SET n12 += {synthetic: true, name: "AI chip design"}
MERGE (n13:AxLab:Domain {id: "axlab/domain/software"})
ON CREATE SET n13 += {synthetic: true, name: "Software and cloud"}
MERGE (n14:AxLab:Process {id: "axlab/process/design"})
ON CREATE SET n14 += {synthetic: true, name: "Design and sell AI chips"}
MERGE (n15:AxLab:Process {id: "axlab/process/fab"})
ON CREATE SET n15 += {synthetic: true, name: "Fabricate wafers"}
MERGE (n16:AxLab:Process {id: "axlab/process/software"})
ON CREATE SET n16 += {synthetic: true, name: "Develop cloud software"}
MERGE (n17:AxLab:Resource {id: "axlab/resource/silicon"})
ON CREATE SET n17 += {synthetic: true, name: "Silicon"}
MERGE (n18:AxLab:Resource {id: "axlab/resource/power"})
ON CREATE SET n18 += {synthetic: true, name: "Electricity"}
MERGE (n19:AxLab:Resource {id: "axlab/resource/route"})
ON CREATE SET n19 += {synthetic: true, name: "Shipping and road transport"}
MERGE (n20:AxLab:Resource {id: "axlab/resource/machine"})
ON CREATE SET n20 += {synthetic: true, name: "Lithography equipment"}
MERGE (n21:AxLab:Product {id: "axlab/product/chips"})
ON CREATE SET n21 += {synthetic: true, name: "AI chips"}
MERGE (n22:AxLab:Product {id: "axlab/product/software"})
ON CREATE SET n22 += {synthetic: true, name: "Cloud software"}
MERGE (n23:AxLab:Context {id: "axlab/context/world"})
ON CREATE SET n23 += {synthetic: true, name: "Fictional analyst world configuration", available_at: "2025-03-01T08:00:00Z", basis: "synthetic world definition", text: "NOVA points to issuer NovaChip and contributing subsidiary NovaCloud. NovaChip operates in AI chip design and software/cloud. NovaCloud operates in software/cloud. The chip business outputs AI chips; ForgeFoundry fabricates them using silicon and lithography equipment. The software process uses electricity and outputs cloud software. NovaChip competes with DragonLogic. SoftPeak is initially outside the group."}
MERGE (n24:AxLab:Person {id: "axlab/person/leader"})
ON CREATE SET n24 += {synthetic: true, name: "NovaChip spokesperson", anonymous: false, platform_account_id: "demo-company-spokesperson"}
MERGE (n25:AxLab:Person {id: "axlab/person/mira"})
ON CREATE SET n25 += {synthetic: true, name: "Mira Chen", anonymous: false, platform_account_id: "demo-mira"}
MERGE (n26:AxLab:Person {id: "axlab/person/anon1"})
ON CREATE SET n26 += {synthetic: true, name: "Anonymous account A", anonymous: true, platform_account_id: "demo-account-A"}
MERGE (n27:AxLab:Person {id: "axlab/person/anon2"})
ON CREATE SET n27 += {synthetic: true, name: "Anonymous account B", anonymous: true, platform_account_id: "demo-account-B"}
MERGE (n28:AxLab:PersonWeight {id: "axlab/weight/mira"})
ON CREATE SET n28 += {synthetic: true, credibility: 0.5, influence: 0.5, predictive_record: 0.5, value_status: "dummy", origin: "fixture author", recorded_at: "2026-10-14T00:00:00Z", version: "demo-1", domain_dependent: false}
MERGE (n29:AxLab:PersonWeight {id: "axlab/weight/anon1"})
ON CREATE SET n29 += {synthetic: true, credibility: 0.5, influence: 0.5, predictive_record: 0.5, value_status: "dummy", origin: "fixture author", recorded_at: "2026-10-14T00:00:00Z", version: "demo-1", domain_dependent: false}
MERGE (n30:AxLab:PersonWeight {id: "axlab/weight/anon2"})
ON CREATE SET n30 += {synthetic: true, credibility: 0.5, influence: 0.5, predictive_record: 0.5, value_status: "dummy", origin: "fixture author", recorded_at: "2026-10-14T00:00:00Z", version: "demo-1", domain_dependent: false}
MERGE (n31:AxLab:Source {id: "axlab/source/nova"})
ON CREATE SET n31 += {synthetic: true, name: "NovaChip press room", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n32:AxLab:Source {id: "axlab/source/forge"})
ON CREATE SET n32 += {synthetic: true, name: "ForgeFoundry press room", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n33:AxLab:Source {id: "axlab/source/litho"})
ON CREATE SET n33 += {synthetic: true, name: "LithoWorks press room", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n34:AxLab:Source {id: "axlab/source/north"})
ON CREATE SET n34 += {synthetic: true, name: "North Business Journal", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n35:AxLab:Source {id: "axlab/source/south"})
ON CREATE SET n35 += {synthetic: true, name: "South Business Journal", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n36:AxLab:Source {id: "axlab/source/route"})
ON CREATE SET n36 += {synthetic: true, name: "Route Authority bulletin", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n37:AxLab:Source {id: "axlab/source/seismic"})
ON CREATE SET n37 += {synthetic: true, name: "Seismic Institute bulletin", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n38:AxLab:Source {id: "axlab/source/audit"})
ON CREATE SET n38 += {synthetic: true, name: "Independent Audit Office note", source_kind: "organisation", selection_note: "A single fictional publisher; not a national consensus"}
MERGE (n39:AxLab:Source {id: "axlab/source/social"})
ON CREATE SET n39 += {synthetic: true, name: "Selected Chirp posts", source_kind: "platform", selection_note: "Three selected individual accounts; not a representative feed"}
MERGE (n40:AxLab:Event {id: "axlab/event/partnership"})
ON CREATE SET n40 += {synthetic: true, name: "Manufacturing agreement announced", event_type: "partnership_announcement", occurred_at: "2025-03-03T09:00:00Z"}
MERGE (n41:AxLab:Event {id: "axlab/event/ipo"})
ON CREATE SET n41 += {synthetic: true, name: "NOVA begins trading", event_type: "ipo", occurred_at: "2025-03-03T09:30:00Z"}
MERGE (n42:AxLab:Event {id: "axlab/event/war"})
ON CREATE SET n42 += {synthetic: true, name: "Conflict disrupts a shipping route", event_type: "conflict_disruption", occurred_at: "2025-03-03T06:00:00Z"}
MERGE (n43:AxLab:Event {id: "axlab/event/tech"})
ON CREATE SET n43 += {synthetic: true, name: "NovaChip announces a new AI chip", event_type: "technology_announcement", occurred_at: "2025-03-04T09:00:00Z"}
MERGE (n44:AxLab:Event {id: "axlab/event/quake"})
ON CREATE SET n44 += {synthetic: true, name: "Earthquake disrupts transport near LithoWorks", event_type: "natural_disaster", occurred_at: "2025-03-03T22:00:00Z"}
MERGE (n45:AxLab:Event {id: "axlab/event/acq"})
ON CREATE SET n45 += {synthetic: true, name: "Proposed SoftPeak acquisition announced", event_type: "acquisition_announcement", occurred_at: "2025-03-06T09:00:00Z"}
MERGE (n46:AxLab:Event {id: "axlab/event/earnings"})
ON CREATE SET n46 += {synthetic: true, name: "NovaChip publishes quarterly earnings", event_type: "earnings_announcement", occurred_at: "2025-03-07T09:00:00Z"}
MERGE (n47:AxLab:Event {id: "axlab/event/production"})
ON CREATE SET n47 += {synthetic: true, name: "New chip production begins", event_type: "production_start", occurred_at: "2025-03-10T09:00:00Z"}
MERGE (n48:AxLab:ProcessingRun {id: "axlab/run/manual"})
ON CREATE SET n48 += {synthetic: true, mode: "manually constructed model fixture", llm_invoked: false, recorded_at: "2026-10-14T00:00:00Z", instructions: "Preserve source-specific expressions, original fictional text, source timing and distinct confirmation. No extractor or market model was run."}
MERGE (n49:AxLab:Report {id: "axlab/report/partnership"})
ON CREATE SET n49 += {synthetic: true, title: "Manufacturing agreement", category: "news", published_at: "2025-03-03T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/partnership", news_status: "confirmed"}
MERGE (n50:AxLab:EvidenceVersion {id: "axlab/evidence/partnership"})
ON CREATE SET n50 += {synthetic: true, full_text: "NovaChip announces a five-year manufacturing agreement with ForgeFoundry. The agreement concerns production of NovaChip AI chips.", sha256: "0a24f71f8ca32c39f0531b5fa56e54bf27b1e8d1d71117db0781e488eb9540d8", encoding: "UTF-8", source_available_at: "2025-03-03T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n51:AxLab:Passage {id: "axlab/passage/partnership-company"})
ON CREATE SET n51 += {synthetic: true, text: "NovaChip announces a five-year manufacturing agreement with ForgeFoundry. The agreement concerns production of NovaChip AI chips.", start: 0, end: 129}
MERGE (n52:AxLab:Expression {id: "axlab/expression/partnership-company"})
ON CREATE SET n52 += {synthetic: true, summary: "NovaChip announces a manufacturing agreement with ForgeFoundry.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n53:AxLab:Idea {id: "axlab/idea/partnership"})
ON CREATE SET n53 += {synthetic: true, summary: "NovaChip announces a manufacturing agreement with ForgeFoundry.", grouping_version: "fixture-v1"}
MERGE (n54:AxLab:Fact {id: "axlab/fact/partnership"})
ON CREATE SET n54 += {synthetic: true, scope: "the company issued this partnership announcement", confirmation_rule: "illustrative external process; policy not yet selected", claim: "NovaChip announced the manufacturing agreement; performance/delivery not established"}
MERGE (n55:AxLab:Confirmation {id: "axlab/confirmation/partnership"})
ON CREATE SET n55 += {synthetic: true, process: "first-party published company statement", recorded_at: "2026-10-14T00:00:00Z", scope: "the company issued this partnership announcement"}
MERGE (n56:AxLab:Report {id: "axlab/report/north-partnership"})
ON CREATE SET n56 += {synthetic: true, title: "Agreement supported by North", category: "news", published_at: "2025-03-03T11:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/north-partnership", news_status: "confirmed"}
MERGE (n57:AxLab:EvidenceVersion {id: "axlab/evidence/north-partnership"})
ON CREATE SET n57 += {synthetic: true, full_text: "NovaChip announced a five-year manufacturing agreement with ForgeFoundry. We strongly support this manufacturing agreement as a production decision.", sha256: "fed8562cd5c153e6355a1176298a3ccbdc016b6bacef98154429a6557c0f850b", encoding: "UTF-8", source_available_at: "2025-03-03T11:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n58:AxLab:Passage {id: "axlab/passage/partnership-north"})
ON CREATE SET n58 += {synthetic: true, text: "NovaChip announced a five-year manufacturing agreement with ForgeFoundry. We strongly support this manufacturing agreement as a production decision.", start: 0, end: 148}
MERGE (n59:AxLab:Expression {id: "axlab/expression/partnership-north"})
ON CREATE SET n59 += {synthetic: true, summary: "NovaChip announces a manufacturing agreement with ForgeFoundry.", category: "news", origin_status: "known", annotation_origin: "manual fixture", agreement_strength: "strong", strength_basis: "source wording in fictional passage", news_status: "confirmed"}
MERGE (n60:AxLab:Report {id: "axlab/report/south-copy"})
ON CREATE SET n60 += {synthetic: true, title: "Announcement relayed by South", category: "news", published_at: "2025-03-04T08:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/south-copy", news_status: "confirmed"}
MERGE (n61:AxLab:EvidenceVersion {id: "axlab/evidence/south-copy"})
ON CREATE SET n61 += {synthetic: true, full_text: "NovaChip announces a five-year manufacturing agreement with ForgeFoundry. The agreement concerns production of NovaChip AI chips.", sha256: "0a24f71f8ca32c39f0531b5fa56e54bf27b1e8d1d71117db0781e488eb9540d8", encoding: "UTF-8", source_available_at: "2025-03-04T08:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n62:AxLab:Passage {id: "axlab/passage/partnership-south"})
ON CREATE SET n62 += {synthetic: true, text: "NovaChip announces a five-year manufacturing agreement with ForgeFoundry. The agreement concerns production of NovaChip AI chips.", start: 0, end: 129}
MERGE (n63:AxLab:Expression {id: "axlab/expression/partnership-south"})
ON CREATE SET n63 += {synthetic: true, summary: "NovaChip announces a manufacturing agreement with ForgeFoundry.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n64:AxLab:Report {id: "axlab/report/ipo"})
ON CREATE SET n64 += {synthetic: true, title: "IPO and business context", category: "news", published_at: "2025-03-03T09:30:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/ipo", news_status: "confirmed"}
MERGE (n65:AxLab:EvidenceVersion {id: "axlab/evidence/ipo"})
ON CREATE SET n65 += {synthetic: true, full_text: "NOVA begins trading today. NovaChip owns NovaCloud, which develops cloud software. NovaChip designs AI chips and uses ForgeFoundry for their manufacture. The business requires silicon and electricity; NovaCloud also requires electricity.", sha256: "07bbbee951bbbdc3bd4b6f1ce8b4a53fd8c70ff2edcc29be98d18d4ef8cba179", encoding: "UTF-8", source_available_at: "2025-03-03T09:30:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n66:AxLab:Passage {id: "axlab/passage/ipo"})
ON CREATE SET n66 += {synthetic: true, text: "NOVA begins trading today. NovaChip owns NovaCloud, which develops cloud software. NovaChip designs AI chips and uses ForgeFoundry for their manufacture. The business requires silicon and electricity; NovaCloud also requires electricity.", start: 0, end: 237}
MERGE (n67:AxLab:Expression {id: "axlab/expression/ipo"})
ON CREATE SET n67 += {synthetic: true, summary: "NovaChip reports NOVA beginning to trade and describes its business.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n68:AxLab:Idea {id: "axlab/idea/ipo"})
ON CREATE SET n68 += {synthetic: true, summary: "NovaChip reports NOVA beginning to trade and describes its business.", grouping_version: "fixture-v1"}
MERGE (n69:AxLab:Fact {id: "axlab/fact/ipo"})
ON CREATE SET n69 += {synthetic: true, scope: "company report of its IPO and business disclosures", confirmation_rule: "illustrative external process; policy not yet selected", claim: "The company reported trading had begun; stock is a separate identity"}
MERGE (n70:AxLab:Confirmation {id: "axlab/confirmation/ipo"})
ON CREATE SET n70 += {synthetic: true, process: "first-party company disclosure", recorded_at: "2026-10-14T00:00:00Z", scope: "company report of its IPO and business disclosures"}
MERGE (n71:AxLab:Report {id: "axlab/report/war"})
ON CREATE SET n71 += {synthetic: true, title: "Route disruption bulletin", category: "news", published_at: "2025-03-03T10:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/war", news_status: "confirmed"}
MERGE (n72:AxLab:EvidenceVersion {id: "axlab/evidence/war"})
ON CREATE SET n72 += {synthetic: true, full_text: "An armed conflict has disrupted Route Seven. The authority reports a closure to commercial shipping starting this morning.", sha256: "d7635f99182be9f31b65abbd27da757487b25f3de096caa603d88c271152ad8c", encoding: "UTF-8", source_available_at: "2025-03-03T10:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n73:AxLab:Passage {id: "axlab/passage/war"})
ON CREATE SET n73 += {synthetic: true, text: "An armed conflict has disrupted Route Seven. The authority reports a closure to commercial shipping starting this morning.", start: 0, end: 122}
MERGE (n74:AxLab:Expression {id: "axlab/expression/war"})
ON CREATE SET n74 += {synthetic: true, summary: "The Route Authority reports a conflict-related shipping closure.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n75:AxLab:Idea {id: "axlab/idea/war"})
ON CREATE SET n75 += {synthetic: true, summary: "The Route Authority reports a conflict-related shipping closure.", grouping_version: "fixture-v1"}
MERGE (n76:AxLab:Fact {id: "axlab/fact/war"})
ON CREATE SET n76 += {synthetic: true, scope: "reported route closure by the named authority", confirmation_rule: "illustrative external process; policy not yet selected", claim: "The authority reports route closure; company impact is not confirmed"}
MERGE (n77:AxLab:Confirmation {id: "axlab/confirmation/war"})
ON CREATE SET n77 += {synthetic: true, process: "official route closure bulletin", recorded_at: "2026-10-14T00:00:00Z", scope: "reported route closure by the named authority"}
MERGE (n78:AxLab:Report {id: "axlab/report/technology"})
ON CREATE SET n78 += {synthetic: true, title: "New chip announcement", category: "news", published_at: "2025-03-04T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/technology", news_status: "confirmed"}
MERGE (n79:AxLab:EvidenceVersion {id: "axlab/evidence/technology"})
ON CREATE SET n79 += {synthetic: true, full_text: "NovaChip announces the N1 AI chip. The company says the design reduces power use. It plans to begin production on March 10; production has not begun as of this announcement.", sha256: "be9fe99b07048d7ef8635b916258f9da81dfb5d873bb66e54899b5bce8d3311b", encoding: "UTF-8", source_available_at: "2025-03-04T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n80:AxLab:Passage {id: "axlab/passage/technology"})
ON CREATE SET n80 += {synthetic: true, text: "NovaChip announces the N1 AI chip. The company says the design reduces power use. It plans to begin production on March 10; production has not begun as of this announcement.", start: 0, end: 173}
MERGE (n81:AxLab:Expression {id: "axlab/expression/technology"})
ON CREATE SET n81 += {synthetic: true, summary: "NovaChip announces N1 and describes a future production plan.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n82:AxLab:Idea {id: "axlab/idea/technology"})
ON CREATE SET n82 += {synthetic: true, summary: "NovaChip announces N1 and describes a future production plan.", grouping_version: "fixture-v1"}
MERGE (n83:AxLab:Fact {id: "axlab/fact/technology"})
ON CREATE SET n83 += {synthetic: true, scope: "occurrence of the company technology announcement", confirmation_rule: "illustrative external process; policy not yet selected", claim: "The announcement was made; energy savings and future production are company claims"}
MERGE (n84:AxLab:Confirmation {id: "axlab/confirmation/technology"})
ON CREATE SET n84 += {synthetic: true, process: "first-party company statement", recorded_at: "2026-10-14T00:00:00Z", scope: "occurrence of the company technology announcement"}
MERGE (n85:AxLab:Report {id: "axlab/report/quake"})
ON CREATE SET n85 += {synthetic: true, title: "Earthquake bulletin", category: "news", published_at: "2025-03-04T07:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/quake", news_status: "confirmed"}
MERGE (n86:AxLab:EvidenceVersion {id: "axlab/evidence/quake"})
ON CREATE SET n86 += {synthetic: true, full_text: "An earthquake occurred at 22:00 on March 3 near the LithoWorks region. The institute confirms the earthquake occurrence and reports disruption of nearby roads. This bulletin does not assess any chip company.", sha256: "8b3de204c76fd3fc4405aa0b1fccc908470f2403005bd46d855258ca22c89659", encoding: "UTF-8", source_available_at: "2025-03-04T07:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n87:AxLab:Passage {id: "axlab/passage/quake"})
ON CREATE SET n87 += {synthetic: true, text: "An earthquake occurred at 22:00 on March 3 near the LithoWorks region. The institute confirms the earthquake occurrence and reports disruption of nearby roads. This bulletin does not assess any chip company.", start: 0, end: 207}
MERGE (n88:AxLab:Expression {id: "axlab/expression/quake"})
ON CREATE SET n88 += {synthetic: true, summary: "The Seismic Institute confirms a quake occurrence and reports road disruption.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n89:AxLab:Idea {id: "axlab/idea/quake"})
ON CREATE SET n89 += {synthetic: true, summary: "The Seismic Institute confirms a quake occurrence and reports road disruption.", grouping_version: "fixture-v1"}
MERGE (n90:AxLab:Fact {id: "axlab/fact/quake"})
ON CREATE SET n90 += {synthetic: true, scope: "earthquake occurrence at the stated place and time", confirmation_rule: "illustrative external process; policy not yet selected", claim: "Earthquake occurrence; effects on NovaChip are not confirmed"}
MERGE (n91:AxLab:Confirmation {id: "axlab/confirmation/quake"})
ON CREATE SET n91 += {synthetic: true, process: "official seismic event bulletin", recorded_at: "2026-10-14T00:00:00Z", scope: "earthquake occurrence at the stated place and time"}
MERGE (n92:AxLab:Report {id: "axlab/report/litho-context"})
ON CREATE SET n92 += {synthetic: true, title: "LithoWorks transport dependency", category: "news", published_at: "2025-03-02T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/litho-context", news_status: "confirmed"}
MERGE (n93:AxLab:EvidenceVersion {id: "axlab/evidence/litho-context"})
ON CREATE SET n93 += {synthetic: true, full_text: "LithoWorks ships lithography equipment to foundries. The equipment deliveries require shipping and road transport on Route Seven.", sha256: "82ca2b5a4e3ef158341aa44f16518e618855665e7ff86bc668bd34f8032a67dd", encoding: "UTF-8", source_available_at: "2025-03-02T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n94:AxLab:Passage {id: "axlab/passage/litho-context"})
ON CREATE SET n94 += {synthetic: true, text: "LithoWorks ships lithography equipment to foundries. The equipment deliveries require shipping and road transport on Route Seven.", start: 0, end: 129}
MERGE (n95:AxLab:Expression {id: "axlab/expression/litho-context"})
ON CREATE SET n95 += {synthetic: true, summary: "LithoWorks equipment deliveries depend on Route Seven transport.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n96:AxLab:Idea {id: "axlab/idea/litho-context"})
ON CREATE SET n96 += {synthetic: true, summary: "LithoWorks equipment deliveries depend on Route Seven transport.", grouping_version: "fixture-v1"}
MERGE (n97:AxLab:Report {id: "axlab/report/forge-context"})
ON CREATE SET n97 += {synthetic: true, title: "Manufacturing inputs", category: "news", published_at: "2025-03-03T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/forge-context", news_status: "confirmed"}
MERGE (n98:AxLab:EvidenceVersion {id: "axlab/evidence/forge-context"})
ON CREATE SET n98 += {synthetic: true, full_text: "ForgeFoundry uses lithography equipment supplied by LithoWorks for NovaChip production. ForgeFoundry also needs NovaChip chip designs before it can manufacture those chips.", sha256: "6aa3211940ff2c2d012b4a8a65a28e9f40af830c28e0892a15c09cc8388554a0", encoding: "UTF-8", source_available_at: "2025-03-05T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n99:AxLab:Passage {id: "axlab/passage/forge-context"})
ON CREATE SET n99 += {synthetic: true, text: "ForgeFoundry uses lithography equipment supplied by LithoWorks for NovaChip production. ForgeFoundry also needs NovaChip chip designs before it can manufacture those chips.", start: 0, end: 172}
MERGE (n100:AxLab:Expression {id: "axlab/expression/forge-context"})
ON CREATE SET n100 += {synthetic: true, summary: "ForgeFoundry uses LithoWorks equipment and NovaChip designs.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n101:AxLab:Idea {id: "axlab/idea/forge-context"})
ON CREATE SET n101 += {synthetic: true, summary: "ForgeFoundry uses LithoWorks equipment and NovaChip designs.", grouping_version: "fixture-v1"}
MERGE (n102:AxLab:Report {id: "axlab/report/rumour"})
ON CREATE SET n102 += {synthetic: true, title: "Possible acquisition reported", category: "news", published_at: "2025-03-05T12:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/rumour", news_status: "rumoured"}
MERGE (n103:AxLab:EvidenceVersion {id: "axlab/evidence/rumour"})
ON CREATE SET n103 += {synthetic: true, full_text: "Unnamed sources suggest NovaChip may acquire SoftPeak. No company announcement or named original information source is supplied. The transaction remains a rumour.", sha256: "fc8c65ab7dfe9685cad9ba6bae9026bf4c452c58b856d4e2a4e5838ef67aea36", encoding: "UTF-8", source_available_at: "2025-03-05T12:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n104:AxLab:Passage {id: "axlab/passage/rumour"})
ON CREATE SET n104 += {synthetic: true, text: "Unnamed sources suggest NovaChip may acquire SoftPeak. No company announcement or named original information source is supplied. The transaction remains a rumour.", start: 0, end: 162}
MERGE (n105:AxLab:Expression {id: "axlab/expression/rumour"})
ON CREATE SET n105 += {synthetic: true, summary: "NovaChip may acquire SoftPeak, according to unnamed sources.", category: "news", origin_status: "unknown", annotation_origin: "manual fixture", news_status: "rumoured"}
MERGE (n106:AxLab:Idea {id: "axlab/idea/rumour"})
ON CREATE SET n106 += {synthetic: true, summary: "NovaChip may acquire SoftPeak, according to unnamed sources.", grouping_version: "fixture-v1"}
MERGE (n107:AxLab:Report {id: "axlab/report/acquisition"})
ON CREATE SET n107 += {synthetic: true, title: "Proposed acquisition announcement", category: "news", published_at: "2025-03-06T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/acquisition", news_status: "confirmed"}
MERGE (n108:AxLab:EvidenceVersion {id: "axlab/evidence/acquisition"})
ON CREATE SET n108 += {synthetic: true, full_text: "NovaChip announces a proposed acquisition of SoftPeak for its software domain. Completion requires approval and has not occurred. The company says diversification may reduce manufacturing-disruption exposure.", sha256: "6a83e3a7844895f21323011b09a4cb3ff1b5e515eebb81c07bfab58792e419c9", encoding: "UTF-8", source_available_at: "2025-03-06T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n109:AxLab:Passage {id: "axlab/passage/acquisition"})
ON CREATE SET n109 += {synthetic: true, text: "NovaChip announces a proposed acquisition of SoftPeak for its software domain. Completion requires approval and has not occurred. The company says diversification may reduce manufacturing-disruption exposure.", start: 0, end: 208}
MERGE (n110:AxLab:Expression {id: "axlab/expression/acquisition"})
ON CREATE SET n110 += {synthetic: true, summary: "NovaChip announces a proposed SoftPeak acquisition; completion is pending.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n111:AxLab:Idea {id: "axlab/idea/acquisition"})
ON CREATE SET n111 += {synthetic: true, summary: "NovaChip announces a proposed SoftPeak acquisition; completion is pending.", grouping_version: "fixture-v1"}
MERGE (n112:AxLab:Fact {id: "axlab/fact/acquisition"})
ON CREATE SET n112 += {synthetic: true, scope: "occurrence of acquisition announcement", confirmation_rule: "illustrative external process; policy not yet selected", claim: "An acquisition was proposed; SoftPeak is not yet a subsidiary"}
MERGE (n113:AxLab:Confirmation {id: "axlab/confirmation/acquisition"})
ON CREATE SET n113 += {synthetic: true, process: "first-party company statement", recorded_at: "2026-10-14T00:00:00Z", scope: "occurrence of acquisition announcement"}
MERGE (n114:AxLab:Report {id: "axlab/report/earnings"})
ON CREATE SET n114 += {synthetic: true, title: "Quarterly earnings", category: "news", published_at: "2025-03-07T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/earnings", news_status: "confirmed"}
MERGE (n115:AxLab:EvidenceVersion {id: "axlab/evidence/earnings"})
ON CREATE SET n115 += {synthetic: true, full_text: "NovaChip reports consolidated GAAP revenue of USD 80 million for fiscal Q4 2024. This disclosure reports earnings, not a prediction of stock-price direction.", sha256: "6f092cb2605c8d149b3aa44a2684464c2872ad81d591a049a368c582cb5a96b3", encoding: "UTF-8", source_available_at: "2025-03-07T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n116:AxLab:Passage {id: "axlab/passage/earnings"})
ON CREATE SET n116 += {synthetic: true, text: "NovaChip reports consolidated GAAP revenue of USD 80 million for fiscal Q4 2024. This disclosure reports earnings, not a prediction of stock-price direction.", start: 0, end: 157}
MERGE (n117:AxLab:Expression {id: "axlab/expression/earnings"})
ON CREATE SET n117 += {synthetic: true, summary: "NovaChip reports FY2024 Q4 consolidated GAAP revenue of USD 80 million.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n118:AxLab:Idea {id: "axlab/idea/revenue80"})
ON CREATE SET n118 += {synthetic: true, summary: "NovaChip reports FY2024 Q4 consolidated GAAP revenue of USD 80 million.", grouping_version: "fixture-v1"}
MERGE (n119:AxLab:Fact {id: "axlab/fact/revenue80"})
ON CREATE SET n119 += {synthetic: true, scope: "NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD", confirmation_rule: "illustrative external process; policy not yet selected", metric: "revenue", value: 80.0, unit: "USD million", period: "FY2024Q4", basis: "GAAP", business_scope: "consolidated"}
MERGE (n120:AxLab:Confirmation {id: "axlab/confirmation/revenue80"})
ON CREATE SET n120 += {synthetic: true, process: "company quarterly financial disclosure", recorded_at: "2026-10-14T00:00:00Z", scope: "NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD"}
MERGE (n121:AxLab:Report {id: "axlab/report/audit"})
ON CREATE SET n121 += {synthetic: true, title: "Conflicting financial confirmation", category: "news", published_at: "2025-03-07T12:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/audit", news_status: "confirmed"}
MERGE (n122:AxLab:EvidenceVersion {id: "axlab/evidence/audit"})
ON CREATE SET n122 += {synthetic: true, full_text: "The Independent Audit Office reports NovaChip consolidated GAAP revenue of USD 82 million for fiscal Q4 2024. It does not identify a revision or a difference in accounting scope. The discrepancy with the company disclosure is unresolved.", sha256: "4205c40aca4ec708bb133aa66170c78b04e552100f9a3edab9426a754dbd69b6", encoding: "UTF-8", source_available_at: "2025-03-07T12:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n123:AxLab:Passage {id: "axlab/passage/audit"})
ON CREATE SET n123 += {synthetic: true, text: "The Independent Audit Office reports NovaChip consolidated GAAP revenue of USD 82 million for fiscal Q4 2024. It does not identify a revision or a difference in accounting scope. The discrepancy with the company disclosure is unresolved.", start: 0, end: 237}
MERGE (n124:AxLab:Expression {id: "axlab/expression/audit"})
ON CREATE SET n124 += {synthetic: true, summary: "Audit Office reports the same scoped revenue as USD 82 million.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n125:AxLab:Idea {id: "axlab/idea/revenue82"})
ON CREATE SET n125 += {synthetic: true, summary: "Audit Office reports the same scoped revenue as USD 82 million.", grouping_version: "fixture-v1"}
MERGE (n126:AxLab:Fact {id: "axlab/fact/revenue82"})
ON CREATE SET n126 += {synthetic: true, scope: "NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD", confirmation_rule: "illustrative external process; policy not yet selected", metric: "revenue", value: 82.0, unit: "USD million", period: "FY2024Q4", basis: "GAAP", business_scope: "consolidated"}
MERGE (n127:AxLab:Confirmation {id: "axlab/confirmation/revenue82"})
ON CREATE SET n127 += {synthetic: true, process: "independent financial confirmation record", recorded_at: "2026-10-14T00:00:00Z", scope: "NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD"}
MERGE (n128:AxLab:Conflict {id: "axlab/conflict/revenue"})
ON CREATE SET n128 += {synthetic: true, status: "on_hold", scope: "NovaChip|revenue|FY2024Q4|consolidated|GAAP|USD", first_supported_at: "2025-03-07T12:00:00Z", recorded_at: "2026-10-14T00:00:00Z", resolution: "awaiting personal review", reason: "two illustrative external confirmations give incompatible values in the same scope"}
MERGE (n129:AxLab:Report {id: "axlab/report/production"})
ON CREATE SET n129 += {synthetic: true, title: "Production starts", category: "news", published_at: "2025-03-10T09:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/production", news_status: "confirmed"}
MERGE (n130:AxLab:EvidenceVersion {id: "axlab/evidence/production"})
ON CREATE SET n130 += {synthetic: true, full_text: "NovaChip reports that N1 chip production has begun today. This later occurrence is separate from the March 4 technology announcement.", sha256: "112bc3b30b80922568eb5af872eebba4e968dc75cc2d9f5886b01e506f25f664", encoding: "UTF-8", source_available_at: "2025-03-10T09:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n131:AxLab:Passage {id: "axlab/passage/production"})
ON CREATE SET n131 += {synthetic: true, text: "NovaChip reports that N1 chip production has begun today. This later occurrence is separate from the March 4 technology announcement.", start: 0, end: 133}
MERGE (n132:AxLab:Expression {id: "axlab/expression/production"})
ON CREATE SET n132 += {synthetic: true, summary: "NovaChip reports N1 production beginning on March 10.", category: "news", origin_status: "known", annotation_origin: "manual fixture", news_status: "confirmed"}
MERGE (n133:AxLab:Idea {id: "axlab/idea/production"})
ON CREATE SET n133 += {synthetic: true, summary: "NovaChip reports N1 production beginning on March 10.", grouping_version: "fixture-v1"}
MERGE (n134:AxLab:Fact {id: "axlab/fact/production"})
ON CREATE SET n134 += {synthetic: true, scope: "the company reports production start on March 10", confirmation_rule: "illustrative external process; policy not yet selected", claim: "The company reports production beginning today"}
MERGE (n135:AxLab:Confirmation {id: "axlab/confirmation/production"})
ON CREATE SET n135 += {synthetic: true, process: "first-party production statement", recorded_at: "2026-10-14T00:00:00Z", scope: "the company reports production start on March 10"}
MERGE (n136:AxLab:Report {id: "axlab/report/up"})
ON CREATE SET n136 += {synthetic: true, title: "Personal stock view: mira", category: "opinion", published_at: "2025-03-04T15:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/up"}
MERGE (n137:AxLab:EvidenceVersion {id: "axlab/evidence/up"})
ON CREATE SET n137 += {synthetic: true, full_text: "I strongly support this view: NOVA stock will rise over the next two weeks because the N1 chip announcement improves its competitive position.", sha256: "ae012f3081816330c64e23dcdb88d8304c496ca57967c0d9574aef0b68337602", encoding: "UTF-8", source_available_at: "2025-03-04T15:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n138:AxLab:Passage {id: "axlab/passage/up"})
ON CREATE SET n138 += {synthetic: true, text: "I strongly support this view: NOVA stock will rise over the next two weeks because the N1 chip announcement improves its competitive position.", start: 0, end: 142}
MERGE (n139:AxLab:Expression {id: "axlab/expression/up"})
ON CREATE SET n139 += {synthetic: true, summary: "NOVA UP over two weeks because N1 improves competition.", category: "opinion", origin_status: "known", annotation_origin: "manual fixture", agreement_strength: "strong", strength_basis: "source wording in fictional passage"}
MERGE (n140:AxLab:Idea {id: "axlab/idea/up-two-weeks"})
ON CREATE SET n140 += {synthetic: true, summary: "NOVA UP over two weeks because N1 improves competition.", grouping_version: "fixture-v1"}
MERGE (n141:AxLab:Judgment {id: "axlab/judgment/up"})
ON CREATE SET n141 += {synthetic: true, direction: "UP", target: "stock-price movement", horizon_phrase: "next two weeks", horizon_origin: "source_explicit", annotation_origin: "manual fixture", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n142:AxLab:Report {id: "axlab/report/up-anonymous"})
ON CREATE SET n142 += {synthetic: true, title: "Personal stock view: anon1", category: "opinion", published_at: "2025-03-04T15:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/up-anonymous"}
MERGE (n143:AxLab:EvidenceVersion {id: "axlab/evidence/up-anonymous"})
ON CREATE SET n143 += {synthetic: true, full_text: "My own view is that NOVA stock will rise over the next two weeks because the N1 chip announcement improves its competitive position.", sha256: "99f6c61ffa5cb0db227e6ef8814d3e1e084a8d6e98a297edffcc98a52517a099", encoding: "UTF-8", source_available_at: "2025-03-04T15:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n144:AxLab:Passage {id: "axlab/passage/up-anonymous"})
ON CREATE SET n144 += {synthetic: true, text: "My own view is that NOVA stock will rise over the next two weeks because the N1 chip announcement improves its competitive position.", start: 0, end: 132}
MERGE (n145:AxLab:Expression {id: "axlab/expression/up-anonymous"})
ON CREATE SET n145 += {synthetic: true, summary: "NOVA UP over two weeks because N1 improves competition.", category: "opinion", origin_status: "known", annotation_origin: "manual fixture"}
MERGE (n146:AxLab:Judgment {id: "axlab/judgment/up-anonymous"})
ON CREATE SET n146 += {synthetic: true, direction: "UP", target: "stock-price movement", horizon_phrase: "next two weeks", horizon_origin: "source_explicit", annotation_origin: "manual fixture", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n147:AxLab:Report {id: "axlab/report/down"})
ON CREATE SET n147 += {synthetic: true, title: "Personal stock view: anon2", category: "opinion", published_at: "2025-03-04T15:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/down"}
MERGE (n148:AxLab:EvidenceVersion {id: "axlab/evidence/down"})
ON CREATE SET n148 += {synthetic: true, full_text: "I tentatively support a bearish view: NOVA stock will fall over the next two weeks because shipping disruption threatens manufacturing deliveries.", sha256: "a7299f24b4b2cec275d0a0f2080e970bccece72e606ef03c1ae2d9026c5c59fd", encoding: "UTF-8", source_available_at: "2025-03-04T15:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n149:AxLab:Passage {id: "axlab/passage/down"})
ON CREATE SET n149 += {synthetic: true, text: "I tentatively support a bearish view: NOVA stock will fall over the next two weeks because shipping disruption threatens manufacturing deliveries.", start: 0, end: 146}
MERGE (n150:AxLab:Expression {id: "axlab/expression/down"})
ON CREATE SET n150 += {synthetic: true, summary: "NOVA DOWN over two weeks because transport disruption threatens deliveries.", category: "opinion", origin_status: "known", annotation_origin: "manual fixture", agreement_strength: "weak", strength_basis: "source wording in fictional passage"}
MERGE (n151:AxLab:Idea {id: "axlab/idea/down-two-weeks"})
ON CREATE SET n151 += {synthetic: true, summary: "NOVA DOWN over two weeks because transport disruption threatens deliveries.", grouping_version: "fixture-v1"}
MERGE (n152:AxLab:Judgment {id: "axlab/judgment/down"})
ON CREATE SET n152 += {synthetic: true, direction: "DOWN", target: "stock-price movement", horizon_phrase: "next two weeks", horizon_origin: "source_explicit", annotation_origin: "manual fixture", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n153:AxLab:Report {id: "axlab/report/near"})
ON CREATE SET n153 += {synthetic: true, title: "Personal stock view: mira", category: "opinion", published_at: "2025-03-05T15:00:00Z", collected_at: "2026-10-14T00:00:00Z", url: "https://example.invalid/axthena/near"}
MERGE (n154:AxLab:EvidenceVersion {id: "axlab/evidence/near"})
ON CREATE SET n154 += {synthetic: true, full_text: "My view is that NOVA stock will rise because demand is strong. I give no timing for this stock-price expectation.", sha256: "ac74bf0c0f6b4423b77e7628ffb9b709b71d7440d2840bef3358cfe2069dca77", encoding: "UTF-8", source_available_at: "2025-03-05T15:00:00Z", availability_basis: "synthetic timestamp supplied by fixture", captured_at: "2026-10-14T00:00:00Z", version: "fixture-v1"}
MERGE (n155:AxLab:Passage {id: "axlab/passage/near"})
ON CREATE SET n155 += {synthetic: true, text: "My view is that NOVA stock will rise because demand is strong. I give no timing for this stock-price expectation.", start: 0, end: 113}
MERGE (n156:AxLab:Expression {id: "axlab/expression/near"})
ON CREATE SET n156 += {synthetic: true, summary: "NOVA UP with unspecified source timing because demand is strong.", category: "opinion", origin_status: "known", annotation_origin: "manual fixture", domain_status: "unspecified in source"}
MERGE (n157:AxLab:Idea {id: "axlab/idea/up-unspecified"})
ON CREATE SET n157 += {synthetic: true, summary: "NOVA UP with unspecified source timing because demand is strong.", grouping_version: "fixture-v1"}
MERGE (n158:AxLab:Judgment {id: "axlab/judgment/near"})
ON CREATE SET n158 += {synthetic: true, direction: "UP", target: "stock-price movement", horizon_phrase: "no timing stated", horizon_origin: "configured_default", annotation_origin: "manual fixture", recorded_at: "2026-10-14T00:00:00Z", horizon_bucket: "near_term", default_policy: "illustrative near-term label; numerical duration not selected"}
MERGE (n159:AxLab:Dependency {id: "axlab/dependency/nova-forge"})
ON CREATE SET n159 += {synthetic: true, kind: "manufacturing_supplier", modality: "source_reported", available_at: "2025-03-03T09:30:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n160:AxLab:Dependency {id: "axlab/dependency/forge-litho"})
ON CREATE SET n160 += {synthetic: true, kind: "equipment_supplier", modality: "source_reported", available_at: "2025-03-05T09:00:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n161:AxLab:Dependency {id: "axlab/dependency/litho-route"})
ON CREATE SET n161 += {synthetic: true, kind: "transport_input", modality: "source_reported", available_at: "2025-03-02T09:00:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n162:AxLab:Dependency {id: "axlab/dependency/forge-design"})
ON CREATE SET n162 += {synthetic: true, kind: "customer_design_input", modality: "source_reported", available_at: "2025-03-05T09:00:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n163:AxLab:Dependency {id: "axlab/dependency/chip-power"})
ON CREATE SET n163 += {synthetic: true, kind: "energy_input", modality: "source_reported", available_at: "2025-03-03T09:30:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n164:AxLab:Dependency {id: "axlab/dependency/software-power"})
ON CREATE SET n164 += {synthetic: true, kind: "energy_input", modality: "source_reported", available_at: "2025-03-03T09:30:00Z", recorded_at: "2026-10-14T00:00:00Z"}
MERGE (n165:AxLab:Interpretation {id: "axlab/interpretation/quake-nova"})
ON CREATE SET n165 += {synthetic: true, summary: "Quake-related transport disruption could affect equipment deliveries and indirectly NovaChip manufacturing.", kind: "potential_indirect_effect", status: "hypothesis", recorded_at: "2026-10-14T00:00:00Z", causal_stock_direction_established: false}
MERGE (n166:AxLab:View {id: "axlab/view/company"})
ON CREATE SET n166 += {synthetic: true, name: "company selected-source view", version: "demo-v1", recorded_at: "2026-10-14T00:00:00Z", interpretation_policy: "source-grounded demo; no national/platform representativeness claim"}
MERGE (n167:AxLab:View {id: "axlab/view/media"})
ON CREATE SET n167 += {synthetic: true, name: "media selected-source view", version: "demo-v1", recorded_at: "2026-10-14T00:00:00Z", interpretation_policy: "source-grounded demo; no national/platform representativeness claim"}
MERGE (n168:AxLab:View {id: "axlab/view/mixed"})
ON CREATE SET n168 += {synthetic: true, name: "mixed selected-source view", version: "demo-v1", recorded_at: "2026-10-14T00:00:00Z", interpretation_policy: "source-grounded demo; no national/platform representativeness claim"}
MERGE (n169:AxLab:PriceBar {id: "axlab/bar/2025-03-03"})
ON CREATE SET n169 += {synthetic: true, date: "2025-03-03", open: 100.0, high: 102.0, low: 99.0, close: 101.0, volume: 100000, interval: "1 trading day", value_status: "dummy", origin: "fictional market-data fixture", available_at: "2025-03-03T21:00:00Z"}
MERGE (n170:AxLab:PriceBar {id: "axlab/bar/2025-03-04"})
ON CREATE SET n170 += {synthetic: true, date: "2025-03-04", open: 101.0, high: 104.0, low: 100.0, close: 103.0, volume: 120000, interval: "1 trading day", value_status: "dummy", origin: "fictional market-data fixture", available_at: "2025-03-04T21:00:00Z"}
MERGE (n171:AxLab:PriceBar {id: "axlab/bar/2025-03-05"})
ON CREATE SET n171 += {synthetic: true, date: "2025-03-05", open: 103.0, high: 104.0, low: 97.0, close: 98.0, volume: 160000, interval: "1 trading day", value_status: "dummy", origin: "fictional market-data fixture", available_at: "2025-03-05T21:00:00Z"}
MERGE (n172:AxLab:PriceBar {id: "axlab/bar/2025-03-06"})
ON CREATE SET n172 += {synthetic: true, date: "2025-03-06", open: 98.0, high: 101.0, low: 97.0, close: 100.0, volume: 110000, interval: "1 trading day", value_status: "dummy", origin: "fictional market-data fixture", available_at: "2025-03-06T21:00:00Z"}
MERGE (n173:AxLab:PriceBar {id: "axlab/bar/2025-03-07"})
ON CREATE SET n173 += {synthetic: true, date: "2025-03-07", open: 100.0, high: 104.0, low: 99.0, close: 102.0, volume: 150000, interval: "1 trading day", value_status: "dummy", origin: "fictional market-data fixture", available_at: "2025-03-07T21:00:00Z"}
MERGE (n11)-[:POINTS_TO {association: "issuer", context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n0)
MERGE (n11)-[:POINTS_TO {association: "subsidiary_contribution", context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n1)
MERGE (n0)-[:OWNS {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n1)
MERGE (n0)-[:OPERATES_IN {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n12)
MERGE (n0)-[:OPERATES_IN {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n13)
MERGE (n1)-[:OPERATES_IN {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n13)
MERGE (n12)-[:HAS_PROCESS {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n14)
MERGE (n13)-[:HAS_PROCESS {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n16)
MERGE (n2)-[:RUNS_PROCESS {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n15)
MERGE (n15)-[:USES_RESOURCE {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n17)
MERGE (n15)-[:USES_RESOURCE {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n20)
MERGE (n16)-[:USES_RESOURCE {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n18)
MERGE (n0)-[:COMPETES_WITH {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n4)
MERGE (n14)-[:PRODUCES {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n21)
MERGE (n15)-[:PRODUCES {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n21)
MERGE (n16)-[:PRODUCES {context_id: "axlab/context/world", available_at: "2025-03-01T08:00:00Z"}]->(n22)
MERGE (n24)-[:REPRESENTS {basis: "fictional context"}]->(n0)
MERGE (n25)-[:HAS_WEIGHT]->(n28)
MERGE (n26)-[:HAS_WEIGHT]->(n29)
MERGE (n27)-[:HAS_WEIGHT]->(n30)
MERGE (n31)-[:PUBLISHED_BY]->(n0)
MERGE (n32)-[:PUBLISHED_BY]->(n2)
MERGE (n33)-[:PUBLISHED_BY]->(n3)
MERGE (n34)-[:PUBLISHED_BY]->(n6)
MERGE (n35)-[:PUBLISHED_BY]->(n7)
MERGE (n36)-[:PUBLISHED_BY]->(n8)
MERGE (n37)-[:PUBLISHED_BY]->(n9)
MERGE (n38)-[:PUBLISHED_BY]->(n10)
MERGE (n40)-[:CONCERNS]->(n0)
MERGE (n40)-[:CONCERNS]->(n2)
MERGE (n41)-[:CONCERNS]->(n11)
MERGE (n42)-[:CONCERNS]->(n19)
MERGE (n43)-[:CONCERNS]->(n12)
MERGE (n44)-[:CONCERNS]->(n3)
MERGE (n44)-[:CONCERNS]->(n19)
MERGE (n45)-[:CONCERNS]->(n0)
MERGE (n45)-[:CONCERNS]->(n5)
MERGE (n46)-[:CONCERNS]->(n0)
MERGE (n47)-[:CONCERNS]->(n12)
MERGE (n47)-[:FOLLOWS_ANNOUNCEMENT {available_at: "2025-03-10T09:00:00Z"}]->(n43)
MERGE (n49)-[:PUBLISHED_IN]->(n31)
MERGE (n49)-[:HAS_EVIDENCE]->(n50)
MERGE (n49)-[:AUTHORED_BY]->(n24)
MERGE (n49)-[:CONTAINS]->(n52)
MERGE (n52)-[:SUPPORTED_BY]->(n51)
MERGE (n51)-[:PART_OF]->(n50)
MERGE (n52)-[:EXPRESSES]->(n53)
MERGE (n52)-[:DERIVED_IN]->(n48)
MERGE (n52)-[:ABOUT]->(n40)
MERGE (n52)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n52)-[:EXPRESSED_BY]->(n24)
MERGE (n54)-[:CONFIRMED_BY]->(n55)
MERGE (n55)-[:SUPPORTED_BY]->(n51)
MERGE (n55)-[:ASSESSES_EXPRESSION]->(n52)
MERGE (n54)-[:SOURCED_IN]->(n52)
MERGE (n56)-[:PUBLISHED_IN]->(n34)
MERGE (n56)-[:HAS_EVIDENCE]->(n57)
MERGE (n56)-[:CONTAINS]->(n59)
MERGE (n59)-[:SUPPORTED_BY]->(n58)
MERGE (n58)-[:PART_OF]->(n57)
MERGE (n59)-[:EXPRESSES]->(n53)
MERGE (n59)-[:DERIVED_IN]->(n48)
MERGE (n59)-[:ABOUT]->(n40)
MERGE (n59)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n60)-[:PUBLISHED_IN]->(n35)
MERGE (n60)-[:HAS_EVIDENCE]->(n61)
MERGE (n60)-[:CONTAINS]->(n63)
MERGE (n63)-[:SUPPORTED_BY]->(n62)
MERGE (n62)-[:PART_OF]->(n61)
MERGE (n63)-[:EXPRESSES]->(n53)
MERGE (n63)-[:DERIVED_IN]->(n48)
MERGE (n63)-[:ABOUT]->(n40)
MERGE (n63)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n60)-[:REPRODUCES {basis: "copying explicitly supplied in synthetic fixture"}]->(n49)
MERGE (n64)-[:PUBLISHED_IN]->(n31)
MERGE (n64)-[:HAS_EVIDENCE]->(n65)
MERGE (n64)-[:CONTAINS]->(n67)
MERGE (n67)-[:SUPPORTED_BY]->(n66)
MERGE (n66)-[:PART_OF]->(n65)
MERGE (n67)-[:EXPRESSES]->(n68)
MERGE (n67)-[:DERIVED_IN]->(n48)
MERGE (n67)-[:ABOUT]->(n41)
MERGE (n67)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n69)-[:CONFIRMED_BY]->(n70)
MERGE (n70)-[:SUPPORTED_BY]->(n66)
MERGE (n70)-[:ASSESSES_EXPRESSION]->(n67)
MERGE (n69)-[:SOURCED_IN]->(n67)
MERGE (n71)-[:PUBLISHED_IN]->(n36)
MERGE (n71)-[:HAS_EVIDENCE]->(n72)
MERGE (n71)-[:CONTAINS]->(n74)
MERGE (n74)-[:SUPPORTED_BY]->(n73)
MERGE (n73)-[:PART_OF]->(n72)
MERGE (n74)-[:EXPRESSES]->(n75)
MERGE (n74)-[:DERIVED_IN]->(n48)
MERGE (n74)-[:ABOUT]->(n42)
MERGE (n74)-[:INFORMATION_ORIGIN]->(n8)
MERGE (n76)-[:CONFIRMED_BY]->(n77)
MERGE (n77)-[:SUPPORTED_BY]->(n73)
MERGE (n77)-[:ASSESSES_EXPRESSION]->(n74)
MERGE (n76)-[:SOURCED_IN]->(n74)
MERGE (n78)-[:PUBLISHED_IN]->(n31)
MERGE (n78)-[:HAS_EVIDENCE]->(n79)
MERGE (n78)-[:CONTAINS]->(n81)
MERGE (n81)-[:SUPPORTED_BY]->(n80)
MERGE (n80)-[:PART_OF]->(n79)
MERGE (n81)-[:EXPRESSES]->(n82)
MERGE (n81)-[:DERIVED_IN]->(n48)
MERGE (n81)-[:ABOUT]->(n43)
MERGE (n81)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n83)-[:CONFIRMED_BY]->(n84)
MERGE (n84)-[:SUPPORTED_BY]->(n80)
MERGE (n84)-[:ASSESSES_EXPRESSION]->(n81)
MERGE (n83)-[:SOURCED_IN]->(n81)
MERGE (n85)-[:PUBLISHED_IN]->(n37)
MERGE (n85)-[:HAS_EVIDENCE]->(n86)
MERGE (n85)-[:CONTAINS]->(n88)
MERGE (n88)-[:SUPPORTED_BY]->(n87)
MERGE (n87)-[:PART_OF]->(n86)
MERGE (n88)-[:EXPRESSES]->(n89)
MERGE (n88)-[:DERIVED_IN]->(n48)
MERGE (n88)-[:ABOUT]->(n44)
MERGE (n88)-[:INFORMATION_ORIGIN]->(n9)
MERGE (n90)-[:CONFIRMED_BY]->(n91)
MERGE (n91)-[:SUPPORTED_BY]->(n87)
MERGE (n91)-[:ASSESSES_EXPRESSION]->(n88)
MERGE (n90)-[:SOURCED_IN]->(n88)
MERGE (n92)-[:PUBLISHED_IN]->(n33)
MERGE (n92)-[:HAS_EVIDENCE]->(n93)
MERGE (n92)-[:CONTAINS]->(n95)
MERGE (n95)-[:SUPPORTED_BY]->(n94)
MERGE (n94)-[:PART_OF]->(n93)
MERGE (n95)-[:EXPRESSES]->(n96)
MERGE (n95)-[:DERIVED_IN]->(n48)
MERGE (n95)-[:ABOUT]->(n3)
MERGE (n95)-[:INFORMATION_ORIGIN]->(n3)
MERGE (n97)-[:PUBLISHED_IN]->(n32)
MERGE (n97)-[:HAS_EVIDENCE]->(n98)
MERGE (n97)-[:CONTAINS]->(n100)
MERGE (n100)-[:SUPPORTED_BY]->(n99)
MERGE (n99)-[:PART_OF]->(n98)
MERGE (n100)-[:EXPRESSES]->(n101)
MERGE (n100)-[:DERIVED_IN]->(n48)
MERGE (n100)-[:ABOUT]->(n2)
MERGE (n100)-[:INFORMATION_ORIGIN]->(n2)
MERGE (n102)-[:PUBLISHED_IN]->(n35)
MERGE (n102)-[:HAS_EVIDENCE]->(n103)
MERGE (n102)-[:CONTAINS]->(n105)
MERGE (n105)-[:SUPPORTED_BY]->(n104)
MERGE (n104)-[:PART_OF]->(n103)
MERGE (n105)-[:EXPRESSES]->(n106)
MERGE (n105)-[:DERIVED_IN]->(n48)
MERGE (n105)-[:ABOUT]->(n0)
MERGE (n107)-[:PUBLISHED_IN]->(n31)
MERGE (n107)-[:HAS_EVIDENCE]->(n108)
MERGE (n107)-[:CONTAINS]->(n110)
MERGE (n110)-[:SUPPORTED_BY]->(n109)
MERGE (n109)-[:PART_OF]->(n108)
MERGE (n110)-[:EXPRESSES]->(n111)
MERGE (n110)-[:DERIVED_IN]->(n48)
MERGE (n110)-[:ABOUT]->(n45)
MERGE (n110)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n112)-[:CONFIRMED_BY]->(n113)
MERGE (n113)-[:SUPPORTED_BY]->(n109)
MERGE (n113)-[:ASSESSES_EXPRESSION]->(n110)
MERGE (n112)-[:SOURCED_IN]->(n110)
MERGE (n114)-[:PUBLISHED_IN]->(n31)
MERGE (n114)-[:HAS_EVIDENCE]->(n115)
MERGE (n114)-[:CONTAINS]->(n117)
MERGE (n117)-[:SUPPORTED_BY]->(n116)
MERGE (n116)-[:PART_OF]->(n115)
MERGE (n117)-[:EXPRESSES]->(n118)
MERGE (n117)-[:DERIVED_IN]->(n48)
MERGE (n117)-[:ABOUT]->(n46)
MERGE (n117)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n119)-[:CONFIRMED_BY]->(n120)
MERGE (n120)-[:SUPPORTED_BY]->(n116)
MERGE (n120)-[:ASSESSES_EXPRESSION]->(n117)
MERGE (n119)-[:SOURCED_IN]->(n117)
MERGE (n121)-[:PUBLISHED_IN]->(n38)
MERGE (n121)-[:HAS_EVIDENCE]->(n122)
MERGE (n121)-[:CONTAINS]->(n124)
MERGE (n124)-[:SUPPORTED_BY]->(n123)
MERGE (n123)-[:PART_OF]->(n122)
MERGE (n124)-[:EXPRESSES]->(n125)
MERGE (n124)-[:DERIVED_IN]->(n48)
MERGE (n124)-[:ABOUT]->(n46)
MERGE (n124)-[:INFORMATION_ORIGIN]->(n10)
MERGE (n126)-[:CONFIRMED_BY]->(n127)
MERGE (n127)-[:SUPPORTED_BY]->(n123)
MERGE (n127)-[:ASSESSES_EXPRESSION]->(n124)
MERGE (n126)-[:SOURCED_IN]->(n124)
MERGE (n128)-[:INVOLVES]->(n119)
MERGE (n128)-[:INVOLVES]->(n126)
MERGE (n128)-[:SUPPORTED_BY]->(n120)
MERGE (n128)-[:SUPPORTED_BY]->(n127)
MERGE (n129)-[:PUBLISHED_IN]->(n31)
MERGE (n129)-[:HAS_EVIDENCE]->(n130)
MERGE (n129)-[:CONTAINS]->(n132)
MERGE (n132)-[:SUPPORTED_BY]->(n131)
MERGE (n131)-[:PART_OF]->(n130)
MERGE (n132)-[:EXPRESSES]->(n133)
MERGE (n132)-[:DERIVED_IN]->(n48)
MERGE (n132)-[:ABOUT]->(n47)
MERGE (n132)-[:INFORMATION_ORIGIN]->(n0)
MERGE (n134)-[:CONFIRMED_BY]->(n135)
MERGE (n135)-[:SUPPORTED_BY]->(n131)
MERGE (n135)-[:ASSESSES_EXPRESSION]->(n132)
MERGE (n134)-[:SOURCED_IN]->(n132)
MERGE (n136)-[:PUBLISHED_IN]->(n39)
MERGE (n136)-[:HAS_EVIDENCE]->(n137)
MERGE (n136)-[:AUTHORED_BY]->(n25)
MERGE (n136)-[:CONTAINS]->(n139)
MERGE (n139)-[:SUPPORTED_BY]->(n138)
MERGE (n138)-[:PART_OF]->(n137)
MERGE (n139)-[:EXPRESSES]->(n140)
MERGE (n139)-[:DERIVED_IN]->(n48)
MERGE (n139)-[:ABOUT]->(n0)
MERGE (n139)-[:INFORMATION_ORIGIN]->(n25)
MERGE (n139)-[:EXPRESSED_BY]->(n25)
MERGE (n139)-[:HAS_JUDGMENT]->(n141)
MERGE (n141)-[:TARGETS]->(n11)
MERGE (n141)-[:SUPPORTED_BY]->(n138)
MERGE (n141)-[:DERIVED_IN]->(n48)
MERGE (n142)-[:PUBLISHED_IN]->(n39)
MERGE (n142)-[:HAS_EVIDENCE]->(n143)
MERGE (n142)-[:AUTHORED_BY]->(n26)
MERGE (n142)-[:CONTAINS]->(n145)
MERGE (n145)-[:SUPPORTED_BY]->(n144)
MERGE (n144)-[:PART_OF]->(n143)
MERGE (n145)-[:EXPRESSES]->(n140)
MERGE (n145)-[:DERIVED_IN]->(n48)
MERGE (n145)-[:ABOUT]->(n0)
MERGE (n145)-[:INFORMATION_ORIGIN]->(n26)
MERGE (n145)-[:EXPRESSED_BY]->(n26)
MERGE (n145)-[:HAS_JUDGMENT]->(n146)
MERGE (n146)-[:TARGETS]->(n11)
MERGE (n146)-[:SUPPORTED_BY]->(n144)
MERGE (n146)-[:DERIVED_IN]->(n48)
MERGE (n147)-[:PUBLISHED_IN]->(n39)
MERGE (n147)-[:HAS_EVIDENCE]->(n148)
MERGE (n147)-[:AUTHORED_BY]->(n27)
MERGE (n147)-[:CONTAINS]->(n150)
MERGE (n150)-[:SUPPORTED_BY]->(n149)
MERGE (n149)-[:PART_OF]->(n148)
MERGE (n150)-[:EXPRESSES]->(n151)
MERGE (n150)-[:DERIVED_IN]->(n48)
MERGE (n150)-[:ABOUT]->(n0)
MERGE (n150)-[:INFORMATION_ORIGIN]->(n27)
MERGE (n150)-[:EXPRESSED_BY]->(n27)
MERGE (n150)-[:HAS_JUDGMENT]->(n152)
MERGE (n152)-[:TARGETS]->(n11)
MERGE (n152)-[:SUPPORTED_BY]->(n149)
MERGE (n152)-[:DERIVED_IN]->(n48)
MERGE (n153)-[:PUBLISHED_IN]->(n39)
MERGE (n153)-[:HAS_EVIDENCE]->(n154)
MERGE (n153)-[:AUTHORED_BY]->(n25)
MERGE (n153)-[:CONTAINS]->(n156)
MERGE (n156)-[:SUPPORTED_BY]->(n155)
MERGE (n155)-[:PART_OF]->(n154)
MERGE (n156)-[:EXPRESSES]->(n157)
MERGE (n156)-[:DERIVED_IN]->(n48)
MERGE (n156)-[:ABOUT]->(n0)
MERGE (n156)-[:INFORMATION_ORIGIN]->(n25)
MERGE (n156)-[:EXPRESSED_BY]->(n25)
MERGE (n156)-[:HAS_JUDGMENT]->(n158)
MERGE (n158)-[:TARGETS]->(n11)
MERGE (n158)-[:SUPPORTED_BY]->(n155)
MERGE (n158)-[:DERIVED_IN]->(n48)
MERGE (n139)-[:ABOUT_DOMAIN]->(n12)
MERGE (n145)-[:ABOUT_DOMAIN]->(n12)
MERGE (n150)-[:ABOUT_DOMAIN]->(n12)
MERGE (n139)-[:REFERS_TO]->(n43)
MERGE (n145)-[:REFERS_TO]->(n43)
MERGE (n150)-[:REFERS_TO]->(n42)
MERGE (n159)-[:SUBJECT]->(n12)
MERGE (n159)-[:OBJECT]->(n2)
MERGE (n159)-[:SUPPORTED_BY]->(n67)
MERGE (n12)-[:DEPENDS_ON {assertion_id: "axlab/dependency/nova-forge", available_at: "2025-03-03T09:30:00Z", kind: "manufacturing_supplier"}]->(n2)
MERGE (n160)-[:SUBJECT]->(n2)
MERGE (n160)-[:OBJECT]->(n3)
MERGE (n160)-[:SUPPORTED_BY]->(n100)
MERGE (n2)-[:DEPENDS_ON {assertion_id: "axlab/dependency/forge-litho", available_at: "2025-03-05T09:00:00Z", kind: "equipment_supplier"}]->(n3)
MERGE (n161)-[:SUBJECT]->(n3)
MERGE (n161)-[:OBJECT]->(n19)
MERGE (n161)-[:SUPPORTED_BY]->(n95)
MERGE (n3)-[:DEPENDS_ON {assertion_id: "axlab/dependency/litho-route", available_at: "2025-03-02T09:00:00Z", kind: "transport_input"}]->(n19)
MERGE (n162)-[:SUBJECT]->(n2)
MERGE (n162)-[:OBJECT]->(n12)
MERGE (n162)-[:SUPPORTED_BY]->(n100)
MERGE (n2)-[:DEPENDS_ON {assertion_id: "axlab/dependency/forge-design", available_at: "2025-03-05T09:00:00Z", kind: "customer_design_input"}]->(n12)
MERGE (n163)-[:SUBJECT]->(n12)
MERGE (n163)-[:OBJECT]->(n18)
MERGE (n163)-[:SUPPORTED_BY]->(n67)
MERGE (n12)-[:DEPENDS_ON {assertion_id: "axlab/dependency/chip-power", available_at: "2025-03-03T09:30:00Z", kind: "energy_input"}]->(n18)
MERGE (n164)-[:SUBJECT]->(n13)
MERGE (n164)-[:OBJECT]->(n18)
MERGE (n164)-[:SUPPORTED_BY]->(n67)
MERGE (n13)-[:DEPENDS_ON {assertion_id: "axlab/dependency/software-power", available_at: "2025-03-03T09:30:00Z", kind: "energy_input"}]->(n18)
MERGE (n165)-[:ABOUT]->(n0)
MERGE (n165)-[:FROM_EVENT]->(n44)
MERGE (n165)-[:SUPPORTED_BY]->(n88)
MERGE (n165)-[:REQUIRES]->(n159)
MERGE (n165)-[:REQUIRES]->(n160)
MERGE (n165)-[:REQUIRES]->(n161)
MERGE (n166)-[:INCLUDES_SOURCE]->(n31)
MERGE (n166)-[:INCLUDES_SOURCE]->(n32)
MERGE (n166)-[:INCLUDES_SOURCE]->(n33)
MERGE (n167)-[:INCLUDES_SOURCE]->(n34)
MERGE (n167)-[:INCLUDES_SOURCE]->(n35)
MERGE (n168)-[:INCLUDES_SOURCE]->(n31)
MERGE (n168)-[:INCLUDES_SOURCE]->(n32)
MERGE (n168)-[:INCLUDES_SOURCE]->(n33)
MERGE (n168)-[:INCLUDES_SOURCE]->(n34)
MERGE (n168)-[:INCLUDES_SOURCE]->(n35)
MERGE (n168)-[:INCLUDES_SOURCE]->(n36)
MERGE (n168)-[:INCLUDES_SOURCE]->(n37)
MERGE (n168)-[:INCLUDES_SOURCE]->(n38)
MERGE (n168)-[:INCLUDES_SOURCE]->(n39)
MERGE (n168)-[:INCLUDES_INTERPRETATION]->(n165)
MERGE (n11)-[:HAS_PRICE_BAR]->(n169)
MERGE (n11)-[:HAS_PRICE_BAR]->(n170)
MERGE (n11)-[:HAS_PRICE_BAR]->(n171)
MERGE (n11)-[:HAS_PRICE_BAR]->(n172)
MERGE (n11)-[:HAS_PRICE_BAR]->(n173)
RETURN "Axthena model lab loaded. Run Q0 to verify counts." AS message;
