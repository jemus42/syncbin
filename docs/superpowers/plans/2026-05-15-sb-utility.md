# `sb` Utility Wrapper Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an `sb` shell function dispatcher for common syncbin operations (pull, sync, push, status, diff, log, cd, doctor).

**Architecture:** Single file `packages/shell/.config/syncbin/sb.sh` containing an `sb()` dispatcher function and `sb-*` helper functions. Sourced explicitly in both zsh and bash alias config files, same pattern as `vault.sh`.

**Tech Stack:** POSIX-compatible shell (sh), GNU stow, git

---

## File Structure

| File | Action | Responsibility |
|---|---|---|
| `packages/shell/.config/syncbin/sb.sh` | Create | Dispatcher + all sb-* functions |
| `packages/shell/.config/zsh/config/04-aliases.zsh` | Modify (line 8) | Add source line for sb.sh |
| `packages/shell/.config/bash/config/02-aliases.bash` | Modify (line 8) | Add source line for sb.sh |

---

### Task 1: Create `sb.sh` with dispatcher and all subcommands

**Files:**
- Create: `packages/shell/.config/syncbin/sb.sh`

- [ ] **Step 1: Create the sb.sh file**

```sh
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
```

- [ ] **Step 2: Commit**

```bash
git add packages/shell/.config/syncbin/sb.sh
git commit -m "feat: add sb utility wrapper for syncbin operations"
```

---

### Task 2: Source sb.sh in zsh and bash configs

**Files:**
- Modify: `packages/shell/.config/zsh/config/04-aliases.zsh:8`
- Modify: `packages/shell/.config/bash/config/02-aliases.bash:8`

- [ ] **Step 1: Add source line to zsh aliases**

After the existing vault.sh source line (line 8), add:

```zsh
# Load syncbin utility wrapper
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh"
```

- [ ] **Step 2: Add source line to bash aliases**

After the existing vault.sh source line (line 8), add:

```bash
# Load syncbin utility wrapper
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh"
```

- [ ] **Step 3: Commit**

```bash
git add packages/shell/.config/zsh/config/04-aliases.zsh packages/shell/.config/bash/config/02-aliases.bash
git commit -m "feat: source sb.sh in zsh and bash configs"
```

---

### Task 3: Verify

- [ ] **Step 1: Re-stow shell package**

```bash
stow -d ~/syncbin/packages -t ~ -R shell
```

- [ ] **Step 2: Source in current shell and test**

```bash
source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh"

# Help output
sb

# Function exists
type sb

# Git operations
sb log
sb status
sb diff

# cd works
sb cd
pwd  # should print $SYNCBIN
```

- [ ] **Step 3: Verify bash sourcing**

```bash
bash -l -c 'type sb'
```
