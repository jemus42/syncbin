# Third-Party Tool Integrations
# External tool initialization and configuration

# McFly history search (if available)
if command -v mcfly >/dev/null 2>&1; then
  eval "$(mcfly init bash)"
  export MCFLY_FUZZY=1
  export MCFLY_RESULTS_SORT=LAST_RUN
  export MCFLY_PROMPT="❯"
  export MCFLY_RESULTS=25  
fi

# Nix package manager
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# fzf fuzzy finder (if available)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# Bash completion (if available)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Homebrew bash completion (if available)
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi