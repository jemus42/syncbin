## No popup menu on keypress (umlauts)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## Change system screenshot location
defaults write com.apple.screencapture location ~/Pictures/

## Make changes take effect
killall SystemUIServer
