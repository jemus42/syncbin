# Init oh-my-zsh stuff

export ZSH=$HOME/.oh-my-zsh

if (( ! $+commands[starship] )); then
    if [[ $host_os = FreeBSD ]] && [[ $MOSH = 1 ]]; then
        ZSH_THEME="jemus42"
    else
        ZSH_THEME="powerlevel10k/powerlevel10k"
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
    git
    git-flow
    encode64
    systemadmin
    perms
    docker docker-compose
    command-not-found
    isodate
    iterm2
    thefuck
)

# Conditional plugins just in case? At least tmux plugin complains if tmux is not found
(( $+commands[zoxide] )) && plugins+=(zoxide) || plugins+=(z)
(( $+commands[gh] )) && plugins+=(gh)
(( $+commands[tmux] )) && plugins+=(tmux)
(( $+commands[httpie] )) && plugins+=(httpie)
(( $+commands[rustc] )) && plugins+=(rust)
(( $+commands[eza] )) && plugins+=(eza)
(( $+commands[fd] )) && plugins+=(fd)
(( $+commands[ripgrep] )) && plugins+=(ripgrep)

# Platform-specific plugins
(( $+commands[systemctl] )) && plugins+=(systemd)
(( $+commands[code] )) && plugins+=(vscode)
[ $host_os = "Darwin" ] && plugins+=(macos)

# These go at the bottom
plugins+=(
    F-Sy-H # Supersedes zsh-syntax-highlighting
    zsh-completions
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
