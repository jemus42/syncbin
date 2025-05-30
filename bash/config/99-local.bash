# Local Overrides and Final Setup
# User-specific customizations and cleanup

# Load local environment overrides
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"
test -e "${HOME}/.path.local" && source "${HOME}/.path.local"
test -e "${HOME}/.functions.local" && source "${HOME}/.functions.local"

# Load HPC-specific aliases if available (bash-compatible)
test -e "${SYNCBIN}/zsh/aliases-hpc.sh" && source "${SYNCBIN}/zsh/aliases-hpc.sh"