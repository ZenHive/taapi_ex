# Exclude integration tests by default (they require TAAPI_API_KEY)
# Run with: mix test --include integration
ExUnit.start(exclude: [:integration])
