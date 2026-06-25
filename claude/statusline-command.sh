#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
short_dir=$(basename "$cwd")

# Context window
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Tokens used (input + output from last call)
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

# Rate limits (Claude.ai subscription)
five_hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hr_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Git branch (skip optional locks, fail silently if not a repo)
git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)

# Separator (dim white)
SEP=$(printf ' \033[2;37m»\033[0m ')

# --- Build parts ---

# Model (cyan) with ✦ icon, effort appended in dim when present
if [ -n "$effort" ]; then
  part_model=$(printf '\033[0;36m✦ %s\033[0m \033[2;36m[%s]\033[0m' "$model" "$effort")
else
  part_model=$(printf '\033[0;36m✦ %s\033[0m' "$model")
fi

# Dir (yellow) with  icon
part_dir=$(printf '\033[0;33m %s\033[0m' "$short_dir")

# Git branch (magenta) with  icon — only when available
part_branch=""
if [ -n "$git_branch" ]; then
  part_branch=$(printf '\033[0;35m %s\033[0m' "$git_branch")
fi

# Context usage with 📊 icon
part_ctx=""
if [ -n "$used_pct" ]; then
  ctx_label=$(printf "📊 ctx:%.0f%%" "$used_pct")
  rem_int=$(printf '%.0f' "${remaining_pct:-100}" 2>/dev/null || echo 100)
  if [ "$rem_int" -le 20 ] 2>/dev/null; then
    part_ctx=$(printf '\033[0;31m%s\033[0m' "$ctx_label")
  else
    part_ctx=$(printf '\033[0;32m%s\033[0m' "$ctx_label")
  fi
fi

# Tokens used (compact: e.g. "🪙 tok:12k/1k")
part_tokens=""
if [ -n "$total_input" ] && [ -n "$total_output" ]; then
  fmt_k() {
    local n=$1
    if [ "$n" -ge 1000 ] 2>/dev/null; then
      printf "%.0fk" "$(echo "scale=1; $n / 1000" | bc)"
    else
      printf "%d" "$n"
    fi
  }
  in_str=$(fmt_k "$total_input")
  out_str=$(fmt_k "$total_output")
  part_tokens=$(printf '\033[0;37m🪙 tok:%s/%s\033[0m' "$in_str" "$out_str")
fi

# Format reset time (hours): epoch → "HH:MM" local or "Xm" if <1h away
fmt_reset_time() {
  local ts="$1"
  [ -z "$ts" ] && return
  local now diff_sec
  now=$(date +%s)
  diff_sec=$(( ts - now ))
  if [ "$diff_sec" -le 0 ]; then
    printf "now"
  elif [ "$diff_sec" -lt 3600 ]; then
    printf "%dm" "$(( diff_sec / 60 ))"
  else
    printf "%s" "$(date -d "@$ts" +%H:%M 2>/dev/null)"
  fi
}

# Format reset countdown (days): epoch → "Xd" or "hoje"
fmt_reset_date() {
  local ts="$1"
  [ -z "$ts" ] && return
  local now diff_sec diff_days
  now=$(date +%s)
  diff_sec=$(( ts - now ))
  if [ "$diff_sec" -le 0 ]; then
    printf "hoje"
  else
    diff_days=$(( (diff_sec + 86399) / 86400 ))
    printf "%dd" "$diff_days"
  fi
}

# Rate limits (only when present) with ⚡ icon
part_limits=""
limits_str=""
if [ -n "$five_hr" ]; then
  reset_str=$(fmt_reset_time "$five_hr_reset")
  if [ -n "$reset_str" ]; then
    limits_str=$(printf "Usage: 5h(%.0f%%) / Reset: %s" "$five_hr" "$reset_str")
  else
    limits_str=$(printf "Usage: 5h(%.0f%%)" "$five_hr")
  fi
fi
if [ -n "$seven_day" ]; then
  reset_str=$(fmt_reset_date "$seven_day_reset")
  if [ -n "$reset_str" ]; then
    wk=$(printf "Usage: 7d(%.0f%%) / Reset: %s" "$seven_day" "$reset_str")
  else
    wk=$(printf "Usage: 7d(%.0f%%)" "$seven_day")
  fi
  limits_str="${limits_str:+$limits_str | }$wk"
fi
if [ -n "$limits_str" ]; then
  part_limits=$(printf '\033[0;37m⚡ %s\033[0m' "$limits_str")
fi

# Logged-in user email (dim white) — read live from Claude account config
user_email=$(jq -r '.oauthAccount.emailAddress // empty' "$HOME/.claude.json" 2>/dev/null)
part_email=""
if [ -n "$user_email" ]; then
  part_email=$(printf '\033[2;37m%s\033[0m' "$user_email")
fi

# --- Assemble line with » separators ---
line="$part_model"
[ -n "$part_email" ]   && line="${line}${SEP}${part_email}"
line="${line}${SEP}${part_dir}"
[ -n "$part_branch" ]  && line="${line}${SEP}${part_branch}"
[ -n "$part_ctx" ]     && line="${line}${SEP}${part_ctx}"
[ -n "$part_tokens" ]  && line="${line}${SEP}${part_tokens}"
[ -n "$part_limits" ]  && line="${line}${SEP}${part_limits}"

printf '%s\n' "$line"
