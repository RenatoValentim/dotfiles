#!/usr/bin/env bash

set -euo pipefail

target_pane_id=${1:?missing target pane id}
shift || true

restore_focus=1

cleanup() {
  if [[ ${restore_focus} -eq 1 ]]; then
    wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
  fi

  if [[ -n "${WEZTERM_PANE:-}" ]]; then
    wezterm cli kill-pane --pane-id "${WEZTERM_PANE}" >/dev/null 2>&1 || true
  fi
}

emit_action() {
  local payload encoded
  payload=$1
  encoded=$(printf '%s' "${payload}" | base64 | tr -d '\n')
  printf '\033]1337;SetUserVar=%s=%s\007' 'WEZTERM_KEYBINDING_PICKER' "${encoded}"
}

trap cleanup EXIT

if ! command -v fzf >/dev/null 2>&1; then
  printf 'fzf is not installed. Press Enter to close.'
  read -r _
  exit 1
fi

selected=$(
  printf '%s\n' "$@" | fzf \
    --ansi \
    --bind='esc:abort' \
    --border=rounded \
    --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330' \
    --delimiter=$'\t' \
    --header='Type to search  Enter run  Esc close' \
    --height='100%' \
    --info=hidden \
    --layout=reverse \
    --margin='4%,14%' \
    --no-sort \
    --padding='1,2' \
    --pointer='>' \
    --prompt='Search > ' \
    --with-nth='3..'
) || true

if [[ -z "${selected}" ]]; then
  exit 0
fi

action_id=${selected%%$'\t'*}
restore_focus=0

wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
emit_action "${target_pane_id}|${action_id}"
sleep 0.05
