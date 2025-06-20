# Tmux Configuration and Functions
# Terminal multiplexer integration

# Tmux session management functions
function tmn () {
  if [ -z "${1}" ]; then
    tmux new-session -A -s "${host_short}"
  else
    tmux new-session -A -s "${1}"
  fi
}

tma () {
    local session_name
    if [ -z "${1}" ]; then
        session_name="${host_short}"
    else
        session_name="${1}"
    fi

    if tmux list-sessions | grep -q "^${session_name}:"; then
        # Session exists, attach to it
        _zsh_tmux_plugin_run attach -t "${session_name}"
    else
        # Session does not exist, create it and then attach
        tmux new-session -s "${session_name}"
        _zsh_tmux_plugin_run attach -t "${session_name}"
    fi
}