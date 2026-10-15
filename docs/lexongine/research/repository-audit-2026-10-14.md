# Repository coherence audit — 2026-10-14

Evidence baseline: zenpuddah/quant-project, remote implementation/data-integrity-2026-10-03 at f75cd3c179f3b070f9a85c054ec3704b89f4cb69; main95993a80412ec52dc17b5cfd4b5ad6d9771f2fe5. Recursive tree was complete; all25 Markdown blobs were fetched. These were evidence snapshots, not a checkout. No product tests were rerun and no owner-local/unpushed context was available.

## Corrections incorporated

- Added current three-project routing, scoped Lexongine authority and stable context. Preserved existing Qaedalus document paths.
- Qualified old ingestion XML/general-cache deferrals so they neither prohibit Lexongine's accepted frontend/result store nor authorize ingestion caching.
- Marked dated stop gates/status summaries as historical and corrected current published/unmerged integrity status without rewriting original test provenance.
- Consolidated appended gap/source/host requirements into their owning specifications and the same twelve task cards.
- Made input/observation missing policy explicit in XML; added a point-event timing reference case; made gap coverage/manifest and canonical wire fields explicit.
- Distinguished dependency-free callback probes, actual MarketDataReader tests requiring Arrow and persisted replay integration requiring Arrow/Parquet.
- Separated accepted/delegated/deferred decisions, proposed interfaces and product verification. Optional research stays outside mandatory authority.

## Preserved integration constraints

MarketDataReader is the checked replay boundary. Persisted kinds are MBO/Trades/OrderExecution; CanonicalBar exists without verified stored-Bar replay. Shared acquisition ordinals precede filtering and data-kind splitting; unrelated acquisitions have no implicit merged ordering. Unknown coverage is not known absence, filtered ordinals are not missing intervals, and accepting Degraded never waives required order/groups/initial-state checks. Canonical MboRecord remains64bytes. Existing storage publication/fsync contracts are unchanged; Lexongine result acceptance is separate.

This handoff's structural/reference/patch verification is documented in the package verification receipt. It establishes document consistency, not product behavior, native ABI compatibility or market correctness. The implementer verifies actual checkout/dependencies/builds and updates progress.
