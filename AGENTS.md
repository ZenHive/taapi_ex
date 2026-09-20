<!-- Auto-generated from CLAUDE.md by claude-marketplace/scripts/sync-agents-md.sh — do not edit manually -->

# CLAUDE.md

<!-- @-import: ~/.claude/includes/verification-policy.md -->
## Verification scope — focused runs, full post-merge QA

This is the canonical policy for **when** checks run. Project command catalogs describe **how** to run them; an alias name such as `precommit` or `check.dispatch` does not require its execution. Apply this policy to implementers, reviewers, orchestrators and hooks. Explicit operator requests and concrete task acceptance criteria can require additional checks.

| Work / role | Required verification |
|---|---|
| Docs, roadmap, comments, text-only changes | Validate the changed artifact (for example rmap validation or AGENTS generation); no code suite, coverage or analyzers. |
| Implementation | Format changed code, compile where relevant, and add/run focused tests for the changed behavior and regression. |
| Reviewer | Independently assess the diff and acceptance criteria; run focused checks for affected behavior and relevant integration boundaries. The reviewer remains the acceptance gate. |
| Post-merge audit + QA | On the landed revision, run the full project suite, coverage and applicable analyzers: Dialyzer, Reach, Sobelow, Credo, Doctor, clone detection and language-specific equivalents. Review the integrated surface against roadmap intent and domain invariants. |

- **Commit, push, PR creation, reviewer handoff, branch switch, rebase, merge and `deps.get` are not by themselves reasons to run full QA.** Do not run full-project gates on every small change or every implementer/reviewer run. No project exception, including aave_sim.
- **Choose checks by changed behavior and risk.** Signing, money, authorization, crypto and external-provider changes still require their relevant security, boundary and live integration tests before acceptance. Missing credentials or failed checks are reported honestly, never converted into a green result. Preserve tests and thresholds; change when they run.
- **Broaden only for a named reason:** explicit request/acceptance criterion, or concrete evidence that focused checks cannot resolve a cross-module regression. State that reason and run the smallest additional check that resolves it. “To be safe” or an alias name is not a reason.
- **Coverage belongs to full QA.** Keep project thresholds (at least 80% standard / 95% critical unless a documented project baseline applies). Do not demand a whole-module coverage uplift before an unrelated edit. Add meaningful tests for the behavior being changed.
- **Inspect aliases before using them.** If `check.dispatch`, `precommit`, `ci`, a registered hint or an inherited hook bundles full tests/coverage/analyzers, use the explicit scoped commands for the run and report the configuration mismatch. Do not claim the alias became lightweight merely because the instructions changed.
- **Reuse evidence for the same revision and scope.** Capture command output once; do not rerun solely for readable logs or to repeat a passed check. A reviewer supplies independent judgment and relevant verification, not an automatic full-suite repetition.
- **Full QA is a separate, nonblocking post-merge audit responsibility.** Record revision/range, commands, results and missing checks. Failures produce visible findings and repair work; they do not retroactively unmerge or become a blanket next-wave/deployment gate. If automatic QA is not configured or has not run, say so; never infer success from the existence of this policy.

Maintain this policy in `~/.claude/includes/verification-policy.md`. Import it from project `CLAUDE.md`; regenerate `AGENTS.md` with `claude-marketplace/scripts/sync-agents-md.sh`. Keep scheduling rules here, project-specific commands and justified risk checks in the project. Do not duplicate the policy in project prose.


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
