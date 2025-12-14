#!/bin/sh
# Shared aliases for bash and zsh
# This file uses POSIX-compatible syntax to work in both shells
# Source this from bash and zsh configs

# =============================================================================
# Git (based on oh-my-zsh git plugin)
# =============================================================================
if command -v git >/dev/null 2>&1; then
  # Basic commands
  alias g='git'
  alias ga='git add'
  alias gaa='git add --all'
  alias gapa='git add --patch'
  alias gau='git add --update'
  alias gav='git add --verbose'
  alias gap='git apply'
  alias gapt='git apply --3way'

  # Branch
  alias gb='git branch'
  alias gba='git branch -a'
  alias gbd='git branch -d'
  alias gbD='git branch -D'
  alias gbl='git blame -b -w'
  alias gbnm='git branch --no-merged'
  alias gbr='git branch --remote'
  alias gbs='git bisect'
  alias gbsb='git bisect bad'
  alias gbsg='git bisect good'
  alias gbsr='git bisect reset'
  alias gbss='git bisect start'

  # Commit
  alias gc='git commit -v'
  alias gc!='git commit -v --amend'
  alias gcn!='git commit -v --no-edit --amend'
  alias gca='git commit -v -a'
  alias gca!='git commit -v -a --amend'
  alias gcan!='git commit -v -a --no-edit --amend'
  alias gcans!='git commit -v -a -s --no-edit --amend'
  alias gcam='git commit -a -m'
  alias gcsm='git commit -s -m'
  alias gcas='git commit -a -s'
  alias gcss='git commit -s'
  alias gcmsg='git commit -m'

  # Checkout
  alias gco='git checkout'
  alias gcor='git checkout --recurse-submodules'
  alias gcb='git checkout -b'

  # Cherry-pick
  alias gcp='git cherry-pick'
  alias gcpa='git cherry-pick --abort'
  alias gcpc='git cherry-pick --continue'

  # Diff
  alias gd='git diff'
  alias gdca='git diff --cached'
  alias gdcw='git diff --cached --word-diff'
  alias gds='git diff --staged'
  alias gdt='git diff-tree --no-commit-id --name-only -r'
  alias gdw='git diff --word-diff'

  # Fetch
  alias gf='git fetch'
  alias gfa='git fetch --all --prune'
  alias gfo='git fetch origin'

  # Pull
  alias gl='git pull'
  alias gpr='git pull --rebase'
  alias gup='git pull --rebase'
  alias gupv='git pull --rebase -v'
  alias gupa='git pull --rebase --autostash'
  alias gupav='git pull --rebase --autostash -v'

  # Push
  alias gp='git push'
  alias gpd='git push --dry-run'
  alias gpf='git push --force-with-lease'
  alias gpf!='git push --force'
  alias gpoat='git push origin --all && git push origin --tags'
  alias gpu='git push upstream'
  alias gpv='git push -v'
  alias gpsup='git push --set-upstream origin $(git branch --show-current)'

  # Log
  alias glg='git log --stat'
  alias glgp='git log --stat -p'
  alias glgg='git log --graph'
  alias glgga='git log --graph --decorate --all'
  alias glgm='git log --graph --max-count=10'
  alias glo='git log --oneline --decorate'
  alias glog='git log --oneline --decorate --graph'
  alias gloga='git log --oneline --decorate --graph --all'
  alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
  alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
  alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"

  # Merge
  alias gm='git merge'
  alias gmtl='git mergetool --no-prompt'
  alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
  alias gma='git merge --abort'

  # Rebase
  alias grb='git rebase'
  alias grba='git rebase --abort'
  alias grbc='git rebase --continue'
  alias grbi='git rebase -i'
  alias grbo='git rebase --onto'
  alias grbs='git rebase --skip'

  # Remote
  alias gr='git remote'
  alias gra='git remote add'
  alias grmv='git remote rename'
  alias grrm='git remote remove'
  alias grset='git remote set-url'
  alias grup='git remote update'
  alias grv='git remote -v'

  # Reset
  alias grh='git reset'
  alias grhh='git reset --hard'
  alias gru='git reset --'
  alias gpristine='git reset --hard && git clean -dffx'

  # Restore
  alias grs='git restore'
  alias grss='git restore --source'
  alias grst='git restore --staged'

  # Remove
  alias grm='git rm'
  alias grmc='git rm --cached'

  # Revert
  alias grev='git revert'

  # Status
  alias gs='git status'
  alias gss='git status -s'
  alias gst='git status'
  alias gsb='git status -sb'

  # Stash
  alias gsta='git stash push'
  alias gstaa='git stash apply'
  alias gstc='git stash clear'
  alias gstd='git stash drop'
  alias gstl='git stash list'
  alias gstp='git stash pop'
  alias gsts='git stash show --text'
  alias gstu='git stash --include-untracked'
  alias gstall='git stash --all'

  # Submodules
  alias gsu='git submodule update'
  alias gsui='git submodule update --init'
  alias gsuir='git submodule update --init --recursive'

  # Switch (modern checkout alternative)
  alias gsw='git switch'
  alias gswc='git switch -c'

  # Tags
  alias gts='git tag -s'
  alias gtv='git tag | sort -V'

  # Worktree
  alias gwt='git worktree'
  alias gwta='git worktree add'
  alias gwtls='git worktree list'
  alias gwtmv='git worktree move'
  alias gwtrm='git worktree remove'

  # Misc
  alias gcl='git clone --recurse-submodules'
  alias gclean='git clean -id'
  alias gcf='git config --list'
  alias ghh='git help'
  alias gignore='git update-index --assume-unchanged'
  alias gunignore='git update-index --no-assume-unchanged'
  alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
fi

# =============================================================================
# Docker / Docker Compose
# =============================================================================
# Detect docker compose command (v2 plugin vs standalone)
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  alias dco='docker compose'
  alias dcb='docker compose build'
  alias dce='docker compose exec'
  alias dcps='docker compose ps'
  alias dcrestart='docker compose restart'
  alias dcrm='docker compose rm'
  alias dcr='docker compose run'
  alias dcstop='docker compose stop'
  alias dcup='docker compose up'
  alias dcupb='docker compose up --build'
  alias dcupd='docker compose up -d'
  alias dcupdb='docker compose up -d --build'
  alias dcdn='docker compose down'
  alias dcl='docker compose logs'
  alias dclf='docker compose logs -f'
  alias dcpull='docker compose pull'
  alias dcstart='docker compose start'
  alias dck='docker compose kill'
elif command -v docker-compose >/dev/null 2>&1; then
  alias dco='docker-compose'
  alias dcb='docker-compose build'
  alias dce='docker-compose exec'
  alias dcps='docker-compose ps'
  alias dcrestart='docker-compose restart'
  alias dcrm='docker-compose rm'
  alias dcr='docker-compose run'
  alias dcstop='docker-compose stop'
  alias dcup='docker-compose up'
  alias dcupb='docker-compose up --build'
  alias dcupd='docker-compose up -d'
  alias dcupdb='docker-compose up -d --build'
  alias dcdn='docker-compose down'
  alias dcl='docker-compose logs'
  alias dclf='docker-compose logs -f'
  alias dcpull='docker-compose pull'
  alias dcstart='docker-compose start'
  alias dck='docker-compose kill'
fi

# Docker shortcuts
if command -v docker >/dev/null 2>&1; then
  alias dk='docker'
  alias dkps='docker ps'
  alias dkpsa='docker ps -a'
  alias dki='docker images'
  alias dkrm='docker rm'
  alias dkrmi='docker rmi'
  alias dkex='docker exec -it'
  alias dklogs='docker logs'
  alias dklogsf='docker logs -f'
  alias dkpull='docker pull'
  alias dkstop='docker stop'
  alias dkstart='docker start'
  alias dkprune='docker system prune -f'
  alias dkvprune='docker volume prune -f'
fi

# =============================================================================
# Systemd (systemctl)
# =============================================================================
if command -v systemctl >/dev/null 2>&1; then
  # User commands (no sudo needed)
  alias sc='systemctl'
  alias scu='systemctl --user'
  alias sc-status='systemctl status'
  alias sc-show='systemctl show'
  alias sc-cat='systemctl cat'
  alias sc-list='systemctl list-units'
  alias sc-list-timers='systemctl list-timers'
  alias sc-list-sockets='systemctl list-sockets'
  alias sc-is-active='systemctl is-active'
  alias sc-is-enabled='systemctl is-enabled'
  alias sc-is-failed='systemctl is-failed'

  # User service variants
  alias scu-status='systemctl --user status'
  alias scu-list='systemctl --user list-units'
  alias scu-list-timers='systemctl --user list-timers'

  # Sudo commands
  alias sc-start='sudo systemctl start'
  alias sc-stop='sudo systemctl stop'
  alias sc-restart='sudo systemctl restart'
  alias sc-reload='sudo systemctl reload'
  alias sc-enable='sudo systemctl enable'
  alias sc-disable='sudo systemctl disable'
  alias sc-mask='sudo systemctl mask'
  alias sc-unmask='sudo systemctl unmask'
  alias sc-edit='sudo systemctl edit'
  alias sc-daemon-reload='sudo systemctl daemon-reload'

  # User service sudo-equivalent (no sudo needed)
  alias scu-start='systemctl --user start'
  alias scu-stop='systemctl --user stop'
  alias scu-restart='systemctl --user restart'
  alias scu-reload='systemctl --user reload'
  alias scu-enable='systemctl --user enable'
  alias scu-disable='systemctl --user disable'
  alias scu-daemon-reload='systemctl --user daemon-reload'

  # Journalctl
  alias jc='journalctl'
  alias jcf='journalctl -f'
  alias jcu='journalctl --user'
  alias jcfu='journalctl --user -f'
  alias jc-boot='journalctl -b'
  alias jc-tail='journalctl -n 100'
fi
