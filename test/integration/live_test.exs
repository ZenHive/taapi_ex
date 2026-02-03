defmodule Taapi.Integration.LiveTest do
  @moduledoc """
  Integration tests against the real Taapi.io API.

  These tests require a valid TAAPI_API_KEY environment variable.
  Run with: TAAPI_API_KEY=your_key mix test --include integration
  """

  use ExUnit.Case

  require Logger

  @moduletag :integration

  # Test definitions: {name, indicator, fields, params, validator_name}
  @momentum_tests [
    {"rsi/1 returns RSI value", :rsi, ["value"], [], :validate_rsi},
    {"rsi/1 with custom period", :rsi, ["value"], [period: 21], nil},
    {"macd/1 returns MACD components", :macd, ["valueMACD", "valueMACDSignal", "valueMACDHist"], [], nil},
    {"adx/1 returns ADX value", :adx, ["value"], [], nil},
    {"cci/1 returns CCI value", :cci, ["value"], [], nil},
    {"mom/1 returns momentum value", :mom, ["value"], [], nil},
    {"roc/1 returns rate of change", :roc, ["value"], [], nil}
  ]

  @oscillator_tests [
    {"stoch/1 returns stochastic values", :stoch, ["valueK", "valueD"], [], nil},
    {"stochrsi/1 returns stochastic RSI", :stochrsi, ["valueK", "valueD"], [], nil},
    {"willr/1 returns Williams %R", :willr, ["value"], [], nil},
    {"ultosc/1 returns ultimate oscillator", :ultosc, ["value"], [], nil}
  ]

  @overlap_tests [
    {"ema/1 returns EMA value", :ema, ["value"], [], :validate_positive},
    {"ema/1 with custom period", :ema, ["value"], [period: 50], nil},
    {"sma/1 returns SMA value", :sma, ["value"], [], nil},
    {"wma/1 returns WMA value", :wma, ["value"], [], nil},
    {"dema/1 returns DEMA value", :dema, ["value"], [], nil},
    {"tema/1 returns TEMA value", :tema, ["value"], [], nil},
    {"bbands/1 returns Bollinger Bands", :bbands, ["valueUpperBand", "valueMiddleBand", "valueLowerBand"], [], nil},
    {"bbands/1 with custom params", :bbands, ["valueUpperBand", "valueMiddleBand", "valueLowerBand"],
     [period: 20, stddev: 2.5], nil},
    {"psar/1 returns Parabolic SAR", :psar, ["value"], [], nil}
  ]

  @volatility_tests [
    {"atr/1 returns ATR value", :atr, ["value"], [], :validate_non_negative},
    {"natr/1 returns normalized ATR", :natr, ["value"], [], nil},
    {"tr/1 returns true range", :tr, ["value"], [], nil}
  ]

  @volume_tests [
    {"obv/1 returns OBV value", :obv, ["value"], [], nil},
    {"mfi/1 returns MFI value", :mfi, ["value"], [], :validate_percentage},
    {"ad/1 returns A/D value", :ad, ["value"], [], nil},
    {"adosc/1 returns A/D oscillator", :adosc, ["value"], [], nil}
  ]

  @price_tests [
    {"candle/1 returns OHLC data", :candle, ["open", "high", "low", "close", "volume"], [], nil},
    {"price/1 returns current price", :price, ["value"], [], nil},
    {"avgprice/1 returns average price", :avgprice, ["value"], [], nil},
    {"medprice/1 returns median price", :medprice, ["value"], [], nil},
    {"typprice/1 returns typical price", :typprice, ["value"], [], nil},
    {"wclprice/1 returns weighted close price", :wclprice, ["value"], [], nil}
  ]

  @pattern_tests [
    {"doji/1 returns pattern result", :doji, ["value"], [], nil},
    {"hammer/1 returns pattern result", :hammer, ["value"], [], nil},
    {"engulfing/1 returns pattern result", :engulfing, ["value"], [], nil},
    {"morningstar/1 returns pattern result", :morningstar, ["value"], [], nil},
    {"eveningstar/1 returns pattern result", :eveningstar, ["value"], [], nil}
  ]

  @optional_params_tests [
    {"backtrack returns previous candle", :rsi, ["value"], [backtrack: 1], nil},
    {"results returns multiple values", :rsi, [], [results: 3], :validate_list_or_map},
    {"addResultTimestamp includes timestamps", :rsi, [], [results: 2, addResultTimestamp: true], :validate_list_or_map},
    {"custom period is respected", :sma, ["value"], [period: 100], nil},
    {"custom stddev for bbands", :bbands, ["valueUpperBand", "valueMiddleBand", "valueLowerBand"],
     [period: 14, stddev: 1.5], nil}
  ]

  setup do
    api_key = System.get_env("TAAPI_API_KEY")
    {:ok, api_key: api_key}
  end

  # Named validators
  defp validate(:validate_rsi, data) do
    value = data["value"]
    assert is_number(value)
    assert value >= 0 and value <= 100
  end

  defp validate(:validate_positive, data) do
    assert is_number(data["value"])
    assert data["value"] > 0
  end

  defp validate(:validate_non_negative, data) do
    assert is_number(data["value"])
    assert data["value"] >= 0
  end

  defp validate(:validate_percentage, data) do
    value = data["value"]
    assert is_number(value)
    assert value >= 0 and value <= 100
  end

  defp validate(:validate_list_or_map, data) do
    assert is_list(data) or is_map(data)
  end

  defp validate(nil, _data), do: :ok

  defp require_api_key!(api_key) do
    if is_nil(api_key) do
      flunk("""
      Missing TAAPI_API_KEY!

      Set this environment variable:
        export TAAPI_API_KEY="your_api_key"

      Get a free API key at: https://taapi.io/
      """)
    end
  end

  defp run_indicator_test(api_key, indicator, fields, extra_params, validator_name) do
    require_api_key!(api_key)

    base_params = [
      api_key: api_key,
      exchange: "binance",
      symbol: "BTC/USDT",
      interval: "1d"
    ]

    params = Keyword.merge(base_params, extra_params)
    result = apply(Taapi, indicator, [params])

    case result do
      {:ok, data} ->
        for field <- fields do
          assert Map.has_key?(data, field),
                 "Expected field #{field} in response, got: #{inspect(Map.keys(data))}"
        end

        validate(validator_name, data)

      {:error, %Taapi.Error{type: :rate_limited}} ->
        Logger.warning("Rate limited - test skipped for #{indicator}")
        :ok

      {:error, error} ->
        flunk("Unexpected error: #{inspect(error)}")
    end
  end

  # Generate tests from module attributes
  describe "momentum indicators" do
    for {name, indicator, fields, params, validator} <- @momentum_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "oscillator indicators" do
    for {name, indicator, fields, params, validator} <- @oscillator_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "overlap indicators" do
    for {name, indicator, fields, params, validator} <- @overlap_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "volatility indicators" do
    for {name, indicator, fields, params, validator} <- @volatility_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "volume indicators" do
    for {name, indicator, fields, params, validator} <- @volume_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "price indicators" do
    for {name, indicator, fields, params, validator} <- @price_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "pattern recognition" do
    for {name, indicator, fields, params, validator} <- @pattern_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "optional parameters" do
    for {name, indicator, fields, params, validator} <- @optional_params_tests do
      @tag indicator: indicator
      test name, %{api_key: api_key} do
        run_indicator_test(api_key, unquote(indicator), unquote(fields), unquote(params), unquote(validator))
      end
    end
  end

  describe "error handling" do
    test "returns unauthorized for invalid API key" do
      result =
        Taapi.rsi(
          api_key: "invalid_key_12345",
          exchange: "binance",
          symbol: "BTC/USDT",
          interval: "1d"
        )

      assert {:error, %Taapi.Error{type: type}} = result
      assert type in [:unauthorized, :upstream_error]
    end

    test "returns error for missing required params" do
      result = Taapi.rsi(api_key: "test_key")

      assert {:error, %Taapi.Error{}} = result
    end
  end
end
