#!/bin/bash

# fix audio
# ~/dotfiles/sway/fixaudio.sh

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "1" ] || [ $monitor_count == "2" ]; then

    # reset
    swaymsg 'workspace 1; workspace 5'
    swaymsg 'workspace 2; workspace 6'

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
else

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
    sleep 1
    swaymsg 'workspace 2'
    sleep 1
    swaymsg 'workspace 3'
fi
