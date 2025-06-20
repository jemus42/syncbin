# Environment Variables and Path Configuration
# Loaded after early config

# Terminal colors and encoding
if not string match -q "*256color*" $TERM
    set -x TERM xterm-256color
end

# Homebrew setup (early in PATH)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
if test -x $HOME/.linuxbrew/bin/brew
    eval ($HOME/.linuxbrew/bin/brew shellenv)
end

# Locale settings
if string match -q "*blog*" (hostname)
    # Edge case for beartooth / centOS
    echo "Applying LC_LANG for beartooth"
    set -x LC_ALL en_US.utf8
    set -x LANG en_US.utf8
else if test (hostname) != "ppth"
    # Regular case
    set -x LC_ALL en_US.UTF-8
    set -x LANG en_US.UTF-8
end

# Default editor
set -x MICRO_TRUECOLOR 1
if command -v micro >/dev/null 2>&1
    set -x EDITOR micro
else
    set -x EDITOR nano
end

# PATH setup - ensure basic system paths are preserved
if not contains /usr/bin $PATH
    set -x PATH /usr/bin /bin /usr/sbin /sbin $PATH
end

# Add custom paths
fish_add_path -p $HOME/.local/bin
fish_add_path $HOME/bin $SYNCBIN/bin
fish_add_path $SYNCBIN/bin/iterm2-utils

# Cargo/Rust and Go
if test -e $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end
if test -e $HOME/go/bin
    fish_add_path $HOME/go/bin
end

# Pager setup
if command -v bat >/dev/null 2>&1
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Other tool integrations that need early setup
if command -v broot >/dev/null 2>&1; and test -f $HOME/.config/broot/launcher/bash/br
    # Fish doesn't have a direct broot integration, use bash version
    function br
        bash -c "source $HOME/.config/broot/launcher/bash/br && br $argv"
    end
end