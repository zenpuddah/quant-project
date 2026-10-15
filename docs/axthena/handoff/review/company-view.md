# Company, subsidiary and stock-judgment review

Accepted display convention (ENG-045): **company orange**, **subsidiary yellow**, **UP green**, **DOWN red**.

`company-view.cypher` is an optional review helper for the fictional `AxHardReview` graph. It selects O1/NovaChips, its direct subsidiaries, its stock and judgments with Idea/source/passages. Direct subsidiary subjects are included. It writes only presentation labels (`ViewCompany`, `ViewSubsidiary`, `ViewUp`, `ViewDown`) to the selected fixture nodes; it does not delete data or run here.

In the graph tool, assign the requested colours to those four display labels and use `name` for organisation captions. The exact style control depends on the installed UI; this file does not promise a particular icon or fullscreen control. If several labels compete for style, select the display label's style in that tool.

The Idea summary and supporting Passage quote show the source's reason and qualifications. This is not a new reason-node subsystem. Green/red denotes the forecast in the source, not an observed return. The query spans multiple reports/windows; inspect each judgment's dates and material conditions before comparing them.

This helper has not been parsed or executed against Neo4j in this handoff. The original graph loader and experiment artifacts remain unchanged in `sources/`. Display labels are view-relative: a company can be a subsidiary in another selected neighbourhood.
