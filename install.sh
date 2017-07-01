# package installation
echo -n "Installing reflector.. "
sudo pacman -S reflector --noconfirm > /dev/null 2>&1
echo "done"

echo -n "Running reflector.. "
sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist > /dev/null 2>&1
echo "done"

echo -n "Installing packages.. "
sudo pacman -S i3-wm i3lock i3status dmenu rofi alsa-utils alsa-oss xorg xterm xorg-xclock xorg-twm xorg-xinit polkit xcursor-themes rxvt-unicode neovim wget chromium cmake python2 python3 python-pip luarocks clang ttf-dejavu ttf-droid ttf-inconsolata feh virtualbox-guest-utils xclip --noconfirm > /dev/null 2>&1
sudo pip3 install neovim > /dev/null 2>&1
echo "done"

# install i3gaps
echo -n "Installing i3gaps.. "
git clone https://www.github.com/Airblader/i3 i3-gaps > /dev/null 2>&1
cd i3-gaps
autoreconf --force --install > /dev/null
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers > /dev/null 2>&1
make > /dev/null 2>&1
sudo make install > /dev/null 2>&1
cd ../../
rm -rf i3-gaps
echo "done"

# vim plug
echo -n "Setting up neovim.. "
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1
mkdir -p $HOME/.config/nvim/
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
nvim +PlugInstall +qall > /dev/null
nvim +UpdateRemotePlugins +qall > /dev/null
echo "done"

# xinitrc
#MON_1=`xrandr | grep " connected" | awk '{ print $1 }' | head -1`
#MON_2=`xrandr | grep " connected" | awk '{ print $1 }' | tail -1`
#echo "xrandr --output $MON_2 --auto --left-of $MON_1" | cat - .xinitrc > .tmptmp && mv .tmptmp ~/.xinitrc

echo -n "Setting up config files.. "
ln -s $HOME/dotfiles/xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources
mkdir -p $HOME/.config/i3/
cp -r $HOME/dotfiles/i3/config $HOME/.config/i3/config
echo "done"

#cp .bashrc $HOME/.bashrc
#mkdir $HOME/.bash/
#git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt
