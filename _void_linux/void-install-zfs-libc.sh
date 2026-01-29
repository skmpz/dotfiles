#!/bin/bash

set -e

# wpa_passphrase <AP> <PW> | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
# wpa_supplicant -B -i <iface> -c /etc/wpa_supplicant/wpa_supplicant.conf
# xbps-install -Syu xbps git
# git clone https://github.com/skmpz/dotfiles
# cd dotfiles
# ./_void_linux/void-libc.sh

# confirm efi support
dmesg | grep -qi efivars && echo "found" || (echo "not found"; exit 1)

# root password
echo "---------------------------------------------------------------"
echo "root password"
echo "---------------------------------------------------------------"
echo -n "pass (first): "; read -s root_pass_first; echo
echo -n "pass (again): "; read -s root_pass; echo
if [ "$root_pass_first" != "$root_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "root pass set"

# user name and pass
echo "---------------------------------------------------------------"
echo "user name and password"
echo "---------------------------------------------------------------"
read -p "username: " user_name
echo -n "pass (first): "; read -s user_pass_first; echo
echo -n "pass (again): "; read -s user_pass; echo
if [ "$user_pass_first" != "$user_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "user pass set"

# hostname
echo "---------------------------------------------------------------"
echo "hostname"
echo "---------------------------------------------------------------"
read -p "hostname: " hostname
echo "hostname set"

# disk
echo "---------------------------------------------------------------"
echo "disk setup"
echo "---------------------------------------------------------------"
options=$(lsblk | awk '/disk/ { print $1 "->" $4 }')
PS3='sel: '
select opt in $options; do
    if [ ! -z $opt ]; then
        disk="/dev/$(echo ${opt} | awk -F'-' '{print $1}')"
        break
    else
        printf 'invalid\n'
    fi
done
echo "disk set to ${disk}"

# encryption
echo "---------------------------------------------------------------"
echo "encryption"
echo "---------------------------------------------------------------"
echo -n "pass: "; read -s encryption_pass_first; echo
echo -n "confirm: "; read -s encryption_pass; echo
if [ "$encryption_pass_first" != "$encryption_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "encryption pass set"

# confirm configs
echo "---------------------------------------------------------------"
echo "configurations confirm"
echo "---------------------------------------------------------------"
echo "username: ${user_name}"
echo "password: ${user_pass}"
echo "root password: ${root_pass}"
echo "hostname: ${hostname}"
echo "disk: ${disk}"
echo "encryption pass: ${encryption_pass}"
echo "---------------------------------------------------------------"
read -p "press enter to confirm or CTRL-C to stop and start over"

# source /etc/os-release
echo "---------------------------------------------------------------"
echo "source /etc/os-release"
echo "---------------------------------------------------------------"
source /etc/os-release
export ID

# generate /etc/hostid
echo "---------------------------------------------------------------"
echo "generate /etc/hostid"
echo "---------------------------------------------------------------"
zgenhostid -f 0x00bab10c

# define disk variables
echo "---------------------------------------------------------------"
echo "define disk variables"
echo "---------------------------------------------------------------"
export BOOT_DISK="${disk}"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"
export POOL_DISK="${disk}"
export POOL_PART="2"
export POOL_DEVICE="${POOL_DISK}p${POOL_PART}"
echo "BOOT_DISK $BOOT_DISK"
echo "BOOT_PART $BOOT_PART"
echo "BOOT_DEVICE $BOOT_DEVICE"
echo "POOL_DISK $POOL_DISK"
echo "POOL_PART $POOL_PART"
echo "POOL_DEVICE $POOL_DEVICE"

# wipe partitions
echo "---------------------------------------------------------------"
echo "wipe partitions"
echo "---------------------------------------------------------------"
zpool labelclear -f "$POOL_DISK" || true
wipefs -a "$POOL_DISK"
wipefs -a "$BOOT_DISK"
sgdisk --zap-all "$POOL_DISK"
sgdisk --zap-all "$BOOT_DISK"

# create partitions
echo "---------------------------------------------------------------"
echo "create partitions"
echo "---------------------------------------------------------------"
sgdisk -n "${BOOT_PART}:1m:+512m" -t "${BOOT_PART}:ef00" "$BOOT_DISK"
sgdisk -n "${POOL_PART}:0:-10m" -t "${POOL_PART}:bf00" "$POOL_DISK"

# create zpool
echo "---------------------------------------------------------------"
echo "create zpool"
echo "---------------------------------------------------------------"
echo "${encryption_pass}" > /etc/zfs/zroot.key
chmod 000 /etc/zfs/zroot.key
zpool create -f -o ashift=12 \
 -O compression=lz4 \
 -O acltype=posixacl \
 -O xattr=sa \
 -O relatime=on \
 -O encryption=aes-256-gcm \
 -O keylocation=file:///etc/zfs/zroot.key \
 -O keyformat=passphrase \
 -o autotrim=on \
 -m none zroot "$POOL_DEVICE"

# create initial filesystems
echo "---------------------------------------------------------------"
echo "create initial filesystems"
echo "---------------------------------------------------------------"
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/${ID}
zfs create -o mountpoint=/home zroot/home
zpool set bootfs=zroot/ROOT/${ID} zroot

# export and reimport
echo "---------------------------------------------------------------"
echo "export and reimport"
echo "---------------------------------------------------------------"
zpool export zroot
zpool import -N -R /mnt zroot
# zfs load-key -L prompt zroot
zfs load-key -L file:///etc/zfs/zroot.key zroot
zfs mount zroot/ROOT/${ID}
zfs mount zroot/home

# update device symlinks
echo "---------------------------------------------------------------"
echo "update device symlinks"
echo "---------------------------------------------------------------"
udevadm trigger

echo "---------------------------------------------------------------"
echo "setting repo keys"
echo "---------------------------------------------------------------"
mkdir -p /mnt/var/db/xbps/keys/
cp -a /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

echo "---------------------------------------------------------------"
echo "installing base"
echo "---------------------------------------------------------------"
XBPS_ARCH=x86_64 xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system

echo "---------------------------------------------------------------"
echo "copy files to the new installation"
echo "---------------------------------------------------------------"
cp /etc/hostid /mnt/etc
mkdir /mnt/etc/zfs
cp /etc/zfs/zroot.key /mnt/etc/zfs

echo "---------------------------------------------------------------"
echo "finalizing setup"
echo "---------------------------------------------------------------"

uuid=$( blkid | grep "$BOOT_DEVICE" | cut -d ' ' -f 2 )
cat << EOF | xchroot /mnt
(echo ${root_pass}; echo ${root_pass}) | passwd
echo ${hostname} > /etc/hostname

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales

useradd ${user_name}
usermod -a -G wheel,floppy,audio,video,cdrom,optical,storage,network,kvm ${user_name}
(echo ${user_pass}; echo ${user_pass}) | passwd ${user_name}

echo "${user_name} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "KEYMAP=us" >> /etc/rc.conf
echo "TIMEZONE=Asia/Nicosia" >> /etc/rc.conf
ln -sf /usr/share/zoneinfo/Asia/Nicosia /etc/localtime

echo "nofsck=\"yes\"" > /etc/dracut.conf.d/zol.conf
echo "add_dracutmodules+=\" zfs \"" > /etc/dracut.conf.d/zol.conf"
echo "omit_dracutmodules+=\" btrfs \"" > /etc/dracut.conf.d/zol.conf"
echo "install_items+=\" /etc/zfs/zroot.key \"" > /etc/dracut.conf.d/zol.conf"

xbps-install -Sy zfs curl efibootmgr

zfs set org.zfsbootmenu:commandline="quiet" zroot/ROOT
zfs set org.zfsbootmenu:keysource="zroot/ROOT/${ID}" zroot

mkfs.vfat -F32 "$BOOT_DEVICE"

echo "$uuid /boot/efi vfat defaults 0 0" >> /etc/fstab
mkdir -p /boot/efi
mount /boot/efi

mkdir -p /boot/efi/EFI/ZBM
curl -o /boot/efi/EFI/ZBM/VMLINUZ.EFI -L https://get.zfsbootmenu.org/efi
cp /boot/efi/EFI/ZBM/VMLINUZ.EFI /boot/efi/EFI/ZBM/VMLINUZ-BACKUP.EFI

efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
  -L "ZFSBootMenu (Backup)" \
  -l '\EFI\ZBM\VMLINUZ-BACKUP.EFI'

efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
  -L "ZFSBootMenu" \
  -l '\EFI\ZBM\VMLINUZ.EFI'

EOF

umount -n -R /mnt
zpool export zroot

echo "---------------------------------------------------------------"
echo "finished - reboot now"
echo "---------------------------------------------------------------"
