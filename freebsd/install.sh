check() {
    if [ "$1" == "0" ]; then
        echo -e "[\e[0;32mOK\e[0m]"
    else
        echo -e "[\e[0;31mFAIL\e[0m]"
        exit 1
    fi
}

echo -n "Installing xorg.............. "
pkg install -y xorg xclip > .install.log
check $?

echo -n "Installing system tools...... "
pkg install -y cmake gmake e2fsprogs wget unrar python2 python3 py27-pip py36-pip pulseaudio alsa-utils mate-terminal rxvt-unicode urxvt-perls >> .install.log
check $?

echo -n "Installing window manager.... "
pkg install -y i3 i3status i3lock rofi >> .install.log
check $?

echo -n "Installing fonts............. "
pkg install -y dejavu Inconsolata-LGC terminus-ttf sourcecodepro-ttf droid-fonts-ttf >> .install.log
check $?

echo -n "Installing desktop apps...... "
pkg install -y caja caja-extensions engrampa evince gedit chromium rtorrent mpv >> .install.log
check $?

echo -n "Installing editors........... "
pkg install -y vim neovim >> .install.log
check $?
