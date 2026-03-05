# Third-Party Tool Integrations
# External tool initialization and configuration

# McFly history search (must be loaded after oh-my-zsh to avoid ctrl+R override)
if (( $+commands[mcfly] )); then
  source <(mcfly init zsh)
  export MCFLY_FUZZY=0
  export MCFLY_RESULTS_SORT=LAST_RUN
  export MCFLY_PROMPT="❯"
  export MCFLY_RESULTS=25  
fi

# Nix package manager
# Rocky Linux needs LOCALE_ARCHIVE set before nix is loaded
if [[ -f /etc/os-release ]] && grep -q '^ID="rocky"' /etc/os-release 2>/dev/null; then
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi
