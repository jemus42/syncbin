#################
### Profiling ###
#################
# zmodload zsh/zprof

# Path to oh-my-zsh configuration.
export SYNCBIN=$HOME/syncbin

# Some stuff needs to be exported before other stuff
source $SYNCBIN/zsh/envars.sh

# Red dots displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

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
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"
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
# zprof