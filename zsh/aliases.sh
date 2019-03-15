## shellstuff
alias reload='cd $SYNCBIN; git pull; source ~/.zshrc; cd -'

## common
alias ll='ls -halF'
alias l='ls -l'
alias la="exa -abghl --git"
alias today='date +"%A, %B %-d, %Y"'

alias preview='qlmanage -p'
alias rot13="tr 'a-zA-Z' 'n-za-mN-ZA-M'"

## git
alias push='git push origin master'
alias pull='git pull origin master'
alias git-reset-to-remote='git fetch && git reset --hard'

## why not
alias timestamp='date +%Y-%m-%d_%H-%M'

## cleaning macos shit
alias cleanDS="find . -name '.DS_Store' -delete"
alias cleanAD="find . -name '._*' -delete"

## R, but clean
alias R='R --no-save --quiet'

## Homebrew
alias brewup="brew upgrade && brew cask upgrade"

## Fake binaries via aliases
alias macdown='open -a MacDown'
alias sha1sum='openssl sha1'
alias sha256sum='shasum -a 256'

## yt-dl
alias yt-channel="youtube-dl -i -o '%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s_%(id)s.%(ext)s'"
alias yt-playlist="youtube-dl -i -o '%(playlist)s/%(playlist_index)s - %(title)s_%(id)s.%(ext)s'"
alias yt-chronological="youtube-dl -i -o '%(upload_date)s - %(title)s_%(id)s.%(ext)s'"
