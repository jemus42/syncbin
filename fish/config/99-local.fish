# Local Overrides and Final Setup
# User-specific customizations and cleanup
#
# XDG-compliant local configs: ~/.config/syncbin/
#   - env           : Environment variables (KEY=value per line)
#   - path          : PATH additions (one directory per line)
#   - *.fish        : Fish-specific configs (all files sourced)
#
# For experimentation, just drop a new .fish file in ~/.config/syncbin/

set -l SYNCBIN_LOCAL "$XDG_CONFIG_HOME/syncbin"
test -z "$SYNCBIN_LOCAL"; and set SYNCBIN_LOCAL "$HOME/.config/syncbin"

# Load environment variables from XDG location
if test -r "$SYNCBIN_LOCAL/env"
    while read -l line
        # Skip empty lines and comments
        test -z "$line"; and continue
        string match -q '#*' "$line"; and continue
        # Parse KEY=value
        set -l parts (string split -m1 '=' "$line")
        if test (count $parts) -eq 2
            set -gx $parts[1] $parts[2]
        end
    end < "$SYNCBIN_LOCAL/env"
end

# Load PATH additions from XDG location
if test -r "$SYNCBIN_LOCAL/path"
    while read -l path_entry
        # Skip empty lines and comments
        test -z "$path_entry"; and continue
        string match -q '#*' "$path_entry"; and continue
        if test -d "$path_entry"
            fish_add_path -p "$path_entry"
        end
    end < "$SYNCBIN_LOCAL/path"
end

# Source all .fish files from XDG location
if test -d "$SYNCBIN_LOCAL"
    for f in $SYNCBIN_LOCAL/*.fish
        test -r "$f"; and source "$f"
    end
end

# Legacy support: load old ~/.*local files if they exist
# TODO: Migrate these to ~/.config/syncbin/ and remove
if test -r "$HOME/.env.local"
    if command -v bass >/dev/null 2>&1
        bass source "$HOME/.env.local"
    end
end

if test -r "$HOME/.path.local"
    while read -l path_entry
        test -d "$path_entry"; and fish_add_path "$path_entry"
    end < "$HOME/.path.local"
end

if test -r "$HOME/.functions.local"
    if command -v bass >/dev/null 2>&1
        bass source "$HOME/.functions.local"
    end
end

# Load HPC-specific aliases if available
if test -r "$SYNCBIN/zsh/aliases-hpc.sh"
    if command -v bass >/dev/null 2>&1
        bass source "$SYNCBIN/zsh/aliases-hpc.sh"
    end
end