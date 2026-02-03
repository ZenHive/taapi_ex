defmodule TaapiTest do
  use ExUnit.Case

  describe "indicators/0" do
    test "returns list of all 208 indicators" do
      indicators = Taapi.indicators()

      assert is_list(indicators)
      assert length(indicators) == 208
    end

    test "each indicator has required fields" do
      for indicator <- Taapi.indicators() do
        assert %Taapi.Indicator{} = indicator
        assert is_atom(indicator.name)
        assert is_binary(indicator.endpoint)
        assert is_binary(indicator.description)
        assert [_ | _] = indicator.categories
      end
    end
  end

  describe "describe/1" do
    test "returns indicator metadata for known indicator" do
      indicator = Taapi.describe(:rsi)

      assert %Taapi.Indicator{} = indicator
      assert indicator.name == :rsi
      assert indicator.endpoint == "rsi"
      assert :momentum in indicator.categories
    end

    test "returns nil for unknown indicator" do
      assert Taapi.describe(:unknown_indicator) == nil
    end
  end

  describe "search/1" do
    test "finds indicators by name" do
      results = Taapi.search("rsi")

      assert [_ | _] = results
      assert Enum.any?(results, &(&1.name == :rsi))
    end

    test "finds indicators by description" do
      results = Taapi.search("momentum")

      assert [_ | _] = results
    end

    test "search is case insensitive" do
      assert Taapi.search("RSI") == Taapi.search("rsi")
    end
  end

  describe "by_category/1" do
    test "returns indicators in category" do
      oscillators = Taapi.by_category(:oscillator)

      assert [_ | _] = oscillators

      for indicator <- oscillators do
        assert :oscillator in indicator.categories
      end
    end

    test "returns indicators for support_resistance category" do
      results = Taapi.by_category(:support_resistance)
      assert [_ | _] = results
    end
  end

  describe "categories/0" do
    test "returns list of unique categories" do
      categories = Taapi.categories()

      assert is_list(categories)
      assert :momentum in categories
      assert :oscillator in categories
      assert :pattern in categories
      assert :math in categories
      assert :price in categories
    end
  end

  describe "delegated indicator functions" do
    test "Taapi.rsi/1 delegates to Taapi.Indicators.rsi/1" do
      # Without API key, should return missing_api_key error
      result = Taapi.rsi(exchange: "binance", symbol: "BTC/USDT", interval: "1d")

      assert {:error, %Taapi.Error{type: :missing_api_key}} = result
    end

    test "Taapi.bbands/1 delegates to Taapi.Indicators.bbands/1" do
      result = Taapi.bbands(exchange: "binance", symbol: "BTC/USDT", interval: "1d")

      assert {:error, %Taapi.Error{type: :missing_api_key}} = result
    end

    test "all 208 indicator functions are delegated" do
      for indicator <- Taapi.indicators() do
        assert function_exported?(Taapi, indicator.name, 1),
               "Expected Taapi.#{indicator.name}/1 to exist"
      end
    end
  end
end
