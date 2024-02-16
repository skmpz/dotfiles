cat ~/.config/sway/config | sed 's/DP-3/TEMP/g' | sed 's/DP-4/DP-3/g' | sed 's/TEMP/DP-4/g' > .tmp
mv .tmp ~/.config/sway/config
swaymsg reload
