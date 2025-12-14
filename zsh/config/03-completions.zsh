# Shell Completions Configuration
# Advanced completion systems loaded after oh-my-zsh

# Carapace completions (if available) - load first as primary completion system
if (( $+commands[carapace] )); then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCarapacing %d\e[m'
  source <(carapace _carapace)
fi

# Custom completions as fallback for commands carapace doesn't support
# Only add to fpath if the command isn't handled by carapace
_syncbin_custom_completions() {
  local comp_dir="${SYNCBIN:-$HOME/syncbin}/zsh/completions"
  [[ -d "$comp_dir" ]] || return

  for comp_file in "$comp_dir"/_*; do
    [[ -r "$comp_file" ]] || continue
    local cmd_name="${${comp_file:t}#_}"
    # Skip if carapace handles this command
    if (( $+commands[carapace] )) && carapace --list 2>/dev/null | grep -q "^${cmd_name} "; then
      continue
    fi
    # Add to fpath if not already there
    [[ " ${fpath[*]} " == *" $comp_dir "* ]] || fpath=($comp_dir $fpath)
    break  # Only need to add once
  done
}
_syncbin_custom_completions
unfunction _syncbin_custom_completions 2>/dev/null

# Reinitialize completions
autoload -U compinit && compinit

# SSH host completion from known_hosts
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'