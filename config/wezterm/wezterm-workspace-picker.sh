#!/usr/bin/env bash

set -euo pipefail

target_pane_id=${1:?missing target pane id}
mode=${2:?missing workspace mode}
shift 2 || true

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

emit_workspace_action() {
  local payload encoded
  payload=$1
  encoded=$(printf '%s' "${payload}" | base64 | tr -d '\n')
  printf '\033]1337;SetUserVar=%s=%s\007' 'WEZTERM_WORKSPACE_ACTION' "${encoded}"
}

zoom_self() {
  if [[ -n "${WEZTERM_PANE:-}" ]]; then
    wezterm cli zoom-pane --pane-id "${WEZTERM_PANE}" --zoom >/dev/null 2>&1 || true
  fi
}

activate_target_and_emit() {
  local payload
  payload=$1

  restore_focus=0
  wezterm cli activate-pane --pane-id "${target_pane_id}" >/dev/null 2>&1 || true
  emit_workspace_action "${payload}"
  sleep 0.05
}

trim_query() {
  local value
  value=$1
  value=${value#"${value%%[![:space:]]*}"}
  value=${value%"${value##*[![:space:]]}"}
  printf '%s' "${value}"
}

trap cleanup EXIT

if ! command -v fzf >/dev/null 2>&1; then
  printf 'fzf is not installed. Press Enter to close.'
  read -r _
  exit 1
fi

zoom_self

case "${mode}" in
  create)
    hint_row=$'hint\tWorkspace names cannot be empty'

    if ! result=$(
      printf '%s\n' "${hint_row}" | fzf \
        --ansi \
        --bind='enter:print-query+accept,esc:abort' \
        --border=rounded \
        --border-label=' New Workspace ' \
        --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330,label:#edb07d' \
        --delimiter=$'\t' \
        --disabled \
        --header='Type a workspace name  Enter create  Esc cancel' \
        --height='16%' \
        --info=hidden \
        --layout=reverse \
        --margin='30%,22%' \
        --no-sort \
        --padding='1,2' \
        --pointer='>' \
        --prompt='Workspace > ' \
        --with-nth='2'
    ); then
      exit 0
    fi

    workspace_name=$(trim_query "${result%%$'\n'*}")
    if [[ -z "${workspace_name}" ]]; then
      exit 0
    fi

    activate_target_and_emit "${target_pane_id}|create|${workspace_name}"
    ;;

  rename)
    current_workspace=${1:-}
    hint_row=$'hint\tWorkspace names cannot be empty'

    if ! result=$(
      printf '%s\n' "${hint_row}" | fzf \
        --ansi \
        --bind='enter:print-query+accept,esc:abort' \
        --border=rounded \
        --border-label=' Rename Workspace ' \
        --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330,label:#edb07d' \
        --delimiter=$'\t' \
        --disabled \
        --header='Edit workspace name  Enter save  Esc cancel' \
        --height='16%' \
        --info=hidden \
        --layout=reverse \
        --margin='30%,22%' \
        --no-sort \
        --padding='1,2' \
        --pointer='>' \
        --prompt='Rename > ' \
        --query="${current_workspace}" \
        --with-nth='2'
    ); then
      exit 0
    fi

    workspace_name=$(trim_query "${result%%$'\n'*}")
    if [[ -z "${workspace_name}" ]]; then
      exit 0
    fi

    activate_target_and_emit "${target_pane_id}|rename|${current_workspace}|${workspace_name}"
    ;;

  switch)
    current_workspace=${1-}
    shift || true

    if [[ $# -eq 0 ]]; then
      printf 'No workspaces found. Press Enter to close.'
      read -r _
      exit 1
    fi

    selected=$(
      printf '%s\n' "$@" | fzf \
        --ansi \
        --bind='esc:abort' \
        --border=rounded \
        --border-label=' Workspaces ' \
        --color='bg:#1f2330,bg+:#232733,fg:#e2e9ff,fg+:#e2e9ff,hl:#edb07d,hl+:#edb07d,border:#6b7089,header:#8b92ad,prompt:#8b92ad,pointer:#9cafeb,spinner:#9cafeb,info:#8b92ad,gutter:#1f2330,label:#edb07d' \
        --delimiter=$'\t' \
        --header='Type to search  Enter switch  Esc cancel' \
        --height='100%' \
        --info=hidden \
        --layout=reverse \
        --margin='4%,14%' \
        --no-sort \
        --padding='1,2' \
        --pointer='>' \
        --prompt='Workspace > ' \
        --with-nth='3..'
    ) || true

    if [[ -z "${selected}" ]]; then
      exit 0
    fi

    workspace_name=${selected%%$'\t'*}
    activate_target_and_emit "${target_pane_id}|switch|${workspace_name}"
    ;;

  *)
    printf 'Unknown workspace mode: %s\n' "${mode}" >&2
    exit 2
    ;;
esac
