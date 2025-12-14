# Shell Completions Configuration
# Custom completions loaded after system bash-completion

# Carapace completions (if available) - load first as primary completion system
if command -v carapace >/dev/null 2>&1; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  source <(carapace _carapace bash)
fi

# Source custom completions as fallback for commands carapace doesn't support
BASH_COMPLETIONS_DIR="${SYNCBIN:-$HOME/syncbin}/bash/completions"
if [[ -d "$BASH_COMPLETIONS_DIR" ]]; then
  _carapace_list=""
  if command -v carapace >/dev/null 2>&1; then
    _carapace_list="$(carapace --list 2>/dev/null | cut -d' ' -f1)"
  fi

  for completion_file in "$BASH_COMPLETIONS_DIR"/*.bash; do
    [[ -r "$completion_file" ]] || continue
    # Extract command name from filename (e.g., nala.bash -> nala)
    cmd_name="$(basename "$completion_file" .bash)"
    # Skip if carapace handles this command
    if [[ -n "$_carapace_list" ]] && echo "$_carapace_list" | grep -qx "$cmd_name"; then
      continue
    fi
    source "$completion_file"
  done
  unset _carapace_list
fi
