# Third-Party Tool Integrations
# External tool initialization and configuration

# McFly history search (must be loaded after oh-my-zsh to avoid ctrl+R override)
if (( $+commands[mcfly] )); then
  source <(mcfly init zsh)
  export MCFLY_FUZZY=1
  export MCFLY_RESULTS_SORT=LAST_RUN
  export MCFLY_PROMPT="❯"
  export MCFLY_RESULTS=25  
fi

# Nix package manager
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi