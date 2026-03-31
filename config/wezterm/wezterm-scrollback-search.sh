#!/usr/bin/env bash

set -euo pipefail

target_pane_id=${1:?missing target pane id}
scrollback_file=${2:?missing scrollback file}

restore_focus=1

cleanup() {
  rm -f "${scrollback_file}" 2>/dev/null || true

  if [[ -n "${WEZTERM_PANE:-}" ]]; then
    wezterm cli zoom-pane --pane-id "${WEZTERM_PANE}" --unzoom >/dev/null 2>&1 || true
  fi

  if [[ ${restore_focus} -eq 1 ]]; then
    wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
  fi

  if [[ -n "${WEZTERM_PANE:-}" ]]; then
    wezterm cli kill-pane --pane-id "${WEZTERM_PANE}" >/dev/null 2>&1 || true
  fi
}

zoom_self() {
  if [[ -n "${WEZTERM_PANE:-}" ]]; then
    wezterm cli zoom-pane --pane-id "${WEZTERM_PANE}" --zoom >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

if ! command -v fzf >/dev/null 2>&1; then
  printf 'fzf is not installed. Press Enter to close.'
  read -r _
  exit 1
fi

if [[ ! -f "${scrollback_file}" ]]; then
  printf 'Scrollback file not found. Press Enter to close.'
  read -r _
  exit 1
fi

zoom_self

selected=$(
  tac "${scrollback_file}" | grep -v '^[[:space:]]*$' | fzf \
    --ansi \
    --bind='esc:abort' \
    --border=rounded \
    --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330' \
    --header='Type to search  Enter copy  Esc close' \
    --height='100%' \
    --info=hidden \
    --layout=reverse \
    --margin='4%,14%' \
    --no-sort \
    --padding='1,2' \
    --pointer='>' \
    --prompt='Scrollback > '
) || true

if [[ -z "${selected}" ]]; then
  exit 0
fi

if command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "${selected}" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "${selected}" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
  printf '%s' "${selected}" | xsel --clipboard --input
fi

restore_focus=0
wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
