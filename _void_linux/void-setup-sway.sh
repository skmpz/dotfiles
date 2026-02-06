#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [target]"
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        box)   target="box";   shift 1 ;;
        pad)   target="pad";   shift 1 ;;
        envie) target="envie"; shift 1 ;;
        siri)  target="siri";  shift 1 ;;
        infi)  target="infi";  shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$target" != "box" ] && [ "$target" != "infi" ] && [ "$target" != "pad" ] && [ "$target" != "envie" ] && [ "$target" != "siri" ]; then show_usage; fi

# user
user=$(echo $USER)

# install base apps
echo "Installing system.."
sudo xbps-install -Sy void-repo-nonfree
sudo xbps-install -Sy \
NetworkManager \
Waybar \
alacritty \
arc-icon-theme \
arc-theme \
bash-completion \
bc \
bind-utils \
blueman \
bluez \
brightnessctl \
chrony \
cmake \
clang \
cronie \
curl \
dbus-elogind \
dejavu-fonts-ttf \
dunst \
elogind \
firefox \
font-adobe-source-code-pro \
font-awesome5 \
font-ibm-plex-otf \
font-inconsolata-otf \
fuse \
gcc \
grim \
gparted \
jq \
keepassxc \
leafpad \
libspa-bluetooth \
mesa-dri \
mpv \
neovim \
nerd-fonts \
network-manager-applet \
nodejs \
noto-fonts-emoji \
noto-fonts-ttf \
ntp \
openssl-devel \
openvpn \
pavucontrol \
pipewire \
pkg-config \
polkit \
pulseaudio-utils \
python3 \
qt5-wayland \
ripgrep \
rsync \
rust-analyzer \
rustup \
sshpass \
slurp \
sof-firmware \
sof-tools \
sway \
swayidle \
swaylock \
syncthing \
tmux \
ttf-ubuntu-font-family \
unzip \
vulkan-loader \
wdisplays \
wget \
wl-clipboard \
wofi \
xcursor-vanilla-dmz \
xdg-desktop-portal \
xdg-desktop-portal-wlr \
xdg-utils \
xorg-fonts \
xtools \
xz \
zathura-pdf-mupdf \
zip || exit 1

# setup configuration
echo "Setting up config files.."
cd $HOME
sudo chown $user:$user -R .
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.cache/nvim
rm -rf $HOME/.config/gtk-3.0/
rm -rf $HOME/.config/gtk-4.0/
rm -rf $HOME/.config/mimeapps.list
rm -rf $HOME/.config/user-dirs.dirs
rm -rf $HOME/.config/sway/
rm -rf $HOME/.config/Thunar/uca.xml
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.local/share/nvim
rm -rf $HOME/.icons/default/
rm -rf $HOME/screens/
rm -rf $HOME/start.sh
rm -rf $HOME/.tmux.conf

# machine specific
if [ "$target" == "box" ]; then
    sudo xbps-install -Sy mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau
    sudo ln -sf /etc/sv/tlp/ /var/service/
elif [ "$target" == "siri" ] || [ "$target" == "infi" ]; then
    sudo xbps-install -Sy tlp mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau
    sudo ln -sf /etc/sv/tlp/ /var/service/
elif [ "$target" == "pad" ] || [ "$target" == "envie" ]; then
    sudo xbps-install -Sy tlp mesa-vulkan-intel intel-video-accel
    sudo ln -sf /etc/sv/tlp/ /var/service/
fi

# create folders
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.config/gtk-4.0/
mkdir -p $HOME/.config/sway/
mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.icons/default/
mkdir -p $HOME/screens/

# wofi
if test -L $HOME/.config/wofi; then unlink $HOME/.config/wofi
elif test -d $HOME/.config/wofi; then rm -rf $HOME/.config/wofi
fi
ln -sf $HOME/dotfiles/wofi/ $HOME/.config/

# dunst
if test -L $HOME/.config/dunst; then unlink $HOME/.config/dunst
elif test -d $HOME/.config/dunst; then rm -rf $HOME/.config/dunst
fi
ln -sf $HOME/dotfiles/dunst/ $HOME/.config/

# alacritty
if test -L $HOME/.config/alacritty; then unlink $HOME/.config/alacritty
elif test -d $HOME/.config/alacritty; then rm -rf $HOME/.config/alacritty
fi
ln -sf $HOME/dotfiles/alacritty/ $HOME/.config/

# waybar
if test -L $HOME/.config/waybar; then unlink $HOME/.config/waybar
elif test -d $HOME/.config/waybar; then rm -rf $HOME/.config/waybar
fi
ln -sf $HOME/dotfiles/waybar/ $HOME/.config/

# nvim
if test -L $HOME/.config/nvim; then unlink $HOME/.config/nvim
elif test -d $HOME/.config/nvim; then rm -rf $HOME/.config/nvim
fi
ln -sf $HOME/dotfiles/nvim/ $HOME/.config/

# thunar
if test -L $HOME/.config/Thunar/; then unlink $HOME/.config/nvim
elif test -d $HOME/.config/nvim; then rm -rf $HOME/.config/nvim
fi
ln -sf $HOME/dotfiles/nvim/ $HOME/.config/

# other
ln -sf $HOME/dotfiles/bash/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/gtk2/gtkrc-2.0 ~/gtkrc-2.0
ln -sf $HOME/dotfiles/gtk3/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -sf $HOME/dotfiles/gtk4/settings.ini $HOME/.config/gtk-4.0/settings.ini
ln -sf $HOME/dotfiles/mime/mimeapps.list $HOME/.config/mimeapps.list
ln -sf $HOME/dotfiles/sway/config $HOME/.config/sway/config
ln -sf $HOME/dotfiles/sway/start.sh $HOME/start.sh
ln -sf $HOME/dotfiles/thunar/uca.xml $HOME/.config/Thunar/uca.xml
ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/user-dirs/user-dirs.dirs $HOME/.config/user-dirs.dirs

# fonts
cp -r $HOME/dotfiles/fonts/* $HOME/.local/share/fonts/

# git aware prompt
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt

# cursor setup
printf "[icon theme]\nInherits=Vanilla-DMZ\n" > $HOME/.icons/default/index.theme

# rust
rustup-init -y

# kill wpa_supplicant
sudo pkill wpa_supplicant

# setup services
sudo ln -sf /etc/sv/dbus/ /var/service/
sudo ln -sf /etc/sv/polkitd/ /var/service/
sudo ln -sf /etc/sv/NetworkManager/ /var/service/
sudo ln -sf /etc/sv/chronyd/ /var/service/
sudo ln -sf /etc/sv/bluetoothd/ /var/service/
sudo ln -sf /etc/sv/cronie/ /var/service/
sudo ln -sf /etc/sv/socklog-unix/ /var/service/
sudo ln -sf /etc/sv/nanoklogd/ /var/service/

# add user to groups
sudo usermod -a -G bluetooth,network,kvm,video,input $user

# remove dirs
rm -rf $HOME/Desktop
rm -rf $HOME/Documents
rm -rf $HOME/Music
rm -rf $HOME/Pictures
rm -rf $HOME/Public
rm -rf $HOME/Templates
rm -rf $HOME/Videos
