#!/bin/bash

# workspace 1
swaymsg 'workspace 1; exec alacritty -o font.size=14 --hold -e ssh -D 1337 intserv'
sleep 2
swaymsg 'workspace 1; split v'
sleep 2
swaymsg 'workspace 1; exec google-chrome-stable'
sleep 10
swaymsg 'workspace 1; resize grow height 80 px or 80 ppt;'
sleep 2

# workspace 2
swaymsg 'workspace 2; exec alacritty -o font.size=14 --hold -e weechat'
sleep 2
swaymsg 'workspace 2; split v'
sleep 2
swaymsg 'workspace 2; exec joplin'
sleep 10
swaymsg 'workspace 2; resize grow height 50 px or 50 ppt;'
sleep 2

# workspace 3
swaymsg 'workspace 3; exec alacritty'
sleep 2
swaymsg 'workspace 3; exec alacritty'
sleep 2

# # workspace 4
swaymsg 'workspace 4; exec alacritty'
sleep 2
swaymsg 'workspace 4; exec alacritty'
sleep 2

# set current to main
swaymsg 'workspace 1'
swaymsg 'workspace 3'
