# Syncbin Architecture

## Overview

Personal dotfiles and shell configuration for cross-machine synchronization.
Lives at `~/syncbin`, symlinked into place by `install.sh`.

**Target platforms:** macOS (primary dev), Ubuntu (servers/workstations), Rocky Linux (HPC)
**Shell priority:** zsh (primary) > bash (supported) > fish (experimental, low priority)
**Repository:** https://github.com/jemus42/syncbin

## Configuration Loading

### ZSH (Primary Shell)

**Entry point:** `zsh/zshrc.zsh` — sets `ZSHCONFIG_DIR` and glob-sources `zsh/config/[0-9][0-9]-*.zsh` in order.

**Load order:**

| File | Purpose | Key side effects |
|------|---------|-----------------|
| `00-early.zsh` | Profiling setup, basic env vars | Sets `SYNCBIN`, `host_short`, `host_os`, `ME`. Initializes compinit. |
| `01-environment.zsh` | XDG dirs, terminal encoding, Homebrew detection, locale, PATH, editor selection | Sets `XDG_*`, `EDITOR`, `MANPAGER`. Adds ~/.local/bin, ~/.cargo/bin, ~/go/bin, $SYNCBIN/bin to PATH. |
| `02-oh-my-zsh.zsh` | OMZ framework init, plugin loading | Conditional plugins based on command availability. Loads F-Sy-H, zsh-autosuggestions. |
| `03-completions.zsh` | Carapace setup, custom completion fallback, SSH host completion | Sets `CARAPACE_BRIDGES`. Adds zsh/completions to fpath only for commands carapace doesn't handle. |
| `04-aliases.zsh` | Sources common/aliases.sh, adds zsh-specific aliases | Alias domains: ls, grep, rsync, yt-dlp, docker, file operations, macOS utilities. |
| `05-functions.zsh` | Custom shell functions | Domains: reload, media processing, git utilities, LaTeX cleanup, R management, WireGuard VPN helpers. |
| `06-rstudio-server.zsh` | RStudio Server aliases and functions | Only relevant on servers running rstudio-server. |
| `07-integrations.zsh` | McFly history search, Nix package manager | Conditional on command availability. |
| `08-prompt.zsh` | Starship prompt init | Loads starship if available. |
| `09-tmux.zsh` | tmn (new session), tma (attach/create) | Tmux session management helpers. |
| `99-local.zsh` | XDG local overrides, legacy file support, path dedup | Sources ~/.config/syncbin/{env,path,*.sh,*.zsh}. Supports deprecated ~/.env.local etc. |

**Conditional loading pattern:**
```zsh
# Plugin loads only if command exists
(( $+commands[zoxide] )) && plugins+=(zoxide)
# Or with command -v
command -v carapace &>/dev/null && { ... }
```

**OS detection pattern:**
```zsh
[[ -f /etc/os-release ]] && source /etc/os-release  # Sets $ID (ubuntu, rocky, etc.)
[[ "$OSTYPE" == darwin* ]] && ...                    # macOS detection
```

### Bash (Differences from ZSH)

Same modular loader pattern: `bash/bashrc` sources `bash/config/[0-9][0-9]-*.bash`.

Key differences:
- No Oh-My-Zsh — uses system bash-completion (`/usr/share/bash-completion/`)
- Fewer numbered files (9 vs 11): no separate tmux file, integrations include fzf/bash-completion loading
- `06-prompt.bash`: starship if available, otherwise custom colorful prompt with git branch
- `07-completions.bash`: same carapace-first fallback logic as zsh
- `99-local.bash`: same ~/.config/syncbin/ mechanism

Files are intentionally parallel to zsh — same numbered prefixes for same concerns where possible.

### Fish (Brief)

**Entry point:** `fish/config.fish` — explicit `source` calls (no glob, fish limitation).

Key differences from zsh/bash:
- Uses `abbreviations` instead of aliases (expand on space, visible in history)
- `01-common-aliases.fish`: translates common/aliases.sh to fish abbreviations
- `fish_add_path` instead of PATH manipulation
- Different syntax for conditionals (`if test ...` not `[[ ... ]]`)

**Status:** Low priority. May lag behind zsh/bash. Not guaranteed to have all features.

## Cross-Shell Shared Code

**`common/aliases.sh`** — POSIX-compatible, sourced by both zsh and bash.

Contains 200+ aliases organized by domain:
- Git (~80 aliases): gco, gst, gd, gl, gp, grb, gsta, etc.
- Docker/Compose (~20): dco, dcup, dcdn, dclogs, dk, dkps, etc.
- Systemd/Journalctl (~30): sc, scu, sc-status, sc-start, jc, jcf, etc.

**How to find specific aliases:**
```bash
grep "^alias gco" common/aliases.sh       # Find specific alias
grep "^# " common/aliases.sh              # Find section headers
grep "^alias dk" common/aliases.sh        # Find docker aliases
```

## Functional Domains

| Domain | Primary location | Secondary | How to explore |
|--------|-----------------|-----------|----------------|
| Git aliases | `common/aliases.sh` | — | `grep "^alias g" common/aliases.sh` |
| Docker/systemd | `common/aliases.sh` | — | `grep "^alias d\|^alias sc\|^alias jc" common/aliases.sh` |
| Shell functions | `zsh/config/05-functions.zsh` | `bash/config/03-functions.bash` | Read the file; functions are well-named |
| VPN/WireGuard | `zsh/config/05-functions.zsh` (bottom half) | same pattern in bash | Search for `_wg_vpn`, `ppth`, `lifespan` |
| R/RStudio | `*/config/*-rstudio-server.*`, `R/` | `05-functions` (upr, rstudio launcher) | `grep -r "rstudio\|Rproj\|upr" */config/` |
| Media processing | `zsh/config/05-functions.zsh` | `bin/` scripts | Search for `compavc`, `gif2mp4`, `ffsilent`, `pdfcombine` |
| Prompt | `starship/starship.toml` | — | Read starship.toml for active config |
| Terminal emulators | `ghostty/config` | `alacritty/alacritty.yml` | Each is self-contained |
| Editors | `helix/`, `micro/`, `zed/` | — | Each directory is independent |
| Bin scripts | `bin/` | — | `ls bin/` and read individual scripts |

## Completion System

**Architecture:** Carapace-first with shell-specific fallback.

```
Command typed → carapace handles it? → YES → carapace provides completions
                                      → NO  → shell-specific completion loaded from */completions/
```

**Carapace setup:**
- Enabled in `*/config/*-completions.*` for each shell
- `CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'` bridges completions across shells
- Custom specs: `carapace/specs/*.yaml` (symlinked to `~/.config/carapace/specs/`)

**Fallback logic (zsh example from 03-completions.zsh):**
```zsh
# Only add custom completions for commands carapace doesn't support
for comp_file in $SYNCBIN/zsh/completions/_*; do
  cmd_name=${comp_file:t:s/_//}
  carapace --list | grep -q "^${cmd_name} " || fpath=($comp_file:h $fpath)
done
```

**Adding a new completion:**

1. **Preferred: Carapace spec** (works for all shells)
   - Create `carapace/specs/mycmd.yaml`
   - Schema: `https://carapace.sh/schemas/command.json`
   - Test: `carapace mycmd --run ''`

2. **Shell-specific fallback** (if carapace can't handle it)
   - zsh: `zsh/completions/_mycmd`
   - bash: `bash/completions/mycmd.bash`
   - fish: `fish/completions/mycmd.fish`

**Current custom completions:** nala, pandoc (both as carapace spec + shell fallback)

## Local Overrides

Machine-specific config lives in `~/.config/syncbin/` (not tracked by git).

| File/Pattern | Loaded by | Purpose |
|--------------|-----------|---------|
| `env` | zsh, bash, fish | Environment variables (KEY=value, # comments) |
| `path` | zsh, bash, fish | PATH additions (one dir per line, # comments) |
| `*.sh` | zsh, bash | POSIX-compatible shared config |
| `*.zsh` | zsh only | ZSH-specific overrides |
| `*.bash` | bash only | Bash-specific overrides |
| `*.fish` | fish only | Fish-specific overrides |

**When to use local overrides vs tracked config:**
- API keys, secrets, credentials → `env` (never tracked)
- Machine-specific PATH (e.g., /opt/custom/bin) → `path`
- Employer-specific aliases → `work.zsh` or `work.sh`
- Experiments → `experiments.zsh`
- Anything that should sync across machines → tracked in syncbin

**Legacy (deprecated, still functional):** `~/.env.local`, `~/.path.local`, `~/.functions.local`

## Installation & Bootstrap

**New machine:**
```bash
curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh
```
This clones the repo (shallow) to ~/syncbin and runs install.sh.

**install.sh does:**
1. Detects OS (macOS/Linux/FreeBSD)
2. Creates symlinks with prompts and backups:
   - `~/.zshrc` → `zsh/zshrc.zsh`
   - `~/.bashrc` → `bash/bashrc`
   - `~/.bash_profile` → `bash/bash_profile`
   - Various `~/.config/*` → tool config dirs
3. Updates git submodules
4. Supports `-y` flag for non-interactive use

**Health check:** `syncbin-doctor` verifies symlinks, submodules, dependencies, completions.

**Git submodules (Oh-My-Zsh plugins/themes):**
- zsh-completions, zsh-autosuggestions, F-Sy-H
- Update all: `git submodule update --remote --merge`

## Patterns & Conventions

**File naming:**
- Config files: `NN-descriptive-name.{zsh,bash,fish}` (00-09 early, 04-08 main, 99 local)
- ZSH completions: `_commandname` (no extension)
- Bash completions: `commandname.bash`
- Fish completions: `commandname.fish`
- Carapace specs: `commandname.yaml`

**Conditional command loading:**
```zsh
# Check before using
command -v bat &>/dev/null && alias cat='bat'
# OMZ plugin pattern
(( $+commands[gh] )) && plugins+=(gh)
```

**XDG compliance:**
- Configs go in `$XDG_CONFIG_HOME` (~/.config/) where tools support it
- Cache in `$XDG_CACHE_HOME` (~/.cache/) — e.g., zsh compdump
- Data in `$XDG_DATA_HOME` (~/.local/share/)
- State in `$XDG_STATE_HOME` (~/.local/state/)

**PATH construction order** (first match wins):
1. ~/.local/bin (user-local binaries)
2. ~/bin (personal scripts)
3. $SYNCBIN/bin (syncbin utilities)
4. ~/.cargo/bin, ~/go/bin (language toolchains)
5. System paths

Deduplicated at end of 99-local.zsh with `typeset -aU path`.

## Adding Things

### New cross-shell alias
1. Add to `common/aliases.sh` (POSIX-compatible syntax)
2. Both zsh and bash pick it up automatically on next reload

### New zsh-only alias
1. Add to `zsh/config/04-aliases.zsh`
2. Consider: should bash have it too? If yes → common/aliases.sh instead

### New function (zsh primary, bash if cross-shell needed)
1. Add to `zsh/config/05-functions.zsh`
2. If needed in bash: also add to `bash/config/03-functions.bash`
3. Fish: optionally `fish/config/03-functions.fish` (low priority)

### New tool integration
1. Determine load order requirement (usually 07-integrations or adjacent)
2. Add conditional block: `command -v tool &>/dev/null && { ... }`
3. Add to `dependencies.yaml` under appropriate section

### New completion (carapace spec)
1. Create `carapace/specs/mycmd.yaml`
2. Use schema: `https://carapace.sh/schemas/command.json`
3. Test: `carapace mycmd --run ''`
4. Symlink handled by install.sh (specs dir → ~/.config/carapace/specs/)

### New editor/tool config directory
1. Create directory at repo root: `toolname/`
2. Add symlink mapping to `install.sh`
3. Document in architecture.md if non-obvious
