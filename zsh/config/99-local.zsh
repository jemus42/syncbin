# Local Overrides and Final Setup
# User-specific customizations and cleanup
#
# XDG-compliant local configs: ~/.config/syncbin/
#   - env           : Environment variables (KEY=value per line)
#   - path          : PATH additions (one directory per line)
#   - *.sh          : POSIX-compatible configs (sourced by both bash and zsh)
#   - *.zsh         : ZSH-specific configs (all files sourced)
#
# For experimentation, just drop a new .zsh or .sh file in ~/.config/syncbin/

local SYNCBIN_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/syncbin"

# Load environment variables from XDG location
if [[ -r "$SYNCBIN_LOCAL/env" ]]; then
  set -a  # auto-export
  source "$SYNCBIN_LOCAL/env"
  set +a
fi

# Load PATH additions from XDG location
if [[ -r "$SYNCBIN_LOCAL/path" ]]; then
  while IFS= read -r path_entry || [[ -n "$path_entry" ]]; do
    [[ -z "$path_entry" || "$path_entry" == \#* ]] && continue
    [[ -d "$path_entry" ]] && path=("$path_entry" $path)
  done < "$SYNCBIN_LOCAL/path"
fi

# Source all .sh files from XDG location (shared with bash)
if [[ -d "$SYNCBIN_LOCAL" ]]; then
  for f in "$SYNCBIN_LOCAL"/*.sh(N); do
    [[ -r "$f" ]] && source "$f"
  done
fi

# Source all .zsh files from XDG location
if [[ -d "$SYNCBIN_LOCAL" ]]; then
  for f in "$SYNCBIN_LOCAL"/*.zsh(N); do
    [[ -r "$f" ]] && source "$f"
  done
fi

# Legacy support: load old ~/.*local files if they exist
# TODO: Migrate these to ~/.config/syncbin/ and remove
if [[ -r "${HOME}/.env.local" ]]; then
  source "${HOME}/.env.local"
fi
if [[ -r "${HOME}/.path.local" ]]; then
  source "${HOME}/.path.local"
fi
if [[ -r "${HOME}/.functions.local" ]]; then
  source "${HOME}/.functions.local"
fi

# Load HPC-specific aliases (bash-compatible, works in zsh too)
[[ -r "${SYNCBIN}/zsh/aliases-hpc.sh" ]] && source "${SYNCBIN}/zsh/aliases-hpc.sh"

# Path deduplication
typeset -aU path

# Profiling output (if enabled)
[[ $zsh_prof = 1 ]] && zprof