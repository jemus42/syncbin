# Init oh-my-zsh stuff

export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel9k/powerlevel9k"

if (( ! $+commands[starship] )); then
    if [[ $host_os = FreeBSD ]] && [[ $MOSH = 1 ]]; then
        ZSH_THEME="jemus42"
    else 
        ZSH_THEME="powerlevel9k/powerlevel10k"
    fi
fi

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
    rsync 
    extract 
    git-flow 
    encode64
    systemadmin
    perms
    docker docker-compose
    ripgrep fd
    command-not-found
    tmux
)
(( $+commands[zoxide] )) && plugins+=(zoxide) || plugins+=(z)

# Platform-specific plugins
(( $+commands[systemctl] )) && plugins+=(systemd)
[ $host_os = "Darwin" ] && plugins+=(macos vscode)

# These go at the bottom
plugins+=(
    zsh-syntax-highlighting 
    zsh-completions
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
