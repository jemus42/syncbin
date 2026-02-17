# ZSH Early Configuration
# This file should be loaded first, before oh-my-zsh

# Prompt theme selection - must be set early
prompt_theme="starship" # or pw10k

# Profiling setup - execute 'zsh_prof=1 zsh' for profiling
if [[ $zsh_prof = 1 ]] ; then
    zmodload zsh/zprof
fi

# Powerlevel10k instant prompt (if using pw10k)
if [[ $prompt_theme = "pw10k" ]]; then
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  
  # Has to be set earlier than expected apparently
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Basic environment setup
export SYNCBIN=$HOME/syncbin
export host_short="$(uname -n)"
export host_os="$(uname -s)"
export ME=$(whoami)

# Move zcompdump out of $HOME into XDG cache dir
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"
export ZSH_COMPDUMP

# Early completion initialization (before omz plugins are loaded)
autoload -Uz compinit
compinit -i -d "$ZSH_COMPDUMP"