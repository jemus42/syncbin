# Common aliases for fish (using abbreviations)
# Fish equivalent of common/aliases.sh (git, docker, systemd)

# =============================================================================
# Git (based on oh-my-zsh git plugin)
# =============================================================================
if command -v git >/dev/null 2>&1
    # Basic commands
    abbr -a g 'git'
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gapa 'git add --patch'
    abbr -a gau 'git add --update'
    abbr -a gav 'git add --verbose'
    abbr -a gap 'git apply'
    abbr -a gapt 'git apply --3way'

    # Branch
    abbr -a gb 'git branch'
    abbr -a gba 'git branch -a'
    abbr -a gbd 'git branch -d'
    abbr -a gbD 'git branch -D'
    abbr -a gbl 'git blame -b -w'
    abbr -a gbnm 'git branch --no-merged'
    abbr -a gbr 'git branch --remote'
    abbr -a gbs 'git bisect'
    abbr -a gbsb 'git bisect bad'
    abbr -a gbsg 'git bisect good'
    abbr -a gbsr 'git bisect reset'
    abbr -a gbss 'git bisect start'

    # Commit
    abbr -a gc 'git commit -v'
    abbr -a 'gc!' 'git commit -v --amend'
    abbr -a 'gcn!' 'git commit -v --no-edit --amend'
    abbr -a gca 'git commit -v -a'
    abbr -a 'gca!' 'git commit -v -a --amend'
    abbr -a 'gcan!' 'git commit -v -a --no-edit --amend'
    abbr -a 'gcans!' 'git commit -v -a -s --no-edit --amend'
    abbr -a gcam 'git commit -a -m'
    abbr -a gcsm 'git commit -s -m'
    abbr -a gcas 'git commit -a -s'
    abbr -a gcss 'git commit -s'
    abbr -a gcmsg 'git commit -m'

    # Checkout
    abbr -a gco 'git checkout'
    abbr -a gcor 'git checkout --recurse-submodules'
    abbr -a gcb 'git checkout -b'

    # Cherry-pick
    abbr -a gcp 'git cherry-pick'
    abbr -a gcpa 'git cherry-pick --abort'
    abbr -a gcpc 'git cherry-pick --continue'

    # Diff
    abbr -a gd 'git diff'
    abbr -a gdca 'git diff --cached'
    abbr -a gdcw 'git diff --cached --word-diff'
    abbr -a gds 'git diff --staged'
    abbr -a gdt 'git diff-tree --no-commit-id --name-only -r'
    abbr -a gdw 'git diff --word-diff'

    # Fetch
    abbr -a gf 'git fetch'
    abbr -a gfa 'git fetch --all --prune'
    abbr -a gfo 'git fetch origin'

    # Pull
    abbr -a gl 'git pull'
    abbr -a gpr 'git pull --rebase'
    abbr -a gup 'git pull --rebase'
    abbr -a gupv 'git pull --rebase -v'
    abbr -a gupa 'git pull --rebase --autostash'
    abbr -a gupav 'git pull --rebase --autostash -v'

    # Push
    abbr -a gp 'git push'
    abbr -a gpd 'git push --dry-run'
    abbr -a gpf 'git push --force-with-lease'
    abbr -a 'gpf!' 'git push --force'
    abbr -a gpoat 'git push origin --all && git push origin --tags'
    abbr -a gpu 'git push upstream'
    abbr -a gpv 'git push -v'

    # Log
    abbr -a glg 'git log --stat'
    abbr -a glgp 'git log --stat -p'
    abbr -a glgg 'git log --graph'
    abbr -a glgga 'git log --graph --decorate --all'
    abbr -a glgm 'git log --graph --max-count=10'
    abbr -a glo 'git log --oneline --decorate'
    abbr -a glog 'git log --oneline --decorate --graph'
    abbr -a gloga 'git log --oneline --decorate --graph --all'
    abbr -a glol "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
    abbr -a glola "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
    abbr -a glols "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"

    # Merge
    abbr -a gm 'git merge'
    abbr -a gmtl 'git mergetool --no-prompt'
    abbr -a gmtlvim 'git mergetool --no-prompt --tool=vimdiff'
    abbr -a gma 'git merge --abort'

    # Rebase
    abbr -a grb 'git rebase'
    abbr -a grba 'git rebase --abort'
    abbr -a grbc 'git rebase --continue'
    abbr -a grbi 'git rebase -i'
    abbr -a grbo 'git rebase --onto'
    abbr -a grbs 'git rebase --skip'

    # Remote
    abbr -a gr 'git remote'
    abbr -a gra 'git remote add'
    abbr -a grmv 'git remote rename'
    abbr -a grrm 'git remote remove'
    abbr -a grset 'git remote set-url'
    abbr -a grup 'git remote update'
    abbr -a grv 'git remote -v'

    # Reset
    abbr -a grh 'git reset'
    abbr -a grhh 'git reset --hard'
    abbr -a gru 'git reset --'
    abbr -a gpristine 'git reset --hard && git clean -dffx'

    # Restore
    abbr -a grs 'git restore'
    abbr -a grss 'git restore --source'
    abbr -a grst 'git restore --staged'

    # Remove
    abbr -a grm 'git rm'
    abbr -a grmc 'git rm --cached'

    # Revert
    abbr -a grev 'git revert'

    # Status
    abbr -a gs 'git status'
    abbr -a gss 'git status -s'
    abbr -a gst 'git status'
    abbr -a gsb 'git status -sb'

    # Stash
    abbr -a gsta 'git stash push'
    abbr -a gstaa 'git stash apply'
    abbr -a gstc 'git stash clear'
    abbr -a gstd 'git stash drop'
    abbr -a gstl 'git stash list'
    abbr -a gstp 'git stash pop'
    abbr -a gsts 'git stash show --text'
    abbr -a gstu 'git stash --include-untracked'
    abbr -a gstall 'git stash --all'

    # Submodules
    abbr -a gsu 'git submodule update'
    abbr -a gsui 'git submodule update --init'
    abbr -a gsuir 'git submodule update --init --recursive'

    # Switch (modern checkout alternative)
    abbr -a gsw 'git switch'
    abbr -a gswc 'git switch -c'

    # Tags
    abbr -a gts 'git tag -s'
    abbr -a gtv 'git tag | sort -V'

    # Worktree
    abbr -a gwt 'git worktree'
    abbr -a gwta 'git worktree add'
    abbr -a gwtls 'git worktree list'
    abbr -a gwtmv 'git worktree move'
    abbr -a gwtrm 'git worktree remove'

    # Misc
    abbr -a gcl 'git clone --recurse-submodules'
    abbr -a gclean 'git clean -id'
    abbr -a gcf 'git config --list'
    abbr -a ghh 'git help'
    abbr -a gignore 'git update-index --assume-unchanged'
    abbr -a gunignore 'git update-index --no-assume-unchanged'
    abbr -a gwch 'git whatchanged -p --abbrev-commit --pretty=medium'
end

# =============================================================================
# Docker / Docker Compose
# =============================================================================
if command -v docker >/dev/null 2>&1
    # Check for compose v2
    if docker compose version >/dev/null 2>&1
        abbr -a dco 'docker compose'
        abbr -a dcb 'docker compose build'
        abbr -a dce 'docker compose exec'
        abbr -a dcps 'docker compose ps'
        abbr -a dcrestart 'docker compose restart'
        abbr -a dcrm 'docker compose rm'
        abbr -a dcr 'docker compose run'
        abbr -a dcstop 'docker compose stop'
        abbr -a dcup 'docker compose up'
        abbr -a dcupb 'docker compose up --build'
        abbr -a dcupd 'docker compose up -d'
        abbr -a dcupdb 'docker compose up -d --build'
        abbr -a dcdn 'docker compose down'
        abbr -a dcl 'docker compose logs'
        abbr -a dclf 'docker compose logs -f'
        abbr -a dcpull 'docker compose pull'
        abbr -a dcstart 'docker compose start'
        abbr -a dck 'docker compose kill'
    else if command -v docker-compose >/dev/null 2>&1
        abbr -a dco 'docker-compose'
        abbr -a dcb 'docker-compose build'
        abbr -a dce 'docker-compose exec'
        abbr -a dcps 'docker-compose ps'
        abbr -a dcrestart 'docker-compose restart'
        abbr -a dcrm 'docker-compose rm'
        abbr -a dcr 'docker-compose run'
        abbr -a dcstop 'docker-compose stop'
        abbr -a dcup 'docker-compose up'
        abbr -a dcupb 'docker-compose up --build'
        abbr -a dcupd 'docker-compose up -d'
        abbr -a dcupdb 'docker-compose up -d --build'
        abbr -a dcdn 'docker-compose down'
        abbr -a dcl 'docker-compose logs'
        abbr -a dclf 'docker-compose logs -f'
        abbr -a dcpull 'docker-compose pull'
        abbr -a dcstart 'docker-compose start'
        abbr -a dck 'docker-compose kill'
    end

    # Docker shortcuts
    abbr -a dk 'docker'
    abbr -a dkps 'docker ps'
    abbr -a dkpsa 'docker ps -a'
    abbr -a dki 'docker images'
    abbr -a dkrm 'docker rm'
    abbr -a dkrmi 'docker rmi'
    abbr -a dkex 'docker exec -it'
    abbr -a dklogs 'docker logs'
    abbr -a dklogsf 'docker logs -f'
    abbr -a dkpull 'docker pull'
    abbr -a dkstop 'docker stop'
    abbr -a dkstart 'docker start'
    abbr -a dkprune 'docker system prune -f'
    abbr -a dkvprune 'docker volume prune -f'
end

# =============================================================================
# Systemd (systemctl)
# =============================================================================
if command -v systemctl >/dev/null 2>&1
    # User commands (no sudo needed)
    abbr -a sc 'systemctl'
    abbr -a scu 'systemctl --user'
    abbr -a sc-status 'systemctl status'
    abbr -a sc-show 'systemctl show'
    abbr -a sc-cat 'systemctl cat'
    abbr -a sc-list 'systemctl list-units'
    abbr -a sc-list-timers 'systemctl list-timers'
    abbr -a sc-list-sockets 'systemctl list-sockets'
    abbr -a sc-is-active 'systemctl is-active'
    abbr -a sc-is-enabled 'systemctl is-enabled'
    abbr -a sc-is-failed 'systemctl is-failed'

    # User service variants
    abbr -a scu-status 'systemctl --user status'
    abbr -a scu-list 'systemctl --user list-units'
    abbr -a scu-list-timers 'systemctl --user list-timers'

    # Sudo commands
    abbr -a sc-start 'sudo systemctl start'
    abbr -a sc-stop 'sudo systemctl stop'
    abbr -a sc-restart 'sudo systemctl restart'
    abbr -a sc-reload 'sudo systemctl reload'
    abbr -a sc-enable 'sudo systemctl enable'
    abbr -a sc-disable 'sudo systemctl disable'
    abbr -a sc-mask 'sudo systemctl mask'
    abbr -a sc-unmask 'sudo systemctl unmask'
    abbr -a sc-edit 'sudo systemctl edit'
    abbr -a sc-daemon-reload 'sudo systemctl daemon-reload'

    # User service (no sudo needed)
    abbr -a scu-start 'systemctl --user start'
    abbr -a scu-stop 'systemctl --user stop'
    abbr -a scu-restart 'systemctl --user restart'
    abbr -a scu-reload 'systemctl --user reload'
    abbr -a scu-enable 'systemctl --user enable'
    abbr -a scu-disable 'systemctl --user disable'
    abbr -a scu-daemon-reload 'systemctl --user daemon-reload'

    # Journalctl
    abbr -a jc 'journalctl'
    abbr -a jcf 'journalctl -f'
    abbr -a jcu 'journalctl --user'
    abbr -a jcfu 'journalctl --user -f'
    abbr -a jc-boot 'journalctl -b'
    abbr -a jc-tail 'journalctl -n 100'
end
