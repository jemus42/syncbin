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
    cd)      cd "$VAULT" ;;
    *)
      echo "v — vault commands"
      echo ""
      echo "  v init          Clone vault to $VAULT"
      echo "  v note [title]  Capture note to ingress (alias: v n)"
      echo "  v sync          Pull + commit + push (alias: v s)"
      echo "  v status        Git status (alias: v st)"
      echo "  v grep <pat>    Search notes (alias: v g)"
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
