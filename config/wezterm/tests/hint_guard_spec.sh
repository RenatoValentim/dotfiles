#!/usr/bin/env bash

set -euo pipefail

pass=0
fail=0

assert_eq() {
  local desc=$1 expected=$2 actual=$3
  if [[ "${actual}" == "${expected}" ]]; then
    printf 'ok - %s\n' "${desc}"
    pass=$((pass + 1))
  else
    printf 'not ok - %s\n' "${desc}"
    printf '  expected: %q\n' "${expected}"
    printf '  actual:   %q\n' "${actual}"
    fail=$((fail + 1))
  fi
}

# ---------------------------------------------------------------------------
# Helpers under test (copied from each script to keep scripts standalone)
# ---------------------------------------------------------------------------

trim_query() {
  local value
  value=$1
  value=${value#"${value%%[![:space:]]*}"}
  value=${value%"${value##*[![:space:]]}"}
  printf '%s' "${value}"
}

# Simulates what wezterm-tab-rename.sh does with an fzf result
tab_rename_extract() {
  local result=$1 hint_row=$2
  local new_title
  new_title=${result%%$'\n'*}
  if [[ "${result}" == "${hint_row}" || "${new_title}" == "${hint_row}" ]]; then
    new_title=""
  fi
  printf '%s' "${new_title}"
}

# Simulates what wezterm-workspace-picker.sh does with an fzf result
workspace_extract() {
  local result=$1 hint_row=$2
  local workspace_name
  workspace_name=$(trim_query "${result%%$'\n'*}")
  if [[ -z "${workspace_name}" || "${result%%$'\n'*}" == "${hint_row}" ]]; then
    printf '__EMPTY__'
    return
  fi
  printf '%s' "${workspace_name}"
}

# ---------------------------------------------------------------------------
# wezterm-tab-rename.sh — hint_row guard
# ---------------------------------------------------------------------------

hint_rename=$'hint\tClear text for automatic title'

# fzf may return only the hint_row (empty query, no leading newline)
assert_eq \
  "tab-rename: empty query returns only hint_row → clears title" \
  "" \
  "$(tab_rename_extract "${hint_rename}" "${hint_rename}")"

# fzf returns query + hint_row (normal path)
assert_eq \
  "tab-rename: user typed name → returns name" \
  "my-tab" \
  "$(tab_rename_extract $'my-tab\n'"${hint_rename}" "${hint_rename}")"

# user cleared the field → empty query, result starts with newline
assert_eq \
  "tab-rename: cleared query (leading newline) → empty title" \
  "" \
  "$(tab_rename_extract $'\n'"${hint_rename}" "${hint_rename}")"

# whitespace-only query must not leak hint
assert_eq \
  "tab-rename: whitespace-only query → whitespace title (not filtered, expected behaviour)" \
  "   " \
  "$(tab_rename_extract $'   \n'"${hint_rename}" "${hint_rename}")"

# ---------------------------------------------------------------------------
# wezterm-workspace-picker.sh — create/rename hint_row guard
# ---------------------------------------------------------------------------

hint_workspace=$'hint\tWorkspace names cannot be empty'

assert_eq \
  "workspace: empty query returns only hint_row → aborts" \
  "__EMPTY__" \
  "$(workspace_extract "${hint_workspace}" "${hint_workspace}")"

assert_eq \
  "workspace: user typed name → returns name" \
  "dev" \
  "$(workspace_extract $'dev\n'"${hint_workspace}" "${hint_workspace}")"

assert_eq \
  "workspace: cleared query (leading newline) → aborts" \
  "__EMPTY__" \
  "$(workspace_extract $'\n'"${hint_workspace}" "${hint_workspace}")"

assert_eq \
  "workspace: whitespace-only query → aborts (trim_query collapses to empty)" \
  "__EMPTY__" \
  "$(workspace_extract $'   \n'"${hint_workspace}" "${hint_workspace}")"

assert_eq \
  "workspace: name with surrounding whitespace → trimmed name" \
  "my workspace" \
  "$(workspace_extract $'  my workspace  \n'"${hint_workspace}" "${hint_workspace}")"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

total=$((pass + fail))
printf '%d/%d tests passed\n' "${pass}" "${total}"

if [[ ${fail} -gt 0 ]]; then
  exit 1
fi
