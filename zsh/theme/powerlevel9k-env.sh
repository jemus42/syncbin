if [[ $(uname -s) = FreeBSD ]] ; then
    POWERLEVEL9K_MODE=""
else
    POWERLEVEL9K_MODE="nerdfont-complete"
fi

# Hide false-positive(?) warning on FreeBSD
POWERLEVEL9K_IGNORE_TERM_COLORS=true

DEFAULT_USER=$USER

# Segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon 
    context 
    dir 
    vcs 
    anaconda 
    virtualenv
    )

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status 
    command_execution_time 
    root_indicator 
    background_jobs 
    #history
    time
    )