# Shell Aliases and Abbreviations
# Common command aliases and shortcuts

# Fish has both aliases and abbreviations
# Abbreviations expand when you press space (like zsh's global aliases)
# Aliases are traditional command substitutions

# Basic utilities
alias du="du -h"
alias today='date +"%A, %B %-d, %Y"'
alias rot13="tr 'a-zA-Z' 'n-za-mN-ZA-M'"
alias timestamp='date +%F_%T'

# Enhanced sudo
alias esudo='sudo --preserve-env=PATH env'
alias smicro="sudo (which micro)"

# Git shortcuts
alias g="git"
alias git-reset-to-remote='git fetch && git reset --hard'
alias git-amend='git commit --amend --no-edit'

# Fish abbreviations for git (expand when typed) - Oh-My-Zsh git plugin equivalents
abbr -a g 'git'
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gapa 'git add --patch'
abbr -a gau 'git add --update'
abbr -a gav 'git add --verbose'
abbr -a gap 'git apply'
abbr -a gapt 'git apply --3way'

abbr -a gb 'git branch'
abbr -a gba 'git branch -a'
abbr -a gbd 'git branch -d'
abbr -a gbda 'git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
abbr -a gbD 'git branch -D'
abbr -a gbl 'git blame -b -w'
abbr -a gbnm 'git branch --no-merged'
abbr -a gbr 'git branch --remote'
abbr -a gbs 'git bisect'
abbr -a gbsb 'git bisect bad'
abbr -a gbsg 'git bisect good'
abbr -a gbsr 'git bisect reset'
abbr -a gbss 'git bisect start'

abbr -a gc 'git commit -v'
abbr -a gc! 'git commit -v --amend'
abbr -a gcn! 'git commit -v --no-edit --amend'
abbr -a gca 'git commit -v -a'
abbr -a gca! 'git commit -v -a --amend'
abbr -a gcan! 'git commit -v -a --no-edit --amend'
abbr -a gcans! 'git commit -v -a -s --no-edit --amend'
abbr -a gcam 'git commit -a -m'
abbr -a gcsm 'git commit -s -m'
abbr -a gcas 'git commit -a -s'
abbr -a gcss 'git commit -s'
abbr -a gcmsg 'git commit -m'
abbr -a gco 'git checkout'
abbr -a gcor 'git checkout --recurse-submodules'
abbr -a gcb 'git checkout -b'
abbr -a gcd 'git checkout $(git_develop_branch)'
abbr -a gcm 'git checkout $(git_main_branch)'
abbr -a gcp 'git cherry-pick'
abbr -a gcpa 'git cherry-pick --abort'
abbr -a gcpc 'git cherry-pick --continue'

abbr -a gd 'git diff'
abbr -a gdca 'git diff --cached'
abbr -a gdcw 'git diff --cached --word-diff'
abbr -a gdct 'git describe --tags $(git rev-list --tags --max-count=1)'
abbr -a gds 'git diff --staged'
abbr -a gdt 'git diff-tree --no-commit-id --name-only -r'
abbr -a gdw 'git diff --word-diff'

abbr -a gf 'git fetch'
abbr -a gfa 'git fetch --all --prune'
abbr -a gfo 'git fetch origin'

abbr -a gg 'git gui citool'
abbr -a gga 'git gui citool --amend'

abbr -a ghh 'git help'

abbr -a gl 'git pull'
abbr -a gll 'git pull origin'
abbr -a glg 'git log --stat'
abbr -a glgp 'git log --stat -p'
abbr -a glgg 'git log --graph'
abbr -a glgga 'git log --graph --decorate --all'
abbr -a glgm 'git log --graph --max-count=10'
abbr -a glo 'git log --oneline --decorate'
abbr -a glol "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
abbr -a glols "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
abbr -a glod "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
abbr -a glods "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
abbr -a glola "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
abbr -a glog 'git log --oneline --decorate --graph'
abbr -a gloga 'git log --oneline --decorate --graph --all'

abbr -a gm 'git merge'
abbr -a gmom 'git merge origin/$(git_main_branch)'
abbr -a gmtl 'git mergetool --no-prompt'
abbr -a gmtlvim 'git mergetool --no-prompt --tool=vimdiff'
abbr -a gmum 'git merge upstream/$(git_main_branch)'

abbr -a gp 'git push'
abbr -a gpd 'git push --dry-run'
abbr -a gpf 'git push --force-with-lease'
abbr -a gpf! 'git push --force'
abbr -a gpoat 'git push origin --all && git push origin --tags'
abbr -a gpr 'git pull --rebase'
abbr -a gpu 'git push upstream'
abbr -a gpv 'git push -v'

abbr -a gr 'git remote'
abbr -a gra 'git remote add'
abbr -a grb 'git rebase'
abbr -a grba 'git rebase --abort'
abbr -a grbc 'git rebase --continue'
abbr -a grbd 'git rebase $(git_develop_branch)'
abbr -a grbi 'git rebase -i'
abbr -a grbm 'git rebase $(git_main_branch)'
abbr -a grbom 'git rebase origin/$(git_main_branch)'
abbr -a grbo 'git rebase --onto'
abbr -a grbs 'git rebase --skip'
abbr -a grev 'git revert'
abbr -a grh 'git reset'
abbr -a grhh 'git reset --hard'
abbr -a groh 'git reset origin/$(git_current_branch) --hard'
abbr -a grm 'git rm'
abbr -a grmc 'git rm --cached'
abbr -a grmv 'git remote rename'
abbr -a grrm 'git remote remove'
abbr -a grs 'git restore'
abbr -a grset 'git remote set-url'
abbr -a grss 'git restore --source'
abbr -a grst 'git restore --staged'
abbr -a grt 'cd "$(git rev-parse --show-toplevel || echo .)"'
abbr -a gru 'git reset --'
abbr -a grup 'git remote update'
abbr -a grv 'git remote -v'

abbr -a gs 'git status'
abbr -a gss 'git status -s'
abbr -a gst 'git status'

# Systemd plugin abbreviations (conditional on systemctl availability)
if command -v systemctl >/dev/null 2>&1
    abbr -a sc-status 'systemctl status'
    abbr -a sc-show 'systemctl show'
    abbr -a sc-help 'systemctl help'
    abbr -a sc-list-units 'systemctl list-units'
    abbr -a sc-list-unit-files 'systemctl list-unit-files'
    abbr -a sc-list-sockets 'systemctl list-sockets'
    abbr -a sc-list-timers 'systemctl list-timers'
    abbr -a sc-start 'sudo systemctl start'
    abbr -a sc-stop 'sudo systemctl stop'
    abbr -a sc-reload 'sudo systemctl reload'
    abbr -a sc-restart 'sudo systemctl restart'
    abbr -a sc-enable 'sudo systemctl enable'
    abbr -a sc-disable 'sudo systemctl disable'
    abbr -a sc-mask 'sudo systemctl mask'
    abbr -a sc-unmask 'sudo systemctl unmask'
    abbr -a sc-failed 'systemctl --failed'
    abbr -a sc-enabled 'systemctl list-unit-files --state=enabled'
    abbr -a sc-disabled 'systemctl list-unit-files --state=disabled'
end

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

# Claude AI
if test -x $HOME/.claude/local/claude
    alias claude="$HOME/.claude/local/claude"
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