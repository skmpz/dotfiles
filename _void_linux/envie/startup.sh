#!/bin/bash

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "2" ]; then

    # 1-screen setup (home)
    middle_display=$(swaymsg -t get_outputs -p | grep U2720Q | cut -f2 -d' ')
    laptop_display="eDP-1"

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
    swaymsg 'workspace 3; exec ~/dotfiles/_void_linux/envie/alacritty/alacritty-start.sh'
    sleep 1
    swaymsg 'workspace 3; exec ~/dotfiles/_void_linux/envie/alacritty/alacritty-start.sh'
    sleep 1

    # workspace 4
    swaymsg 'workspace 4; exec ~/dotfiles/_void_linux/envie/alacritty/alacritty-start.sh'
    sleep 1
    swaymsg 'workspace 4; exec ~/dotfiles/_void_linux/envie/alacritty/alacritty-start.sh'
    sleep 1

    # workspace 9
    swaymsg 'workspace 9; exec keepassxc'
    sleep 3

    # set current to main
    swaymsg 'workspace 1'
    sleep 1
fi
