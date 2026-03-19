#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail=0

say() { printf '%s\n' "$*"; }

run() {
  say "+ $*"
  if ! "$@"; then
    fail=1
  fi
}

if command -v fish >/dev/null 2>&1; then
  say "==> fish: syntax check"
  while IFS= read -r -d '' file; do
    run fish -n "$file"
  done < <(find config/fish -type f -name '*.fish' -print0)
else
  say "==> fish: skipped (fish not installed)"
fi

say "==> bash: syntax check (WezTerm helper)"
run bash -n config/wezterm/wezterm-fzf-picker.sh

if command -v stylua >/dev/null 2>&1; then
  say "==> stylua: format check"
  run stylua --check --config-path config/lazyvim/stylua.toml config/lazyvim config/wezterm
else
  say "==> stylua: skipped (stylua not installed)"
fi

if command -v lua >/dev/null 2>&1; then
  say "==> wezterm: Lua tests"
  run lua config/wezterm/tests/run.lua
else
  say "==> wezterm: skipped (lua not installed)"
fi

if [[ "${CHECK_NVIM:-0}" == "1" ]]; then
  if command -v nvim >/dev/null 2>&1; then
    say "==> nvim: headless config smoke test (LazyVim)"
    nvim_state_dir="$(mktemp -d)"
    if command -v timeout >/dev/null 2>&1; then
      run env XDG_CONFIG_HOME="$ROOT_DIR/config" NVIM_APPNAME="lazyvim" XDG_STATE_HOME="$nvim_state_dir" timeout 30s nvim --headless "+qall"
    else
      run env XDG_CONFIG_HOME="$ROOT_DIR/config" NVIM_APPNAME="lazyvim" XDG_STATE_HOME="$nvim_state_dir" nvim --headless "+qall"
    fi
    rm -rf "$nvim_state_dir"
  else
    say "==> nvim: skipped (nvim not installed)"
  fi
else
  say "==> nvim: skipped (set CHECK_NVIM=1 to enable)"
fi

if [[ "$fail" -ne 0 ]]; then
  say "Checks failed."
  exit 1
fi

say "All checks passed."
