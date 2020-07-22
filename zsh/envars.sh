# Fonts, themes, stuff like that
# This still yields warning on FreeBSD for starship, but not for other prompts
# echo "Dealing with colors"
# echo "TERM is $TERM"
[[ "$TERM" != *256color ]] && export TERM='xterm-256color'

# powerlevel9k config must be done before theme is set
# source $SYNCBIN/zsh/theme/powerlevel9k-env.sh

# ENCODIIING
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# Possibly sometimes relevant
# LC_COLLATE=C

# LS_COLORS via vivid: https://github.com/sharkdp/vivid
export LS_COLORS="$(cat $SYNCBIN/colors/molokai.lscolors)"

# ZSH-specifics
test ! -d $HOME/.config/zsh && mkdir $HOME/.config/zsh

# ZDOTDIR would need move of .zshrc etc 
# http://zsh.sourceforge.net/Doc/Release/Files.html
# ZDOTDIR=$HOME/.config/zsh

# Don't clutter ~/
ZSH_COMPDUMP="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Less highlighting maybe?
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Defaults
(( $+commands[micro] )) && export EDITOR=micro || export EDITOR=nano
export PATH=$HOME/bin:$SYNCBIN/bin:$PATH

# Load iterm2 utils if connected via iterm2 
# See also: https://iterm2.com/documentation-utilities.html
# $SYNCBIN/bin/iterm2-utils/it2check && 
export PATH=$PATH:$SYNCBIN/bin/iterm2-utils

# export PATH=$HOME/bin:$SYNCBIN/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# Unused: /opt/X11/bin /usr/texbin

# Anaconda / Python
# Need conda to find path... to conda m)
# export PATH=$(conda info --base)/bin:"$PATH"
# test -d /usr/local/anaconda3 && export PATH=/usr/local/anaconda3/bin:"$PATH"
# test -d /Users/Lukas/Library/r-miniconda && export PATH=$PATH:/Users/Lukas/Library/r-miniconda/bin

# Make system ruby work
# export GEM_HOME=~/.gem
# test -d ~/.gem && export PATH=~/.gem/bin:$PATH

# RStudio without startup message
RSTUDIO_WHICH_R='/usr/local/bin/R --quiet'

# Is this mosh?
# https://github.com/mobile-shell/mosh/issues/738#issuecomment-240961629
ps -p $PPID | grep mosh-server > /dev/null
if [[ "$?" == "0" ]]; then
  export MOSH=1
else
  export MOSH=0
fi
