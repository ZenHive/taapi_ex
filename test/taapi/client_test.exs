defmodule Taapi.ClientTest do
  use ExUnit.Case

  describe "get/2" do
    test "returns error when api_key is missing" do
      result = Taapi.Client.get("rsi", exchange: "binance", symbol: "BTC/USDT", interval: "1d")

      assert {:error, %Taapi.Error{type: :missing_api_key}} = result
    end

    test "returns error when api_key is empty string" do
      result =
        Taapi.Client.get("rsi",
          api_key: "",
          exchange: "binance",
          symbol: "BTC/USDT",
          interval: "1d"
        )

      assert {:error, %Taapi.Error{type: :missing_api_key}} = result
    end
  end

  describe "base_url/0" do
    test "returns taapi.io base URL" do
      assert Taapi.Client.base_url() == "https://api.taapi.io"
    end
  end
end
