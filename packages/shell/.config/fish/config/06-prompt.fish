# Prompt Configuration
# Terminal prompt setup and theming

# Starship prompt (if available)
if command -v starship >/dev/null 2>&1
    starship init fish | source
else
    # Fish has a nice default prompt, but we can customize it
    # Fish prompt is defined through functions
    
    function fish_prompt
        # Get current directory
        set_color blue
        echo -n (prompt_pwd)
        
        # Git branch (if in a git repo)
        set git_branch (git branch 2>/dev/null | sed -n 's/* \(.*\)/\1/p')
        if test -n "$git_branch"
            set_color yellow
            echo -n " ($git_branch)"
        end
        
        set_color normal
        echo -n " \$ "
    end
    
    function fish_right_prompt
        # Show last command duration if > 1s
        if test $CMD_DURATION -gt 1000
            set_color cyan
            echo (math $CMD_DURATION / 1000)"s"
            set_color normal
        end
    end
end