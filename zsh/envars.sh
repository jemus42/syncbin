# Fonts, themes, stuff like that
if [[ "$TERM" != *256color ]]; then export TERM='xterm-256color'; fi

# powerlevel9k config must be done before theme is set
source $SYNCBIN/zsh/theme/powerlevel9k-env.sh

# ENCODIIING
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# ZSH-specifics
test ! -d $HOME/.config/zsh && mkdir $HOME/.config/zsh

# ZDOTDIR would need move of .zshrc etc 
# http://zsh.sourceforge.net/Doc/Release/Files.html
# ZDOTDIR=$HOME/.config/zsh

# Don't clutter ~/
ZSH_COMPDUMP="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Defaults
export EDITOR=nano
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# Unused: /opt/X11/bin /usr/texbin

# Make system ruby work
export GEM_HOME=~/.gem
test -d ~/.gem && export PATH=~/.gem/bin:$PATH

# R without startup
export RSTUDIO_WHICH_R='/usr/local/bin/R --quiet'