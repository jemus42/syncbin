# Syncbin Roadmap & Status

Last reviewed: 2026-05-09

## Actively Used

- zsh config — daily, all machines
- bash config — servers, fallback environments
- starship prompt — cross-shell, all machines
- ghostty terminal — primary terminal on macOS
- helix editor — primary terminal editor
- bat, btop, zellij — daily tools
- carapace completions — all shells
- R config (Rprofile, arf.toml, radian_profile) — daily R development
- WireGuard VPN helpers — regular use
- common aliases (git, docker, systemd) — daily
- bin/ utilities (extract, syncbin-doctor, upall) — regular use

## Stale / Archival Candidates

| Item | Last meaningful edit | Reason | Status |
|------|---------------------|--------|--------|
| `rstudio/` | — | Replaced by Positron | Pending review |
| `R/ColorScheme` | — | RStudio-specific | Pending review |
| `*/config/*-rstudio-server.*` | — | Still needed on servers? | Pending review |
| `alacritty/alacritty.yml` | — | Replaced by ghostty? | Pending review |
| `micro/` | — | Replaced by helix? | Pending review |
| `zed/` | — | Still in use? | Pending review |
| `ohmyzsh_custom/plugins/zsh-syntax-highlighting` | — | Superseded by F-Sy-H | Removed |
| `bin/slacc`, `bin/sljobs`, `bin/slusage` | — | HPC-specific, still needed? | Pending review |
| `screenrc` | — | tmux/zellij replaced screen | Likely removable |

## Low Priority / Experimental

- **fish config** — curiosity-driven, not production use
- **nushell** — not started, potential future interest

## Future Directions

### Claude / AI Agent Config Syncing
**Goal:** Centrally manage Claude skills, plugins, and settings to sync across devices and project contexts.

**Open questions:**
- Store in syncbin (e.g., `claude/` directory with symlinks to ~/.claude/)?
- Or separate repo with its own lifecycle?
- Which parts are machine-specific vs shared? (skills: shared, auth: local)
- How to handle project-specific vs global CLAUDE.md instructions?

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
- Consolidate R REPL config (arf.toml vs radian_profile — pick primary?)
- Remove deprecated legacy override file loading from 99-local.*
- ~~Remove zsh-syntax-highlighting submodule~~ (done)
- ~~Remove powerlevel10k submodule and p10k config~~ (done)

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-05-09 | Create architecture.md + roadmap.md | AI agents need structured reference beyond CLAUDE.md |
| — | (template for future entries) | — |
