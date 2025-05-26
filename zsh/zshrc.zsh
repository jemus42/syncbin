prompt_theme="starship" # or pw10k

if [[ $prompt_theme = "pw10k" ]]; then
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi


# And before omz plugins are loaded
autoload -Uz compinit
compinit -i

#################
### Profiling ###
#################
# execute 'zsh_prof=1 zsh' for profiling
if [[ $zsh_prof = 1 ]] ; then
    zmodload zsh/zprof
fi

if [[ $prompt_theme = "pw10k" ]]; then
  # Has to be set earlier than expected apparently
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

export SYNCBIN=$HOME/syncbin

export host_short="$(uname -n)"
export host_os="$(uname -s)"
export ME=$(whoami)

# Some stuff needs to be exported before other stuff
source $SYNCBIN/zsh/envars.sh
test -e "${HOME}/.env.local" && source "${HOME}/.env.local"


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
# There's a omz plugin for this, using that instead
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##############
### Prompt ###
##############
## my zsh theme, either the OMZSH way or the manual way
# source $SYNCBIN/zsh/theme/jemus42.zsh-theme

if [[ $prompt_theme = "starship" ]]; then
  # starship
  if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
  fi
fi

# Enabling mcfly here to avoid later overriding of ctrl+R for some reason
if (( $+commands[mcfly] ))
then
  # https://github.com/cantino/mcfly/issues/254
  source <(mcfly init zsh)
  export MCFLY_FUZZY=1
  export MCFLY_RESULTS_SORT=LAST_RUN
  export MCFLY_PROMPT="❯"
  export MCFLY_RESULTS=25  
fi

# Load carapace after oh-my-zsh to ensure completions work properly
if (( $+commands[carapace] ))
then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCarapacing %d\e[m'
  
  # Force rebuild the completion system before loading carapace
  # rm -f ${ZDOTDIR:-$HOME}/.zcompdump
  # rm -f ${ZDOTDIR:-$HOME}/.zcompdump.zwc
  
  # Load carapace completions
  source <(carapace _carapace)
  
  # Ensure carapace completions take precedence
  autoload -U compinit && compinit
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

function tmn () {
  if [ -z "${1}" ]
  then
    tmux new-session -A -s "${host_short}"
  else
    tmux new-session -A -s "${1}"
  fi
}

function tma () {
  if [ -z "${1}" ]
  then
    tmux attach -t "${host_short}"
  else
    tmux attach -t "${1}"
  fi
}

if [[ $prompt_theme = "pw10k" ]]; then
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f $SYNCBIN/zsh/theme/p10k.zsh ]] || source $SYNCBIN/zsh/theme/p10k.zsh
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]
  then . $HOME/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer
