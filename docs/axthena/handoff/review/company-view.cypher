// Optional fictional AxHardReview helper. Adds presentation labels only.
// Not executed in this handoff. Select label colours in your graph tool.
MATCH (company:AxHardReview:Organisation {org_id: 'O1'})
OPTIONAL MATCH (child:AxHardReview:Organisation)-[:SUBSIDIARY_OF]->(company)
WITH company, collect(child) AS subsidiaries
MATCH listing=(stock:AxHardReview:Stock)-[:ISSUED_BY]->(company)
MATCH forecast=(expression:AxHardReview:Expression)-[:HAS_JUDGMENT]->(judgment:AxHardReview:Judgment)-[:TARGETS]->(stock)
MATCH explanation=(expression)-[:EXPRESSES]->(idea:AxHardReview:Idea)
MATCH subject=(idea)-[:CONCERNS]->(concerned:AxHardReview:Organisation)
WHERE concerned = company OR concerned IN subsidiaries
OPTIONAL MATCH family=(child:AxHardReview:Organisation)-[:SUBSIDIARY_OF]->(company)
OPTIONAL MATCH evidence=(expression)-[:SUPPORTED_BY]->(:AxHardReview:Passage)
OPTIONAL MATCH attribution=(expression)-[:ATTRIBUTED_TO]->(:AxHardReview:Source)
OPTIONAL MATCH publication=(:AxHardReview:Report)-[:CONTAINS]->(expression)
SET company:ViewCompany
FOREACH (n IN subsidiaries | SET n:ViewSubsidiary)
REMOVE judgment:ViewUp:ViewDown
FOREACH (n IN CASE WHEN judgment.direction = 'UP' THEN [judgment] ELSE [] END | SET n:ViewUp)
FOREACH (n IN CASE WHEN judgment.direction = 'DOWN' THEN [judgment] ELSE [] END | SET n:ViewDown)
RETURN family, listing, forecast, explanation, subject, evidence, attribution, publication;
