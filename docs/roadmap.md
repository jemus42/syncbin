# Syncbin Roadmap & Status

Last reviewed: 2026-05-15

## Actively Used

- zsh config — daily, all machines
- bash config — servers, fallback environments
- starship prompt — cross-shell, all machines
- iTerm2 — primary terminal on macOS (hotkey window)
- ghostty terminal — secondary terminal, exploring
- micro editor — primary terminal editor
- bat, btop, zellij — daily tools
- carapace completions — all shells
- fzf-tab — fzf-powered completion menu (zsh)
- R config (Rprofile, arf.toml) — daily R development
- WireGuard VPN helpers — regular use
- common aliases (git, docker, systemd) — daily
- bin/ utilities (extract, syncbin-doctor, upall) — regular use
- git config (gitconfig, gitignore, delta pager) — all machines

## Stale / Archival Candidates

| Item | Last meaningful edit | Reason | Status |
|------|---------------------|--------|--------|
| `rstudio/` | — | Replaced by Positron, but themes useful as reference for porting | Keep themes |
| `R/ColorScheme` | — | RStudio-specific, but useful theme reference | Keep as reference |
| `*/config/*-rstudio-server.*` | — | Still needed on servers? | Pending review |
| ~~`alacritty/`~~ | — | Removed 2026-05-15 | Done |
| `zed/` | — | Still in use? | Pending review |
| `bin/slacc`, `bin/sljobs`, `bin/slusage` | — | HPC-specific, still needed? | Pending review |
| ~~`screenrc`~~ | — | Removed 2026-05-15 | Done |

## Low Priority / Experimental

- **fish config** — curiosity-driven, not production use
- **nushell** — not started, potential future interest

## Future Directions

### Claude / AI Agent Config Syncing
**Status:** Partially implemented (2026-05-09)

**Done:**
- Global CLAUDE.md tracked in syncbin, symlinked to ~/.claude/
- Custom skills tracked in syncbin/claude/skills/, symlinked
- Shared statusline script, patched into settings.json via jq
- Statusline shows: model, context bar, cost, rate limits (5h/7d), git branch, cwd
- `claude-sync-skills` script for discovering and integrating skills from other machines
- R project template for reuse in project CLAUDE.md files

**Statusline candidates (available in JSON, not yet shown):**
- Effort level indicator (skipped — not actionable from statusline)
- Session diff stats (+lines/-lines)

**Deferred (requires private repo or separate solution):**
- settings.json full sync (contains machine-specific paths, plugin permissions)
- additionalDirectories paths are machine-specific
- Plugin config requires node.js (not available on all machines, e.g., HPC cluster)

### Git Config Syncing
**Status:** Done (2026-05-15)

Migrated `~/.gitconfig` to XDG-compliant `~/.config/git/config`, tracked in `packages/git/` via stow. Cleaned 13-year-old config: removed legit aliases, git-media filter, stale workflows. Machine-specific bits (credential helpers, GPG signing key, gpg program path) live in `~/.config/syncbin/gitconfig-local` via git's native `[include]`. Template at `docs/gitconfig-local.example`. Global gitignore at `~/.config/git/ignore` (XDG auto-discovery, no `core.excludesfile` needed). GPG strategy: one key per machine, each added to GitHub/GitLab.

### Positron
**Goal:** Track Positron editor configuration like other tools.

**Open questions:**
- Track extensions list? (equivalent of `code --list-extensions`)
- Track keybindings, settings.json?
- Where in syncbin structure? (`positron/`? `editors/positron/`?)
- Overlap with VS Code settings format — share or separate?

### Stow Migration
**Status:** Done (2026-05-14), verified on all platforms (2026-05-15)

Replaced manual symlink management with GNU stow. Configs reorganized into `packages/` directory with home-directory-mirroring structure. `install.sh` calls `stow` per-package instead of `safe_symlink`. Non-symlink operations (OMZ, submodules, TPM, Claude settings.json patch) remain in install.sh. Auto-detects and offers removal of pre-migration symlinks. Tested on macOS, Ubuntu, Rocky Linux (HPC).

### Completion System Expansion
- Add carapace specs for frequently-used tools without good completions
- Reduce shell-specific completions as carapace coverage grows
- Consider contributing specs upstream to carapace

### Cleanup Tasks
- Audit `bin/` scripts — identify unused, document purpose of keepers
- ~~Consolidate R REPL config~~ radian removed, arf.toml is primary
- ~~Remove deprecated legacy override file loading from 99-local.*~~ (done)
- ~~Remove zsh-syntax-highlighting submodule~~ (done)
- ~~Remove powerlevel10k submodule and p10k config~~ (done)
- ~~Remove radian_profile~~ (done)

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-05-15 | Git config syncing | Migrated ~/.gitconfig to XDG packages/git/ via stow. Machine-specific bits (credentials, GPG) in ~/.config/syncbin/gitconfig-local via [include]. Removed legit aliases, git-media filter, stale config. |
| 2026-05-15 | Stow migration verified | Tested on macOS, Ubuntu (toefte, bertha), Rocky Linux (bipc HPC). Auto-migration of old symlinks works. |
| 2026-05-14 | Stow migration | Replaced manual symlink management with GNU stow. Configs reorganized into packages/ with home-directory-mirroring structure. |
| 2026-05-13 | Remove radian_profile | radian is dead, unused for years |
| 2026-05-13 | Remove legacy override files (~/.env.local etc) | ~/.config/syncbin/ mechanism replaced them |
| 2026-05-13 | Keep rstudio/ themes as reference | Useful for porting monokai spacegray eighties to other editors |
| 2026-05-13 | Add fzf-tab, fix compinit | fzf-powered completions, reduced startup from 3x compinit to 1x |
| 2026-05-09 | Create architecture.md + roadmap.md | AI agents need structured reference beyond CLAUDE.md |
