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

# prompt for password
sudo ls > /dev/null

echo -n "Setting up sudoers........... "
sudo sh -c 'echo "Defaults timestamp_timeout=-1">>/usr/local/etc/sudoers' >> .install.log 2>> .install.log
check $?

echo -n "Installing system tools...... "
sudo pkg install -y bash cmake uncrustify gmake rsync scrot imagemagick e2fsprogs pkgconf wget unrar python2 python3 py27-pip py36-pip pulseaudio alsa-utils mate-terminal rxvt-unicode urxvt-perls gtk-arc-themes fusefs-ntfs >> .install.log 2>> .install.log
check $?

echo -n "Installing xorg.............. "
sudo pkg install -y xorg xclip > .install.log 2>> .install.log check $?  echo -n "Installing window manager.... "
sudo pkg install -y i3 i3status i3lock rofi feh >> .install.log 2>> .install.log
check $?

echo -n "Installing fonts............. "
sudo pkg install -y dejavu Inconsolata-LGC terminus-ttf sourcecodepro-ttf droid-fonts-ttf >> .install.log 2>> .install.log
check $?

echo -n "Installing desktop apps...... "
sudo pkg install -y caja freecolor plexmediaserver caja-extensions engrampa evince gedit chromium rtorrent mpv calibre virtualbox-ose >> .install.log 2>> .install.log
check $?

echo -n "Setting up ports tree........ "
sudo pkg install -y portmaster >> .install.log 2>> .install.log
sudo portsnap fetch >> .install.log 2>> .install.log
sudo portsnap extract >> .install.log 2>> .install.log
check $?

echo -n "Installing [n]vim and tools.. "
sudo pkg install -y vim neovim >> .install.log 2>> .install.log
sudo pip-2.7 install --upgrade neovim >> .install.log 2>> .install.log
sudo pip-3.6 install --upgrade neovim >> .install.log 2>> .install.log
check $?

echo -n "Configuring system files..... "
sudo chsh -s /usr/local/bin/bash sk >> .install.log 2>> .install.log
rm -rf /home/sk/bin/
rm -rf /home/sk/.bash/
rm -rf /home/sk/.bashrc
rm -rf /home/sk/.rsession/
rm -rf /home/sk/.rtorrentrc
rm -rf /home/sk/.gtkrc-2.0
rm -rf /home/sk/.xinitrc
rm -rf /home/sk/.Xresources
rm -rf /home/sk/.config/i3/*
rm -rf /home/sk/.config/gtk-3.0/settings.ini
rm -rf /home/sk/.config/nvim/init.vim
rm -rf /home/sk/.urxvt/
mkdir -p /home/sk/.bash/
mkdir -p /home/sk/.rsession/
mkdir -p /home/sk/.config/i3/
mkdir -p /home/sk/.config/nvim/
mkdir -p /home/sk/.config/gtk-3.0/
mkdir -p /home/sk/.urxvt/ext/
mkdir -p /home/sk/.icons/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2> /dev/null
check_no_ok $?
git clone https://github.com/skmpz/git-aware-prompt /home/sk/.bash/git-aware-prompt > /dev/null 2> /dev/null
check_no_ok $?
cp font-size /home/sk/.urxvt/ext/
ln -s /home/sk/dotfiles/freebsd/bashrc /home/sk/.bashrc
ln -s /home/sk/dotfiles/freebsd/rtorrent.rc /home/sk/.rtorrent.rc
ln -s /home/sk/dotfiles/freebsd/xresources /home/sk/.Xresources
ln -s /home/sk/dotfiles/freebsd/xinitrc /home/sk/.xinitrc
ln -s /home/sk/dotfiles/freebsd/gtkrc-2.0 /home/sk/.gtkrc-2.0
ln -s /home/sk/dotfiles/freebsd/config /home/sk/.config/i3/config
ln -s /home/sk/dotfiles/freebsd/init.vim /home/sk/.config/nvim/init.vim
ln -s /home/sk/dotfiles/freebsd/settings.ini /home/sk/.config/gtk-3.0/settings.ini
cp -r /usr/local/share/icons/whiteglass ~/.icons/
fc-cache -fv > /dev/null
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
sudo sysrc dbus_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc hald_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc linux_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc fsck_y_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc background_fsck="NO" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc vboxnet_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
sudo sysrc vboxnetflt_enable="YES" >> .install.log 2>> .install.log
check_no_ok $?
check $?
