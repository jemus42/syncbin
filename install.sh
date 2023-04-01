#! /usr/bin/env zsh

# Define SYNCBIN here as well as in zshrc because this might be called on fresh installs
export SYNCBIN=$HOME/syncbin

# Create .config dir if needed
test ! -d ~/.config/zsh && mkdir -p $HOME/.config/zsh
test ! -d ~/.config/broot && mkdir -p $HOME/.config/broot
test ! -d ~/.config/conda && mkdir -p $HOME/.config/conda
test ! -d ~/.config/zellij && mkdir -p $HOME/.config/zellij
test ! -d ~/.config/lsd && mkdir -p $HOME/.config/lsd
test ! -d ~/.config/micro && mkdir -p $HOME/.config/micro

#########################
## Installing dotfiles ##
#########################
ln -sf $SYNCBIN/zsh/zshrc.zsh $HOME/.zshrc
ln -sf $SYNCBIN/screenrc $HOME/.screenrc
ln -sf $SYNCBIN/tmux.conf $HOME/.tmux.conf
ln -sf $SYNCBIN/R/Rprofile $HOME/.Rprofile
ln -sf $SYNCBIN/zsh/theme/starship.toml $HOME/.config/starship.toml
ln -sf $SYNCBIN/broot_conf.hjson $HOME/.config/broot/conf.hjson
ln -sf $SYNCBIN/R/radian_profile $HOME/.radian_profile
ln -sf $SYNCBIN/condarc $HOME/.config/conda/condarc
ln -sf $SYNCBIN/zellij $HOME/.config/zellij/config.yaml
ln -sf $SYNCBIN/lsd.conf.yml $HOME/.config/lsd/config.yaml
ln -sf $SYNCBIN/helix $HOME/.config/helix
ln -sf $SYNCBIN/micro/settings.json $HOME/.config/micro/settings.json
ln -sf $SYNCBIN/micro/bindings.json $HOME/.config/micro/bindings.json

# Install OMZSH if not present
# After this is executed, the rest of the script doesn't run anymore :(
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Link ZSH theme to OMZSH custom theme dir only if already doing the OMZ thing
test -d "$HOME/.oh-my-zsh" && ln -sf $SYNCBIN/zsh/theme/jemus42.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/jemus42.zsh-theme

git -C $SYNCBIN submodule update --init --recursive

# Only for macOS
if [[ $host_os == Darwin ]]; then
  test ! -d ~/.config/alacritty && mkdir -p $HOME/.config/alacritty
  ln -sf $SYNCBIN/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

  ln -sf $SYNCBIN/zed $HOME/.config/zed
fi
