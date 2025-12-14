# Syncbin Jemu

Personal dotfiles and configuration management for cross-machine
synchronization.

## Quick Start

**Bootstrap (new machine):**

```bash
curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh

# Or interactive mode:
curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh -s -- -i
```

**Manual:**

```bash
git clone --recursive https://github.com/jemus42/syncbin ~/syncbin
cd ~/syncbin && ./install.sh
```

**Health check:**

```bash
syncbin-doctor
```

## Repository Structure

```
syncbin/
├── zsh/                    # Zsh configuration (primary shell)
│   ├── zshrc.zsh          # Main entry point (~/.zshrc)
│   ├── config/            # Modular configs (00-*.zsh to 99-*.zsh)
│   └── completions/       # Custom completions (_command format)
├── bash/                   # Bash configuration
│   ├── bashrc             # Main entry point (~/.bashrc)
│   ├── config/            # Modular configs (00-*.bash to 99-*.bash)
│   └── completions/       # Custom completions (command.bash)
├── fish/                   # Fish configuration
│   ├── config.fish        # Main entry point
│   ├── config/            # Modular configs (00-*.fish to 99-*.fish)
│   └── completions/       # Custom completions (command.fish)
├── ohmyzsh_custom/        # Oh-My-Zsh plugins (git submodules)
├── bin/                   # Custom scripts (added to PATH)
├── alacritty/             # Alacritty terminal config
├── ghostty/               # Ghostty terminal config
├── bat/                   # Bat config and themes
├── btop/                  # Btop system monitor config
├── helix/                 # Helix editor config
├── micro/                 # Micro editor config
├── zed/                   # Zed editor config
├── zellij/                # Zellij multiplexer config
├── R/                     # R/RStudio configuration
├── shared/                # Cross-shell compatible scripts
│   ├── aliases.sh        # Bash/zsh compatible aliases
│   └── aliases.fish      # Fish abbreviations
├── carapace/              # Carapace completion specs
│   └── specs/            # Custom specs (symlinked to ~/.config/carapace/specs)
├── bootstrap.sh           # One-line installer
├── install.sh             # Main installation script
└── dependencies.yaml      # Tool dependencies manifest
```

## Shell Configuration

All three shells use a **modular configuration** approach with numbered files:

```
config/
├── 00-early.zsh         # Profiling, basic setup
├── 01-environment.zsh   # Environment variables, PATH, XDG
├── 02-oh-my-zsh.zsh     # Oh-My-Zsh initialization (zsh only)
├── 03-completions.zsh   # Completion system (carapace + fallback)
├── 04-aliases.zsh       # Shell aliases
├── 05-functions.zsh     # Custom functions
├── 06-rstudio-server.zsh
├── 07-integrations.zsh  # Tool integrations (zoxide, direnv, etc.)
├── 08-prompt.zsh        # Prompt configuration
├── 09-tmux.zsh          # Tmux integration
└── 99-local.zsh         # Local machine overrides
```

## Local Overrides (Machine-Specific Config)

Local configuration that shouldn't be committed lives in `~/.config/syncbin/`:

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

**Example:**

```bash
# ~/.config/syncbin/env
MY_API_KEY=secret123

# ~/.config/syncbin/path
/opt/custom/bin
~/projects/tools/bin

# ~/.config/syncbin/experiments.zsh
alias foo='echo bar'
```

## Completion System

[Carapace](https://carapace.sh) is the primary completion system (600+
commands). Custom completions in `*/completions/` directories serve as fallback
for commands carapace doesn't support.

**Adding completions:**

1. **Carapace spec (preferred):** `carapace/specs/mycmd.yaml` (synced across machines)
2. **Shell-specific:** `zsh/completions/_mycmd`, `bash/completions/mycmd.bash`,
   `fish/completions/mycmd.fish`

## Key Commands

| Command          | Description                                   |
| ---------------- | --------------------------------------------- |
| `reload`         | Pull latest syncbin, run doctor, reload shell |
| `syncbin-doctor` | Health check for the installation             |
| `extract` / `x`  | Universal archive extraction (tar, zip, 7z, rar, etc.) |

## Dependencies

See `dependencies.yaml` for full list. Key tools:

- **Required:** git
- **Recommended:** carapace, starship, bat, eza/lsd, fd, ripgrep, fzf, zoxide

## Credits

- https://github.com/mathiasbynens/dotfiles
- [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-users](https://github.com/zsh-users) (completions, autosuggestions,
  syntax-highlighting)
- [Carapace](https://carapace.sh)
