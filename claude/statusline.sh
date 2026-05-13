#!/usr/bin/env bash
# Claude Code statusline — receives JSON on stdin
# Displays: model | context usage bar | cost | git branch

set -euo pipefail

data=$(cat)

# Extract fields with jq
model=$(printf '%s' "$data" | jq -r '.model.display_name // "unknown"')
ctx_pct=$(printf '%s' "$data" | jq -r '.context_window.used_percentage // 0')
cost=$(printf '%s' "$data" | jq -r '.cost.total_cost_usd // 0')

# Context bar (20 chars wide)
bar_width=20
filled=$(printf '%.0f' "$(echo "$ctx_pct * $bar_width / 100" | bc -l 2>/dev/null || echo 0)")
[ "$filled" -gt "$bar_width" ] 2>/dev/null && filled=$bar_width
[ "$filled" -lt 0 ] 2>/dev/null && filled=0
empty=$((bar_width - filled))

bar=""
i=0; while [ $i -lt "$filled" ]; do bar="${bar}█"; i=$((i+1)); done
i=0; while [ $i -lt "$empty" ]; do bar="${bar}░"; i=$((i+1)); done

# Color context bar based on usage
if [ "$(echo "$ctx_pct > 80" | bc -l 2>/dev/null || echo 0)" = "1" ]; then
  bar_color="\033[31m"  # red
elif [ "$(echo "$ctx_pct > 60" | bc -l 2>/dev/null || echo 0)" = "1" ]; then
  bar_color="\033[33m"  # yellow
else
  bar_color="\033[32m"  # green
fi
reset="\033[0m"

# Format cost
cost_fmt=$(printf '$%.2f' "$cost")

# Git branch (fast, no caching needed)
branch=""
if git_branch=$(git branch --show-current 2>/dev/null) && [ -n "$git_branch" ]; then
  branch=" 󰘬 ${git_branch}"
fi

# Format context percentage
ctx_fmt=$(printf '%.0f%%' "$ctx_pct")

printf "%s │ ${bar_color}%s${reset} %s │ %s%s" \
  "$model" "$bar" "$ctx_fmt" "$cost_fmt" "$branch"
