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
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.config/i3/*
rm -rf $HOME/.config/gtk-3.0/settings.ini
rm -rf $HOME/.config/nvim/init.vim
rm -rf $HOME/.urxvt/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.urxvt/ext/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2> /dev/null
check_no_ok $?
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt > /dev/null 2> /dev/null
check_no_ok $?
cp font-size $HOME/.urxvt/ext/
ln -s $HOME/dotfiles/freebsd/bashrc $HOME/.bashrc
ln -s $HOME/dotfiles/freebsd/xresources $HOME/.Xresources
ln -s $HOME/dotfiles/freebsd/xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/freebsd/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $HOME/dotfiles/freebsd/config $HOME/.config/i3/config
ln -s $HOME/dotfiles/freebsd/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/freebsd/settings.ini $HOME/.config/gtk-3.0/settings.ini
fc-cache -fv > /dev/null
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
check $?
