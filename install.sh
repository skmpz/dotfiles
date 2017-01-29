# NeoVIM
#mkdir -p $HOME/.config/nvim/
#ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim

# xinitrc
MON_1=`xrandr | grep " connected" | awk '{ print $1 }' | head -1`
MON_2=`xrandr | grep " connected" | awk '{ print $1 }' | tail -1`
echo "xrandr --output $MON_2 --auto --left-of $MON_1" | cat - .xinitrc > .tmptmp && mv .tmptmp ~/.xinitrc

# Xresources
sudo pacman -S xcursor-themes
ln -s $HOME/dotfiles/.Xresources $HOME/.Xresources

# i3 blocks
#wget https://aur.archlinux.org/cgit/aur.git/snapshot/i3blocks.tar.gz
#tar xf i3blocks.tar.gz
#cd i3blocks
#makepkg -Sri --skippgpcheck






















