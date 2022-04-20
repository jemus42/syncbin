# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#################
### Profiling ###
#################
# execute 'zsh_prof=1 zsh' for profiling
if [[ $zsh_prof = 1 ]] ; then
    zmodload zsh/zprof
fi

# Has to be set earlier than expected apparently
ZSH_THEME="powerlevel10k/powerlevel10k"

export SYNCBIN=$HOME/syncbin

export host_short=${HOST/.*/}
export host_os=$(uname -s)
export ME=$(whoami)

# Some stuff needs to be exported before other stuff
source $SYNCBIN/zsh/envars.sh
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"

# Add homebrew completions
# https://formulae.brew.sh/formula/zsh-completions
if (( $+commands[brew] )); then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

########################
### oh-my-zsh config ###
########################
source $SYNCBIN/zsh/oh-my-zsh-init.sh

#########################
### Syncbin additions ###
#########################
source $SYNCBIN/zsh/aliases.sh
source $SYNCBIN/zsh/functions.sh

#######################
### Local overrides ###
#######################
test -e "${HOME}/.path.local" && source "${HOME}/.path.local"
test -e "${HOME}/.functions.local" && source "${HOME}/.functions.local"

################################
### Third-Party integrations ###
################################
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##############
### Prompt ###
##############
## my zsh theme, either the OMZSH way or the manual way
# source $SYNCBIN/zsh/theme/jemus42.zsh-theme

# starship
if (( $+commands[starship] )); then
  #eval "$(starship init zsh)"
fi

########################
## Path deduplication ##
########################
# Via https://til.hashrocket.com/posts/7evpdebn7g-remove-duplicates-in-zsh-path
# typeset -aU path
# or maybe
# eval `/usr/libexec/path_helper -s`

#################
### Profiling ###
#################
[[ $zsh_prof = 1 ]] && zprof

#############################
### At the very end: tmux ###
#############################

# Auto-attach tmux session over ssh
# If no session exists, it makes a new one named after the host
# https://stackoverflow.com/a/43819740/409362
# Only runs if:
# 0. tmux is installed (do nothing otherwise)
# 1. Profiling is not enabled
# 2. It's a SSH connection
# 3. It's an interactive shell
# if (( $+commands[tmux] )) && [ -z $zsh_prof ] && [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then
#    tmux new-session -A -s ${host_short}
# fi

# Nope, do it on demand
alias tmn='tmux new-session -A -s ${host_short}'
alias tma='tmux attach -t ${host_short}'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $SYNCBIN/zsh/theme/p10k.zsh ]] || source $SYNCBIN/zsh/theme/p10k.zsh
