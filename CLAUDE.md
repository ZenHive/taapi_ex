# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@include ~/.claude/includes/across-instances.md
@include ~/.claude/includes/critical-rules.md
@include ~/.claude/includes/skills-awareness.md
@include ~/.claude/includes/task-prioritization.md
@include ~/.claude/includes/task-writing.md
@include ~/.claude/includes/web-command.md
@include ~/.claude/includes/code-style.md
@include ~/.claude/includes/development-philosophy.md
@include ~/.claude/includes/documentation-guidelines.md
@include ~/.claude/includes/api-integration.md
@include ~/.claude/includes/development-commands.md
@include ~/.claude/includes/elixir-patterns.md
@include ~/.claude/includes/elixir-setup.md
@include ~/.claude/includes/ex-unit-json.md
@include ~/.claude/includes/dialyzer-json.md
@include ~/.claude/includes/library-design.md

## Published Package

- **Hex**: https://hex.pm/packages/taapi_ex
- **Docs**: https://hexdocs.pm/taapi_ex
- **Source**: https://github.com/ZenHive/taapi_ex

## Commands

```bash
# Run all unit tests
mix test

# Run tests with AI-friendly JSON output
mix test.json --quiet

# Run integration tests (requires TAAPI_API_KEY env var)
TAAPI_API_KEY=your_key mix test --include integration

# Run a single test file
mix test test/taapi/client_test.exs

# Quality checks
mix format --check-formatted
mix credo --strict
mix dialyzer
mix doctor

# Start Tidewave MCP server (for Claude Code integration)
mix tidewave
```

## Architecture

This is an Elixir client library for the Taapi.io technical analysis API with 208 indicators.

### Key Design Pattern: Macro-Based Indicator Generation

The library uses a compile-time macro system to generate 208 indicator functions from declarative definitions:

1. **`Taapi.Indicator`** (`lib/taapi/indicator.ex`) - DSL macro that accumulates `@indicator_defs` and generates:
   - Individual indicator functions (e.g., `rsi/1`, `macd/1`)
   - `all_indicators/0` returning metadata list
   - `describe/1` for per-indicator lookup

2. **`Taapi.Indicators`** (`lib/taapi/indicators.ex`) - Contains all 208 indicator definitions using the `indicator/2` macro. Each definition specifies endpoint, description, and categories.

3. **`Taapi.Delegator`** (`lib/taapi/delegator.ex`) - `@before_compile` hook that generates `defdelegate` calls from `Taapi` module to `Taapi.Indicators`.

4. **`Taapi`** (`lib/taapi.ex`) - Public API module. Delegates all 208 indicator functions plus provides discovery functions (`indicators/0`, `describe/1`, `search/1`, `by_category/1`, `categories/0`).

### Data Flow

```
User calls Taapi.rsi(opts)
    → defdelegate to Taapi.Indicators.rsi(opts)
    → Taapi.Client.get("rsi", opts)
    → Req.get() to https://api.taapi.io/rsi
    → {:ok, map()} or {:error, Taapi.Error.t()}
```

### Error Handling

`Taapi.Error` provides typed errors: `:missing_api_key`, `:unauthorized`, `:rate_limited`, `:not_found`, `:upstream_error`, `:network_error`.

## Integration Tests

Integration tests in `test/integration/live_test.exs` require a real API key and are excluded by default. They use data-driven test generation from module attributes.

## API Reference

Taapi.io API documentation: https://taapi.io/indicators/
