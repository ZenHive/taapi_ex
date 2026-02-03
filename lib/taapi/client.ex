defmodule Taapi.Client do
  @moduledoc """
  Low-level HTTP client for Taapi.io API.

  This module handles the actual HTTP requests. For most use cases, prefer
  the indicator functions in `Taapi` module. Use this module directly when:

  - You need to call a custom or new indicator not yet in the library
  - You want more control over request parameters

  ## Examples

      # Direct client usage (escape hatch)
      Taapi.Client.get("rsi",
        api_key: "your_key",
        exchange: "binance",
        symbol: "BTC/USDT",
        interval: "1d"
      )

      # With optional params
      Taapi.Client.get("ema",
        api_key: "your_key",
        exchange: "binance",
        symbol: "ETH/USDT",
        interval: "4h",
        period: 21,
        backtrack: 1
      )

  """

  @base_url "https://api.taapi.io"

  @type result :: {:ok, map()} | {:error, Taapi.Error.t()}

  @doc """
  Makes a GET request to a Taapi.io indicator endpoint.

  ## Required Options

  - `:api_key` - Your Taapi.io API key
  - `:exchange` - Exchange name (e.g., "binance", "coinbase")
  - `:symbol` - Trading pair (e.g., "BTC/USDT", "ETH/BTC")
  - `:interval` - Timeframe (e.g., "1m", "5m", "1h", "4h", "1d")

  ## Optional Parameters

  - `:period` - Indicator lookback period (default varies by indicator)
  - `:backtrack` - Get previous candle values (e.g., 1 for previous candle)
  - `:results` - Number of results to return
  - `:addResultTimestamp` - Include timestamps in results (true/false)

  Additional indicator-specific params are passed through to the API.

  ## Returns

  - `{:ok, map()}` - Successful response with indicator data
  - `{:error, Taapi.Error.t()}` - Error with structured information

  ## Examples

      iex> Taapi.Client.get("rsi", api_key: "key", exchange: "binance", symbol: "BTC/USDT", interval: "1d")
      {:ok, %{"value" => 55.23}}

      iex> Taapi.Client.get("rsi", exchange: "binance", symbol: "BTC/USDT", interval: "1d")
      {:error, %Taapi.Error{type: :missing_api_key, ...}}

  """
  @spec get(String.t(), keyword()) :: result()
  def get(endpoint, opts) when is_binary(endpoint) and is_list(opts) do
    with {:ok, api_key} <- extract_api_key(opts),
         {:ok, params} <- build_params(api_key, opts) do
      do_request(endpoint, params)
    end
  end

  @doc false
  defp extract_api_key(opts) do
    case Keyword.get(opts, :api_key) do
      nil -> {:error, Taapi.Error.missing_api_key()}
      "" -> {:error, Taapi.Error.missing_api_key()}
      key when is_binary(key) -> {:ok, key}
    end
  end

  @doc false
  defp build_params(api_key, opts) do
    # Remove api_key from opts, add as 'secret' for Taapi API
    params =
      opts
      |> Keyword.delete(:api_key)
      |> Keyword.put(:secret, api_key)

    {:ok, params}
  end

  @doc false
  defp do_request(endpoint, params) do
    url = "#{@base_url}/#{endpoint}"

    case Req.get(url, params: params) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, Taapi.Error.unauthorized()}

      {:ok, %{status: 404}} ->
        {:error, Taapi.Error.not_found(endpoint)}

      {:ok, %{status: 429}} ->
        {:error, Taapi.Error.rate_limited()}

      {:ok, %{status: status, body: body}} ->
        {:error, Taapi.Error.upstream_error(status, body)}

      {:error, reason} ->
        {:error, Taapi.Error.network_error(reason)}
    end
  end

  @doc """
  Returns the base URL for the Taapi.io API.
  """
  @spec base_url() :: String.t()
  def base_url, do: @base_url
end
