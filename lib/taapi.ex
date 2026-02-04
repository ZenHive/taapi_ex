defmodule Taapi do
  @moduledoc """
  Elixir client for [Taapi.io](https://taapi.io/?ref=24745) technical analysis API.

  Provides functions for all 208 Taapi.io indicators with explicit API key passing.

  ## Quick Start

      # Fetch RSI for BTC/USDT on Binance
      Taapi.rsi(
        api_key: "your_taapi_key",
        exchange: "binance",
        symbol: "BTC/USDT",
        interval: "1d"
      )
      # => {:ok, %{"value" => 55.23}}

      # Fetch Bollinger Bands with custom period
      Taapi.bbands(
        api_key: "your_taapi_key",
        exchange: "binance",
        symbol: "ETH/USDT",
        interval: "4h",
        period: 20
      )
      # => {:ok, %{"valueUpperBand" => 2150.5, "valueMiddleBand" => 2100.0, ...}}

  ## Required Options

  All indicator functions require:

  - `:api_key` - Your Taapi.io API key
  - `:exchange` - Exchange name (e.g., "binance", "coinbase", "kraken")
  - `:symbol` - Trading pair (e.g., "BTC/USDT", "ETH/BTC")
  - `:interval` - Timeframe (e.g., "1m", "5m", "15m", "1h", "4h", "1d", "1w")

  ## Optional Parameters

  Most indicators accept:

  - `:period` - Lookback period (default varies by indicator)
  - `:backtrack` - Get previous candle values (e.g., 1 for previous candle)
  - `:results` - Number of results to return
  - `:addResultTimestamp` - Include timestamps in results (true/false)

  ## Discovery

      # List all available indicators
      Taapi.indicators()

      # Get metadata for a specific indicator
      Taapi.describe(:rsi)

      # Search indicators by name or description
      Taapi.search("momentum")

      # Filter by category
      Taapi.by_category(:oscillator)

  ## Error Handling

  All functions return `{:ok, map()}` or `{:error, Taapi.Error.t()}`.

      case Taapi.rsi(api_key: key, exchange: "binance", symbol: "BTC/USDT", interval: "1d") do
        {:ok, %{"value" => rsi}} ->
          IO.puts("RSI: \#{rsi}")

        {:error, %Taapi.Error{type: :rate_limited}} ->
          IO.puts("Rate limited, please wait")

        {:error, %Taapi.Error{type: type, message: msg}} ->
          IO.puts("Error (\#{type}): \#{msg}")
      end

  ## Direct Client Access

  For custom or new indicators not yet in the library:

      Taapi.Client.get("custom_indicator",
        api_key: "your_key",
        exchange: "binance",
        symbol: "BTC/USDT",
        interval: "1d"
      )

  """

  @before_compile Taapi.Delegator

  @doc """
  Returns metadata for all available indicators.

  ## Example

      Taapi.indicators()
      # => [%Taapi.Indicator{name: :rsi, ...}, ...]

  """
  @spec indicators() :: [Taapi.Indicator.t()]
  defdelegate indicators, to: Taapi.Indicators, as: :all_indicators

  @doc """
  Returns metadata for a specific indicator.

  ## Example

      Taapi.describe(:rsi)
      # => %Taapi.Indicator{name: :rsi, endpoint: "rsi", ...}

      Taapi.describe(:unknown)
      # => nil

  """
  @spec describe(atom()) :: Taapi.Indicator.t() | nil
  defdelegate describe(name), to: Taapi.Indicators

  @doc """
  Searches indicators by name or description.

  ## Example

      Taapi.search("momentum")
      # => [%Taapi.Indicator{name: :rsi, ...}, %Taapi.Indicator{name: :macd, ...}, ...]

  """
  @spec search(String.t()) :: [Taapi.Indicator.t()]
  def search(query) when is_binary(query) do
    query_downcase = String.downcase(query)

    Enum.filter(Taapi.Indicators.all_indicators(), fn indicator ->
      String.contains?(String.downcase(Atom.to_string(indicator.name)), query_downcase) ||
        String.contains?(String.downcase(indicator.description), query_downcase)
    end)
  end

  @doc """
  Returns all indicators in a specific category.

  ## Example

      Taapi.by_category(:oscillator)
      # => [%Taapi.Indicator{name: :rsi, ...}, %Taapi.Indicator{name: :stoch, ...}, ...]

  """
  @spec by_category(Taapi.Indicator.category()) :: [Taapi.Indicator.t()]
  def by_category(category) when is_atom(category) do
    Enum.filter(Taapi.Indicators.all_indicators(), fn indicator ->
      category in indicator.categories
    end)
  end

  @doc """
  Returns all available categories.

  ## Example

      Taapi.categories()
      # => [:momentum, :oscillator, :overlap, :volatility, :volume, :pattern, :price]

  """
  @spec categories() :: [Taapi.Indicator.category()]
  def categories do
    Taapi.Indicators.all_indicators()
    |> Enum.flat_map(& &1.categories)
    |> Enum.uniq()
    |> Enum.sort()
  end
end
