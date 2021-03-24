#!/usr/bin/env sh

pkill polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar main -c ~/.config/polybar/config.ini &
polybar sec -c ~/.config/polybar/config.ini &
