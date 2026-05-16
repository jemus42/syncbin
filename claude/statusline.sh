#!/usr/bin/env bash
# Claude Code statusline — receives JSON on stdin
# Displays: model | context usage bar | cost | rate limits | git branch | cwd

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

# Rate limits (conditional — only present for Pro/Max after first response)
rate_fmt=""
rate_5h=$(printf '%s' "$data" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$rate_5h" ]; then
  rate_7d=$(printf '%s' "$data" | jq -r '.rate_limits.seven_day.used_percentage // empty')
  r5=$(printf '%.0f' "$rate_5h")
  # Color: green <60, yellow 60-80, red >80
  if [ "$r5" -gt 80 ] 2>/dev/null; then
    r5_color="\033[31m"
  elif [ "$r5" -gt 60 ] 2>/dev/null; then
    r5_color="\033[33m"
  else
    r5_color="\033[32m"
  fi
  rate_fmt=" │ ${r5_color}5h:${r5}%${reset}"
  if [ -n "$rate_7d" ]; then
    r7=$(printf '%.0f' "$rate_7d")
    if [ "$r7" -gt 80 ] 2>/dev/null; then
      r7_color="\033[31m"
    elif [ "$r7" -gt 60 ] 2>/dev/null; then
      r7_color="\033[33m"
    else
      r7_color="\033[32m"
    fi
    rate_fmt="${rate_fmt} ${r7_color}7d:${r7}%${reset}"
  fi
fi

# Working directory (collapse $HOME to ~)
cwd=$(printf '%s' "$data" | jq -r '.cwd // empty')
if [ -n "$cwd" ]; then
  cwd="${cwd/#$HOME/\~}"
  cwd_fmt="  ${cwd}"
else
  cwd_fmt=""
fi

# Format context percentage
ctx_fmt=$(printf '%.0f%%' "$ctx_pct")

printf "%b" "${model} │ ${bar_color}${bar}${reset} ${ctx_fmt} │ ${cost_fmt}${rate_fmt}${branch}${cwd_fmt}"
