# Prompt Configuration
# Terminal prompt setup and theming

# Starship prompt (if selected and available)
if [[ $prompt_theme = "starship" ]] && (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Powerlevel10k configuration (if selected)
if [[ $prompt_theme = "pw10k" ]]; then
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f $SYNCBIN/zsh/theme/p10k.zsh ]] || source $SYNCBIN/zsh/theme/p10k.zsh
fi