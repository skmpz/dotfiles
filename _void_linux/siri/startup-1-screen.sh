#!/bin/bash

# workspace 1
swaymsg 'workspace 1; exec joplin --enable-features=UseOzonePlatform --ozone-platform=wayland'
sleep 10

# workspace 2
swaymsg 'workspace 2; exec google-chrome-stable'
sleep 10
swaymsg 'workspace 2; exec firefox-wayland'
sleep 10

# workspace 3
swaymsg 'workspace 3; exec alacritty'
sleep 1
swaymsg 'workspace 3; exec alacritty'
sleep 1

# workspace 4
swaymsg 'workspace 4; exec alacritty'
sleep 1
swaymsg 'workspace 4; exec alacritty'
sleep 1

# workspace 9
swaymsg 'workspace 9; exec keepassxc'
sleep 3

# set current to main
swaymsg 'workspace 1'
sleep 1
