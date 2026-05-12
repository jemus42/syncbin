# ZSH Early Configuration
# This file should be loaded first, before oh-my-zsh

# Profiling setup - execute 'zsh_prof=1 zsh' for profiling
if [[ $zsh_prof = 1 ]] ; then
    zmodload zsh/zprof
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