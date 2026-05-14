# Stow Migration Spec

## Goal

Replace install.sh's manual `safe_symlink` calls with GNU stow for symlink management. Reorganize repo into `packages/` directory with stow-compatible structure (internal paths mirror home directory). install.sh remains for non-symlink operations (OMZ, submodules, TPM, Claude settings.json patch, legacy cleanup).

## Scope

**In scope:**
- Create `packages/` directory with stow-compatible package structure
- `git mv` all config files into packages
- Update install.sh to use `stow` instead of `safe_symlink` for config linking
- Update shell entry points to source from `$HOME/.config/` instead of `$SYNCBIN/`
- Move `bin/` scripts to target `~/.local/bin/` via stow
- Update `$SYNCBIN/bin` PATH references (replaced by `~/.local/bin/`)
- Update docs (architecture.md, .claude/CLAUDE.md)
- Update `syncbin-doctor` for new structure

**Out of scope:**
- Removing `safe_symlink`/`safe_symlink_if_missing` helper functions (keep for edge cases)
- Changing shell config load order or behavior
- Adding new tools or configs
- Git config syncing (separate roadmap item)

## Package Layout

### packages/ directory

```
packages/
├── shell/                          # zsh + bash + fish + common
│   ├── .zshrc                      # ← zsh/zshrc.zsh
│   ├── .zshenv                     # ← zsh/zshenv
│   ├── .bashrc                     # ← bash/bashrc
│   ├── .bash_profile               # ← bash/bash_profile
│   ├── .screenrc                   # ← screenrc
│   ├── .oh-my-zsh/custom/themes/
│   │   └── jemus42.zsh-theme       # ← zsh/theme/jemus42.zsh-theme
│   └── .config/
│       ├── zsh/
│       │   ├── config/             # ← zsh/config/ (00-*.zsh to 99-*.zsh)
│       │   └── completions/        # ← zsh/completions/
│       ├── bash/
│       │   ├── config/             # ← bash/config/ (00-*.bash to 99-*.bash)
│       │   └── completions/        # ← bash/completions/
│       ├── fish/
│       │   ├── config.fish         # ← fish/config.fish
│       │   ├── config/             # ← fish/config/ (00-*.fish to 99-*.fish)
│       │   └── completions/        # ← fish/completions/
│       └── syncbin/
│           ├── aliases.sh          # ← common/aliases.sh
│           └── vault.sh            # ← common/vault.sh
├── prompt/
│   └── .config/
│       └── starship.toml           # ← starship/starship.toml
├── bat/
│   └── .config/bat/
│       ├── config                  # ← bat/config
│       └── themes/                 # ← bat/themes/
├── btop/
│   └── .config/btop/
│       └── themes/                 # ← btop/themes/
├── zellij/
│   └── .config/zellij/
│       ├── config.kdl              # ← zellij/zellij.kdl
│       └── themes/                 # ← zellij/themes/
├── tmux/
│   └── .config/tmux/
│       └── tmux.conf               # ← tmux.conf
├── helix/
│   └── .config/helix/              # ← helix/ (entire directory)
├── ghostty/
│   └── .config/ghostty/            # ← ghostty/ (entire directory)
├── micro/
│   └── .config/micro/
│       ├── settings.json           # ← micro/settings.json
│       ├── bindings.json           # ← micro/bindings.json
│       └── syntax/                 # ← micro/syntax/
├── r/
│   ├── .Rprofile                   # ← R/Rprofile
│   └── .config/arf/
│       └── arf.toml                # ← R/arf.toml (macOS fixup post-stow)
├── claude/
│   └── .claude/
│       ├── CLAUDE.md               # ← claude/CLAUDE.md
│       └── skills/                 # ← claude/skills/ (jamesian, review, vault-ingest)
├── carapace/
│   └── .config/carapace/
│       └── specs/                  # ← carapace/specs/
├── broot/
│   └── .config/broot/
│       └── conf.hjson              # ← broot_conf.hjson
├── conda/
│   └── .config/conda/
│       └── condarc                 # ← condarc
├── lsd/
│   └── .config/lsd/
│       └── config.yaml             # ← lsd.conf.yml
├── bin/
│   └── .local/bin/                 # ← bin/* (all scripts)
├── alacritty/                      # macOS only
│   └── .config/alacritty/
│       └── alacritty.yml           # ← alacritty/alacritty.yml
└── zed/                            # macOS only
    └── .config/zed/                # ← zed/ (settings.json, etc.)
```

### Stays at repo root (not stowed)

| Path | Reason |
|------|--------|
| `install.sh`, `bootstrap.sh`, `defaults.sh` | Installation scripts |
| `ohmyzsh_custom/` | Git submodules, loaded via `$ZSH_CUSTOM` path |
| `claude/statusline.sh` | Referenced by absolute path in settings.json |
| `claude/r-project-template.md` | Reference doc, not symlinked |
| `starship/*.toml` (variants) | Theme alternatives, only active one is stowed |
| `rstudio/themes/` | Conditional post-stow hook, rarely used |
| `R/lintr`, `R/*.tmTheme` | Reference files, not symlinked |
| `colors/`, `latex/` | Reference material |
| `docs/`, `README.md`, `LICENSE` | Documentation |
| `dependencies.yaml`, `.gitmodules` | Metadata |

## $SYNCBIN Reference Updates

After migration, configs should reference their installed locations (`$HOME/.config/...`) rather than `$SYNCBIN/` where possible. `$SYNCBIN` remains necessary for repo-root references (ohmyzsh_custom, statusline.sh, install scripts).

### Shell entry points

**zshrc.zsh** (becomes `packages/shell/.zshrc`):
```sh
# Before:
ZSHCONFIG_DIR="${SYNCBIN:-$HOME/syncbin}/zsh/config"
# After:
ZSHCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/config"
```

**bashrc** (becomes `packages/shell/.bashrc`):
```sh
# Before:
BASHCONFIG_DIR="${SYNCBIN:-$HOME/syncbin}/bash/config"
# After:
BASHCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bash/config"
```

**config.fish** (becomes `packages/shell/.config/fish/config.fish`):
```fish
# Before:
set FISHCONFIG_DIR "$SYNCBIN/fish/config"
# After:
set FISHCONFIG_DIR "$HOME/.config/fish/config"
```

### Config modules

**00-early.zsh** — keep `export SYNCBIN=$HOME/syncbin` (still needed for ohmyzsh_custom, reload function)

**01-environment.zsh / 01-environment.bash** — PATH changes:
```sh
# Before:
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils
# After:
export PATH=$PATH:$HOME/.local/bin
# iterm2-utils scripts move into packages/bin/.local/bin/ alongside everything else
```

**02-oh-my-zsh.zsh** — keep `ZSH_CUSTOM=$SYNCBIN/ohmyzsh_custom` (submodules stay at repo root)

**03-completions.zsh / 07-completions.bash**:
```sh
# Before:
local comp_dir="${SYNCBIN:-$HOME/syncbin}/zsh/completions"
# After:
local comp_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
```

**04-aliases.zsh / 02-aliases.bash** — source path changes:
```sh
# Before:
[[ -r "${SYNCBIN}/common/aliases.sh" ]] && source "${SYNCBIN}/common/aliases.sh"
[[ -r "${SYNCBIN}/common/vault.sh" ]] && source "${SYNCBIN}/common/vault.sh"
# After:
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh"
```

**05-functions.zsh / 03-functions.bash** — `reload()` function:
```sh
# Keep $SYNCBIN reference — reload pulls the repo, needs repo path
git -C $SYNCBIN pull --recurse-submodules origin main
$SYNCBIN/bin/syncbin-doctor  # → change to: syncbin-doctor (will be in ~/.local/bin/)
```

**99-local.zsh / 99-local.bash** — HPC aliases line:
```sh
# Before:
[[ -r "${SYNCBIN}/zsh/aliases-hpc.sh" ]] && source "${SYNCBIN}/zsh/aliases-hpc.sh"
# After: remove (file doesn't exist, dead reference)
```

## install.sh Changes

### New stow helper

```sh
stow_package() {
    local pkg="$1"
    local pkg_dir="$SYNCBIN/packages/$pkg"
    if [ ! -d "$pkg_dir" ]; then
        print_status "$YELLOW" "⚠ Package not found: $pkg"
        return 0
    fi
    if stow -d "$SYNCBIN/packages" -t "$HOME" "$pkg" 2>&1; then
        print_status "$GREEN" "✓ Stowed: $pkg"
    else
        print_status "$RED" "✗ Failed to stow: $pkg"
        return 1
    fi
}
```

### Conflict pre-scan

Before stowing, check for existing non-symlink files that would conflict. Back up and remove them (with prompt, unless `-y`).

```sh
prestow_check() {
    local pkg="$1"
    local pkg_dir="$SYNCBIN/packages/$pkg"
    local conflicts
    conflicts=$(stow -d "$SYNCBIN/packages" -t "$HOME" --no-folding -n "$pkg" 2>&1 | grep "existing target" || true)
    if [ -n "$conflicts" ]; then
        echo "$conflicts" | while read -r line; do
            # Extract conflicting path, back up
            ...
        done
    fi
}
```

### Stow section replaces symlink section

```sh
# Dependency check
if ! command -v stow >/dev/null 2>&1; then
    print_status "$RED" "✗ GNU stow is required but not installed"
    case "$OS_TYPE" in
        macos)  echo "  Install: brew install stow" ;;
        linux)  echo "  Install: apt install stow / dnf install stow" ;;
    esac
    exit 1
fi

# Core packages (all platforms)
for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude; do
    stow_package "$pkg"
done

# macOS packages
if [ "$OS_TYPE" = "macos" ]; then
    for pkg in alacritty ghostty zed; do
        stow_package "$pkg"
    done
fi

# R package (all platforms, macOS fixup follows)
stow_package "r"
```

### Post-stow hooks

```sh
# macOS: arf.toml lives at ~/Library/Application Support/arf/ not ~/.config/arf/
if [ "$OS_TYPE" = "macos" ]; then
    arf_xdg="$HOME/.config/arf/arf.toml"
    arf_macos="$HOME/Library/Application Support/arf"
    if [ -L "$arf_xdg" ]; then
        ensure_dir "$arf_macos"
        # Move symlink from XDG location to macOS location
        mv "$arf_xdg" "$arf_macos/arf.toml"
        print_status "$GREEN" "✓ Moved arf.toml to macOS location"
    fi
fi

# Claude settings.json patch (unchanged from current)
# ...

# RStudio themes (unchanged, conditional)
# ...
```

### Unstow support

```sh
# New flag: install.sh --unstow
if [ "$UNSTOW" = 1 ]; then
    for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude r; do
        stow -d "$SYNCBIN/packages" -t "$HOME" -D "$pkg" 2>/dev/null
    done
    if [ "$OS_TYPE" = "macos" ]; then
        for pkg in alacritty ghostty zed; do
            stow -d "$SYNCBIN/packages" -t "$HOME" -D "$pkg" 2>/dev/null
        done
    fi
    print_status "$GREEN" "All packages unstowed."
    exit 0
fi
```

## Migration Commit Sequence

1. **Create packages/ structure, move shell configs** — `git mv` zsh/, bash/, fish/, common/, screenrc into `packages/shell/`
2. **Move tool configs** — bat, btop, zellij, tmux, helix, ghostty, micro, broot, conda, lsd, carapace, alacritty, zed into respective packages
3. **Move bin/ to packages/bin/.local/bin/** — all scripts
4. **Move R config** — R/Rprofile, R/arf.toml into `packages/r/`
5. **Move claude config** — claude/CLAUDE.md, claude/skills/ into `packages/claude/.claude/`
6. **Move starship and prompt** — starship/starship.toml into `packages/prompt/`
7. **Update shell entry points** — change `$SYNCBIN/` source paths to `$HOME/.config/`
8. **Update config modules** — PATH, aliases, completions references
9. **Rewrite install.sh** — replace symlink section with stow calls, add stow check, add hooks
10. **Update syncbin-doctor** — check stow-managed symlinks instead of hardcoded paths
11. **Update docs** — architecture.md, .claude/CLAUDE.md, README.md
12. **Tag pre-migration commit** — `git tag pre-stow-migration` on the commit before migration starts

## Risks and Mitigation

**Stow not installed:** install.sh checks upfront, provides per-OS install instructions, exits cleanly.

**Existing files conflict:** Pre-scan with `stow -n` (dry run), back up conflicts, prompt user (respects `-y`).

**Other machines break on git pull:** Old symlinks point to moved files. Running install.sh fixes everything. Between pull and install, shells may error. Same risk as any structural change. `pre-stow-migration` tag enables easy revert.

**macOS arf.toml path:** Post-stow hook moves symlink from `~/.config/arf/` to `~/Library/Application Support/arf/`. Stow always targets XDG location; fixup runs after.

**$SYNCBIN references:** Kept for repo-root operations (ohmyzsh_custom, reload, install scripts). Config sourcing moves to `$HOME/.config/` paths. If stow hasn't run, shell configs warn about missing config directories instead of silently failing.

## Testing

1. Tag `pre-stow-migration` before starting
2. Run migration on local macOS
3. Run install.sh, verify all symlinks created
4. Open new terminal — verify zsh, bash, fish load correctly
5. Run `syncbin-doctor` — verify all checks pass
6. Test `reload` function
7. Test `claude-sync-skills`
8. Test on one Linux machine (Ubuntu or Rocky)
9. Push when both platforms verified
