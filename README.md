# Taapi

[![Hex.pm](https://img.shields.io/hexpm/v/taapi_ex.svg)](https://hex.pm/packages/taapi_ex)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/taapi_ex)
[![License](https://img.shields.io/hexpm/l/taapi_ex.svg)](LICENSE)

Elixir client for [Taapi.io](https://taapi.io/?ref=24745) technical analysis API with all 208 indicators.

## Features

- All 208 Taapi.io indicators as typed functions
- Explicit API key passing (no hidden environment variable magic)
- Structured error types with `Taapi.Error`
- Discovery API for exploring available indicators
- Direct client access for custom/new endpoints

## Installation

Add `taapi_ex` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:taapi_ex, "~> 0.1.0"}
  ]
end
```

## Quick Start

```elixir
# Fetch RSI for BTC/USDT on Binance
{:ok, %{"value" => rsi}} = Taapi.rsi(
  api_key: "your_taapi_key",
  exchange: "binance",
  symbol: "BTC/USDT",
  interval: "1d"
)

# Fetch Bollinger Bands with custom period
{:ok, bands} = Taapi.bbands(
  api_key: "your_taapi_key",
  exchange: "binance",
  symbol: "ETH/USDT",
  interval: "4h",
  period: 20
)
```

## Required Options

All indicator functions require:

| Option | Description | Example |
|--------|-------------|---------|
| `:api_key` | Your Taapi.io API key | `"abc123"` |
| `:exchange` | Exchange name | `"binance"`, `"coinbase"`, `"kraken"` |
| `:symbol` | Trading pair | `"BTC/USDT"`, `"ETH/BTC"` |
| `:interval` | Timeframe | `"1m"`, `"5m"`, `"15m"`, `"1h"`, `"4h"`, `"1d"`, `"1w"` |

## Optional Parameters

Most indicators accept:

| Option | Description | Example |
|--------|-------------|---------|
| `:period` | Lookback period | `14`, `21`, `50` |
| `:backtrack` | Previous candle offset | `1` (previous), `2` (2 candles ago) |
| `:results` | Number of results | `5` (last 5 values) |
| `:addResultTimestamp` | Include timestamps | `true` |

## Discovery API

```elixir
# List all available indicators
Taapi.indicators()
# => [%Taapi.Indicator{name: :rsi, ...}, ...]

# Get metadata for a specific indicator
Taapi.describe(:macd)
# => %Taapi.Indicator{name: :macd, endpoint: "macd", categories: [:momentum], ...}

# Search indicators
Taapi.search("momentum")
# => [%Taapi.Indicator{...}, ...]

# Filter by category
Taapi.by_category(:oscillator)
# => [%Taapi.Indicator{name: :rsi, ...}, ...]

# List all categories
Taapi.categories()
# => [:math, :momentum, :oscillator, :overlap, :pattern, :price, ...]
```

## Error Handling

All functions return `{:ok, map()}` or `{:error, Taapi.Error.t()}`:

```elixir
case Taapi.rsi(api_key: key, exchange: "binance", symbol: "BTC/USDT", interval: "1d") do
  {:ok, %{"value" => rsi}} ->
    # Use RSI value
    do_something(rsi)

  {:error, %Taapi.Error{type: :rate_limited}} ->
    # Handle rate limiting
    :retry_later

  {:error, %Taapi.Error{type: :unauthorized}} ->
    # Invalid API key
    :check_credentials

  {:error, %Taapi.Error{type: type, message: msg}} ->
    # Other errors
    Logger.error("Taapi error (#{type}): #{msg}")
end
```

### Error Types

| Type | Description |
|------|-------------|
| `:missing_api_key` | No API key provided |
| `:unauthorized` | Invalid API key (HTTP 401) |
| `:rate_limited` | Rate limit exceeded (HTTP 429) |
| `:not_found` | Endpoint not found (HTTP 404) |
| `:upstream_error` | Taapi API error |
| `:network_error` | Connection failure |

## Direct Client Access

For custom or new indicators not yet in the library:

```elixir
Taapi.Client.get("custom_indicator",
  api_key: "your_key",
  exchange: "binance",
  symbol: "BTC/USDT",
  interval: "1d"
)
```

## Supported Indicators

All 208 Taapi.io indicators organized by category:

| Category | Examples |
|----------|----------|
| **Pattern Recognition** (61) | `doji`, `hammer`, `engulfing`, `morningstar`, `eveningstar` |
| **Momentum** | `rsi`, `macd`, `adx`, `cci`, `mom`, `roc`, `stoch`, `stochrsi` |
| **Oscillators** | `accosc`, `chop`, `dpo`, `fisher`, `fosc`, `kvo`, `msw` |
| **Overlap Studies** | `ema`, `sma`, `bbands`, `ichimoku`, `psar`, `vwap`, `keltnerchannels` |
| **Volatility** | `atr`, `natr`, `bbw`, `stddev`, `volatility` |
| **Volume** | `obv`, `mfi`, `ad`, `adosc`, `cmf`, `nvi`, `pvi` |
| **Trend** | `supertrend`, `vortex`, `vhf`, `qstick` |
| **Statistics** | `linearreg`, `beta`, `correl`, `stddev`, `var`, `tsf` |
| **Math** | `abs`, `ceil`, `floor`, `max`, `min`, `sqrt`, `sum` |
| **Price** | `candle`, `candles`, `price`, `avgprice`, `medprice`, `typprice` |

See [Taapi.io Indicators](https://taapi.io/indicators/?ref=24745) for the complete list.

## Rate Limiting

This library does **not** implement rate limiting. Taapi.io has rate limits based on your subscription tier. Implement rate limiting in your application as needed.

## Getting an API Key

1. Visit [Taapi.io](https://taapi.io/?ref=24745)
2. Sign up for a free account
3. Get your API key from the dashboard

Free tier includes limited requests. See [pricing](https://taapi.io/product-category/subscription/?ref=24745) for higher limits.

## License

MIT - see [LICENSE](LICENSE) for details.
