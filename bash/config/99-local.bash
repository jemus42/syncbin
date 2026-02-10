# Local Overrides and Final Setup
# User-specific customizations and cleanup
#
# XDG-compliant local configs: ~/.config/syncbin/
#   - env           : Environment variables (KEY=value per line)
#   - path          : PATH additions (one directory per line)
#   - *.sh          : POSIX-compatible configs (sourced by both bash and zsh)
#   - *.bash        : Bash-specific configs (all files sourced)
#
# For experimentation, just drop a new .bash or .sh file in ~/.config/syncbin/

SYNCBIN_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/syncbin"

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
    [[ -d "$path_entry" ]] && export PATH="$path_entry:$PATH"
  done < "$SYNCBIN_LOCAL/path"
fi

# Source all .sh files from XDG location (shared with zsh)
if [[ -d "$SYNCBIN_LOCAL" ]]; then
  for f in "$SYNCBIN_LOCAL"/*.sh; do
    [[ -r "$f" ]] && source "$f"
  done
fi

# Source all .bash files from XDG location
if [[ -d "$SYNCBIN_LOCAL" ]]; then
  for f in "$SYNCBIN_LOCAL"/*.bash; do
    [[ -r "$f" ]] && source "$f"
  done
fi

# Legacy support: load old ~/.*local files if they exist
# TODO: Migrate these to ~/.config/syncbin/ and remove
[[ -r "${HOME}/.env.local" ]] && source "${HOME}/.env.local"
[[ -r "${HOME}/.path.local" ]] && source "${HOME}/.path.local"
[[ -r "${HOME}/.functions.local" ]] && source "${HOME}/.functions.local"

# Load HPC-specific aliases if available (bash-compatible)
[[ -r "${SYNCBIN}/zsh/aliases-hpc.sh" ]] && source "${SYNCBIN}/zsh/aliases-hpc.sh"

# Additional tool integrations
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin"
[[ -f "$HOME/.x-cmd.root/X" ]] && source "$HOME/.x-cmd.root/X"