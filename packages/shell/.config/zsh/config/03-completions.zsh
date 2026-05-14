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
  local comp_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
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

# SSH host completion from known_hosts
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# fzf-tab configuration
if (( $+functions[fzf-tab-complete] )); then
  # Use tmux popup if in tmux, otherwise default fzf
  if [[ -n "$TMUX" ]]; then
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  fi

  # Show grouped descriptions
  zstyle ':fzf-tab:*' show-group full

  # Switch between groups with < and >
  zstyle ':fzf-tab:*' switch-group '<' '>'

  # Preview for file/directory completions
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'

  # Preview for kill/ps completions
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps -p $word -o pid,user,%cpu,%mem,command'

  # Preview for environment variables
  zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

  # Preview for git
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta --width=$FZF_PREVIEW_COLUMNS 2>/dev/null || git diff $word'
  zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --oneline --color=always $word'
  zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --color=always $word -- 2>/dev/null || git log --oneline --color=always $word'

  # Preview for systemctl
  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'
fi