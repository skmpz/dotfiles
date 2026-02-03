#!/bin/bash

# Get focused output
output=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).output')
resolution=$(swaymsg -t get_outputs -r | jq -r --arg OUT "$output" '.[] | select(.name == $OUT) | "\(.current_mode.width)x\(.current_mode.height)" ')

echo $resolution

if [ "$resolution" = "1920x1080" ]; then
    alacritty --config-file ~/dotfiles/alacritty/alacritty1920x1080.toml
elif [ "$resolution" = "2560x1600" ]; then
    alacritty --config-file ~/dotfiles/alacritty/alacritty2560x1600.toml
elif [ "$resolution" = "2560x1440" ]; then
    alacritty --config-file ~/dotfiles/alacritty/alacritty2560x1440.toml
elif [ "$resolution" = "3840x2160" ]; then
    alacritty --config-file ~/dotfiles/alacritty/alacritty3840x2160.toml
fi
