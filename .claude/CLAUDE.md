# Syncbin — Agent Instructions

Personal dotfiles at ~/syncbin, symlinked into place. Cross-machine sync for macOS, Ubuntu, Rocky Linux.

## Priorities

- **zsh**: primary shell, full support, always update
- **bash**: supported, keep in sync with zsh for cross-shell features
- **fish**: low priority experimental, update optionally
- Cross-shell changes must update both zsh and bash (fish optional)

## Rules

- Machine-specific config goes in `~/.config/syncbin/`, never in tracked files
- Completions: prefer carapace spec (`carapace/specs/`) over shell-specific
- Source files end with newline
- Use `command -v` checks before depending on optional tools
- Check `docs/roadmap.md` before adding or removing features/tools

## References

- `docs/architecture.md` — how everything works (load order, patterns, recipes)
- `docs/roadmap.md` — what's active, stale, and planned
- `dependencies.yaml` — tool manifest
- `README.md` — human-facing overview
