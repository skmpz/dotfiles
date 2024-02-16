cat $HOME/.config/sway/config.base $HOME/.config/sway/config.local > $HOME/.config/sway/config
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_CURRENT_DESKTOP=sway
dbus-run-session ssh-agent sway
