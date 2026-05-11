#!/bin/sh
# Vault integration — knowledge base shell functions
# Source from zsh/bash configs alongside aliases.sh
# Vault: Obsidian-based knowledge management, synced via git

export VAULT="${VAULT:-$HOME/vault}"
VAULT_REMOTE="ssh://git@codeberg.org/lksbrk/obsidian-vault-jemsu.git"

# ── Dispatcher ────────────────────────────────────────────────────────────────
# v <cmd> [args...]  →  vault-<cmd> [args...]
v() {
  case "$1" in
    init)    shift; vault-init "$@" ;;
    note|n)  shift; vault-note "$@" ;;
    sync|s)  shift; vault-sync "$@" ;;
    status|st) shift; vault-status "$@" ;;
    grep|g)  shift; vault-grep "$@" ;;
    find|f)  shift; vault-find "$@" ;;
    search)  shift; vault-search "$@" ;;
    cd)      cd "$VAULT" ;;
    *)
      echo "v — vault commands"
      echo ""
      echo "  v init          Clone vault to $VAULT"
      echo "  v note [title]  Capture note to ingress (alias: v n)"
      echo "  v sync          Pull + commit + push (alias: v s)"
      echo "  v status        Git status (alias: v st)"
      echo "  v grep <pat>    Search notes (alias: v g)"
      echo "  v find          Browse notes with fzf (alias: v f)"
      echo "  v search        Search note contents with fzf"
      echo "  v cd            cd into vault"
      return 1
      ;;
  esac
}

# ── Init ──────────────────────────────────────────────────────────────────────
# Clone vault to ~/vault (or $VAULT)
vault-init() {
  if [ -d "$VAULT/.git" ] || [ -L "$VAULT/.git" ]; then
    echo "Vault already exists at $VAULT"
    vault-status
    return 0
  fi

  if [ -e "$VAULT" ]; then
    echo "$VAULT exists but is not a vault (no .git)" >&2
    return 1
  fi

  echo "Cloning vault to $VAULT..."
  git clone "$VAULT_REMOTE" "$VAULT" && \
    echo "Done. Vault ready at $VAULT"
}

# ── Note ──────────────────────────────────────────────────────────────────────
# Quick note capture into ingress
# Usage: vault-note "title"           → opens $EDITOR
#        vault-note "title" "content" → writes directly
#        vault-note                   → timestamped note, opens $EDITOR
vault-note() {
  if [ ! -d "$VAULT/ingress" ]; then
    echo "Vault not found at $VAULT/ingress" >&2
    echo "Run: v init" >&2
    return 1
  fi

  local ts
  ts=$(date '+%Y%m%d%H%M')
  local title="${1:-capture-$ts}"
  local slug
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  local file="$VAULT/ingress/${slug}.md"

  if [ -n "$2" ]; then
    cat > "$file" <<EOF
---
title: "$title"
tags:
  - ingress
created: $(date '+%Y-%m-%d')
machine: $(hostname -s)
---

$2
EOF
    echo "Created: $file"
  else
    cat > "$file" <<EOF
---
title: "$title"
tags:
  - ingress
created: $(date '+%Y-%m-%d')
machine: $(hostname -s)
---

EOF
    ${EDITOR:-nano} "$file"
  fi
}

# ── Sync ──────────────────────────────────────────────────────────────────────
# Pull + push vault changes
vault-sync() {
  if [ ! -d "$VAULT/.git" ] && [ ! -L "$VAULT/.git" ]; then
    echo "No git repo at $VAULT" >&2
    return 1
  fi

  echo "Syncing vault..."
  git -C "$VAULT" pull --rebase --autostash origin main && \
  git -C "$VAULT" add -A && \
  git -C "$VAULT" diff --cached --quiet || \
    git -C "$VAULT" commit -m "vault-sync: $(hostname -s) $(date '+%Y-%m-%d %H:%M')" && \
  git -C "$VAULT" push origin main
  echo "Done."
}

# ── Status ────────────────────────────────────────────────────────────────────
vault-status() {
  if [ ! -d "$VAULT/.git" ] && [ ! -L "$VAULT/.git" ]; then
    echo "No git repo at $VAULT" >&2
    return 1
  fi

  echo "Vault: $VAULT"
  echo "Branch: $(git -C "$VAULT" branch --show-current)"
  echo ""
  git -C "$VAULT" status -s
}

# ── Grep ──────────────────────────────────────────────────────────────────────
vault-grep() {
  if [ -z "$1" ]; then
    echo "Usage: v grep <pattern>" >&2
    return 1
  fi

  if command -v rg >/dev/null 2>&1; then
    rg --type md "$@" "$VAULT"
  else
    grep -r --include='*.md' "$@" "$VAULT"
  fi
}

# ── Find ─────────────────────────────────────────────────────────────────────
# Browse vault notes by filename with fzf, open selection in $EDITOR
vault-find() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf required for vault-find" >&2
    return 1
  fi
  if [ ! -d "$VAULT" ]; then
    echo "Vault not found at $VAULT" >&2
    return 1
  fi

  local preview_cmd
  if command -v glow >/dev/null 2>&1; then
    preview_cmd='glow --style dark -- "$VAULT"/{}'
  elif command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --color=always --style=plain -- "$VAULT"/{}'
  else
    preview_cmd='cat -- "$VAULT"/{}'
  fi

  local initial_query="${1:-}"

  local selected
  if command -v fd >/dev/null 2>&1; then
    selected=$(fd --type f --extension md --exclude .git --exclude .obsidian . "$VAULT" | \
      sed "s|^$VAULT/||" | \
      fzf --scheme=path \
          --preview "$preview_cmd" \
          --preview-window=right:60% \
          --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up' \
          --header='ctrl-d/u: scroll preview' \
          --prompt="vault> " \
          --query="$initial_query") || return 0
  else
    selected=$(find "$VAULT" -name '*.md' -not -path '*/.git/*' -not -path '*/.obsidian/*' -type f | \
      sed "s|^$VAULT/||" | \
      sort | \
      fzf --scheme=path \
          --preview "$preview_cmd" \
          --preview-window=right:60% \
          --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up' \
          --header='ctrl-d/u: scroll preview' \
          --prompt="vault> " \
          --query="$initial_query") || return 0
  fi

  ${EDITOR:-vi} "$VAULT/$selected"
}

# ── Search ───────────────────────────────────────────────────────────────────
# Search vault note contents with ripgrep + fzf, open selection in $EDITOR
vault-search() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf required for vault-search" >&2
    return 1
  fi
  if ! command -v rg >/dev/null 2>&1; then
    echo "ripgrep (rg) required for vault-search" >&2
    return 1
  fi
  if [ ! -d "$VAULT" ]; then
    echo "Vault not found at $VAULT" >&2
    return 1
  fi

  local initial_query="${1:-}"

  local result
  result=$(rg --type md --line-number --color=never --smart-case \
    "${initial_query:-.}" "$VAULT" 2>/dev/null | \
    sed "s|^$VAULT/||" | \
    fzf --exact \
        --delimiter=: \
        --preview 'bat --color=always --style=plain --highlight-line {2} -- "$VAULT"/{1} 2>/dev/null || cat -- "$VAULT"/{1}' \
        --preview-window=right:60%:+{2}-10 \
        --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up' \
        --header='ctrl-d/u: scroll preview' \
        --prompt="search> " \
        --query="$initial_query") || return 0

  local file
  file=$(printf '%s' "$result" | cut -d: -f1)
  local line
  line=$(printf '%s' "$result" | cut -d: -f2)

  # Open at the matching line if editor supports it
  case "${EDITOR:-vi}" in
    *vim*|*nvim*) ${EDITOR:-vi} "+$line" "$VAULT/$file" ;;
    *hx*|*helix*) ${EDITOR:-vi} "$VAULT/$file:$line" ;;
    *micro*)      ${EDITOR:-vi} "$VAULT/$file" -startpos "$line,0" ;;
    *)            ${EDITOR:-vi} "$VAULT/$file" ;;
  esac
}
