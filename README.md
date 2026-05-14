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
├── packages/                # Stow packages (mirrored into $HOME)
│   ├── shell/              # Zsh, bash, fish configs
│   │   ├── .zshrc          # → ~/.zshrc
│   │   ├── .bashrc         # → ~/.bashrc
│   │   └── .config/        # → ~/.config/{zsh,bash,fish,syncbin}/
│   ├── prompt/             # → ~/.config/starship.toml
│   ├── bin/                # → ~/.local/bin/*
│   ├── bat/                # → ~/.config/bat/
│   ├── btop/               # → ~/.config/btop/
│   ├── zellij/             # → ~/.config/zellij/
│   ├── tmux/               # → ~/.config/tmux/
│   ├── helix/              # → ~/.config/helix/
│   ├── ghostty/            # → ~/.config/ghostty/
│   ├── micro/              # → ~/.config/micro/
│   ├── broot/              # → ~/.config/broot/
│   ├── conda/              # → ~/.config/conda/
│   ├── lsd/                # → ~/.config/lsd/
│   ├── carapace/           # → ~/.config/carapace/specs/
│   ├── claude/             # → ~/.claude/CLAUDE.md, ~/.claude/skills/
│   ├── r/                  # → ~/.Rprofile, ~/.config/arf/
│   ├── alacritty/          # → ~/.config/alacritty/ (macOS)
│   └── zed/                # → ~/.config/zed/ (macOS)
├── ohmyzsh_custom/         # Oh-My-Zsh plugins (git submodules)
├── claude/                 # statusline.sh, r-project-template.md
├── starship/               # Theme variants
├── install.sh              # Installation (uses stow)
├── bootstrap.sh            # One-line installer
└── dependencies.yaml       # Tool manifest
```

## Stow Package System

Configs are organized in `packages/` where each package mirrors the home directory structure.
`install.sh` uses [GNU stow](https://www.gnu.org/software/stow/) to create symlinks:

```bash
# Install all packages
./install.sh

# Remove all symlinks
./install.sh --unstow
```

## Shell Configuration

All three shells use a **modular configuration** approach with numbered files
in `packages/shell/.config/{zsh,bash,fish}/config/`:

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
commands). Custom completions in `packages/shell/.config/*/completions/` directories
serve as fallback for commands carapace doesn't support.

**Adding completions:**

1. **Carapace spec (preferred):** `packages/carapace/.config/carapace/specs/mycmd.yaml` (synced across machines)
2. **Shell-specific:** `packages/shell/.config/zsh/completions/_mycmd`,
   `packages/shell/.config/bash/completions/mycmd.bash`,
   `packages/shell/.config/fish/completions/mycmd.fish`

## Key Commands

| Command          | Description                                   |
| ---------------- | --------------------------------------------- |
| `reload`         | Pull latest syncbin, run doctor, reload shell |
| `syncbin-doctor` | Health check for the installation             |
| `extract` / `x`  | Universal archive extraction (tar, zip, 7z, rar, etc.) |

## Dependencies

See `dependencies.yaml` for full list. Key tools:

- **Required:** git, stow
- **Recommended:** carapace, starship, bat, eza/lsd, fd, ripgrep, fzf, zoxide

## Credits

- https://github.com/mathiasbynens/dotfiles
- [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [zsh-users](https://github.com/zsh-users) (completions, autosuggestions)
- [Carapace](https://carapace.sh)
