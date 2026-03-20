# Repository Guidelines

## Project Structure & Module Organization

- `config/`: primary dotfiles, intended to be linked into `~/.config` (XDG).
  - `config/fish/`: Fish shell config (`config.fish`, `conf.d/`, `functions/`, completions).
  - `config/wezterm/`: WezTerm config (Lua; modular config under `config/wezterm/config/`, tests under `config/wezterm/tests/`).
  - `config/lazygit/`: Lazygit config (YAML).
  - `config/lazyvim/`: Neovim config (LazyVim; Lua, formatted with StyLua).
  - `config/RootNvim/`: alternate Neovim config (Lua).
- `scripts/`: repo tooling (currently `scripts/check.sh`).
- `.github/workflows/ci.yml`: CI runs `./scripts/check.sh`.

## Build, Test, and Development Commands

- `./scripts/check.sh`: runs local checks (Fish syntax, WezTerm helper Bash syntax, StyLua on LazyVim and WezTerm, and WezTerm Lua tests).
- `CHECK_NVIM=1 ./scripts/check.sh`: additionally smoke-tests Neovim headlessly (requires `nvim`).

Quick install (symlink what you use):
- `ln -s "$PWD/config/fish" ~/.config/fish`
- `ln -s "$PWD/config/lazyvim" ~/.config/nvim`

## Coding Style & Naming Conventions

- Shell: use `bash` with `set -euo pipefail`; keep scripts POSIX-ish unless Bash features are needed.
- Fish: keep all `*.fish` files passing `fish -n` (CI enforces this).
- Lua (Neovim/WezTerm): format with StyLua. Repo settings: 2-space indent, 120 columns (`config/lazyvim/stylua.toml`) apply to both `config/lazyvim` and `config/wezterm`.
- Language: keep comments and user-facing strings in English for consistency.
- Local-only overrides: use untracked “local” files (examples already ignored):
  - `config/fish/conf.d/local.fish`
  - `config/lazygit/config.local.yml`

## Testing Guidelines

Treat `./scripts/check.sh` and CI as the quality gate. WezTerm has lightweight Lua tests in `config/wezterm/tests/`. Add new checks to `scripts/check.sh` when introducing new languages/tools.

## Commit & Pull Request Guidelines

- Commit history may be sparse; prefer Conventional Commits going forward (e.g., `feat(fish): …`, `fix(wezterm): …`, `chore(ci): …`).
- PRs should include: what changed, which config(s) it affects, and how you validated (e.g., `./scripts/check.sh`, manual app reload steps).
- Don’t commit secrets; keep sensitive values in local override files or external secret stores.
