#!/usr/bin/env bash

set -euo pipefail

target_pane_id=${1:?missing target pane id}
window_id=${2:?missing window id}
cwd=${3-}
hint_row=$'hint\tLeave empty for the automatic title'

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
    --border-label=' New Tab ' \
    --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330,label:#edb07d' \
    --delimiter=$'\t' \
    --disabled \
    --header='Type a tab name  Enter create  Esc cancel' \
    --height='16%' \
    --info=hidden \
    --layout=reverse \
    --margin='30%,22%' \
    --no-sort \
    --padding='1,2' \
    --pointer='>' \
    --prompt='New Tab > ' \
    --with-nth='2'
); then
  exit 0
fi

tab_title=${result%%$'\n'*}

if [[ "${result}" == "${hint_row}" || "${tab_title}" == "${hint_row}" ]]; then
  tab_title=""
fi

restore_focus=0

if [[ -n "${cwd}" ]]; then
  new_pane_id=$(wezterm cli spawn --window-id "${window_id}" --cwd "${cwd}")
else
  new_pane_id=$(wezterm cli spawn --window-id "${window_id}")
fi

if [[ -n "${tab_title}" ]]; then
  wezterm cli set-tab-title --pane-id "${new_pane_id}" "${tab_title}" >/dev/null 2>&1 || true
fi

wezterm cli activate-pane --pane-id "${new_pane_id}" >/dev/null 2>&1 || true
sleep 0.05
