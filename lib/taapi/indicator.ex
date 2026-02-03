defmodule Taapi.Indicator do
  @moduledoc """
  Indicator metadata struct and DSL macro for defining indicators.

  This module provides the `indicator` macro used to define all 208 Taapi.io
  indicators with their metadata (endpoint, description, categories, parameters).

  ## Indicator Struct

  Each indicator has:
  - `:name` - Atom name (e.g., `:rsi`)
  - `:endpoint` - API endpoint path (e.g., "rsi")
  - `:description` - Human-readable description
  - `:categories` - List of category atoms (e.g., `[:momentum, :oscillator]`)
  - `:params` - List of indicator-specific parameters beyond the standard ones

  ## Categories

  Indicators can belong to multiple categories:
  - `:momentum` - Trend strength and direction
  - `:oscillator` - Bounded indicators showing overbought/oversold
  - `:overlap` - Overlay on price chart (moving averages, bands)
  - `:volatility` - Price volatility measures
  - `:volume` - Volume-based indicators
  - `:pattern` - Candlestick pattern recognition
  - `:math` - Mathematical transforms and operators
  - `:price` - Price data and transforms
  - `:statistic` - Statistical functions
  - `:trend` - Trend identification
  - `:support_resistance` - Support and resistance levels

  ## Standard Parameters

  All indicators accept these standard parameters:
  - `:exchange` - Exchange name (required)
  - `:symbol` - Trading pair (required)
  - `:interval` - Timeframe (required)
  - `:backtrack` - Previous candle offset (optional)
  - `:results` - Number of results (optional)
  - `:addResultTimestamp` - Include timestamps (optional)

  """

  @type param :: %{
          name: atom(),
          type: :integer | :float | :string | :boolean,
          default: term() | nil,
          description: String.t()
        }

  @type category ::
          :momentum
          | :oscillator
          | :overlap
          | :volatility
          | :volume
          | :pattern
          | :math
          | :price
          | :statistic
          | :trend
          | :support_resistance

  @type t :: %__MODULE__{
          name: atom(),
          endpoint: String.t(),
          description: String.t(),
          categories: [category()],
          params: [param()]
        }

  @enforce_keys [:name, :endpoint, :description, :categories]
  defstruct [:name, :endpoint, :description, :categories, params: []]

  @doc """
  Creates a new Indicator struct.
  """
  @spec new(atom(), String.t(), String.t(), [category()], [param()]) :: t()
  def new(name, endpoint, description, categories, params \\ []) do
    %__MODULE__{
      name: name,
      endpoint: endpoint,
      description: description,
      categories: List.wrap(categories),
      params: params
    }
  end

  @doc false
  # Macro for defining indicators - accumulates to @indicator_defs
  defmacro indicator(name, opts) do
    quote do
      @indicator_defs {unquote(name), unquote(opts)}
    end
  end

  @doc false
  # Sets up the indicator DSL in a module
  defmacro __using__(_opts) do
    quote do
      import Taapi.Indicator, only: [indicator: 2]

      Module.register_attribute(__MODULE__, :indicator_defs, accumulate: true)

      @before_compile Taapi.Indicator
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    indicator_defs = env.module |> Module.get_attribute(:indicator_defs) |> Enum.reverse()

    # Generate indicator functions
    indicator_fns =
      for {name, opts} <- indicator_defs do
        endpoint = Keyword.fetch!(opts, :endpoint)
        description = Keyword.fetch!(opts, :description)

        quote do
          @doc """
          #{unquote(description)}

          ## Required Options

          - `:api_key` - Your Taapi.io API key
          - `:exchange` - Exchange name (e.g., "binance")
          - `:symbol` - Trading pair (e.g., "BTC/USDT")
          - `:interval` - Timeframe (e.g., "1d", "4h", "1h")

          ## Optional Parameters

          - `:period` - Lookback period (indicator-specific default)
          - `:backtrack` - Previous candle offset
          - `:results` - Number of results to return
          - `:addResultTimestamp` - Include timestamps (true/false)

          ## Examples

              Taapi.#{unquote(name)}(
                api_key: "your_key",
                exchange: "binance",
                symbol: "BTC/USDT",
                interval: "1d"
              )

          """
          @spec unquote(name)(keyword()) :: {:ok, map()} | {:error, Taapi.Error.t()}
          def unquote(name)(opts) when is_list(opts) do
            Taapi.Client.get(unquote(endpoint), opts)
          end
        end
      end

    # Generate all_indicators/0
    indicators_list =
      for {name, opts} <- indicator_defs do
        endpoint = Keyword.fetch!(opts, :endpoint)
        description = Keyword.fetch!(opts, :description)
        categories = Keyword.fetch!(opts, :categories)
        params = Keyword.get(opts, :params, [])

        quote do
          Taapi.Indicator.new(
            unquote(name),
            unquote(endpoint),
            unquote(description),
            unquote(categories),
            unquote(Macro.escape(params))
          )
        end
      end

    all_indicators_fn =
      quote do
        @doc """
        Returns metadata for all defined indicators.
        """
        @spec all_indicators() :: [Taapi.Indicator.t()]
        def all_indicators do
          unquote(indicators_list)
        end
      end

    # Generate describe/1 for each indicator
    describe_fns =
      for {name, opts} <- indicator_defs do
        endpoint = Keyword.fetch!(opts, :endpoint)
        description = Keyword.fetch!(opts, :description)
        categories = Keyword.fetch!(opts, :categories)
        params = Keyword.get(opts, :params, [])

        quote do
          def describe(unquote(name)) do
            Taapi.Indicator.new(
              unquote(name),
              unquote(endpoint),
              unquote(description),
              unquote(categories),
              unquote(Macro.escape(params))
            )
          end
        end
      end

    describe_fallback =
      quote do
        @doc """
        Returns metadata for a specific indicator by name.
        """
        @spec describe(atom()) :: Taapi.Indicator.t() | nil
        def describe(_), do: nil
      end

    indicator_fns ++ [all_indicators_fn | describe_fns] ++ [describe_fallback]
  end
end
