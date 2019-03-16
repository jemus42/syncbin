#! /usr/bin/env zsh

# Define SYNCBIN here as well as in zshrc because this might be called on fresh installs
export SYNCBIN=$HOME/syncbin

# Create .config dir if needed
test ! -d ~/.config/zsh && mkdir $HOME/.config

#########################
## Installing dotfiles ##
#########################
ln -sf $SYNCBIN/zsh/zshrc.zsh $HOME/.zshrc
ln -sf $SYNCBIN/screenrc $HOME/.screenrc
ln -sf $SYNCBIN/tmux.conf $HOME/.tmux.conf
ln -sf $SYNCBIN/zsh/liquidpromptrc $HOME/.config/liquidpromptrc

# Link ZSH theme to OMZSH custom theme dir
if [ -d "$HOME/.oh-my-zsh" ]; then
    ln -sf $SYNCBIN/zsh/theme/jemus42.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/jemus42.zsh-theme
fi

#############################################
## General ZSH plugins not included by OMZ ##
#############################################

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ] ; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ] ; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions ] ; then
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions;
fi

###############################
## liquidprompt prompt theme ##
###############################

# if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/liquidprompt ] ; then
#     git clone https://github.com/nojhan/liquidprompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/liquidprompt;
# fi

###############################
## powerlevel9k prompt theme ##
###############################

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k ] ; then
    git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k;
fi