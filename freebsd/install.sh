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

# parse arguments
for i in "$@"
do
    case $i in
        --laptop) mode="laptop"; shift 1 ;;
        --home) mode="home"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
echo "MODE $mode"
if [ "$mode" != "laptop" ] && [ "$mode" != "home" ]; then show_usage; fi

echo -n "Installing system tools...... "
sudo pkg install -y \
ImageMagick7 \
alsa-utils \
autocutsel \
bash \
caja \
caja-extensions \
calibre \
chromium \
cmake \
e2fsprogs \
en-hunspell \
engrampa \
evince \
feh \
freecolor \
fusefs-ntfs \
gcc \
gedit \
gmake \
i3-gaps \
i3lock \
i3status \
libreoffice \
mate-terminal \
mpv \
nomacs \
pkgconf \
pulseaudio \
py27-pip \
py37-pip \
python2 \
python3 \
rofi \
rsync \
rxvt-unicode \
scrot \
synergy \
unrar \
urxvt-perls \
wget \
xclip \
xorg \
>> .install.log 2>> .install.log
check $?

echo -n "Installing fonts............. "
sudo pkg install -y \
Inconsolata-LGC \
dejavu \
droid-fonts-ttf \
font-awesome \
sourcecodepro-ttf \
ubuntu-font \
>> .install.log 2>> .install.log
check $?

# echo -n "Setting up ports tree........ "
# sudo pkg install -y portmaster >> .install.log 2>> .install.log
# sudo portsnap fetch >> .install.log 2>> .install.log
# sudo portsnap extract >> .install.log 2>> .install.log
# check $?

echo -n "Installing [n]vim and tools.. "
sudo pkg install -y vim neovim >> .install.log 2>> .install.log
check_no_ok $?
sudo pip-2.7 install --upgrade neovim >> .install.log 2>> .install.log
check_no_ok $?
sudo pip-3.7 install --upgrade neovim >> .install.log 2>> .install.log
check $?

echo -n "Configuring system files..... "
rm -rf $HOME/bin/
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.Xresources.local
rm -rf $HOME/.config/i3/*
rm -rf $HOME/.config/gtk-3.0/settings.ini
rm -rf $HOME/.config/nvim/init.vim
rm -rf $HOME/.urxvt/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/.icons/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2> /dev/null
check_no_ok $?
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt > /dev/null 2> /dev/null
check_no_ok $?
cp font-size $HOME/.urxvt/ext/

if [ "$mode" == "home" ]; then
    DIR=$HOME/dotfiles/freebsd/home/
elif [ "$mode" == "laptop" ]; then
    DIR=$HOME/dotfiles/freebsd/laptop/
fi

ln -sf $DIR/xinitrc $HOME/.xinitrc
ln -sf $DIR/Xresources.local $HOME/.Xresources.local
ln -sf $DIR/config.local $HOME/.config/i3/config.local
ln -sf $DIR/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/config.base $HOME/.config/i3/config.base
ln -sf $HOME/dotfiles/freebsd/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/freebsd/xresources $HOME/.Xresources
ln -sf $HOME/dotfiles/freebsd/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -sf $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
ln -sf $HOME/dotfiles/freebsd/settings.ini $HOME/.config/gtk-3.0/settings.ini
cp -r /usr/local/share/icons/whiteglass $HOME/.icons/
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
check $?
