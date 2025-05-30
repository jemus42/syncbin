# Environment Variables and Path Configuration
# Loaded after early config, before oh-my-zsh

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

# Completion dump location (don't clutter ~/)
ZSH_COMPDUMP="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# ZSH highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Default editor
export MICRO_TRUECOLOR=1
(( $+commands[micro] )) && export EDITOR=micro || export EDITOR=nano

# PATH setup
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# Cargo/Rust
test -e "${HOME}/.cargo/bin" && export PATH=$HOME/.cargo/bin:$PATH

# Pager setup
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Other tool integrations that need early setup
(( $+commands[broot] )) && source $HOME/.config/broot/launcher/bash/br
(( $+commands[koji] )) && eval $(koji completions zsh)