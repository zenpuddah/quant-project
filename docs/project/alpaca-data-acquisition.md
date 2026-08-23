# Alpaca Data Acquisition

## Scope

- **Accepted:** On 2026-08-23, one trailing calendar month of daily raw stock bars was acquired for `SPY`, `AAPL`, `MSFT`, and `AMZN`.
- **Accepted:** The request window was `2026-07-23T00:00:00Z` inclusive through `2026-08-23T00:00:00Z` exclusive.
- **Accepted:** This is a user-requested research-data artifact only. It does not design or implement the C++ model.

## Credential verification

- **Observed:** The environment variables `APCA_API_KEY_ID` and `APCA_API_SECRET_KEY` were used without printing their values or writing them to a file.
- **Observed:** The Alpaca historical-data request returned HTTP `200`.
- **Observed:** The trading-account endpoint returned HTTP `401`; trading-account access is therefore not asserted. Historical market-data access was authorized successfully.

## Request

- **Endpoint:** `GET https://data.alpaca.markets/v2/stocks/bars`
- **Symbols:** `SPY`, `AAPL`, `MSFT`, `AMZN`
- **Timeframe:** `1Day`
- **Feed:** `iex` (IEX feed, not the consolidated SIP feed)
- **Adjustment:** `raw` (unadjusted bars)
- **Sort:** `asc`
- **Limit:** `1000`
- **Pagination:** The response returned `next_page_token: null`; no additional page was required.

## Raw artifact

- **Path:** `data/raw/alpaca/alpaca_stocks_bars_1day_raw_2026-07-23_2026-08-23.json`
- **Git policy:** `/data/raw/` is excluded by the repository `.gitignore`. No credential values are stored in the repository.

## Response schema

The observed response shape was:

```json
{
  "bars": {
    "<symbol>": [
      {
        "c": "number",
        "h": "number",
        "l": "number",
        "n": "number",
        "o": "number",
        "t": "string",
        "v": "number",
        "vw": "number"
      }
    ]
  },
  "next_page_token": "string or null"
}
```

Bar fields are `c` close, `h` high, `l` low, `n` trade count, `o` open, `t` timestamp, `v` volume, and `vw` volume-weighted average price.

## Timestamps and observations

- **Observed timestamp format:** RFC3339/ISO-8601 UTC strings ending in `Z`, for example `2026-07-23T04:00:00Z`.
- **Observed range:** `2026-07-23T04:00:00Z` through `2026-08-21T04:00:00Z`.
- **Counts:** 22 bars per symbol, 88 bars total.
- **Completeness:** All four symbols have the same 22 timestamps. No duplicate timestamps, null fields, or missing symbol observations were found.
- **Missing sessions:** None among the 22 weekday sessions in the requested interval. `2026-08-22` and `2026-08-23` were weekend dates after the last observed session and are not treated as missing observations.
