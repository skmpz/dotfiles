xset r rate 250 80
setxkbmap -option grp:win_space_toggle us,el
xrdb -merge ~/.Xresources
setxkbmap -option caps:escape
feh --bg-scale ~/dotfiles/bg.png
xrandr --output DP-4 --primary
xrandr --output DP-2 --right-of DP-4
exec i3
#exec mate-session
#exec gnome-session
#exec startfluxbox
