#!/bin/bash

# Get focused output
output=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).output')

if [ "$output" = "eDP-1" ]; then
    alacritty --config-file ~/dotfiles/_void_linux/envie/alacritty/alacritty.toml
else
    alacritty --config-file ~/dotfiles/_void_linux/envie/alacritty/alacritty-smaller.toml
fi
