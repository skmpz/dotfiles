xset r rate 250 80
setxkbmap -option grp:win_space_toggle us,el
xrdb -merge ~/.Xresources
setxkbmap -option caps:escape
feh --bg-scale ~/dotfiles/bg.jpg
xrandr --output DP-2 --primary
xrandr --output DP-4 --right-of DP-2
xrandr --output HDMI-0 --left-of DP-2
exec i3
#exec mate-session
#exec gnome-session
#exec startfluxbox
