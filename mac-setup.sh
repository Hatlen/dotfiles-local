# Good docs for macos settings can be found here:https://macos-defaults.com/

# Install rosetta for running x86 apps on arm macs (only needed for metasploit
# as of 2025-03-21)
softwareupdate --install-rosetta --agree-to-license

# Keyboard settings
## Disable inserting of special characters when long pressing keys:
defaults write -g ApplePressAndHoldEnabled -bool false
## Use f<n> keys as function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
## Quicker key repeats:
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2
## Enable tabbing/keyboard navigation
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# Touchpad tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Configure dock
defaults write com.apple.dock "tilesize" -int "48" && killall Dock
defaults write com.apple.dock autohide -bool true && killall Dock

# Screenshots
defaults write com.apple.screencapture "location" -string "~/Downloads" && killall SystemUIServer

# Finder settings
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" && killall Finder
defaults write com.apple.finder "AppleShowAllFiles" -bool "true" && killall Finder
defaults write com.apple.finder "ShowPathbar" -bool "true" && killall Finder
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" && killall Finder
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1" && killall Finder

# Xcode settings
defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true" && killall Xcode
# Simulator settings
defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "~/Downloads"
