#!/usr/bin/env bash

set -euo pipefail

target_pane_id=${1:?missing target pane id}
tab_id=${2:?missing tab id}
current_title=${3-}
hint_row=$'hint\tClear text for automatic title'

restore_focus=1

cleanup() {
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

emit_rename() {
  local payload encoded
  payload=$1
  encoded=$(printf '%s' "${payload}" | base64 | tr -d '\n')
  printf '\033]1337;SetUserVar=%s=%s\007' 'WEZTERM_TAB_RENAME' "${encoded}"
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

zoom_self

if ! result=$(
  printf '%s\n' "${hint_row}" | fzf \
    --ansi \
    --bind='enter:print-query+accept,esc:abort' \
    --border=rounded \
    --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330' \
    --delimiter=$'\t' \
    --disabled \
    --header='Edit tab name  Enter save  Esc cancel  Clear text for automatic' \
    --height='100%' \
    --info=hidden \
    --layout=reverse \
    --margin='4%,14%' \
    --no-sort \
    --padding='1,2' \
    --pointer='>' \
    --prompt='Rename > ' \
    --query="${current_title}" \
    --with-nth='2'
); then
  exit 0
fi

new_title=${result%%$'\n'*}

if [[ "${result}" == "${hint_row}" || "${new_title}" == "${hint_row}" ]]; then
  new_title=""
fi

wezterm cli set-tab-title --tab-id "${tab_id}" "${new_title}" >/dev/null 2>&1 || true

restore_focus=0
wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
emit_rename "${target_pane_id}|${tab_id}|${new_title}"
sleep 0.05
