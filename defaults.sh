#! /bin/sh
# Yes, yet another "make everything okay"-script. It's my first.
# Partly taken from https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# Partly from Quinn Nelson https://www.youtube.com/watch?v=psPgSN1bPLY

## No popup menu on keypress (umlauts)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## Change system screenshot location and disable shadow under windows
## (And set the format to jpg)
# First test if the desired folder exist (won't autocreate)

if [ ! -d "~/Pictures/Screenshots" ]; then
    mkdir ~/Pictures/Screenshots;
fi

defaults write com.apple.screencapture location ~/Pictures/Screenshots/
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "jpg"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

## Make changes take effect
killall SystemUIServer


# Disable dock bounce
defaults write com.apple.dock no-bouncing -bool TRUE; killall Dock

# Faster dock hiding
defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0.1;killall Dock
# Undo: 
# defaults write com.apple.dock autohide-delay -float 0.5; defaults write com.apple.dock autohide-time-modifier -int 0.5 ;killall Dock

# Add dock spacer (paste for each spacer): 
# defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && killall Dock
# Add half-height dock spacer (paste for each): #
# defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}' && killall Dock

# Disable DIsk eject warning (must restart Mac to take effect): 
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd
# Re-enable warning: sudo defaults delete /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification && sudo pkill diskarbitrationd
# Alternatively, download ejectify: https://ejectify.app

# Make hidden apps transparent: 
defaults write com.apple.Dock showhidden -bool TRUE && killall Dock

#######################
## Preview/QuickLook ##
#######################
# It should display plaintextfiles, so yeah. (via https://coderwall.com/p/dlithw)

if [ ! -d "/Library/QuickLook/QLStephen.qlgenerator" ]; then
	## Download latest version of QLStephen
	cd ~/Downloads;
	wget https://github.com/downloads/whomwah/qlstephen/QLStephen.qlgenerator.zip;
	unzip QLStephen.qlgenerator.zip;

	## Move it in the right place
	sudo cp -r QLStephen.qlgenerator /Library/QuickLook/

	## Make changes take effect
	qlmanage -r
fi
# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

###################
##  Finder stuff ##
###################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

###############
##  General  ##
###############

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Don’t show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable Disk Utility debug menu
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true

# Disable system startup sound
sudo nvram SystemAudioVolume=%80
