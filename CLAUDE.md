# Syncbin - Dotfiles Repository

Personal dotfiles and configuration management for cross-machine synchronization.

## Repository Structure

```
syncbin/
├── zsh/                    # Zsh configuration (primary shell)
│   ├── zshrc.zsh          # Main entry point (symlinked to ~/.zshrc)
│   ├── config/            # Modular configs loaded in order (00-*.zsh to 99-*.zsh)
│   ├── completions/       # Custom zsh completions (_command format)
│   └── theme/             # Prompt themes (p10k, starship configs)
├── bash/                   # Bash configuration
│   ├── bashrc             # Main entry point
│   ├── config/            # Modular configs (00-*.bash to 99-*.bash)
│   └── completions/       # Custom bash completions (command.bash format)
├── fish/                   # Fish configuration
│   ├── config.fish        # Main entry point
│   ├── config/            # Modular configs (00-*.fish to 99-*.fish)
│   └── completions/       # Custom fish completions (command.fish format)
├── ohmyzsh_custom/        # Oh-My-Zsh custom directory (git submodules)
│   ├── plugins/           # zsh-completions, zsh-autosuggestions, F-Sy-H, etc.
│   └── themes/            # powerlevel10k
├── bin/                    # Custom scripts added to PATH
│   └── syncbin-doctor     # Health check script
├── shared/                 # Cross-shell compatible scripts
│   ├── aliases.sh         # Bash/zsh shared aliases (docker, systemd)
│   └── aliases.fish       # Fish version (abbreviations)
├── R/                      # R/RStudio configuration
├── alacritty/             # Alacritty terminal config
├── ghostty/               # Ghostty terminal config
├── helix/                 # Helix editor config
├── micro/                 # Micro editor config
├── zed/                   # Zed editor config
├── btop/                  # Btop system monitor config
├── bat/                   # Bat (cat replacement) config
├── zellij/                # Zellij terminal multiplexer config
├── bootstrap.sh           # One-line installer script
├── install.sh             # Main installation script
├── dependencies.yaml      # Tool dependencies manifest
└── CLAUDE.md              # This file
```

## Shell Configuration Architecture

All three shells (zsh, bash, fish) use a **modular configuration** approach:

1. Main entry point loads numbered config files in order
2. Config files are prefixed with numbers for explicit load order
3. `99-local.{zsh,bash,fish}` is for machine-specific overrides (gitignored)

### Load Order (zsh example)
- `00-early.zsh` - Profiling, basic setup
- `01-environment.zsh` - Environment variables, PATH
- `02-oh-my-zsh.zsh` - Oh-My-Zsh initialization
- `03-completions.zsh` - Completion system setup
- `04-aliases.zsh` - Shell aliases
- `05-functions.zsh` - Custom functions
- `06-rstudio-server.zsh` - RStudio Server integration
- `07-integrations.zsh` - Tool integrations (zoxide, direnv, etc.)
- `08-prompt.zsh` - Prompt configuration
- `09-tmux.zsh` - Tmux integration
- `99-local.zsh` - Local machine overrides

## Completion System

### Carapace Integration
[Carapace](https://carapace.sh) is the primary completion system, providing 600+ command completions across all shells.

**Configuration:**
- Enabled in `*/config/*-completions.*` for each shell
- Custom specs: `~/.config/carapace/specs/*.yaml`
- Bridges completions from zsh/fish/bash/inshellisense

**Smart Fallback:**
Custom completions in `{zsh,bash,fish}/completions/` only load for commands carapace doesn't support. This prevents conflicts while allowing offline fallback.

### Adding New Completions

**Option 1: Carapace spec (preferred - works for all shells)**
```yaml
# ~/.config/carapace/specs/mycmd.yaml
# yaml-language-server: $schema=https://carapace.sh/schemas/command.json
name: mycmd
description: My command
flags:
  -v, --verbose: Enable verbose output
  -o, --output=: Output file
completion:
  flag:
    output: ["$files"]
commands:
  - name: subcommand
    description: A subcommand
```

**Option 2: Shell-specific completion**
- zsh: `zsh/completions/_mycmd`
- bash: `bash/completions/mycmd.bash`
- fish: `fish/completions/mycmd.fish`

Note: Shell-specific completions are skipped if carapace handles the command.

## Installation

**Bootstrap (new machine):**
```bash
curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh
# Or interactive:
curl -fsSL ... | sh -s -- -i
```

**Manual:**
```bash
git clone --recursive https://github.com/jemus42/syncbin ~/syncbin
cd ~/syncbin && ./install.sh
```

## Key Environment Variables

- `SYNCBIN` - Path to syncbin directory (default: `~/syncbin`)
- `CARAPACE_BRIDGES` - Completion bridges enabled (`zsh,fish,bash,inshellisense`)
- `XDG_CONFIG_HOME` - User config directory (default: `~/.config`)
- `XDG_DATA_HOME` - User data directory (default: `~/.local/share`)
- `XDG_CACHE_HOME` - User cache directory (default: `~/.cache`)
- `XDG_STATE_HOME` - User state directory (default: `~/.local/state`)

## XDG Base Directory Compliance

Syncbin follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) where possible.

**XDG-compliant locations (`~/.config/`):**
- fish, starship, bat, btop, lsd, micro, zellij, helix, ghostty, tmux, broot, conda

**Legacy locations (required by apps):**
- `~/.zshrc`, `~/.bashrc`, `~/.bash_profile` - Shell entry points
- `~/.Rprofile`, `~/.radian_profile` - R configuration
- `~/.screenrc` - Screen configuration
- `~/.oh-my-zsh` - Oh-My-Zsh installation

## Local Overrides (Machine-Specific Config)

Local configuration that shouldn't be committed to syncbin lives in `~/.config/syncbin/`:

```
~/.config/syncbin/
├── env              # Environment variables (KEY=value, one per line)
├── path             # PATH additions (one directory per line)
├── local.zsh        # ZSH-specific overrides
├── local.bash       # Bash-specific overrides
├── local.fish       # Fish-specific overrides
├── work.zsh         # Example: work-specific config
└── experiments.zsh  # Example: trying new things
```

**How it works:**
- `env` and `path` files are shell-agnostic (work for all shells)
- All `*.zsh` files are sourced by zsh, `*.bash` by bash, `*.fish` by fish
- Drop in new files to experiment without touching syncbin
- Comments (`#`) supported in env and path files

**Example usage:**

```bash
# ~/.config/syncbin/env
MY_API_KEY=secret123
CUSTOM_VAR=value

# ~/.config/syncbin/path
/opt/custom/bin
~/projects/tools/bin

# ~/.config/syncbin/experiments.zsh
alias foo='echo bar'
export EXPERIMENTAL=true
```

**Legacy support:** Old `~/.env.local`, `~/.path.local`, `~/.functions.local` files still work but are deprecated.

## Health Check

Run the doctor command to verify your syncbin installation:

```bash
syncbin-doctor
# Or directly:
$SYNCBIN/bin/syncbin-doctor
```

This checks:
- Core setup (git repo, submodules)
- Shell configuration symlinks
- Oh-My-Zsh installation
- Required and optional dependencies
- Custom completions

## Dependencies

See `dependencies.yaml` for a full list of required and optional tools.

**Required:** git

**Recommended:**
- `carapace` - Multi-shell completion system
- `starship` - Cross-shell prompt
- `bat`, `eza`/`lsd`, `fd`, `ripgrep`, `fzf` - Modern CLI tools
- `zoxide` - Smarter cd
- `direnv` - Directory environments

## Git Submodules

Oh-My-Zsh plugins managed as submodules:
- `zsh-users/zsh-completions`
- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-syntax-highlighting`
- `z-shell/F-Sy-H` (fast syntax highlighting)
- `romkatv/powerlevel10k`

Update all: `git submodule update --remote --merge`

## Maintenance Notes

### Adding Shell Configuration
1. Create numbered file in appropriate `config/` directory
2. For fish: also add sourcing to `config.fish` (doesn't use glob loading)

### Cross-Shell Compatibility
When adding features, consider implementing for all three shells:
- zsh: Most feature-rich, primary development target
- bash: Fallback for servers/minimal environments
- fish: Alternative shell with different syntax

### Completion Precedence
1. Carapace (if installed and supports command)
2. Shell-specific custom completions (fallback)
3. System completions

### File Naming Conventions
- zsh completions: `_commandname` (no extension)
- bash completions: `commandname.bash`
- fish completions: `commandname.fish`
- Config files: `NN-descriptive-name.{zsh,bash,fish}`

## Common Tasks

**Test carapace completion:**
```bash
carapace mycmd --run ''
```

**List carapace-supported commands:**
```bash
carapace --list | grep pattern
```

**Check if carapace handles a command:**
```bash
carapace --list | grep "^commandname "
```

**Regenerate shell completions from tool:**
```bash
# If tool supports it:
mytool --completion zsh > zsh/completions/_mytool
mytool --completion bash > bash/completions/mytool.bash
mytool --completion fish > fish/completions/mytool.fish
```

**Reload syncbin (available in all shells):**
```bash
reload
```
This pulls latest changes, runs `syncbin-doctor`, and restarts the shell.
