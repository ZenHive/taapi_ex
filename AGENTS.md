# AGENTS.md

Instructions for AI coding agents working on this repository.

## Project Overview

Elixir client library for the [Taapi.io](https://taapi.io) technical analysis API. Provides typed functions for all 208 indicators with compile-time code generation.

## Architecture

```
User calls Taapi.rsi(opts)
    → defdelegate to Taapi.Indicators.rsi(opts)
    → Taapi.Client.get("rsi", opts)
    → Req.get() to https://api.taapi.io/rsi
    → {:ok, map()} or {:error, Taapi.Error.t()}
```

### Key Modules

| Module | Purpose | Notes |
|--------|---------|-------|
| `Taapi` | Public API | Delegates 208 indicator functions + discovery API |
| `Taapi.Indicators` | Indicator definitions | Uses `indicator/2` macro, generates functions at compile time |
| `Taapi.Indicator` | DSL macro | `@before_compile` generates functions from `@indicator_defs` |
| `Taapi.Delegator` | Delegation macro | Generates `defdelegate` calls from `Taapi` to `Taapi.Indicators` |
| `Taapi.Client` | HTTP client | Low-level `Req` wrapper, escape hatch for custom endpoints |
| `Taapi.Error` | Error struct | Typed errors: `:missing_api_key`, `:rate_limited`, etc. |

### Adding New Indicators

If Taapi.io adds new indicators:

1. Add to `lib/taapi/indicators.ex`:
   ```elixir
   indicator(:new_indicator,
     endpoint: "new_indicator",
     description: "Description from Taapi docs",
     categories: [:category1, :category2]
   )
   ```

2. Run `mix compile` - function is auto-generated

3. Add integration test to `test/integration/live_test.exs` in appropriate category

## Commands

```bash
mix test.json --quiet           # Unit tests (JSON output)
mix test --include integration  # Integration tests (requires TAAPI_API_KEY)
mix format                      # Format code
mix credo --strict              # Static analysis
mix dialyzer                    # Type checking
mix doctor                      # Documentation quality
mix docs                        # Generate docs
```

## Design Principles

### Library, Not Application

- **Explicit credentials**: All functions require `api_key:` option, no env fallback
- **No global state**: Each call is independent
- **Multi-tenant safe**: Multiple API keys can be used in same app

### Error Handling

- All functions return `{:ok, map()} | {:error, Taapi.Error.t()}`
- HTTP errors mapped to semantic types (`:rate_limited`, `:unauthorized`, etc.)
- Raw upstream errors preserved in `details`

### Macro Pattern

The `indicator/2` macro is idiomatic Elixir for declarative APIs:
- Accumulates definitions via module attribute
- `@before_compile` generates functions + metadata
- Compile-time validation catches typos
- Single source of truth for 208 indicators

## Testing

### Unit Tests
- Test error paths without API calls
- Test delegation and discovery functions
- Run with `mix test.json --quiet`

### Integration Tests
- Require `TAAPI_API_KEY` environment variable
- Tagged with `@moduletag :integration`
- Excluded by default, run with `mix test --include integration`
- Handle rate limiting gracefully (log warning, pass test)

## File Boundaries

| File | Does | Does NOT |
|------|------|----------|
| `Taapi` | Public API, delegation, discovery | HTTP calls, indicator definitions |
| `Taapi.Indicators` | Indicator definitions only | HTTP logic, error handling |
| `Taapi.Client` | HTTP requests, response parsing | Indicator knowledge |
| `Taapi.Error` | Error types and constructors | HTTP or API logic |

## Quality Gates

- Dialyzer: 0 warnings
- Credo: No issues on `--strict`
- Doctor: 100% doc coverage (macro modules excluded)
- Tests: All passing
- Format: `mix format --check-formatted`
