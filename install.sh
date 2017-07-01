# package installation

#just to enter passwd
sudo ls > /dev/null

echo -n "Setting up mirrors.. "
sudo pacman -S reflector --noconfirm > /dev/null 2>&1
sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist > /dev/null 2>&1
echo "done"

echo -n "Installing packages.. "
sudo pacman -S i3-wm i3lock i3status dmenu rofi alsa-utils alsa-oss xorg xterm xorg-xclock xorg-twm xorg-xinit polkit xcursor-themes rxvt-unicode neovim wget chromium cmake python2 python3 python-pip luarocks clang ttf-dejavu ttf-droid ttf-inconsolata feh xclip --noconfirm > /dev/null 2>&1
sudo pip3 install neovim > /dev/null 2>&1
git clone https://www.github.com/Airblader/i3 i3-gaps > /dev/null 2>&1
cd i3-gaps
autoreconf --force --install > /dev/null 2>&1
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers > /dev/null 2>&1
make > /dev/null 2>&1
sudo make install > /dev/null 2>&1
cd ../../
rm -rf i3-gaps
echo "done"

# xinitrc
#MON_1=`xrandr | grep " connected" | awk '{ print $1 }' | head -1`
#MON_2=`xrandr | grep " connected" | awk '{ print $1 }' | tail -1`
#echo "xrandr --output $MON_2 --auto --left-of $MON_1" | cat - .xinitrc > .tmptmp && mv .tmptmp ~/.xinitrc

echo -n "Setting up config files.. "
rm -rf $HOME/.bashrc
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt > /dev/null 2>&1
ln -s $HOME/dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/dotfiles/xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/i3/config $HOME/.config/i3/config
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
echo "done"
