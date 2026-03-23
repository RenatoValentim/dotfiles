# AGENTS.md

Guidance for coding agents working in this repository.

## Scope
- This repo is a personal `LazyVim` configuration, not a general Lua app.
- The entrypoint is `init.lua`, which loads `lua/config/lazy.lua`.
- Most changes affect the Neovim experience for other projects opened in this
  editor, not behavior inside this repo itself.
- Prefer small, convention-friendly edits over broad rewrites.

## Repository layout
- `init.lua`: startup entrypoint.
- `lua/config/`: core overrides such as bootstrap, options, keymaps, and
  autocmds.
- `lua/plugins/`: lazy.nvim plugin specs and plugin-specific overrides.
- `lua/me/utils/`: local helper modules.
- `stylua.toml`: formatting rules for Lua files.
- `lazy-lock.json`: pinned plugin versions.
- `lazyvim.json`: LazyVim extras metadata.

## Commands

### Format
- Format the full repo with `stylua .`.
- Format one file with `stylua lua/plugins/oil-nvim.lua`.

### Lint
- No repo-local CLI linter is configured.
- Do not invent `luacheck`, `selene`, or other lint commands unless the user
  explicitly asks for that tooling.
- Lua language-server feedback is expected through `.neoconf.json` while using
  Neovim.

### Tests
- There is no repo-local automated test suite.
- There are no unit-test, integration-test, or test runner files in this repo.
- Do not claim tests passed unless you actually added and ran them.

### Single-test workflow
- There is no single-test command for this repository itself.
- This config does enable Neotest for projects edited with this Neovim setup.
- The Jest adapter in `lua/plugins/neotest.lua` uses the shell pattern
  `npm test -- <jest-args>`.
- Example single-file pattern for an external Jest project:
  `npm test -- path/to/test-file.test.ts`.
- Example single-test-name pattern for an external Jest project:
  `npm test -- path/to/test-file.test.ts -t "test name"`.
- Keep those commands scoped to Neotest integration, not this repository.

### Neovim validation
- Start Neovim normally with `nvim` when validating interactive behavior.
- Sync plugins headlessly after changing plugin specs or imports with
  `nvim --headless "+Lazy! sync" +qa`.
- Use headless startup as a smoke test after substantial config changes with
  `nvim --headless +qa`.

## File placement
- Put core editor settings in `lua/config/options.lua`.
- Put global keymaps in `lua/config/keymaps.lua`.
- Put autocmds in `lua/config/autocmds.lua`.
- Put plugin specs in `lua/plugins/`, usually one plugin or one topic per file.
- Put reusable helpers in `lua/me/utils/`.
- Avoid adding new top-level files unless they clearly belong there.

## Formatting conventions
- Follow `stylua.toml`: 2 spaces, spaces not tabs, and 120 column max.
- Let Stylua control line wrapping and multiline table layout.
- Keep files ASCII unless the file already uses justified Unicode, such as UI
  glyphs in plugin configuration.
- Use trailing commas in multiline tables when Stylua expects them.
- Keep blank lines intentional; avoid overly dense or overly sparse files.

## Imports and modules
- Prefer `require(...)` near the top of the file for local dependencies.
- Alias frequently used helpers into locals when it improves readability.
- Common examples in this repo are `local map = LazyVim.safe_keymap_set` and
  `local key_options = require("me.utils.keymap_options_config").set_keymap_options`.
- Return a plugin spec table directly from plugin files when possible.
- Use `local M = {}` and `return M` for helper modules that export functions.
- Keep module paths aligned with the directory structure.

## Plugin spec conventions
- Follow the lazy.nvim spec shape already used in `lua/plugins/`.
- Common keys here include `dependencies`, `opts`, `config`, `keys`, `lazy`,
  `event`, `cmd`, `enabled`, and `import`.
- Use `opts = { ... }` for straightforward static config.
- Use `opts = function(_, opts) ... end` when extending inherited defaults.
- Prefer small, focused plugin files over large mixed-purpose files.
- Preserve existing LazyVim extra imports in `lua/config/lazy.lua` unless the
  requested behavior changes.

## Naming conventions
- Prefer descriptive lowercase filenames.
- In `lua/plugins/`, follow the existing lowercase, plugin/topic-oriented naming
  style, often with hyphenated filenames.
- In helper modules, prefer snake_case names for files, locals, and functions.
- Use `M` as the exported module table when following the module pattern.
- Prefer clear locals such as `map`, `opts`, `detail`, or `key_options` over
  opaque abbreviations.

## Types and annotations
- This repo uses selective EmmyLua and Lua LS annotations, not exhaustive type
  coverage.
- Add annotations when they clarify complex tables, callback signatures, or
  plugin APIs.
- Good candidates are helper params and rich `opts` tables.
- Avoid noisy annotations on trivial locals.
- Keep annotations compatible with Lua LS expectations.

## Keymaps and options
- Prefer `LazyVim.safe_keymap_set` for general mappings.
- Provide a `desc` for user-facing mappings whenever practical.
- Reuse `lua/me/utils/keymap_options_config.lua` when its shared mapping options
  fit the change.
- Put broad mappings in `lua/config/keymaps.lua`.
- Put plugin-local mappings in a plugin spec's `keys` field or `config`
  callback when ownership is clearer there.
- Set editor options with `vim.opt`.
- Set globals with `vim.g`.
- Change machine-local paths carefully and only when the request requires it.

## Error handling and notifications
- Use explicit failure handling for startup-critical paths.
- Follow the bootstrap pattern in `lua/config/lazy.lua` for fatal startup
  failures: `vim.api.nvim_echo(...)` plus `os.exit(1)`.
- Use `vim.notify(...)` for user-visible runtime warnings.
- Keep autocmd and UI callbacks defensive and small.
- Avoid silently swallowing errors.
- Only introduce `pcall` when optional behavior can fail safely and the
  fallback is obvious.

## Comments and readability
- Keep comments sparse and useful.
- Prefer clear names and small functions over explanatory comments.
- Preserve comments that document plugin APIs, annotations, or non-obvious UI
  behavior.
- Do not add banner comments or redundant prose.

## Change strategy
- Preserve the existing LazyVim and lazy.nvim patterns.
- Avoid replacing personal customizations unless the user explicitly asks.
- Be careful with bootstrap, keymaps, plugin loading, and environment-specific
  settings; small edits can affect the full editor experience.
- If you change plugin specs, run the relevant Neovim validation commands.
- If you add helpers, keep them generic enough to justify their existence.

## Pre-handoff checklist
- Format touched Lua files with `stylua`.
- Mention any command you could not run.
- State clearly when no tests exist for the changed area.
- Call out Neovim validation steps when the change is interactive.
- Reference modified files directly in your final response.
