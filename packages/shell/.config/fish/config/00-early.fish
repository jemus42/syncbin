# Fish Early Configuration
# This file should be loaded first

# Basic environment setup
set -x SYNCBIN (test -n "$SYNCBIN" && echo $SYNCBIN || echo $HOME/syncbin)
set -x host_short (uname -n)
set -x host_os (uname -s)
set -x ME (whoami)

# Fish-specific settings are handled by fish itself
# Fish has sensible defaults for history, completion, etc.