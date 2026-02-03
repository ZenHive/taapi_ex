defmodule Taapi.Error do
  @moduledoc """
  Structured error type for Taapi API errors.

  ## Error Types

  - `:invalid_params` - Missing or invalid required parameters
  - `:missing_api_key` - No API key provided
  - `:rate_limited` - API rate limit exceeded (HTTP 429)
  - `:unauthorized` - Invalid API key (HTTP 401)
  - `:not_found` - Endpoint or resource not found (HTTP 404)
  - `:upstream_error` - Taapi API returned an error
  - `:network_error` - Connection or network failure

  ## Examples

      iex> %Taapi.Error{type: :rate_limited, message: "Rate limit exceeded"}
      %Taapi.Error{type: :rate_limited, message: "Rate limit exceeded", details: nil}

  """

  @type error_type ::
          :invalid_params
          | :missing_api_key
          | :rate_limited
          | :unauthorized
          | :not_found
          | :upstream_error
          | :network_error

  @type t :: %__MODULE__{
          type: error_type(),
          message: String.t(),
          details: map() | nil
        }

  defstruct [:type, :message, :details]

  @doc """
  Creates a new error with the given type and message.
  """
  @spec new(error_type(), String.t(), map() | nil) :: t()
  def new(type, message, details \\ nil) do
    %__MODULE__{type: type, message: message, details: details}
  end

  @doc """
  Creates an invalid_params error.
  """
  @spec invalid_params(String.t()) :: t()
  def invalid_params(message) do
    new(:invalid_params, message)
  end

  @doc """
  Creates a missing_api_key error.
  """
  @spec missing_api_key() :: t()
  def missing_api_key do
    new(:missing_api_key, "API key is required. Pass api_key: \"your_key\" option.")
  end

  @doc """
  Creates a rate_limited error.
  """
  @spec rate_limited() :: t()
  def rate_limited do
    new(:rate_limited, "Taapi API rate limit exceeded. Please wait before retrying.")
  end

  @doc """
  Creates an unauthorized error.
  """
  @spec unauthorized() :: t()
  def unauthorized do
    new(:unauthorized, "Invalid Taapi API key.")
  end

  @doc """
  Creates a not_found error.
  """
  @spec not_found(String.t()) :: t()
  def not_found(endpoint) do
    new(:not_found, "Endpoint '#{endpoint}' not found.")
  end

  @doc """
  Creates an upstream_error from API response.
  """
  @spec upstream_error(integer(), any()) :: t()
  def upstream_error(status, body) do
    message = extract_error_message(body) || "Taapi API error (HTTP #{status})"
    new(:upstream_error, message, %{status: status, body: body})
  end

  @doc """
  Creates a network_error from connection failure.
  """
  @spec network_error(term()) :: t()
  def network_error(reason) do
    new(:network_error, "Network error: #{inspect(reason)}", %{reason: reason})
  end

  @doc false
  defp extract_error_message(%{"error" => error}) when is_binary(error), do: error
  defp extract_error_message(%{"message" => message}) when is_binary(message), do: message
  defp extract_error_message(_), do: nil
end
