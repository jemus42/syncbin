#!/bin/sh
# Vault integration — knowledge base shell functions
# Source from zsh/bash configs alongside aliases.sh
# Vault: Obsidian-based knowledge management, synced via git

export VAULT="${VAULT:-$HOME/vault}"

# Quick note capture into ingress
# Usage: vault-note "title"           → opens $EDITOR
#        vault-note "title" "content" → writes directly
#        vault-note                   → timestamped note, opens $EDITOR
vault-note() {
  if [ ! -d "$VAULT/ingress" ]; then
    echo "Vault not found at $VAULT/ingress" >&2
    echo "Set \$VAULT or clone to ~/vault" >&2
    return 1
  fi

  local ts
  ts=$(date '+%Y%m%d%H%M')
  local title="${1:-capture-$ts}"
  local slug
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  local file="$VAULT/ingress/${slug}.md"

  if [ -n "$2" ]; then
    # Direct write mode
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
    # Editor mode — create template, open editor
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

# Show vault status
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

# Search vault notes by content
vault-grep() {
  if [ -z "$1" ]; then
    echo "Usage: vault-grep <pattern>" >&2
    return 1
  fi

  if command -v rg >/dev/null 2>&1; then
    rg --type md "$@" "$VAULT"
  else
    grep -r --include='*.md' "$@" "$VAULT"
  fi
}
