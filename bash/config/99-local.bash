# Local Overrides and Final Setup
# User-specific customizations and cleanup

# Load local environment overrides
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"
test -e "${HOME}/.path.local" && source "${HOME}/.path.local"
test -e "${HOME}/.functions.local" && source "${HOME}/.functions.local"

# Load HPC-specific aliases if available (bash-compatible)
test -e "${SYNCBIN}/zsh/aliases-hpc.sh" && source "${SYNCBIN}/zsh/aliases-hpc.sh"

# Additional tool integrations from original .bashrc
# Cargo environment
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"

# RVM (Ruby Version Manager)
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
test -d "$HOME/.rvm/bin" && export PATH="$PATH:$HOME/.rvm/bin"

# x-cmd
test -f "$HOME/.x-cmd.root/X" && . "$HOME/.x-cmd.root/X"