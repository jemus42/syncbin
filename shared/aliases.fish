# Shared aliases for fish (using abbreviations)
# Fish equivalent of shared/aliases.sh

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
