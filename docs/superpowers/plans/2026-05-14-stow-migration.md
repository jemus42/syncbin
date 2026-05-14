# Stow Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace manual symlink management in install.sh with GNU stow by reorganizing the repo into `packages/` with home-directory-mirroring structure.

**Architecture:** All config files move into `packages/<name>/` directories whose internal paths mirror `$HOME`. install.sh calls `stow` per-package instead of `safe_symlink`. Non-symlink operations (OMZ install, submodules, TPM, Claude settings.json patch) stay in install.sh. Shell entry points change from sourcing `$SYNCBIN/` paths to `$HOME/.config/` paths since stow places them there.

**Tech Stack:** GNU stow, POSIX sh, git mv

---

## File Structure

### Moved into packages/ (git mv)

- `packages/shell/.zshrc` ← `zsh/zshrc.zsh`
- `packages/shell/.zshenv` ← `zsh/zshenv`
- `packages/shell/.bashrc` ← `bash/bashrc`
- `packages/shell/.bash_profile` ← `bash/bash_profile`
- `packages/shell/.screenrc` ← `screenrc`
- `packages/shell/.oh-my-zsh/custom/themes/jemus42.zsh-theme` ← `zsh/theme/jemus42.zsh-theme`
- `packages/shell/.config/zsh/config/*` ← `zsh/config/*`
- `packages/shell/.config/zsh/completions/*` ← `zsh/completions/*`
- `packages/shell/.config/bash/config/*` ← `bash/config/*`
- `packages/shell/.config/bash/completions/*` ← `bash/completions/*`
- `packages/shell/.config/fish/config.fish` ← `fish/config.fish`
- `packages/shell/.config/fish/config/*` ← `fish/config/*`
- `packages/shell/.config/fish/completions/*` ← `fish/completions/*`
- `packages/shell/.config/syncbin/aliases.sh` ← `common/aliases.sh`
- `packages/shell/.config/syncbin/vault.sh` ← `common/vault.sh`
- `packages/prompt/.config/starship.toml` ← `starship/starship.toml`
- `packages/bat/.config/bat/config` ← `bat/config`
- `packages/bat/.config/bat/themes/` ← `bat/themes/`
- `packages/btop/.config/btop/themes/` ← `btop/themes/`
- `packages/zellij/.config/zellij/config.kdl` ← `zellij/zellij.kdl`
- `packages/zellij/.config/zellij/themes/` ← `zellij/themes/`
- `packages/tmux/.config/tmux/tmux.conf` ← `tmux.conf`
- `packages/helix/.config/helix/` ← `helix/`
- `packages/ghostty/.config/ghostty/` ← `ghostty/`
- `packages/micro/.config/micro/settings.json` ← `micro/settings.json`
- `packages/micro/.config/micro/bindings.json` ← `micro/bindings.json`
- `packages/micro/.config/micro/syntax/` ← `micro/syntax/`
- `packages/r/.Rprofile` ← `R/Rprofile`
- `packages/r/.config/arf/arf.toml` ← `R/arf.toml`
- `packages/claude/.claude/CLAUDE.md` ← `claude/CLAUDE.md`
- `packages/claude/.claude/skills/` ← `claude/skills/`
- `packages/carapace/.config/carapace/specs/` ← `carapace/specs/`
- `packages/broot/.config/broot/conf.hjson` ← `broot_conf.hjson`
- `packages/conda/.config/conda/condarc` ← `condarc`
- `packages/lsd/.config/lsd/config.yaml` ← `lsd.conf.yml`
- `packages/bin/.local/bin/*` ← `bin/*`
- `packages/alacritty/.config/alacritty/alacritty.yml` ← `alacritty/alacritty.yml`
- `packages/zed/.config/zed/` ← `zed/`

### Stays at repo root

- `install.sh`, `bootstrap.sh`, `defaults.sh`
- `ohmyzsh_custom/` (git submodules, referenced by `$ZSH_CUSTOM`)
- `claude/statusline.sh`, `claude/r-project-template.md` (path-referenced, not symlinked)
- `starship/` theme variants (only active one is stowed via prompt package)
- `rstudio/themes/` (conditional post-stow hook)
- `R/lintr`, `R/Monokai Spacegray Eighties.tmTheme` (reference files)
- `colors/`, `latex/`, `docs/`, `README.md`, `LICENSE`, `dependencies.yaml`

### Modified in place

- `install.sh` — replace symlink section with stow calls
- Shell entry points — change `$SYNCBIN/` source paths to `$HOME/.config/`
- Shell config modules — update PATH, aliases, completions references
- `syncbin-doctor` — update symlink checks for stow paths
- `docs/architecture.md` — update structure documentation
- `.claude/CLAUDE.md` — update repository structure section

---

### Task 0: Tag pre-migration commit and verify stow is available

**Files:**
- None modified

- [ ] **Step 1: Tag current commit**

```bash
cd /Users/Lukas/syncbin
git tag pre-stow-migration
```

- [ ] **Step 2: Verify stow is installed**

```bash
command -v stow && stow --version
```

Expected: stow version output. If not installed: `brew install stow` (macOS) or `apt install stow` (Linux).

---

### Task 1: Create packages/shell structure and move shell configs

**Files:**
- Move: `zsh/zshrc.zsh` → `packages/shell/.zshrc`
- Move: `zsh/zshenv` → `packages/shell/.zshenv`
- Move: `zsh/config/*` → `packages/shell/.config/zsh/config/*`
- Move: `zsh/completions/*` → `packages/shell/.config/zsh/completions/*`
- Move: `zsh/theme/jemus42.zsh-theme` → `packages/shell/.oh-my-zsh/custom/themes/jemus42.zsh-theme`
- Move: `bash/bashrc` → `packages/shell/.bashrc`
- Move: `bash/bash_profile` → `packages/shell/.bash_profile`
- Move: `bash/config/*` → `packages/shell/.config/bash/config/*`
- Move: `bash/completions/*` → `packages/shell/.config/bash/completions/*`
- Move: `fish/config.fish` → `packages/shell/.config/fish/config.fish`
- Move: `fish/config/*` → `packages/shell/.config/fish/config/*`
- Move: `fish/completions/*` → `packages/shell/.config/fish/completions/*`
- Move: `common/aliases.sh` → `packages/shell/.config/syncbin/aliases.sh`
- Move: `common/vault.sh` → `packages/shell/.config/syncbin/vault.sh`
- Move: `screenrc` → `packages/shell/.screenrc`

- [ ] **Step 1: Create directory structure**

```bash
cd /Users/Lukas/syncbin
mkdir -p packages/shell/.config/zsh/config
mkdir -p packages/shell/.config/zsh/completions
mkdir -p packages/shell/.config/bash/config
mkdir -p packages/shell/.config/bash/completions
mkdir -p packages/shell/.config/fish/config
mkdir -p packages/shell/.config/fish/completions
mkdir -p packages/shell/.config/syncbin
mkdir -p packages/shell/.oh-my-zsh/custom/themes
```

- [ ] **Step 2: git mv shell files**

```bash
cd /Users/Lukas/syncbin

# ZSH
git mv zsh/zshrc.zsh packages/shell/.zshrc
git mv zsh/zshenv packages/shell/.zshenv
git mv zsh/config/* packages/shell/.config/zsh/config/
git mv zsh/completions/* packages/shell/.config/zsh/completions/
git mv zsh/theme/jemus42.zsh-theme packages/shell/.oh-my-zsh/custom/themes/jemus42.zsh-theme

# Bash
git mv bash/bashrc packages/shell/.bashrc
git mv bash/bash_profile packages/shell/.bash_profile
git mv bash/config/* packages/shell/.config/bash/config/
git mv bash/completions/* packages/shell/.config/bash/completions/

# Fish
git mv fish/config.fish packages/shell/.config/fish/config.fish
git mv fish/config/* packages/shell/.config/fish/config/
git mv fish/completions/* packages/shell/.config/fish/completions/

# Common → syncbin config dir
git mv common/aliases.sh packages/shell/.config/syncbin/aliases.sh
git mv common/vault.sh packages/shell/.config/syncbin/vault.sh

# Screenrc
git mv screenrc packages/shell/.screenrc
```

- [ ] **Step 3: Clean up empty directories**

```bash
cd /Users/Lukas/syncbin
rmdir zsh/theme zsh/completions zsh/config zsh
rmdir bash/completions bash/config bash
rmdir fish/completions fish/config fish
rmdir common
```

- [ ] **Step 4: Commit**

```bash
cd /Users/Lukas/syncbin
git add -A
git commit -m "refactor: move shell configs into packages/shell for stow"
```

---

### Task 2: Move tool config packages

**Files:**
- Move: `bat/config`, `bat/themes/` → `packages/bat/.config/bat/`
- Move: `btop/themes/` → `packages/btop/.config/btop/themes/`
- Move: `zellij/zellij.kdl`, `zellij/themes/` → `packages/zellij/.config/zellij/`
- Move: `tmux.conf` → `packages/tmux/.config/tmux/tmux.conf`
- Move: `helix/` → `packages/helix/.config/helix/`
- Move: `ghostty/` → `packages/ghostty/.config/ghostty/`
- Move: `micro/settings.json`, `micro/bindings.json`, `micro/syntax/` → `packages/micro/.config/micro/`
- Move: `broot_conf.hjson` → `packages/broot/.config/broot/conf.hjson`
- Move: `condarc` → `packages/conda/.config/conda/condarc`
- Move: `lsd.conf.yml` → `packages/lsd/.config/lsd/config.yaml`
- Move: `carapace/specs/` → `packages/carapace/.config/carapace/specs/`
- Move: `starship/starship.toml` → `packages/prompt/.config/starship.toml`

- [ ] **Step 1: Create directory structure**

```bash
cd /Users/Lukas/syncbin
mkdir -p packages/bat/.config/bat
mkdir -p packages/btop/.config/btop
mkdir -p packages/zellij/.config/zellij
mkdir -p packages/tmux/.config/tmux
mkdir -p packages/helix/.config
mkdir -p packages/ghostty/.config
mkdir -p packages/micro/.config/micro
mkdir -p packages/broot/.config/broot
mkdir -p packages/conda/.config/conda
mkdir -p packages/lsd/.config/lsd
mkdir -p packages/carapace/.config/carapace
mkdir -p packages/prompt/.config
```

- [ ] **Step 2: git mv tool configs**

```bash
cd /Users/Lukas/syncbin

# Bat
git mv bat/config packages/bat/.config/bat/config
git mv bat/themes packages/bat/.config/bat/themes

# Btop
git mv btop/themes packages/btop/.config/btop/themes

# Zellij
git mv zellij/zellij.kdl packages/zellij/.config/zellij/config.kdl
git mv zellij/themes packages/zellij/.config/zellij/themes

# Tmux
git mv tmux.conf packages/tmux/.config/tmux/tmux.conf

# Helix (entire directory)
git mv helix packages/helix/.config/helix

# Ghostty (entire directory)
git mv ghostty packages/ghostty/.config/ghostty

# Micro
git mv micro/settings.json packages/micro/.config/micro/settings.json
git mv micro/bindings.json packages/micro/.config/micro/bindings.json
git mv micro/syntax packages/micro/.config/micro/syntax

# Broot
git mv broot_conf.hjson packages/broot/.config/broot/conf.hjson

# Conda
git mv condarc packages/conda/.config/conda/condarc

# Lsd
git mv lsd.conf.yml packages/lsd/.config/lsd/config.yaml

# Carapace
git mv carapace/specs packages/carapace/.config/carapace/specs

# Starship (only active config, variants stay)
git mv starship/starship.toml packages/prompt/.config/starship.toml
```

- [ ] **Step 3: Clean up empty directories**

```bash
cd /Users/Lukas/syncbin
rmdir bat btop zellij micro carapace 2>/dev/null
# Note: starship/ still has variant .toml files and README — keep it
```

- [ ] **Step 4: Commit**

```bash
cd /Users/Lukas/syncbin
git add -A
git commit -m "refactor: move tool configs into packages/ for stow"
```

---

### Task 3: Move platform-specific, R, and Claude packages

**Files:**
- Move: `alacritty/alacritty.yml` → `packages/alacritty/.config/alacritty/alacritty.yml`
- Move: `zed/` → `packages/zed/.config/zed/`
- Move: `R/Rprofile` → `packages/r/.Rprofile`
- Move: `R/arf.toml` → `packages/r/.config/arf/arf.toml`
- Move: `claude/CLAUDE.md` → `packages/claude/.claude/CLAUDE.md`
- Move: `claude/skills/` → `packages/claude/.claude/skills/`

- [ ] **Step 1: Create directory structure**

```bash
cd /Users/Lukas/syncbin
mkdir -p packages/alacritty/.config/alacritty
mkdir -p packages/zed/.config
mkdir -p packages/r/.config/arf
mkdir -p packages/claude/.claude
```

- [ ] **Step 2: git mv files**

```bash
cd /Users/Lukas/syncbin

# Alacritty
git mv alacritty/alacritty.yml packages/alacritty/.config/alacritty/alacritty.yml

# Zed (entire directory)
git mv zed packages/zed/.config/zed

# R
git mv R/Rprofile packages/r/.Rprofile
git mv R/arf.toml packages/r/.config/arf/arf.toml

# Claude (CLAUDE.md and skills — statusline.sh and r-project-template.md stay)
git mv claude/CLAUDE.md packages/claude/.claude/CLAUDE.md
git mv claude/skills packages/claude/.claude/skills
```

- [ ] **Step 3: Clean up empty directories**

```bash
cd /Users/Lukas/syncbin
rmdir alacritty 2>/dev/null
# Note: R/ still has lintr and .tmTheme reference files — keep it
# Note: claude/ still has statusline.sh and r-project-template.md — keep it
```

- [ ] **Step 4: Update existing symlinks for claude**

The `~/.claude/CLAUDE.md` symlink currently points to `syncbin/claude/CLAUDE.md` — it needs to point to the new location. But since we're using stow now, just remove the old symlink. Stow will recreate it.

```bash
rm -f ~/.claude/CLAUDE.md
rm -f ~/.claude/skills/jamesian
rm -f ~/.claude/skills/review
rm -f ~/.claude/skills/vault-ingest
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Lukas/syncbin
git add -A
git commit -m "refactor: move platform, R, and claude configs into packages/ for stow"
```

---

### Task 4: Move bin/ scripts to packages/bin

**Files:**
- Move: `bin/*` → `packages/bin/.local/bin/*`
- Keep: `bin/iterm2-utils/` → `packages/bin/.local/bin/` (flatten — move scripts, not directory)

- [ ] **Step 1: Create directory structure**

```bash
cd /Users/Lukas/syncbin
mkdir -p packages/bin/.local/bin
```

- [ ] **Step 2: git mv all scripts**

```bash
cd /Users/Lukas/syncbin

# Move all regular files from bin/
for f in bin/*; do
    [ -f "$f" ] && git mv "$f" packages/bin/.local/bin/
done

# Move iterm2-utils scripts (flatten into .local/bin)
for f in bin/iterm2-utils/*; do
    [ -f "$f" ] && git mv "$f" packages/bin/.local/bin/
done

# Clean up
rmdir bin/iterm2-utils 2>/dev/null
rmdir bin 2>/dev/null
```

- [ ] **Step 3: Commit**

```bash
cd /Users/Lukas/syncbin
git add -A
git commit -m "refactor: move bin/ scripts to packages/bin/.local/bin for stow"
```

---

### Task 5: Update shell entry points to source from $HOME/.config/

**Files:**
- Modify: `packages/shell/.zshrc`
- Modify: `packages/shell/.bashrc`
- Modify: `packages/shell/.config/fish/config.fish`

- [ ] **Step 1: Update .zshrc**

In `/Users/Lukas/syncbin/packages/shell/.zshrc`, change line 15:

```
# Before:
ZSHCONFIG_DIR="${SYNCBIN:-$HOME/syncbin}/zsh/config"
# After:
ZSHCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/config"
```

- [ ] **Step 2: Update .bashrc**

In `/Users/Lukas/syncbin/packages/shell/.bashrc`, change line 13:

```
# Before:
BASHCONFIG_DIR="${SYNCBIN:-$HOME/syncbin}/bash/config"
# After:
BASHCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bash/config"
```

- [ ] **Step 3: Update config.fish**

In `/Users/Lukas/syncbin/packages/shell/.config/fish/config.fish`, replace lines 4-9:

```fish
# Before:
if test -n "$SYNCBIN"
    set FISHCONFIG_DIR "$SYNCBIN/fish/config"
else
    set FISHCONFIG_DIR "$HOME/syncbin/fish/config"
end

# After:
set FISHCONFIG_DIR "$HOME/.config/fish/config"
```

- [ ] **Step 4: Commit**

```bash
cd /Users/Lukas/syncbin
git add packages/shell/.zshrc packages/shell/.bashrc packages/shell/.config/fish/config.fish
git commit -m "refactor: update shell entry points to source from ~/.config/"
```

---

### Task 6: Update shell config module references

**Files:**
- Modify: `packages/shell/.config/zsh/config/01-environment.zsh`
- Modify: `packages/shell/.config/bash/config/01-environment.bash`
- Modify: `packages/shell/.config/zsh/config/03-completions.zsh`
- Modify: `packages/shell/.config/bash/config/07-completions.bash`
- Modify: `packages/shell/.config/zsh/config/04-aliases.zsh`
- Modify: `packages/shell/.config/bash/config/02-aliases.bash`
- Modify: `packages/shell/.config/zsh/config/05-functions.zsh`
- Modify: `packages/shell/.config/bash/config/03-functions.bash`
- Modify: `packages/shell/.config/fish/config/01-environment.fish`
- Modify: `packages/shell/.config/fish/config/03-functions.fish`
- Modify: `packages/shell/.config/fish/config/07-completions.fish`
- Modify: `packages/shell/.config/zsh/config/99-local.zsh`
- Modify: `packages/shell/.config/bash/config/99-local.bash`
- Modify: `packages/shell/.config/fish/config/99-local.fish`

- [ ] **Step 1: Update PATH in zsh environment**

In `packages/shell/.config/zsh/config/01-environment.zsh`, replace lines 42-44:

```zsh
# Before:
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# After:
export PATH=$HOME/.local/bin:$PATH
```

The `$HOME/.local/bin` line already exists and is correct — stow puts bin scripts there. Remove the `$SYNCBIN/bin` and `iterm2-utils` lines (those scripts now live in `~/.local/bin/`).

- [ ] **Step 2: Update PATH in bash environment**

In `packages/shell/.config/bash/config/01-environment.bash`, replace lines 40-42:

```bash
# Before:
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# After:
export PATH=$HOME/.local/bin:$PATH
```

- [ ] **Step 3: Update PATH in fish environment**

In `packages/shell/.config/fish/config/01-environment.fish`, replace lines 54-55:

```fish
# Before:
fish_add_path $HOME/bin $SYNCBIN/bin
fish_add_path $SYNCBIN/bin/iterm2-utils

# After:
fish_add_path $HOME/.local/bin
```

- [ ] **Step 4: Update zsh completions**

In `packages/shell/.config/zsh/config/03-completions.zsh`, replace line 14:

```zsh
# Before:
  local comp_dir="${SYNCBIN:-$HOME/syncbin}/zsh/completions"

# After:
  local comp_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
```

- [ ] **Step 5: Update bash completions**

In `packages/shell/.config/bash/config/07-completions.bash`, replace line 11:

```bash
# Before:
BASH_COMPLETIONS_DIR="${SYNCBIN:-$HOME/syncbin}/bash/completions"

# After:
BASH_COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bash/completions"
```

- [ ] **Step 6: Update fish completions**

In `packages/shell/.config/fish/config/07-completions.fish`, replace lines 14-15:

```fish
# Before:
    if test -n "$SYNCBIN"
        set -l comp_dir "$SYNCBIN/fish/completions"

# After:
        set -l comp_dir "$HOME/.config/fish/completions"
```

Adjust the surrounding logic accordingly — remove the `$SYNCBIN` conditional since the path is now fixed.

- [ ] **Step 7: Update zsh aliases**

In `packages/shell/.config/zsh/config/04-aliases.zsh`, replace lines 5 and 8:

```zsh
# Before:
[[ -r "${SYNCBIN}/common/aliases.sh" ]] && source "${SYNCBIN}/common/aliases.sh"
[[ -r "${SYNCBIN}/common/vault.sh" ]] && source "${SYNCBIN}/common/vault.sh"

# After:
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh"
```

- [ ] **Step 8: Update bash aliases**

In `packages/shell/.config/bash/config/02-aliases.bash`, replace line 5:

```bash
# Before:
[[ -r "${SYNCBIN}/common/aliases.sh" ]] && source "${SYNCBIN}/common/aliases.sh"

# After:
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/aliases.sh"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/syncbin/vault.sh"
```

Note: bash aliases didn't source vault.sh before — add it now for parity with zsh.

- [ ] **Step 9: Update zsh functions (reload)**

In `packages/shell/.config/zsh/config/05-functions.zsh`, replace lines 7-11:

```zsh
# Before:
function reload () {
  echo "Updating syncbin at $SYNCBIN..."
  git -C $SYNCBIN pull --recurse-submodules origin main
  echo ""
  echo "Running health check..."
  $SYNCBIN/bin/syncbin-doctor

# After:
function reload () {
  echo "Updating syncbin at $SYNCBIN..."
  git -C $SYNCBIN pull --recurse-submodules origin main
  echo ""
  echo "Running health check..."
  syncbin-doctor
```

Only change is `$SYNCBIN/bin/syncbin-doctor` → `syncbin-doctor` (now in `~/.local/bin/` via stow).

- [ ] **Step 10: Update bash functions (reload)**

In `packages/shell/.config/bash/config/03-functions.bash`, replace line 11:

```bash
# Before:
  "$SYNCBIN/bin/syncbin-doctor"

# After:
  syncbin-doctor
```

- [ ] **Step 11: Update fish functions (reload)**

In `packages/shell/.config/fish/config/03-functions.fish`, replace line 11:

```fish
# Before:
    "$SYNCBIN/bin/syncbin-doctor"

# After:
    syncbin-doctor
```

- [ ] **Step 12: Remove dead HPC aliases reference in zsh**

In `packages/shell/.config/zsh/config/99-local.zsh`, remove line 44:

```zsh
# Remove this line (file doesn't exist):
[[ -r "${SYNCBIN}/zsh/aliases-hpc.sh" ]] && source "${SYNCBIN}/zsh/aliases-hpc.sh"
```

- [ ] **Step 13: Remove dead HPC aliases reference in bash**

In `packages/shell/.config/bash/config/99-local.bash`, remove line 44:

```bash
# Remove this line (file doesn't exist):
[[ -r "${SYNCBIN}/zsh/aliases-hpc.sh" ]] && source "${SYNCBIN}/zsh/aliases-hpc.sh"
```

- [ ] **Step 14: Remove dead HPC aliases reference in fish**

In `packages/shell/.config/fish/config/99-local.fish`, remove lines 68-70:

```fish
# Remove these lines (file doesn't exist):
if test -r "$SYNCBIN/zsh/aliases-hpc.sh"
    if type -q bass
        bass source "$SYNCBIN/zsh/aliases-hpc.sh"
```

And remove the corresponding `end` statements.

- [ ] **Step 15: Commit**

```bash
cd /Users/Lukas/syncbin
git add -A
git commit -m "refactor: update shell config module references for stow paths"
```

---

### Task 7: Rewrite install.sh for stow

**Files:**
- Modify: `install.sh`

- [ ] **Step 1: Add stow dependency check**

Add after the OS detection block (around line 50), before the helper functions:

```sh
# Check for stow
if ! command -v stow >/dev/null 2>&1; then
    printf "${RED}GNU stow is required but not installed.${NC}\n"
    case "$OS_TYPE" in
        macos)  echo "  Install: brew install stow" ;;
        linux)  echo "  Install: apt install stow  OR  dnf install stow" ;;
    esac
    exit 1
fi
```

- [ ] **Step 2: Add stow helper functions**

Add after the existing helper functions (after `safe_symlink_if_missing`):

```sh
# Stow a package from packages/ into $HOME
stow_package() {
    local pkg="$1"
    local pkg_dir="$SYNCBIN/packages/$pkg"
    if [ ! -d "$pkg_dir" ]; then
        print_status "$YELLOW" "⚠ Package not found: $pkg"
        return 0
    fi
    # Dry-run to detect conflicts
    local conflicts
    conflicts=$(stow -d "$SYNCBIN/packages" -t "$HOME" -n "$pkg" 2>&1 | grep "existing target is" || true)
    if [ -n "$conflicts" ]; then
        print_status "$YELLOW" "! Conflicts detected for $pkg:"
        echo "$conflicts" | while IFS= read -r line; do
            # Extract the conflicting file path
            local target
            target=$(echo "$line" | sed 's/.*existing target is neither a link nor a directory: //')
            if [ -n "$target" ] && [ -e "$HOME/$target" ]; then
                if prompt_user "  Back up and replace $HOME/$target?"; then
                    create_backup "$HOME/$target"
                else
                    print_status "$YELLOW" "  ⚠ Skipped: $target"
                fi
            fi
        done
    fi
    if stow -d "$SYNCBIN/packages" -t "$HOME" "$pkg" 2>/dev/null; then
        print_status "$GREEN" "✓ Stowed: $pkg"
    else
        print_status "$RED" "✗ Failed to stow: $pkg"
        return 1
    fi
}

# Unstow a package
unstow_package() {
    local pkg="$1"
    stow -d "$SYNCBIN/packages" -t "$HOME" -D "$pkg" 2>/dev/null
}
```

- [ ] **Step 3: Add --unstow flag support**

Add to the argument parsing block (after `--help`):

```sh
        --unstow)
            UNSTOW=1
            shift
            ;;
```

And add unstow logic after the confirmation prompt:

```sh
# Handle unstow
if [ "$UNSTOW" = 1 ]; then
    print_status "$BLUE" "Unstowing all packages..."
    for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude r; do
        unstow_package "$pkg"
    done
    if [ "$OS_TYPE" = "macos" ]; then
        for pkg in alacritty ghostty zed; do
            unstow_package "$pkg"
        done
    fi
    print_status "$GREEN" "All packages unstowed."
    exit 0
fi
```

- [ ] **Step 4: Replace directory creation section**

Replace the "Create directories" section. Stow creates parent directories, but some targets need pre-creation for apps that expect them:

```sh
#########################
## Create directories  ##
#########################
print_status "$BLUE" "📁 Creating configuration directories..."

ensure_dir "$HOME/.config"
ensure_dir "$HOME/.local/bin"
ensure_dir "$HOME/.config/syncbin"  # Local overrides directory

echo
```

- [ ] **Step 5: Replace symlink sections with stow calls**

Replace everything from "Shell configurations" through "Theme directories" and "Claude Code" and "Platform-specific" with:

```sh
#########################
## Stow packages       ##
#########################
print_status "$BLUE" "📦 Stowing configuration packages..."

# Core packages (all platforms)
for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude r; do
    stow_package "$pkg"
done

echo

#########################
## Platform-specific   ##
#########################
if [ "$OS_TYPE" = "macos" ]; then
    print_status "$BLUE" "🍎 Stowing macOS-specific packages..."
    for pkg in alacritty ghostty zed; do
        stow_package "$pkg"
    done
    echo
fi

#########################
## Post-stow hooks     ##
#########################
print_status "$BLUE" "🔧 Running post-stow hooks..."

# macOS: arf.toml lives at ~/Library/Application Support/arf/
if [ "$OS_TYPE" = "macos" ]; then
    arf_xdg="$HOME/.config/arf/arf.toml"
    arf_macos_dir="$HOME/Library/Application Support/arf"
    if [ -L "$arf_xdg" ]; then
        ensure_dir "$arf_macos_dir"
        mv "$arf_xdg" "$arf_macos_dir/arf.toml"
        # Remove empty .config/arf directory left by stow
        rmdir "$HOME/.config/arf" 2>/dev/null
        print_status "$GREEN" "✓ Moved arf.toml symlink to macOS location"
    fi
fi

# Claude Code: patch statusline into settings.json
if command -v jq >/dev/null 2>&1; then
    settings_file="$HOME/.claude/settings.json"
    statusline_cmd="bash \"$SYNCBIN/claude/statusline.sh\""
    if [ -f "$settings_file" ]; then
        tmp=$(mktemp)
        if jq --arg cmd "$statusline_cmd" '.statusLine = {"type": "command", "command": $cmd, "refreshInterval": 5}' \
            "$settings_file" > "$tmp" 2>/dev/null; then
            mv "$tmp" "$settings_file"
            print_status "$GREEN" "✓ Patched statusline in settings.json"
        else
            rm -f "$tmp"
            print_status "$YELLOW" "⚠ Failed to patch statusline (jq error)"
        fi
    else
        printf '{"statusLine":{"type":"command","command":"%s","refreshInterval":5}}\n' "$statusline_cmd" > "$settings_file"
        print_status "$GREEN" "✓ Created settings.json with statusline"
    fi
else
    print_status "$YELLOW" "⚠ jq not found — skipping statusline patch (install jq to enable)"
fi

# RStudio themes (conditional)
if [ -d "$HOME/.config/rstudio/themes/" ] && [ -d "$SYNCBIN/rstudio/themes" ]; then
    print_status "$BLUE" "📈 Installing RStudio themes..."
    for theme in "$SYNCBIN/rstudio/themes"/*.rstheme; do
        if [ -f "$theme" ]; then
            safe_symlink "$theme" "$HOME/.config/rstudio/themes/$(basename "$theme")"
        fi
    done
fi

echo
```

- [ ] **Step 6: Update summary section**

Update the "Next steps" section to reflect stow:

```sh
print_status "$BLUE" "📋 Next steps:"
echo "   • Restart your terminal or run:"
echo "     - For ZSH:  source ~/.zshrc"
echo "     - For Bash: source ~/.bashrc"
echo "     - For Fish: source ~/.config/fish/config.fish"
echo "   • Install additional tools as needed:"
echo "     - starship, bat, lsd, ripgrep, fzf, etc."
echo "   • Customize local settings in ~/.config/syncbin/:"
echo "     - env (environment variables), path (PATH additions)"
echo "     - *.zsh, *.bash, *.fish (shell-specific configs)"
echo "   • Unstow individual packages: install.sh --unstow"
echo
print_status "$BLUE" "🔗 Packages stowed via GNU stow:"
echo "   • shell: ~/.zshrc, ~/.bashrc, ~/.config/fish/, ~/.config/zsh/, ~/.config/bash/"
echo "   • prompt: ~/.config/starship.toml"
echo "   • bin: ~/.local/bin/*"
echo "   • Tools: bat, btop, zellij, tmux, helix, micro, broot, conda, lsd, carapace"
echo "   • claude: ~/.claude/CLAUDE.md, ~/.claude/skills/"
echo "   • r: ~/.Rprofile, ~/.config/arf/"
if [ "$OS_TYPE" = "macos" ]; then
    echo "   • macOS: alacritty, ghostty, zed"
fi
echo
```

- [ ] **Step 7: Verify install.sh syntax**

```bash
sh -n /Users/Lukas/syncbin/install.sh
```

Expected: no errors.

- [ ] **Step 8: Commit**

```bash
cd /Users/Lukas/syncbin
git add install.sh
git commit -m "refactor: rewrite install.sh to use stow for symlink management"
```

---

### Task 8: Update syncbin-doctor for stow

**Files:**
- Modify: `packages/bin/.local/bin/syncbin-doctor`

- [ ] **Step 1: Update shell config symlink checks**

Replace the "Shell Configuration Symlinks" section (around lines 130-137). Stow creates symlinks differently — it links individual files, and `readlink` returns a relative path through `packages/`. Update `check_symlink` calls:

```sh
#########################
## Shell Configs
#########################
print_header "Shell Configuration Symlinks"

# Stow creates relative symlinks — just check existence and that they're symlinks
check_stow_link() {
    local link="$1"
    local name="$2"
    if [ -L "$link" ] && [ -e "$link" ]; then
        check_ok "$name"
    elif [ -L "$link" ]; then
        check_err "$name: broken symlink"
    elif [ -e "$link" ]; then
        check_warn "$name: exists but not a symlink (run install.sh)"
    else
        check_err "$name: missing"
    fi
}

check_stow_link "$HOME/.zshrc" "ZSH config (~/.zshrc)"
check_stow_link "$HOME/.bashrc" "Bash config (~/.bashrc)"
check_stow_link "$HOME/.bash_profile" "Bash profile (~/.bash_profile)"
check_stow_link "$HOME/.config/fish/config.fish" "Fish config"
```

- [ ] **Step 2: Update completions path checks**

Replace the "Shell Completions" section (around lines 250-277):

```sh
#########################
## Completions
#########################
print_header "Shell Completions"

zsh_comp_dir="$HOME/.config/zsh/completions"
if [ -d "$zsh_comp_dir" ]; then
    zsh_comp_count=$(find "$zsh_comp_dir" -name "_*" -type f 2>/dev/null | wc -l | tr -d ' ')
    check_ok "ZSH custom completions ($zsh_comp_count)"
else
    check_info "No ZSH custom completions directory"
fi

bash_comp_dir="$HOME/.config/bash/completions"
if [ -d "$bash_comp_dir" ]; then
    bash_comp_count=$(find "$bash_comp_dir" -name "*.bash" -type f 2>/dev/null | wc -l | tr -d ' ')
    check_ok "Bash custom completions ($bash_comp_count)"
else
    check_info "No Bash custom completions directory"
fi

fish_comp_dir="$HOME/.config/fish/completions"
if [ -d "$fish_comp_dir" ]; then
    fish_comp_count=$(find "$fish_comp_dir" -name "*.fish" -type f 2>/dev/null | wc -l | tr -d ' ')
    check_ok "Fish custom completions ($fish_comp_count)"
else
    check_info "No Fish custom completions directory"
fi
```

- [ ] **Step 3: Add stow check**

Add after the "Required Dependencies" section:

```sh
if has_cmd stow; then
    check_ok "stow $(stow --version 2>&1 | head -1 | grep -o '[0-9].*')"
else
    check_err "stow not found (required for install.sh)"
fi
```

- [ ] **Step 4: Commit**

```bash
cd /Users/Lukas/syncbin
git add packages/bin/.local/bin/syncbin-doctor
git commit -m "refactor: update syncbin-doctor for stow-managed symlinks"
```

---

### Task 9: Update documentation

**Files:**
- Modify: `docs/architecture.md`
- Modify: `.claude/CLAUDE.md`
- Modify: `docs/roadmap.md`
- Modify: `README.md`

- [ ] **Step 1: Update .claude/CLAUDE.md**

Update the "Repository Structure" section in `/Users/Lukas/syncbin/.claude/CLAUDE.md` to reflect `packages/` layout. Key changes:
- Top-level directories now under `packages/`
- Shell configs grouped in `packages/shell/`
- `bin/` is now `packages/bin/.local/bin/`
- New "Stow Package System" section explaining the `stow_package` workflow

- [ ] **Step 2: Update docs/architecture.md**

Update the architecture doc to reflect:
- New `packages/` structure
- How stow replaces manual symlinks
- Updated load order (configs now at `~/.config/zsh/config/`, etc.)
- Updated PATH handling (`~/.local/bin/` instead of `$SYNCBIN/bin`)
- Updated "Adding things" recipes for stow workflow

- [ ] **Step 3: Update docs/roadmap.md**

Mark stow migration as done:

```markdown
### Stow Migration
**Status:** Done (2026-05-14)

Replaced manual symlink management with GNU stow. Configs reorganized into `packages/` directory with home-directory-mirroring structure. install.sh calls `stow` per-package.
```

- [ ] **Step 4: Update README.md**

Update installation instructions and structure overview to reflect stow.

- [ ] **Step 5: Commit**

```bash
cd /Users/Lukas/syncbin
git add .claude/CLAUDE.md docs/architecture.md docs/roadmap.md README.md
git commit -m "docs: update documentation for stow migration"
```

---

### Task 10: Remove planning artifacts and test

**Files:**
- Remove: `docs/superpowers/`

- [ ] **Step 1: Remove planning artifacts**

```bash
cd /Users/Lukas/syncbin
rm -rf docs/superpowers/
```

- [ ] **Step 2: Run install.sh**

```bash
cd /Users/Lukas/syncbin
./install.sh -y
```

Expected: all packages stowed successfully, no errors.

- [ ] **Step 3: Verify stow symlinks**

```bash
ls -la ~/.zshrc ~/.bashrc ~/.bash_profile ~/.screenrc
ls -la ~/.config/starship.toml
ls -la ~/.config/bat/config
ls -la ~/.config/zellij/config.kdl
ls -la ~/.config/tmux/tmux.conf
ls -la ~/.Rprofile
ls -la ~/.claude/CLAUDE.md
ls -la ~/.local/bin/syncbin-doctor
```

Expected: all are symlinks pointing into `syncbin/packages/`.

- [ ] **Step 4: Open new terminal and verify shell loads**

```bash
zsh -l -c 'echo "ZSH OK: $SYNCBIN"'
bash -l -c 'echo "Bash OK: $SYNCBIN"'
```

Expected: both print the SYNCBIN path without errors.

- [ ] **Step 5: Run syncbin-doctor**

```bash
syncbin-doctor
```

Expected: all checks pass.

- [ ] **Step 6: Test reload function**

```bash
# In a zsh shell:
type reload
```

Expected: function defined, references `$SYNCBIN` for git pull and `syncbin-doctor` (found in PATH).

- [ ] **Step 7: Verify install.sh syntax**

```bash
sh -n /Users/Lukas/syncbin/install.sh
```

Expected: no errors.

- [ ] **Step 8: Commit cleanup if needed and final state check**

```bash
cd /Users/Lukas/syncbin
git status
git log --oneline pre-stow-migration..HEAD
```

Expected: clean working tree, clear commit history showing the migration.
