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

# ZSH_COMPDUMP is set in zshenv (earliest possible, before any compinit)
# compinit is handled by oh-my-zsh (02) — don't call it here