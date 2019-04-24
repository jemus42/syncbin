# if [[ $(host_os) = FreeBSD ]] ; then
#     POWERLEVEL9K_MODE=""
# else
#     POWERLEVEL9K_MODE="nerdfont-complete"
# fi

POWERLEVEL9K_MODE="nerdfont-complete"

# Hide false-positive(?) warning on FreeBSD
[ $host_os = "FreeBSD" ] && POWERLEVEL9K_IGNORE_TERM_COLORS=true

####
#### Conext (user + host)
####
POWERLEVEL9K_CONTEXT_TEMPLATE=%n:%m
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=false

POWERLEVEL9K_ALWAYS_SHOW_USER=false


# State	Meaning
# DEFAULT	You are a normal user
# ROOT	You are the root user
# SUDO	You are using elevated rights
# REMOTE_SUDO	You are SSH'ed into the machine and have elevated rights
# REMOTE	You are SSH'ed into the machine

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='black'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='grey9'

####
#### Icons
####

POWERLEVEL9K_OS_ICON_BACKGROUND='black'

POWERLEVEL9K_ROOT_ICON="\uF09C"
POWERLEVEL9K_USER_ICON="" # "\uF415"
POWERLEVEL9K_SUDO_ICON=$'\uF09C'

POWERLEVEL9K_HOST_ICON=""
POWERLEVEL9K_SSH_ICON=""

# Default user only for my local machine
DEFAULT_USER=Lukas

###
### Folder truncation
###
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_first_and_last" # "truncate_to_unique"  # "truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

####
#### Multiline
####

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
 POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%F{white}"

POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%F{white} "
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=""

###
### colors
###
POWERLEVEL9K_USER_DEFAULT_BACKGROUND='black'
POWERLEVEL9K_USER_DEFAULT_FOREGROUND='grey9'

POWERLEVEL9K_USER_ROOT_BACKGROUND='black'
POWERLEVEL9K_USER_ROOT_FOREGROUND='red'

POWERLEVEL9K_HOST_LOCAL_BACKGROUND='black'
POWERLEVEL9K_HOST_LOCAL_FOREGROUND='grey9'

POWERLEVEL9K_HOST_REMOTE_FOREGROUND='white'
POWERLEVEL9K_HOST_REMOTE_BACKGROUND='black'


POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="black"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="red"

POWERLEVEL9K_DIR_HOME_BACKGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="black"

POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="blue"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="black"

POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="blue"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="black"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="black"

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="black"

POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="red"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="black"

#POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$''
#POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$''

#POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''

###
### Segments
###
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon 
    # ssh
    context_joined 
    root_indicator_joined

    # user_joined host_joined
    dir_writable dir
    
    # newline
    
    vcs 
    # newline
    # os_icon
    # battery
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status 
    command_execution_time 
    anaconda 
    virtualenv
    background_jobs 
    # disk_usage
    # ram
    time
    # date
)

# For debugging etc, to manually print specific segments/characters
# echo $(print_icon 'LEFT_SEGMENT_SEPARATOR')