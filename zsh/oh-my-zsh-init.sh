# Init oh-my-zsh stuff

export ZSH=$HOME/.oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$SYNCBIN/ohmyzsh_custom

# Reduce startup time by not giving a fuck
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Red dots displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Disabled because of false-positives that were starting to get annoying

plugins=(
   # rsync # use custom aliases without compression
    extract
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

# Conditional plugins just in case? At least tmux plugin complains if tmux is not found
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

# These go at the bottom
plugins+=(
    F-Sy-H # Supersedes zsh-syntax-highlighting
    # zsh-completions
    zsh-autosuggestions
)

(( $+commands[carapace] )) || plugins+=(zsh-completions)


source $ZSH/oh-my-zsh.sh
