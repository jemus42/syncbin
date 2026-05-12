# Prompt Configuration
# Terminal prompt setup and theming

# Starship prompt
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi