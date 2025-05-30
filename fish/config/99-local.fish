# Local Overrides and Final Setup
# User-specific customizations and cleanup

# Load local environment overrides
if test -e $HOME/.env.local
    # Fish doesn't have direct sourcing of shell scripts, use bass or manual parsing
    if command -v bass >/dev/null 2>&1
        bass source $HOME/.env.local
    else
        echo "Skipping .env.local (requires bass plugin or fish-compatible syntax)"
    end
end

if test -e $HOME/.path.local
    # Add paths from .path.local
    while read -l path_entry
        if test -d $path_entry
            fish_add_path $path_entry
        end
    end < $HOME/.path.local
end

if test -e $HOME/.functions.local
    # Only source if it's fish-compatible, otherwise skip
    if command -v bass >/dev/null 2>&1
        bass source $HOME/.functions.local
    else
        echo "Skipping .functions.local (requires bass plugin or fish-compatible syntax)"
    end
end

# Load HPC-specific aliases if available (should work in fish too)
if test -e $SYNCBIN/zsh/aliases-hpc.sh
    # Source shell script using bass if available, otherwise skip
    if command -v bass >/dev/null 2>&1
        bass source $SYNCBIN/zsh/aliases-hpc.sh
    end
end