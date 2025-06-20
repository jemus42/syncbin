# Shell Completions Configuration
# Advanced completion systems loaded after oh-my-zsh

# Custom completion path
fpath=($SYNCBIN/zsh/completions $fpath)

# Carapace completions (if available)
if (( $+commands[carapace] )); then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCarapacing %d\e[m'
  
  # Load carapace completions
  source <(carapace _carapace)
  
  # Ensure carapace completions take precedence
  autoload -U compinit && compinit
fi

# SSH host completion from known_hosts
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'