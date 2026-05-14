# RStudio Server Functions
# Server management and monitoring functions

# RStudio server aliases and functions (only if rstudio-server is available)
if command -v rstudio-server >/dev/null 2>&1
    alias rs="rstudio-server"
    alias rs-status="rstudio-server status"
    alias rs-active="rstudio-server active-sessions"
    alias rs-restart="sudo rstudio-server restart"
    alias rs-stop="sudo rstudio-server stop"
    alias rs-kill="sudo rstudio-server kill-session"

    # Count active sessions by user
    function rs-active-count
        # Get active sessions, extract user field, remove empty line,
        # sort to group users, count unique users, print descending
        rstudio-server active-sessions | awk '{print $5}' | awk NF | sort | uniq -c | sort -bgr
    end

    # Server monitoring functions
    function whothere
        echo "Logged in users:"
        echo ""

        whoc

        echo "----------------------"
        echo ""

        echo "rstudio server sessions:"
        echo ""

        rs-active-count
        
        echo "----------------------"
        echo ""
        
        echo "Processes by user:"
        echo ""

        for user in (members -p emmy)
            echo "     $user: "(ps -u "$user" --no-headers | wc -l)
        end
          
        echo "----------------------"
        echo ""
    end

    function whoc
        who | awk '{print $1}' | sort | uniq -c | sort -bgr
    end
end