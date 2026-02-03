defmodule Taapi.Delegator do
  @moduledoc false

  defmacro __before_compile__(_env) do
    # Generate defdelegate for each indicator
    for indicator <- Taapi.Indicators.all_indicators() do
      name = indicator.name

      quote do
        defdelegate unquote(name)(opts), to: Taapi.Indicators
      end
    end
  end
end
