# Third-Party Tool Integrations
# External tool initialization and configuration

# McFly history search (if available)
if command -v mcfly >/dev/null 2>&1
    mcfly init fish | source
    set -x MCFLY_FUZZY 1
    set -x MCFLY_RESULTS_SORT LAST_RUN
    set -x MCFLY_PROMPT "❯"
    set -x MCFLY_RESULTS 25
end

# Nix package manager
if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
    # Fish doesn't have a direct equivalent, use bash source
    function nix-env-init
        bash -c "source $HOME/.nix-profile/etc/profile.d/nix.sh && env" | \
        while read -l line
            if string match -q "*=*" $line
                set var (string split -m 1 = $line)
                set -x $var[1] $var[2]
            end
        end
    end
    nix-env-init
end

# Fish has built-in completions for many tools, but we can add more

# Direnv integration (if available)
if command -v direnv >/dev/null 2>&1
    direnv hook fish | source
end

# Zoxide integration (if available)
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end