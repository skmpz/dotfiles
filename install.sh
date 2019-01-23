#!/bin/bash

function check {
    if [ "$1" == "0" ]; then
        echo -e "[\e[0;32mOK\e[0m]"
    else
        echo -e "[\e[0;31mFAIL\e[0m]"
        exit 1
    fi
}

# just to enter pass
sudo ls > /dev/null

echo -n "Getting pacman up to date.... "
sudo pacman -Syy --noconfirm --needed > /dev/null 2>> .install.log
check $?

echo -n "Installing system tools...... "
sudo pacman -S alsa-utils alsa-oss openssh bash-completion bc wget tmux cmake unrar python2 python3 python-pip luarocks clang pulseaudio alsa-utils --noconfirm --needed > /dev/null 2>> .install.log
check $?

echo -n "Install X window manager..... "
sudo pacman -S xorg xterm xorg-xclock xorg-twm xorg-xinit polkit xcursor-themes xclip --noconfirm --needed > /dev/null 2>> .install.log
check $?

echo -n "Installing i3 and wm tools... "
sudo pacman -S i3-wm i3lock i3status rofi rxvt-unicode urxvt-perls mate-terminal feh arc-icon-theme arc-gtk-theme ttf-dejavu ttf-ubuntu-font-family terminus-font adobe-source-code-pro-fonts ttf-droid otf-font-awesome ttf-inconsolata --noconfirm --needed > /dev/null 2>> .install.log
check $?

echo -n "Installing applications...... "
sudo pacman -S engrampa nomacs aircrack-ng rsync vim evince fbreader caja caja-open-terminal gedit neovim chromium synergy --noconfirm --needed > /dev/null 2>> .install.log
check $?

echo -n "Setting up i3-gaps........... "
git clone https://www.github.com/Airblader/i3 i3-gaps > /dev/null 2>> .install.log
cd i3-gaps
autoreconf --force --install > /dev/null 2>> .install.log
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers > /dev/null 2>> ../../.install.log
make -j 4 > /dev/null 2>> ../../.install.log
sudo make install > /dev/null 2>> ../../.install.log
cd ../../
check $?

echo -n "Setting up neovim............ "
sudo pip2 install --upgrade neovim > /dev/null 2>> .install.log
sudo pip3 install --upgrade neovim > /dev/null 2>> .install.log
check $?

echo -n "Setting up config files...... "
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.config/i3/*
rm -rf $HOME/.config/gtk-3.0/settings.ini
rm -rf $HOME/.config/nvim/init.vim
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.urxvt/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.urxvt/ext/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>> .install.log
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt > /dev/null 2>> .install.log
ln -s $HOME/dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $HOME/dotfiles/xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/config $HOME/.config/i3/config
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/settings.ini $HOME/.config/gtk-3.0/settings.ini
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
check $?

if [ "$1" == "vm" ]; then
    echo -n "Setting up vm modules........ "
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm --needed > /dev/null 2>> .install.log
    printf "vboxguest\nvboxsf\nvboxvideo\n" > vboxservice.conf
    sudo cp vboxservice.conf /etc/modules-load.d/
    sudo systemctl enable vboxservice.service > /dev/null 2>> .install.log
check $?
fi
