#!/bin/bash

# reset
swaymsg 'workspace 1; workspace 5'
swaymsg 'workspace 2; workspace 6'
swaymsg 'workspace 3; workspace 7'
swaymsg 'workspace 4; workspace 8'

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)
if swaymsg -t get_outputs -p | grep -q 6PB0P44; then setup_loc="1"; else setup_loc="2"; fi

if [ $monitor_count == "1" ] || [ $monitor_count == "2" ]; then
    swaymsg 'workspace 1; exec joplin --enable-features=UseOzonePlatform --ozone-platform=wayland' && sleep 8
    swaymsg 'workspace 2; exec google-chrome-stable' && sleep 8
    swaymsg 'workspace 3; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 3; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 4; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 4; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 9; exec keepassxc' && sleep 3
    swaymsg 'workspace 1'
else
    swaymsg 'workspace 1; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 1; split v' && sleep 1
    swaymsg 'workspace 1; exec google-chrome-stable' && sleep 8
    swaymsg 'workspace 1; resize set height 3500px' && sleep 1
    swaymsg 'workspace 1; focus up;' && sleep 1
    swaymsg 'workspace 1; split h' && sleep 1
    swaymsg 'workspace 1; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1

    swaymsg 'workspace 2; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 2; split v' && sleep 1
    if [ $monitor_count == "4" ] && [ "$setup_loc" == "1" ]; then
        swaymsg 'workspace 2; exec joplin --enable-features=UseOzonePlatform --ozone-platform=wayland' && sleep 8
        swaymsg 'workspace 2; resize set height 3500px' && sleep 1
    elif [ $monitor_count == "4" ] && [ "$setup_loc" == "2" ]; then
        swaymsg 'workspace 2; exec keepassxc' && sleep 1
        swaymsg 'workspace 2; exec joplin --enable-features=UseOzonePlatform --ozone-platform=wayland' && sleep 8
        swaymsg 'workspace 2; focus up;' && sleep 1
        swaymsg 'workspace 2; focus up;' && sleep 1
        swaymsg 'workspace 2; resize shrink height 1000px' && sleep 1
        swaymsg 'workspace 2; focus down;' && sleep 1
        swaymsg 'workspace 2; focus down;' && sleep 1
        swaymsg 'workspace 2; resize grow height 1400px' && sleep 1
        swaymsg 'workspace 2; focus up;' && sleep 1
    fi
    swaymsg 'workspace 2; focus up;' && sleep 1
    swaymsg 'workspace 2; split h' && sleep 1
    swaymsg 'workspace 2; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1

    swaymsg 'workspace 3; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 3; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1

    swaymsg 'workspace 4; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1
    swaymsg 'workspace 4; exec $HOME/dotfiles/alacritty/alacritty-start.sh' && sleep 1

    swaymsg 'workspace 1' && sleep 1
    swaymsg 'workspace 2' && sleep 1
    swaymsg 'workspace 3' && sleep 1
    swaymsg 'workspace 4'
fi
