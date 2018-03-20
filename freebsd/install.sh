check() {
    if [ "$1" == "0" ]; then
        echo -e "[\e[0;32mOK\e[0m]"
    else
        echo -e "[\e[0;31mFAIL\e[0m]"
        exit 1
    fi
}

check_no_ok() {
    if [ "$1" != "0" ]; then
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

echo -n "Setting up configs........... "
rm -rf /home/sk/.bash/
rm -rf /home/sk/.bashrc
rm -rf /home/sk/.gtkrc-2.0
rm -rf /home/sk/.xinitrc
rm -rf /home/sk/.Xresources
rm -rf /home/sk/.config/i3/*
rm -rf /home/sk/.config/gtk-3.0/settings.ini
rm -rf /home/sk/.config/nvim/init.vim
rm -rf /home/sk/.urxvt/
mkdir -p /home/sk/.bash/
mkdir -p /home/sk/.config/i3/
mkdir -p /home/sk/.config/nvim/
mkdir -p /home/sk/.config/gtk-3.0/
mkdir -p /home/sk/.urxvt/ext/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2> /dev/null
check_no_ok $?
git clone https://github.com/skmpz/git-aware-prompt /home/sk/.bash/git-aware-prompt > /dev/null 2> /dev/null
check_no_ok $?
cp font-size /home/sk/.urxvt/ext/
ln -s /home/sk/dotfiles/freebsd/bashrc /home/sk/.bashrc
ln -s /home/sk/dotfiles/freebsd/xresources /home/sk/.Xresources
ln -s /home/sk/dotfiles/freebsd/xinitrc /home/sk/.xinitrc
ln -s /home/sk/dotfiles/freebsd/gtkrc-2.0 /home/sk/.gtkrc-2.0
ln -s /home/sk/dotfiles/freebsd/config /home/sk/.config/i3/config
ln -s /home/sk/dotfiles/freebsd/init.vim /home/sk/.config/nvim/init.vim
ln -s /home/sk/dotfiles/freebsd/settings.ini /home/sk/.config/gtk-3.0/settings.ini
fc-cache -fv > /dev/null
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
sysrc dbus_enable="YES"
sysrc hald_enable="YES"
sysrc linux_enable="YES"

check $?
