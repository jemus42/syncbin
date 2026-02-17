# Environment Variables and Path Configuration
# Loaded after early config, before oh-my-zsh

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Terminal colors and encoding
[[ "$TERM" != *256color ]] && export TERM='xterm-256color'

# Homebrew setup (early in PATH)
test -x "/opt/homebrew/bin/brew" && eval $(/opt/homebrew/bin/brew shellenv)
test -x "/home/linuxbrew/.linuxbrew/bin/brew" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -x "~/.linuxbrew/bin/brew" && eval $(~/.linuxbrew/bin/brew shellenv)

# Locale settings
if [[ "$(hostname)" =~ .*"blog".* ]]; then
  # Edge case for beartooth / centOS
  echo "Applying LC_LANG for beartooth"
  export LC_ALL=en_US.utf8
  export LANG=en_US.utf8
elif [[ "$(hostname)" != "ppth" ]]; then
  # Regular case
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
fi

# ZSH-specific directories
test ! -d $HOME/.config/zsh && mkdir $HOME/.config/zsh

# ZSH highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Default editor
export MICRO_TRUECOLOR=1
(( $+commands[micro] )) && export EDITOR=micro || export EDITOR=nano

# PATH setup
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# Cargo/Rust and Go
test -e "${HOME}/.cargo/bin" && export PATH=$HOME/.cargo/bin:$PATH
test -e "${HOME}/go/bin" && export PATH=$HOME/go/bin:$PATH

# Bun
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
if test -d "${BUN_INSTALL}/bin"; then
  export PATH=$BUN_INSTALL/bin:$PATH
  [[ -s "${BUN_INSTALL}/_bun" ]] && source "${BUN_INSTALL}/_bun"
fi

# Pager setup
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Other tool integrations that need early setup
(( $+commands[broot] )) && source $HOME/.config/broot/launcher/bash/br
(( $+commands[koji] )) && eval $(koji completions zsh)
