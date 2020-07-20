#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [opts]"
    echo "-----------------------------------------------"
    echo -n "[opts] "
    echo "laptop/home/vm    install mode    [required]"
    echo "-----------------------------------------------"
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        vm) mode="VM"; shift 1 ;;
        home) mode="HOME"; shift 1 ;;
        laptop) mode="LAPTOP"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$mode" != "HOME" ] && [ "$mode" != "VM" ] && [ "$mode" != "LAPTOP" ]; then show_usage; fi
# ------------------------- arguments --------------------------

echo "Installing system.."
sudo xbps-install -Sy \
alsa-oss \
alsa-utils \
arc-icon-theme \
arc-theme \
autoconf \
automake \
bash-completion \
bc \
binwalk \
blueman \
caja \
caja-open-terminal \
calibre \
chromium \
clang \
cmake \
cppcheck \
curl \
engrampa \
feh \
font-adobe-source-code-pro \
font-awesome \
font-inconsolata-otf \
void-repo-nonfree \
foremost \
gdb \
gedit \
gparted \
i3-gaps \
i3lock \
i3status \
ImageMagick \
mate-terminal \
mpv \
neovim \
nmap \
nodejs \
nomacs \
openjdk8 \
p7zip \
pulseaudio \
python \
python-neovim \
python3 \
python3-neovim \
rofi \
rsync \
rxvt-unicode \
scrot \
dejavu-fonts-ttf \
ttf-ubuntu-font-family \
upower \
vim \
wget \
wireshark-gtk \
xclip \
xcursor-themes \
xorg \
xterm \

echo "Setting up config files.."
cd $HOME
sudo chown sk:sk -R . > /dev/null 2>> $LOGFILE
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.Xresources.local
rm -rf $HOME/.config/i3/
rm -rf $HOME/.config/gtk-3.0/
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.urxvt/
rm -rf $HOME/screen/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/screen/
# sudo mkdir -p /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/fonts/Inconsolata.otf /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/fonts/source-code-pro/* /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/locale /etc/default/locale
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt
cp $HOME/dotfiles/font-size $HOME/.urxvt/ext/
ln -sf $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -sf $HOME/dotfiles/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -sf $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
ln -sf $HOME/dotfiles/Xresources $HOME/.Xresources
ln -sf $HOME/dotfiles/config.base $HOME/.config/i3/config.base
ln -sf $HOME/dotfiles/inputrc $HOME/.inputrc
if [ "$mode" == "HOME" ]; then
    ln -sf $HOME/dotfiles/home/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/home/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/home/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/home/bashrc $HOME/.bashrc
elif [ "$mode" == "LAPTOP" ]; then
    # sudo apt install -y tlp >> $LOGFILE 2>&1
    # sudo systemctl enable tlp >> $LOGFILE 2>&1
    ln -sf $HOME/dotfiles/_void_linux/laptop/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/_void_linux/laptop/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/bashrc $HOME/.bashrc
fi
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
printf "[Icon Theme]\nInherits=whiteglass\n" | sudo tee /usr/share/icons/default/index.theme
sudo chown sk:sk -R $HOME
