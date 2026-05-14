# Shell Completions Configuration
# Custom completions path for fish

# Carapace completions (if available) - load first as primary completion system
if command -v carapace >/dev/null 2>&1
    set -x CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    carapace _carapace fish | source
end

# Custom completions as fallback for commands carapace doesn't support
# Fish sources .fish files from fish_complete_path automatically,
# so we selectively add only files for commands carapace doesn't handle
function __syncbin_load_custom_completions
    if test -n "$SYNCBIN"
        set -l comp_dir "$SYNCBIN/fish/completions"
    else
        set -l comp_dir "$HOME/syncbin/fish/completions"
    end

    test -d "$comp_dir"; or return

    # Get list of commands carapace handles
    set -l carapace_cmds
    if command -v carapace >/dev/null 2>&1
        set carapace_cmds (carapace --list 2>/dev/null | string replace -r ' .*' '')
    end

    # Source completions for commands carapace doesn't handle
    for comp_file in $comp_dir/*.fish
        test -r "$comp_file"; or continue
        set -l cmd_name (basename $comp_file .fish)
        # Skip if carapace handles this command
        if contains -- $cmd_name $carapace_cmds
            continue
        end
        source $comp_file
    end
end
__syncbin_load_custom_completions
functions -e __syncbin_load_custom_completions
