# Prompt Configuration
# Terminal prompt setup and theming

# Starship prompt (if available)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  # Fallback prompt if starship is not available
  # Color definitions
  RED='\[\033[0;31m\]'
  GREEN='\[\033[0;32m\]'
  YELLOW='\[\033[0;33m\]'
  BLUE='\[\033[0;34m\]'
  PURPLE='\[\033[0;35m\]'
  CYAN='\[\033[0;36m\]'
  WHITE='\[\033[0;37m\]'
  RESET='\[\033[0m\]'

  # Git branch function for fallback prompt
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }

  # Set a colorful prompt with git branch info
  PS1="${CYAN}\u${RESET}@${GREEN}\h${RESET}:${BLUE}\w${RESET}${YELLOW}\$(parse_git_branch)${RESET}\$ "
fi