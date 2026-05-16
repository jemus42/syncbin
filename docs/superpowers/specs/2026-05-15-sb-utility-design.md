# Design: `sb` — Syncbin Utility Wrapper

## Summary

Shell function dispatcher for common syncbin operations across machines. Mirrors the `v` (vault) pattern: shell function in a sourced file, case-statement routing, short aliases.

## Location

`packages/shell/.config/syncbin/sb.sh` — sourced by zsh and bash via the existing syncbin loader.

## Subcommands

| Command | Alias | Description |
|---|---|---|
| `sb pull` | `sb pl` | `git -C $SYNCBIN pull --recurse-submodules` — fetch latest changes |
| `sb sync` | `sb s` | Pull + run `$SYNCBIN/install.sh -y` — full sync with stow |
| `sb push` | `sb p` | Stage all, interactive commit, push |
| `sb status` | `sb st` | `git -C $SYNCBIN status` then `syncbin-doctor` |
| `sb cd` | — | `cd $SYNCBIN` |
| `sb doctor` | `sb dr` | Run `syncbin-doctor` |
| `sb log` | `sb l` | `git -C $SYNCBIN log --oneline -15` |
| `sb diff` | `sb d` | `git -C $SYNCBIN diff` |
| `sb` (no args) | — | Print help |

## Behavior Details

### `sb pull`

```sh
git -C "$SYNCBIN" pull --recurse-submodules
```

Most common operation during maintenance. No stow, no install.sh.

### `sb sync`

```sh
git -C "$SYNCBIN" pull --recurse-submodules
"$SYNCBIN/install.sh" -y
```

Uses `-y` for non-interactive mode. Stow is idempotent — safe to auto-accept.

### `sb push`

```sh
git -C "$SYNCBIN" add -A
git -C "$SYNCBIN" status
git -C "$SYNCBIN" commit  # opens $EDITOR for message
git -C "$SYNCBIN" push
```

Shows status after staging so user sees what's going in. Opens editor for commit message — no blind commits. If commit is aborted (empty message), push is skipped.

### `sb status`

```sh
git -C "$SYNCBIN" status
syncbin-doctor
```

Git status first (quick), then doctor (thorough).

### `sb cd`

```sh
cd "$SYNCBIN"
```

Requires shell function (not standalone script) to affect parent shell.

### `sb doctor`

Delegates to existing `syncbin-doctor` script. No wrapper logic needed.

### `sb log`

```sh
git -C "$SYNCBIN" log --oneline -15
```

### `sb diff`

```sh
git -C "$SYNCBIN" diff
```

## Dependencies

- `$SYNCBIN` env var (already set by shell config loader)
- `syncbin-doctor` (already in `~/.local/bin/`)
- `git` (assumed available everywhere syncbin runs)

## Shell Sourcing

The file needs explicit sourcing in both shell configs, same as `vault.sh`:

- `packages/shell/.config/zsh/config/04-aliases.zsh` — add source line
- `packages/shell/.config/bash/config/02-aliases.bash` — add source line

Pattern: `[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/sb.sh"`

## Out of Scope

- Per-package stow/unstow — low frequency, use stow directly
- Drift detection (comparing ~/ vs packages/) — stow symlinks make this moot
- Editor integration — micro doesn't open directories usefully
- Machine-specific subcommands — keep it universal

## Testing

After implementation:
1. `sb` — prints help
2. `sb st` — shows git status + doctor output
3. `sb pl` — pulls (may be no-op if up to date)
4. `sb cd` — changes directory to $SYNCBIN
5. `sb log` — shows recent commits
6. Verify sourced in both zsh and bash: `type sb`
