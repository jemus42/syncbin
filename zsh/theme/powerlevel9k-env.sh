# if [[ $(host_os) = FreeBSD ]] ; then
#     POWERLEVEL9K_MODE=""
# else
#     POWERLEVEL9K_MODE="nerdfont-complete"
# fi

POWERLEVEL9K_MODE="nerdfont-complete"

# Hide false-positive(?) warning on FreeBSD
POWERLEVEL9K_IGNORE_TERM_COLORS=true

####
#### Conext (user + host)
####
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
POWERLEVEL9K_ALWAYS_SHOW_USER=true

POWERLEVEL9K_CONTEXT_TEMPLATE=%n:%m

# Default user only for my local machine
DEFAULT_USER=Lukas

####
#### Multiline
####

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─ "
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

#POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B1'
#POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B3'

###
### Segments
###
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon 
    ssh
    #context 
    user host
    dir 
    dir_writable
    
    #newline
    
    vcs 
    anaconda 
    virtualenv
    )

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status 
    command_execution_time 
    root_indicator 
    background_jobs 
    #disk_usage
    #history
    time
    )