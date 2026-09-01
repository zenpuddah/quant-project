```mermaid
classDiagram
    direction LR

    class InstrumentId {
        +value : uint64
    }
    class OrderId {
        +value : uint64
    }
    class Timestamp {
        +unix_nanos : int64
    }
    class VenueId {
        +value : string
    }
    class SourceInfo {
        +provider : string
        +dataset : string optional
        +schema : string optional
    }
    class InstrumentType {
        Equity
        Option
        Future
        Other
    }
    class CurrencyCode {
        +value : string
    }
    class FixedDecimal {
        +coefficient : int64
        +scale : uint8
    }
    class Price {
        +value : FixedDecimal
    }
    class Quantity {
        +value : FixedDecimal
    }
    class Money {
        +currency : CurrencyCode
        +amount : FixedDecimal
    }
    class Side {
        Buy
        Sell
    }
    class MboAction {
        Add
        Modify
        Cancel
        Execute
        Clear
    }

    class ReferenceHistory {
        +append(ReferenceVersion)
        +at(Timestamp)
    }
    class ReferenceVersion {
        +valid_from : Timestamp
        +valid_until : Timestamp optional
        +symbol : string
        +type : InstrumentType
        +currency : CurrencyCode optional
        +tick_size : Price optional
        +lot_size : Quantity optional
    }

    class EventHeader {
        +instrument_id : InstrumentId
        +venue : VenueId
        +event_time : Timestamp
        +receive_time : Timestamp optional
        +sequence : uint64 optional
        +channel_id : uint32 optional
        +source_flags : uint64
        +source : SourceInfo
    }
    class MboEvent {
        +action : MboAction
        +order_id : OrderId optional
        +side : Side optional
        +price : Price optional
        +quantity : Quantity optional
    }
    class Trade {
        +price : Price
        +quantity : Quantity
        +aggressor_side : Side optional
    }
    class Quote {
        +bid_price : Price optional
        +bid_quantity : Quantity optional
        +ask_price : Price optional
        +ask_quantity : Quantity optional
    }
    class L2View {
        +price_levels
    }
    class Bar {
        +interval_start : Timestamp
        +interval_end : Timestamp
        +open : Price
        +high : Price
        +low : Price
        +close : Price
        +volume : Quantity
    }
    class MarketState {
        +state_at(Timestamp)
    }
    class DataState {
        +state_at(Timestamp)
    }
    class ValidationIssues {
        +code : string
        +message : string
    }

    class OriginalPool {
        +observed_records
    }
    class TransformedPool {
        +derived_records
    }
    class LineageNode {
        +parents
        +operation
        +parameters
        +code_version
    }
    class Revision {
        +original_event
        +correction
    }
    class Snapshot {
        +history_position
        +derived_state
    }

    InstrumentId "1" --> "1" ReferenceHistory : keys
    ReferenceHistory "1" *-- "0..*" ReferenceVersion : stores
    ReferenceVersion --> InstrumentId : identifies
    ReferenceVersion --> InstrumentType
    ReferenceVersion --> CurrencyCode
    ReferenceVersion --> Price : tick size
    ReferenceVersion --> Quantity : lot size

    Price *-- FixedDecimal : wraps
    Quantity *-- FixedDecimal : wraps
    Money *-- FixedDecimal : amount
    Money --> CurrencyCode

    EventHeader --> InstrumentId : identifies
    EventHeader --> VenueId
    EventHeader --> Timestamp
    EventHeader --> SourceInfo
    MboEvent *-- EventHeader
    Trade *-- EventHeader
    Quote *-- EventHeader
    Bar *-- EventHeader
    MboEvent --> OrderId
    MboEvent --> Side
    MboEvent --> MboAction
    MboEvent --> Price
    MboEvent --> Quantity
    Trade --> Price
    Trade --> Quantity
    Quote --> Price
    Quote --> Quantity
    Bar --> Price
    Bar --> Quantity

    MboEvent ..> Trade : distinct concepts
    MboEvent ..> L2View : can derive
    L2View ..> Quote : can derive
    Trade ..> Bar : can derive
    MboEvent ..> ValidationIssues : validated by
    Trade ..> ValidationIssues : validated by
    Quote ..> ValidationIssues : validated by
    Bar ..> ValidationIssues : validated by

    OriginalPool "1" o-- "0..*" MboEvent : observed
    OriginalPool "1" o-- "0..*" Trade : observed
    OriginalPool "1" o-- "0..*" Quote : observed
    OriginalPool "1" o-- "0..*" Bar : observed
    TransformedPool "1" o-- "0..*" L2View : derived
    TransformedPool "1" o-- "0..*" Bar : derived
    TransformedPool "1" o-- "0..*" LineageNode : traces
    LineageNode --> OriginalPool : parent history
    LineageNode --> TransformedPool : descendant
    Revision --> OriginalPool : preserves history
    Revision --> Revision : revision history
    Snapshot --> TransformedPool : recovery checkpoint
    MarketState ..> EventHeader : reduced from state events
    DataState ..> EventHeader : reduced from quality events
```

## Iteration 2 — accepted MBO physical-layout direction

The Mermaid model above remains the logical/current Iteration 1 model. For the second implementation/performance pass, use a Databento-inspired fixed-size MBO record as the first physical-layout candidate rather than storing action-specific variable-length records or the current collection of independent `std::optional` fields.

- Keep typed construction at the writer boundary (`Add`, `Modify`, `Cancel`, `Execute`, `Clear` semantics), then normalize into one compact fixed-size tagged MBO record.
- Store records contiguously and let consumers iterate with a constant stride. The writer → buffer → consumer model is initially synchronous; this decision does not introduce threading or lock-free queues.
- The action tag determines the semantics of the fixed payload fields. Actions such as `Clear` may leave some fixed slots unused; this deliberate space cost is traded for predictable layout, simple iteration, easier prefetch/cache behavior, and less per-record decoding logic.
- Preserve the option to expose typed consumer views even if the physical buffer is one fixed record type.
- Benchmark the actual record footprint before freezing the layout. Useful targets to test include 32, 40, 48, and 64 bytes, with cache-line interaction measured rather than assumed.
- Sizing sanity check discussed during design: with 1,000,000 records, a 64-byte fixed layout uses 64 MB. If 30% are `Clear` and a hypothetical variable-length layout could encode `Clear` in 32 bytes while all other records remain 64 bytes, the variable layout would use 54.4 MB. The fixed layout therefore spends 9.6 MB, about 15%, for the constant-stride representation in that example.
- Exact field widths, padding/alignment, sentinel/unused-field semantics, common-header layout, and the final record size remain Iteration 2 implementation/benchmark decisions.
