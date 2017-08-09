# package installation

#just to enter passwd
sudo ls > /dev/null

echo -n "Setting up mirrors.. "
sudo pacman -S reflector --noconfirm > /dev/null 2>&1
sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist > /dev/null 2>&1
echo "done"

echo -n "Installing packages.. "
sudo pacman -S i3-wm i3lock i3blocks i3status rofi alsa-utils alsa-oss xorg xterm engrampa evince virtualbox-host-modules-arch openssh caja bash-completion xorg-xclock xorg-twm xorg-xinit polkit xcursor-themes rxvt-unicode neovim bc wget chromium cmake python2 python3 python-pip luarocks clang ttf-dejavu terminus-font adobe-source-code-pro-fonts ttf-droid ttf-inconsolata feh xclip pulseaudio alsa-utils synergy arc-gtk-theme qt4 qt arc-icon-theme vlc tmux transmission-gtk ntp --noconfirm --needed > /dev/null 2>&1
sudo pip3 install neovim > /dev/null 2>&1
git clone https://www.github.com/Airblader/i3 i3-gaps /dev/null 2>&1
cd i3-gaps
autoreconf --force --install /dev/null 2>&1
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers /dev/null 2>&1
make /dev/null 2>&1
sudo make install  /dev/null 2>&1
cd ../../
echo "done"

echo -n "Setting up config files.. "
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.config/i3/*
rm -rf $HOME/.config/gtk-3.0/settings.ini
rm -rf $HOME/.config/nvim/init.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt > /dev/null 2>&1
ln -s $HOME/dotfiles/bashrc $HOME/.bashrc
ln -s /home/sk/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $HOME/dotfiles/xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/i3/config $HOME/.config/i3/config
ln -s $HOME/dotfiles/i3/i3blocks.conf $HOME/.config/i3/i3blocks.conf
cp $HOME/dotfiles/i3/disk.sh $HOME/.config/i3/disk.sh
cp $HOME/dotfiles/i3/ip.sh $HOME/.config/i3/ip.sh
cp $HOME/dotfiles/i3/mail.sh $HOME/.config/i3/mail.sh
cp $HOME/dotfiles/i3/os.sh $HOME/.config/i3/os.sh
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/settings.ini $HOME/.config/gtk-3.0/settings.ini
mkdir ~/.local/share/fonts
cp $HOME/dotfiles/fonts/fontawesome-webfont.ttf ~/.local/share/fonts/
fc-cache -fv > /dev/null 2>&1
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
sudo ntpdate time.nist.gov > /dev/null 2>&1
echo "done"
