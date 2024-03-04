#!/bin/bash

middle_display=$(swaymsg -t get_outputs -p | grep FVVS5H3 | cut -f2 -d' ')

if [ "$middle_display" == "DP-7" ]; then
    swaymsg 'workspace 1; workspace 7;'
fi

# workspace 1
swaymsg 'workspace 1; exec alacritty'
sleep 1
swaymsg 'workspace 1; split v'
sleep 1
swaymsg 'workspace 1; exec google-chrome-stable'
sleep 8
swaymsg 'workspace 1; resize grow height 80 px or 80 ppt;'
sleep 1
swaymsg 'workspace 1; focus up;'
sleep 1
swaymsg 'workspace 1; split h'
sleep 1
swaymsg 'workspace 1; exec alacritty'
sleep 1

# workspace 2
swaymsg 'workspace 2; exec alacritty'
sleep 1
swaymsg 'workspace 2; split v'
sleep 1
swaymsg 'workspace 2; exec joplin --enable-features=UseOzonePlatform --ozone-platform=wayland'
sleep 8
swaymsg 'workspace 2; resize grow height 80 px or 80 ppt;'
sleep 1
swaymsg 'workspace 2; focus up;'
sleep 1
swaymsg 'workspace 2; split h'
sleep 1
swaymsg 'workspace 2; exec alacritty'
sleep 1

# workspace 3
swaymsg 'workspace 3; exec alacritty'
sleep 1
swaymsg 'workspace 3; exec alacritty'
sleep 1

# # workspace 4
swaymsg 'workspace 4; exec alacritty'
sleep 1
swaymsg 'workspace 4; exec alacritty'
sleep 1

# # workspace 9
swaymsg 'workspace 9; exec keepassxc'
sleep 3

# set current to main
swaymsg 'workspace 1'
swaymsg 'workspace 3'
