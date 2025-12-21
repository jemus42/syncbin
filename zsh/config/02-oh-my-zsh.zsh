# Oh-My-Zsh Configuration
# This file contains all oh-my-zsh related configuration
# Clearly separated from other shell configuration

# Oh-My-Zsh paths and settings
export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$SYNCBIN/ohmyzsh_custom

# Oh-My-Zsh behavior settings
ZSH_DISABLE_COMPFIX=true
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=30
# COMPLETION_WAITING_DOTS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true" # Disabled because of false-positives

# Core Oh-My-Zsh plugins
plugins=(
    # extract
    git
    git-flow
    gitignore
    encode64
    systemadmin
    perms
    docker docker-compose
    command-not-found
    isodate
    iterm2
)

# Conditional plugins (only if command exists)
(( $+commands[zoxide] )) && plugins+=(zoxide) || plugins+=(z)
(( $+commands[gh] )) && plugins+=(gh)
(( $+commands[tmux] )) && plugins+=(tmux)
(( $+commands[httpie] )) && plugins+=(httpie)
(( $+commands[rustc] )) && plugins+=(rust)
(( $+commands[thefuck] )) && plugins+=(thefuck)
(( $+commands[direnv] )) && plugins+=(direnv)
(( $+commands[fzf] )) && plugins+=(fzf)
(( $+commands[rbenv] )) && plugins+=(rbenv)

# Platform-specific plugins
(( $+commands[systemctl] )) && plugins+=(systemd)
(( $+commands[code] )) && plugins+=(vscode)
[ $host_os = "Darwin" ] && plugins+=(macos)

# Third-party plugins (loaded last for oh-my-zsh)
plugins+=(
    F-Sy-H # Supersedes zsh-syntax-highlighting
    zsh-autosuggestions
)

# Only add zsh-completions if carapace is not available
(( $+commands[carapace] )) || plugins+=(zsh-completions)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh
