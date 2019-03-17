# Init oh-my-zsh stuff

export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel9k/powerlevel9k"

if [[ $host_os != FreeBSD ]]; then
   ZSH_THEME="powerlevel9k/powerlevel9k"
elif [[ $MOSH = 1 ]]; then
    ZSH_THEME="jemus42"
else 
    ZSH_THEME="powerlevel9k/powerlevel9k"
fi

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Reduce startup time by not giving a fuck
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=69

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# This should be done via liquidprompt I guess?
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Disabled because of false-positives that were starting to get annoying

plugins=(rsync extract git-flow z 
         catimg
         colored-man-pages
         common-aliases
         encode64
         systemadmin
         zsh_reload
         systemd # Technically platform-specific, not sure how to (quickly) test for it tho
         perms
         # These go at the bottom
         zsh-completions
         zsh-syntax-highlighting 
         zsh-autosuggestions
         )

# Platform-specific plugins
[ $host_os = "Darwin" ] && plugins+=(scw osx)

source $ZSH/oh-my-zsh.sh