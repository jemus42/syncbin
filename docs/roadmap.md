# Syncbin Roadmap & Status

Last reviewed: 2026-05-13

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

## Stale / Archival Candidates

| Item | Last meaningful edit | Reason | Status |
|------|---------------------|--------|--------|
| `rstudio/` | — | Replaced by Positron, but themes useful as reference for porting | Keep themes |
| `R/ColorScheme` | — | RStudio-specific, but useful theme reference | Keep as reference |
| `*/config/*-rstudio-server.*` | — | Still needed on servers? | Pending review |
| `alacritty/alacritty.yml` | — | Never adopted beyond early beta curiosity | Can remove |
| `zed/` | — | Still in use? | Pending review |
| `bin/slacc`, `bin/sljobs`, `bin/slusage` | — | HPC-specific, still needed? | Pending review |
| `screenrc` | — | tmux/zellij replaced screen | Likely removable |

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
- `claude-sync-skills` script for discovering and integrating skills from other machines
- R project template for reuse in project CLAUDE.md files

**Deferred (requires private repo or separate solution):**
- settings.json full sync (contains machine-specific paths, plugin permissions)
- additionalDirectories paths are machine-specific
- Plugin config requires node.js (not available on all machines, e.g., HPC cluster)

### Positron
**Goal:** Track Positron editor configuration like other tools.

**Open questions:**
- Track extensions list? (equivalent of `code --list-extensions`)
- Track keybindings, settings.json?
- Where in syncbin structure? (`positron/`? `editors/positron/`?)
- Overlap with VS Code settings format — share or separate?

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
| 2026-05-13 | Remove radian_profile | radian is dead, unused for years |
| 2026-05-13 | Remove legacy override files (~/.env.local etc) | ~/.config/syncbin/ mechanism replaced them |
| 2026-05-13 | Keep rstudio/ themes as reference | Useful for porting monokai spacegray eighties to other editors |
| 2026-05-13 | Add fzf-tab, fix compinit | fzf-powered completions, reduced startup from 3x compinit to 1x |
| 2026-05-09 | Create architecture.md + roadmap.md | AI agents need structured reference beyond CLAUDE.md |
