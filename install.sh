# package installation
sudo pacman -Syy --noconfirm
sudo pacman -S reflector --noconfirm
sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm

sudo pacman -S i3-wm i3lock i3status dmenu rofi alsa-utils alsa-oss xorg xterm xorg-xclock xorg-twm xorg-xinit polkit xcursor-themes rxvt-unicode neovim wget chromium cmake python3 python-pip luarocks clang ttf-dejavu ttf-droid ttf-inconsolata feh --noconfirm 

# install i3gaps
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd ../../
rm -rf i3-gaps

# neovim python
#sudo pip3 install neovim

# vim plug
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# neovim config
#mkdir -p $HOME/.config/nvim/
#cp $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim

# xinitrc
#MON_1=`xrandr | grep " connected" | awk '{ print $1 }' | head -1`
#MON_2=`xrandr | grep " connected" | awk '{ print $1 }' | tail -1`
#echo "xrandr --output $MON_2 --auto --left-of $MON_1" | cat - .xinitrc > .tmptmp && mv .tmptmp ~/.xinitrc
ln -s $HOME/dotfiles/xinitrc $HOME/.xinitrc

# Xresources
#sudo pacman -S xcursor-themes
#ln -s $HOME/dotfiles/.Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources

# i3 blocks
#wget https://aur.archlinux.org/cgit/aur.git/snapshot/i3blocks.tar.gz
#tar xf i3blocks.tar.g /
#cd i3blocks
#makepkg -sri --skippgpcheck --noconfirm
mkdir -p $HOME/.config/i3/
cp -r $HOME/dotfiles/i3/config $HOME/.config/i3/config
#cd ..
#rm -rf i3blocks*
mkdir -p $HOME/.local/share/fonts
cp fonts/*.ttf $HOME/.local/share/fonts
fc-cache -fv

#cp .bashrc $HOME/.bashrc
#mkdir $HOME/.bash/
#git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt
