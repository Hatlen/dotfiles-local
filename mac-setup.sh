# Disable inserting of special characters when long pressing keys:
defaults write -g ApplePressAndHoldEnabled -bool false

# Quicker key repeats:
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2

# Touchpad tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
