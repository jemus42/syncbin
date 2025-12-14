#!/bin/sh
# Shared aliases for bash and zsh
# This file uses POSIX-compatible syntax to work in both shells
# Source this from bash and zsh configs

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
