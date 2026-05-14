# Bash Early Configuration
# This file should be loaded first

# Basic environment setup
export SYNCBIN=${SYNCBIN:-$HOME/syncbin}
export host_short="$(uname -n)"
export host_os="$(uname -s)"
export ME=$(whoami)

# Bash-specific options
set -o emacs  # Use emacs key bindings
shopt -s checkwinsize  # Check window size after each command
shopt -s histappend    # Append to history file
shopt -s cmdhist       # Save multi-line commands in history as single line
shopt -s cdspell       # Correct minor spelling errors in cd commands

# History configuration
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and commands starting with space
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T '

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"