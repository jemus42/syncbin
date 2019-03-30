## common
#alias ll='ls -halF'
#alias l='ls -l'
#alias la="exa -abghl --git"

alias du="du -h"
alias df="df -h"

alias today='date +"%A, %B %-d, %Y"'

#alias preview='qlmanage -p' # Use quick-look() instead
alias rot13="tr 'a-zA-Z' 'n-za-mN-ZA-M'"

## git
alias push='git push origin master'
alias pull='git pull origin master'
alias git-reset-to-remote='git fetch && git reset --hard'

## why not
alias timestamp='date +%F_%T'

## cleaning macos shit
alias cleanDS="find . -name '.DS_Store' -delete; find . -name '._*' -delete"

## R, but clean
alias R='R --no-save --quiet'

## Misc helpers
alias sha1='openssl sha1'
alias sha256='shasum -a 256'

## yt-dl
alias yt-channel="youtube-dl -i -o '%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s_%(id)s.%(ext)s'"
alias yt-playlist="youtube-dl -i -o '%(playlist)s/%(playlist_index)s - %(title)s_%(id)s.%(ext)s'"
alias yt-chronological="youtube-dl -i -o '%(upload_date)s - %(title)s_%(id)s.%(ext)s'"

####
#### Thefuck
 (( $+commands[thefuck] )) && eval $(thefuck --alias)

 #######################################################
 ## Copypasta from common-aliases plugin, with tweaks ##
 #######################################################

# If GNU ls is there, make ls be gls
(( $+commands[gls] )) && alias ls='gls --color=tty'

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fdir='find . -type d -name'
alias ffile='find . -type f -name'


# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
if is-at-least 4.2.0; then
  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "
  alias -s ace="unace l"
fi

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
