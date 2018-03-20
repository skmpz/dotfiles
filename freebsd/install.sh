function check {
    if [ "$1" == "0" ]; then
        echo -e "[\e[0;32mOK\e[0m]"
    else
        echo -e "[\e[0;31mFAIL\e[0m]"
        exit 1
    fi
}

echo -n "Installing system tools...... "
pkg install -y xorg i3 rofi rxvt-unicode
check $?
