# Fish Configuration - Modular Approach
# Main configuration file that loads all modules in the correct order

# Get the directory where this script is located
if test -n "$SYNCBIN"
    set FISHCONFIG_DIR "$SYNCBIN/fish/config"
else
    set FISHCONFIG_DIR "$HOME/syncbin/fish/config"
end

# Source early config first to set up basic environment
if test -r "$FISHCONFIG_DIR/00-early.fish"
    source "$FISHCONFIG_DIR/00-early.fish"
end

# Source environment config 
if test -r "$FISHCONFIG_DIR/01-environment.fish"
    source "$FISHCONFIG_DIR/01-environment.fish"
end

# Source aliases
if test -r "$FISHCONFIG_DIR/02-aliases.fish"
    source "$FISHCONFIG_DIR/02-aliases.fish"
end

# Source functions
if test -r "$FISHCONFIG_DIR/03-functions.fish"
    source "$FISHCONFIG_DIR/03-functions.fish"
end

# Source RStudio server functions (if available)
if test -r "$FISHCONFIG_DIR/04-rstudio-server.fish"
    source "$FISHCONFIG_DIR/04-rstudio-server.fish"
end

# Source integrations
if test -r "$FISHCONFIG_DIR/05-integrations.fish"
    source "$FISHCONFIG_DIR/05-integrations.fish"
end

# Source prompt configuration
if test -r "$FISHCONFIG_DIR/06-prompt.fish"
    source "$FISHCONFIG_DIR/06-prompt.fish"
end

# Source completions configuration
if test -r "$FISHCONFIG_DIR/07-completions.fish"
    source "$FISHCONFIG_DIR/07-completions.fish"
end

# Source local overrides last
if test -r "$FISHCONFIG_DIR/99-local.fish"
    source "$FISHCONFIG_DIR/99-local.fish"
end