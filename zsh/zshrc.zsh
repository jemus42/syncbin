#################
### Profiling ###
#################
# execute 'zsh_prof=1 zsh' for profiling
if [[ $zsh_prof = 1 ]] ; then
    zmodload zsh/zprof
fi

# Config vars for platform/host specific stuff later
export host_short=${HOST/.*/}
export host_os=$(uname -s)
export ME=$(whoami)

# Path to oh-my-zsh configuration.
export SYNCBIN=$HOME/syncbin

# Some stuff needs to be exported before other stuff
source $SYNCBIN/zsh/envars.sh
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"

# Add homebrew completions
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

test -e "${HOME}/.travis/travis.sh" && source "${HOME}/.travis/travis.sh"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

###############
### Antigen ###
###############

# source $SYNCBIN/zsh/antigen-pre-init.sh

##############
### Prompt ###
##############

## my zsh theme, either the OMZSH way or the manual way
# source $SYNCBIN/zsh/theme/jemus42.zsh-theme

# liquidprompt, only if interactive shell
# [[ $- = *i* ]] && source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/liquidprompt/liquidprompt

## In case of pure prompt:
# autoload -U promptinit; promptinit
# prompt pure

#################
### Profiling ###
#################
[[ $zsh_prof = 1 ]] && zprof

#############################
### At the very end: tmux ###
#############################

# Attach tmux session
# If no session exists, it makes a new one 
# https://stackoverflow.com/a/43819740/409362
# Only runs if:
# 1. Profiling is not enabled
# 2. It's a SSH connection
# 3. It's an interactive shell
# If conditions unmet, issue exit 0 to not start my local sessions with an error indicator

if [ -z $zsh_prof ] && [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then
    tmux new-session -A -s $host_short
    # exit
fi