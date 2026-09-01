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
