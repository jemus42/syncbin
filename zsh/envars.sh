# Fonts, themes, stuff like that
[[ "$TERM" != *256color ]] && export TERM='xterm-256color'

# powerlevel9k config must be done before theme is set
source $SYNCBIN/zsh/theme/powerlevel9k-env.sh

# ENCODIIING
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# Possibly sometimes relevant
# LC_COLLATE=C

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
export EDITOR=nano
export PATH=$HOME/bin:$SYNCBIN/bin:$PATH

# Load iterm2 utils if they exist. 
# See also: https://iterm2.com/documentation-utilities.html
test -e "${HOME}/.iterm2/" && export PATH=$HOME/.iterm2:$PATH

# export PATH=$HOME/bin:$SYNCBIN/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# Unused: /opt/X11/bin /usr/texbin

# Anaconda / Python
# Need conda to find path... to conda m)
# export PATH=$(conda info --base)/bin:"$PATH"
test -d /usr/local/anaconda3 && export PATH=/usr/local/anaconda3/bin:"$PATH"

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