# Shell Aliases and Abbreviations
# Common command aliases and shortcuts

# Fish has both aliases and abbreviations
# Abbreviations expand when you press space (like zsh's global aliases)
# Aliases are traditional command substitutions

# Note: Common aliases (git, docker, systemd) are in 01-common-aliases.fish

# Basic utilities
alias du="du -h"
alias today='date +"%A, %B %-d, %Y"'
alias rot13="tr 'a-zA-Z' 'n-za-mN-ZA-M'"
alias timestamp='date +%F_%T'

# Enhanced sudo
alias esudo='sudo --preserve-env=PATH env'
alias smicro="sudo (which micro)"

# Custom git shortcuts (not in oh-my-zsh)
alias git-reset-to-remote='git fetch && git reset --hard'
alias git-amend='git commit --amend --no-edit'

# macOS cleanup
alias cleanDS="find . -name '.DS_Store' -print -delete; find . -name '._*' -print -delete"
alias cleanempty="find . -type d -empty -delete"

# R configuration
alias R='R --no-save --quiet'

# Cryptographic utilities
alias sha1='openssl sha1'
alias sha256='shasum -a 256'

# YouTube downloader shortcuts
alias yt="yt-dlp"
alias yt-list="yt-dlp --list-formats"
alias yt-channel="yt-dlp -i -o '%(uploader)s/%(playlist)s/%(title)s [%(id)s].%(ext)s'"
alias yt-playlist='yt-dlp -i -o "%(playlist_index)s - %(title)s [%(id)s].%(ext)s"'
alias yt-chronological="yt-dlp -i -o '%(upload_date)s -  %(title)s [%(id)s].%(ext)s'"

# Rsync shortcuts (without compression)
alias rsync-copy="rsync -av --progress -h"
alias rsync-copy-safe="rsync -av --progress -h --partial"
alias rsync-move="rsync -av --progress -h --remove-source-files"
alias rsync-move-safe="rsync -av --progress -h --remove-source-files --partial"
alias rsync-update="rsync -avu --progress -h"
alias rsync-synchronize="rsync -av --delete --progress -h"

# Docker utilities
alias pdf2htmlEX='docker run -ti --rm -v (pwd):/pdf -w /pdf pdf2htmlex/pdf2htmlex'

# The Fuck integration
if command -v thefuck >/dev/null 2>&1
    thefuck --alias | source
end

# Enhanced ls commands
if command -v gls >/dev/null 2>&1
    alias ls='gls --color=tty'
end

if command -v lsd >/dev/null 2>&1
    alias ls='lsd'
end

# Detailed ls aliases
alias l='ls -lFh'     # size,show type,human readable
alias la='ls -lAFh'   # long list,show almost all,show type,human readable
alias lt='ls -ltFh'   # long list,sorted by date,show type,human readable
alias ll='ls -l'      # long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

# Enhanced grep
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

# Ripgrep shortcuts
alias rgf="rg -F"
alias rgu="rg -u"
alias rgl="rg -l"
alias rguu="rg -uu"
alias rglu="rg -l -u"
alias rgfu="rg -F -u"
alias rgfl="rg -F -l"
alias rgflu="rg -F -l -u"

# Enhanced directory listing
if command -v eza >/dev/null 2>&1
    alias eza='eza -l --git --icons'
end

# File operations
alias x='extract'  # Universal archive extraction
alias t='tail -f'
alias fdir='find . -type d -name'
alias ffile='find . -type f -name'

# macOS specific
alias ql="qlmanage -p"
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

# Development tools
if command -v lazygit >/dev/null 2>&1
    alias gg='lazygit'
end

if command -v lazydocker >/dev/null 2>&1
    alias ldo='lazydocker'
end

# Terminal multiplexers
alias zel='zellij'
alias za='zellij attach -c'

# GPG utilities
alias gpg-list-keys='gpg --list-secret-keys --keyid-format LONG'
alias gpg-export='gpg --armor --export' # Supply key id afterwards

# Fish-specific abbreviations for common commands
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a mkdir 'mkdir -p'