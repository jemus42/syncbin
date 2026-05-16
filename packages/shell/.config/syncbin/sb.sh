#!/bin/sh
# Syncbin utility — common operations wrapper
# Source from zsh/bash configs alongside vault.sh

# ── Dispatcher ────────────────────────────────────────────────────────────────
# sb <cmd> [args...]  →  sb-<cmd> [args...]
sb() {
  if [ -z "$SYNCBIN" ]; then
    echo "sb: \$SYNCBIN not set" >&2
    return 1
  fi

  case "$1" in
    pull|pl)   shift; sb-pull "$@" ;;
    sync|s)    shift; sb-sync "$@" ;;
    push|p)    shift; sb-push "$@" ;;
    status|st) shift; sb-status "$@" ;;
    cd)        cd "$SYNCBIN" ;;
    doctor|dr) shift; sb-doctor "$@" ;;
    log|l)     shift; sb-log "$@" ;;
    diff|d)    shift; sb-diff "$@" ;;
    *)
      echo "sb — syncbin commands"
      echo ""
      echo "  sb pull        Pull latest changes (alias: sb pl)"
      echo "  sb sync        Pull + install.sh -y (alias: sb s)"
      echo "  sb push        Stage, commit, push (alias: sb p)"
      echo "  sb status      Git status + doctor (alias: sb st)"
      echo "  sb cd          cd into \$SYNCBIN"
      echo "  sb doctor      Run syncbin-doctor (alias: sb dr)"
      echo "  sb log         Recent commits (alias: sb l)"
      echo "  sb diff        Git diff (alias: sb d)"
      return 1
      ;;
  esac
}

# ── Pull ──────────────────────────────────────────────────────────────────────
# Fetch latest changes, no stow/install
sb-pull() {
  git -C "$SYNCBIN" pull --recurse-submodules
}

# ── Sync ──────────────────────────────────────────────────────────────────────
# Pull + run install.sh (full sync with stow)
sb-sync() {
  git -C "$SYNCBIN" pull --recurse-submodules && \
    "$SYNCBIN/install.sh" -y
}

# ── Push ──────────────────────────────────────────────────────────────────────
# Stage all, show status, interactive commit, push
sb-push() {
  git -C "$SYNCBIN" add -A
  echo ""
  git -C "$SYNCBIN" status
  echo ""
  git -C "$SYNCBIN" commit || return 1
  git -C "$SYNCBIN" push
}

# ── Status ────────────────────────────────────────────────────────────────────
sb-status() {
  git -C "$SYNCBIN" status
  echo ""
  if command -v syncbin-doctor >/dev/null 2>&1; then
    syncbin-doctor
  else
    echo "syncbin-doctor not found in PATH" >&2
  fi
}

# ── Doctor ────────────────────────────────────────────────────────────────────
sb-doctor() {
  if command -v syncbin-doctor >/dev/null 2>&1; then
    syncbin-doctor
  else
    echo "syncbin-doctor not found in PATH" >&2
    return 1
  fi
}

# ── Log ───────────────────────────────────────────────────────────────────────
sb-log() {
  git -C "$SYNCBIN" log --oneline -15
}

# ── Diff ──────────────────────────────────────────────────────────────────────
sb-diff() {
  git -C "$SYNCBIN" diff
}
