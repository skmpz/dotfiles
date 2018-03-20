check() {
    if [ "$1" == "0" ]; then
        echo -e "[\e[0;32mOK\e[0m]"
    else
        echo -e "[\e[0;31mFAIL\e[0m]"
        exit 1
    fi
}

echo -n "Installing system tools...... "
# pkg install -y xorg > .install.log
check $?

echo -n "Installing window manager.... "
pkg install -y i3 i3status i3lock rofi rxvt-unicode urxvt-perls >> .install.log
check $?

echo -n "Installing desktop apps...... "
pkg install -y caja caja-extensions engrampa evince gedit chrome rtorrent mpv >> .install.log
check $?

echo -n "Installing editors........... "
pkg install -y vim neovim >> .install.log
check $?
