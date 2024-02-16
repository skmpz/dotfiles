PROG=$( basename $0 )

case "$1" in
    -h|--help)
        echo "Usage: $PROG"
        echo
        echo 'shows the properties of the focused window

best bindings:
bindsym  $mod+question exec sway-prop
bindsym $a+$c+question exec sway-prop

but if running from a terminal rather than a sway key binding:
sleep 2; sway-prop'
        exit 0
        ;;
esac

TMP=/tmp/sway-prop-$$.tmp

trap "rm $TMP" EXIT

swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true)' > "$TMP"

if [[ "$1" || -t 1 ]]; then
    cat "$TMP"
else
    # I prefer to popup a terminal eg:
    if type kitty &> /dev/null; then
        kitty --class floating -e bash -c "less $TMP"
    else
        # ... but sway doesn't have anything like i3-sensible-terminal.
        # swaynag is always installed with sway, so:
        swaynag -l -m "sway-prop" < "$TMP"
    fi
fi

