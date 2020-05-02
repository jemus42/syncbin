#! /usr/bin/env zsh

# Define SYNCBIN here as well as in zshrc because this might be called on fresh installs
export SYNCBIN=$HOME/syncbin

# Create .config dir if needed
test ! -d ~/.config/zsh && mkdir -p $HOME/.config/zsh

#########################
## Installing dotfiles ##
#########################
ln -sf $SYNCBIN/zsh/zshrc.zsh $HOME/.zshrc
ln -sf $SYNCBIN/screenrc $HOME/.screenrc
ln -sf $SYNCBIN/tmux.conf $HOME/.tmux.conf
ln -sf $SYNCBIN/zsh/theme/starship.toml $HOME/.config/starship.toml

ln -sf $SYNCBIN/R/radian_profile $HOME/.radian_profile

# Unused
# ln -sf $SYNCBIN/zsh/liquidpromptrc $HOME/.config/liquidpromptrc

# Install OMZSH if not present
# After this is executed, the rest of the script doesn't run anymore :(
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &
fi

# Link ZSH theme to OMZSH custom theme dir only if already doing the OMZ thing
test -d "$HOME/.oh-my-zsh" && ln -sf $SYNCBIN/zsh/theme/jemus42.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/jemus42.zsh-theme

# Only for macOS
if [[ $host_os == Darwin ]]; then
  # store path to settings file for convenience
  itermpref=$HOME/Library/Preferences/com.googlecode.iterm2.plist
  
  # Backup existing file only if it exists and isn't a symlink already
  test ! -L $itermpref && mv $itermpref ${itermpref}_bak

  # Symlink syncbin settings into place
  ln -s $SYNCBIN/com.googlecode.iterm2.plist $itermpref

  # Install RStudio prefs symlink
  mkdir -p $HOME/.config/rstudio
  ln -s $SYNCBIN/R/rstudio-prefs-Dufte.json $HOME/.config/rstudio/rstudio-prefs.json

  # VSCode User settings
  ln -sf $SYNCBIN/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
  ln -sf $SYNCBIN/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  ln -sf $SYNCBIN/vscode/snippets $HOME/Library/Application\ Support/Code/User/snippets
fi
