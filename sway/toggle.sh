cat ~/.config/sway/config | sed 's/DP-6/TEMP/g' | sed 's/DP-7/DP-6/g' | sed 's/TEMP/DP-7/g' > .tmp
mv .tmp ~/.config/sway/config
swaymsg reload
