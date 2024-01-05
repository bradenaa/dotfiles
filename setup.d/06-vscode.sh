#!/bin/bash

ln -sf /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code $(brew --prefix)/bin/code

# Visual Studio Code :: Package list
pkglist=(
isudox.vscode-jetbrains-keybindings
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done

# Merge dot file settings with the existing settings json
local_settings="${dotfile_root}/vscode/settings.json"
global_user_settings="$HOME/Library/Application Support/Code/User/settings.json"

tmp=$(mktemp)
jq -s '.[0] * .[1]' "$local_settings" "$global_user_settings" > "$tmp" && mv "$tmp" "$global_user_settings" 
