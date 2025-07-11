#!/bin/bash

# reset
swaymsg 'workspace 1; workspace 5'
swaymsg 'workspace 2; workspace 6'
swaymsg 'workspace 3; workspace 7'
swaymsg 'workspace 4; workspace 8'

# workspace 1
swaymsg 'workspace 1; exec alacritty'
sleep 1
swaymsg 'workspace 1; split v'
sleep 1
swaymsg 'workspace 1; exec google-chrome-stable'
sleep 8
swaymsg 'workspace 1; resize set height 3500px'
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
swaymsg 'workspace 2; resize set height 3500px'
sleep 1
swaymsg 'workspace 2; focus up;'
sleep 1
swaymsg 'workspace 2; split h'
sleep 1
swaymsg 'workspace 2; exec alacritty'

# workspace 8
swaymsg 'workspace 8; exec alacritty'
sleep 1
swaymsg 'workspace 8; split v'
sleep 1
swaymsg 'workspace 8; exec alacritty -o font.size=14 --hold -e ssh cvoid -t "export TERM=rxvt; tmux a"'
sleep 1

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

# set current to main
swaymsg 'workspace 1'
sleep 1
swaymsg 'workspace 2'
sleep 1
swaymsg 'workspace 3'
