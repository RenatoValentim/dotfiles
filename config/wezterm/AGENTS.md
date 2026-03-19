# AGENTS.md

## Scope

This directory is a standalone WezTerm configuration project rooted at `config/wezterm`.
Treat this directory as the working root unless the user explicitly asks to operate from the parent dotfiles repository.
No agent rule files were found here:

- no `.cursorrules`
- no `.cursor/rules/`
- no `.github/copilot-instructions.md`

## Repository Layout

- `wezterm.lua` - thin bootstrap entry point
- `config/init.lua` - composes the full WezTerm config
- `config/options.lua` - shared options, theme, font, leader key
- `config/opacity.lua` - transparency events and opacity state
- `config/tabs.lua` - tab labels, zoom badge, right status
- `config/keys.lua` - keymaps and the fzf keybinding picker
- `tests/run.lua` - custom Lua test runner
- `tests/*_spec.lua` - unit-style specs
- `wezterm-fzf-picker.sh` - shell helper for the picker
- `wezterm.lua` should stay tiny
- modules in `config/` export an `M` table
- `apply(...)` mutates the config object
- `register(...)` attaches WezTerm event handlers
- prefer pure helpers when logic can be tested outside WezTerm

## Build, Lint, and Test Commands

There is no build step in this directory.
Primary local commands:

- test suite: `lua tests/run.lua`
- shell syntax: `bash -n wezterm-fzf-picker.sh`
- format fix: `stylua wezterm.lua config tests`
- CI-compatible format fix from the dotfiles root: `stylua --config-path config/lazyvim/stylua.toml config/wezterm`
  The README also documents parent-repo wrapper commands:
- `./scripts/check.sh`
- `CHECK_NVIM=1 ./scripts/check.sh`
  Prefer the direct local commands when working only in `config/wezterm`.

## Validation Baseline

At the last verification:

- `lua tests/run.lua` passes
- `bash -n wezterm-fzf-picker.sh` passes
- `stylua --config-path config/lazyvim/stylua.toml config/wezterm` is the CI-facing format fix command
- logic and tests are green
- formatting is not fully normalized to StyLua yet
- always run `stylua wezterm.lua config tests` before finishing any adjustment in this repo; do not skip it, because CI can fail on formatting drift

## Running a Single Test

The custom test runner does not support filtering flags.

- module: `lua -e 'package.path="./?.lua;./?/init.lua;" .. package.path; local cases = require("tests.tabs_spec"); local total = 0; for _, case in ipairs(cases) do total = total + 1; local ok, err = xpcall(case.run, debug.traceback); if not ok then io.stderr:write(err .. "\n"); os.exit(1) end; print("ok - tabs - " .. case.name) end; print(total .. " tests passed")'`
- named case: `lua -e 'package.path="./?.lua;./?/init.lua;" .. package.path; local target = "extracts basenames and cwd names"; for _, case in ipairs(require("tests.tabs_spec")) do if case.name == target then local ok, err = xpcall(case.run, debug.traceback); if not ok then io.stderr:write(err .. "\n"); os.exit(1) end; print("ok - tabs - " .. case.name); os.exit(0) end end; io.stderr:write("case not found: " .. target .. "\n"); os.exit(2)'`
  When adapting those commands:
- replace `tests.tabs_spec` with the target module
- replace the `target` string with the exact case name
- keep the `package.path` prefix intact

## Lua Style Guidelines

General rules:

- use `local` by default
- avoid globals
- keep `require(...)` statements at the top of the file
- return a module table named `M`
- prefer small focused modules over growing one large file
- use double-quoted strings
- use trailing commas in multiline tables
- keep blank lines only between logical sections
  Naming:
- files use snake_case
- locals use snake_case
- helper functions use snake_case
- exported module table is `M`
- public entry points are usually `apply` or `register`
- event names use descriptive kebab-case strings like `"toggle-transparency"`
  Imports and module structure:
- group imports at the top
- do not scatter `require(...)` calls unless necessary
- prefer helper functions above exported functions
- keep `wezterm.lua` thin and route composition through `config/init.lua`
  Function style:
- prefer early returns over deep nesting
- keep callbacks short when possible
- if a WezTerm callback grows, extract pure helpers
- keep UI text and behavior metadata close to the feature that owns them
  Tables, formatting, and types:
- short inline tables are fine when readable
- multiline tables should be formatter-friendly
- avoid manual alignment that StyLua will undo
- preserve existing Unicode only when it is part of the UI, such as the zoom badge
- this repo does not use a formal type system
- do not introduce type annotations unless explicitly requested
- express structure with clear table fields and focused helper functions
  Comments:
- comments are sparse
- add comments only for non-obvious reasoning or API quirks
- do not add narrative comments for straightforward code

## Error Handling

Preferred style:

- use nil checks and early returns
- use `pcall` when calling WezTerm mux or window APIs that may be unavailable
- fail safely if a pane, tab, window, or mux object is missing
- avoid throwing raw errors from event handlers unless unavoidable
  In tests:
- use plain `assert(...)`
- let `tests/run.lua` handle `xpcall(...)` and traceback printing
- keep each case independent

## Bash Style Guidelines

Shell conventions from `wezterm-fzf-picker.sh`:

- use `#!/usr/bin/env bash`
- enable `set -euo pipefail`
- quote variable expansions
- declare function locals with `local`
- keep function names in snake_case
- use `printf` for exact output
- use `command -v` for dependency checks
- use `trap ... EXIT` for cleanup
- reserve `|| true` for cleanup or intentional best-effort operations
  When editing the shell helper:
- preserve the interface expected by `config/keys.lua`
- preserve the tab-delimited picker row contract
- preserve pane focus restoration and cleanup behavior unless intentionally changing it

## Testing Conventions

Each spec file returns cases shaped like:

- `{ name = "...", run = function() ... end }`
  Testing expectations:
- keep specs simple and table-driven
- use plain `assert`
- prefer testing pure helpers over live WezTerm integration
- update the matching spec when behavior changes
- keep spec names human-readable and behavior-focused
- good targets include string formatting, path helpers, keybinding labeling, lookup id generation, picker row generation, and tab title selection logic

## Feature-Specific Guidance

If you change keybindings:

- update both the actual binding and its `desc`
- keep `category` and `suggested` metadata in sync
- verify picker display behavior still matches expectations
  If you change tab behavior:
- verify explicit title precedence
- verify process and cwd fallback logic
- verify zoom badge behavior in both tab bar and right status
  If you change event-driven behavior:
- keep event names stable unless intentionally migrating all call sites
- verify both the registration path and any pure helper logic used by it

## Completion Checklist

Before finishing:

- run `lua tests/run.lua`
- run `bash -n wezterm-fzf-picker.sh` if the shell helper changed
- always run `stylua wezterm.lua config tests` before finishing, even for small Lua changes
- run `stylua --config-path config/lazyvim/stylua.toml config/wezterm` from the dotfiles root
- mention any remaining pre-existing formatting drift or unrelated issues

## Commit Conventions

- always use Conventional Commits when drafting or creating commits
- prefer the format `type(scope): subject`
- keep the subject lowercase, imperative, and focused on the user-visible change

## Agent Behavior Summary

When acting autonomously in this repo:

- read `README.md` first
- preserve the small-module structure
- prefer minimal, focused edits
- keep runtime logic testable
- follow existing naming and formatting conventions
- always run `stylua wezterm.lua config tests` before handing work back to the user
- do not introduce new frameworks or tooling unless explicitly requested
