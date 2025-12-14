# Environment Variables and Path Configuration
# Loaded after early config

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Terminal colors and encoding
[[ "$TERM" != *256color ]] && export TERM='xterm-256color'

# Homebrew setup (early in PATH)
test -x "/opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"
test -x "/home/linuxbrew/.linuxbrew/bin/brew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -x "$HOME/.linuxbrew/bin/brew" && eval "$($HOME/.linuxbrew/bin/brew shellenv)"

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

# Default editor
export MICRO_TRUECOLOR=1
if command -v micro >/dev/null 2>&1; then
  export EDITOR=micro
else
  export EDITOR=nano
fi

# PATH setup
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/bin:$SYNCBIN/bin
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# Cargo/Rust and Go
test -e "${HOME}/.cargo/bin" && export PATH=$HOME/.cargo/bin:$PATH
test -e "${HOME}/go/bin" && export PATH=$HOME/go/bin:$PATH

# Pager setup
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Other tool integrations that need early setup
if command -v broot >/dev/null 2>&1 && [ -f "$HOME/.config/broot/launcher/bash/br" ]; then
  source "$HOME/.config/broot/launcher/bash/br"
fi