# ZSH Configuration - Modular Approach
# Main configuration file that loads all modules in the correct order
# 
# Load order is critical for proper functionality:
# 1. Early setup (profiling, prompt selection, basic env)
# 2. Environment variables and PATH configuration  
# 3. Oh-My-Zsh configuration and plugins
# 4. Advanced completions (carapace, custom)
# 5. Aliases and functions
# 6. Tool integrations that need post-OMZ setup
# 7. Prompt configuration
# 8. Local overrides and cleanup

# Get the directory where this script is located
ZSHCONFIG_DIR="${SYNCBIN:-$HOME/syncbin}/zsh/config"

# Load configuration modules in order
for config_file in "$ZSHCONFIG_DIR"/[0-9][0-9]-*.zsh; do
  if [[ -r "$config_file" ]]; then
    source "$config_file"
  fi
done

# Legacy environment file (contains items now moved to 01-environment.zsh)
# This can be removed once migration is complete
source $SYNCBIN/zsh/envars.sh