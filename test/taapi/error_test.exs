defmodule Taapi.ErrorTest do
  use ExUnit.Case

  describe "new/3" do
    test "creates error with all fields" do
      error = Taapi.Error.new(:upstream_error, "Something went wrong", %{status: 500})

      assert error.type == :upstream_error
      assert error.message == "Something went wrong"
      assert error.details == %{status: 500}
    end

    test "creates error without details" do
      error = Taapi.Error.new(:rate_limited, "Too many requests")

      assert error.type == :rate_limited
      assert error.message == "Too many requests"
      assert error.details == nil
    end
  end

  describe "convenience constructors" do
    test "missing_api_key/0" do
      error = Taapi.Error.missing_api_key()

      assert error.type == :missing_api_key
      assert is_binary(error.message)
    end

    test "rate_limited/0" do
      error = Taapi.Error.rate_limited()

      assert error.type == :rate_limited
      assert is_binary(error.message)
    end

    test "unauthorized/0" do
      error = Taapi.Error.unauthorized()

      assert error.type == :unauthorized
      assert is_binary(error.message)
    end

    test "not_found/1" do
      error = Taapi.Error.not_found("custom_endpoint")

      assert error.type == :not_found
      assert String.contains?(error.message, "custom_endpoint")
    end

    test "upstream_error/2" do
      error = Taapi.Error.upstream_error(500, %{"error" => "Internal error"})

      assert error.type == :upstream_error
      assert error.message == "Internal error"
      assert error.details.status == 500
    end

    test "upstream_error/2 with unknown body format" do
      error = Taapi.Error.upstream_error(500, "raw string")

      assert error.type == :upstream_error
      assert String.contains?(error.message, "500")
    end

    test "network_error/1" do
      error = Taapi.Error.network_error(:timeout)

      assert error.type == :network_error
      assert String.contains?(error.message, "timeout")
      assert error.details.reason == :timeout
    end
  end
end
