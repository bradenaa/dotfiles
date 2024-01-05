#!/bin/zsh

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Free the Dock
defaults write com.apple.Dock size-immutable -bool no; killall Dock

# Remove the auto-hiding Dock delay
defaults write com.apple.dock "autohide" -bool "true" && killall Dock
defaults write com.apple.Dock autohide-delay -float 0; killall Dock

# Remove the animation when hiding/showing the Dock
defaults write com.apple.Dock autohide-time-modifier -float 0; killall Dock

# Set the icon size of Dock items
defaults write com.apple.Dock tilesize -int 35

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2 # normal minimum is 2 (30 ms)
defaults write NSGlobalDomain InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Lock the Dock size
defaults write com.apple.Dock size-immutable -bool yes; killall Dock
