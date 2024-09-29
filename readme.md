# Comprehensive Arch Linux Installation Guide

## Table of Contents
1. [Creating the Installer (Windows)](#1-creating-the-installer-windows)
2. [Booting into Live Environment](#2-booting-into-live-environment)
3. [Connecting to the Internet](#3-connecting-to-the-internet)
4. [Updating System Clock](#4-updating-system-clock)
5. [Partitioning the Disk](#5-partitioning-the-disk)
6. [Formatting Partitions](#6-formatting-partitions)
7. [Mounting File Systems](#7-mounting-file-systems)
8. [Installing Essential Packages](#8-installing-essential-packages)
9. [Configuring the System](#9-configuring-the-system)
10. [Boot Loader Installation](#10-boot-loader-installation)
11. [Network Configuration](#11-network-configuration)
12. [Setting Root Password](#12-setting-root-password)
13. [Creating User and Granting Sudo Privileges](#13-creating-user-and-granting-sudo-privileges)
14. [Installing Graphics Drivers](#14-installing-graphics-drivers)
15. [Installing Xorg](#15-installing-xorg)
16. [Installing Hyprland](#16-installing-hyprland)
17. [Installing and Configuring Waybar](#17-installing-and-configuring-waybar)
18. [Installing Yay](#18-installing-yay)
19. [Installing and Configuring Vim](#19-installing-and-configuring-vim)
20. [Final Steps](#20-final-steps)

## 1. Creating the Installer (Windows)
1. Download Arch Linux ISO from https://archlinux.org/download/
2. Download Rufus from https://rufus.ie/
3. Insert USB drive (8GB+)
4. Open Rufus
5. Select USB drive
6. Click SELECT, choose Arch ISO
7. Click START
8. Select "Write in DD Image mode" when prompted
9. Wait for process to complete

## 2. Booting into Live Environment
1. Restart PC, enter BIOS/UEFI
2. Set boot priority to USB
3. Save and exit BIOS/UEFI
4. Select "Arch Linux install medium" from boot menu

## 3. Connecting to the Internet
```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect SSID
exit
ping archlinux.org
```

## 4. Updating System Clock
```bash
timedatectl set-ntp true
```

## 5. Partitioning the Disk
```bash
fdisk -l
fdisk /dev/sdX
```
1. Create GPT partition table: `g`
2. Create EFI partition:
   ```
   n
   1
   [Enter]
   +512M
   t
   1
   ```
3. Create root partition:
   ```
   n
   2
   [Enter]
   [Enter]
   ```
4. Write changes: `w`

## 6. Formatting Partitions
```bash
mkfs.fat -F32 /dev/sdX1
mkfs.ext4 /dev/sdX2
```

## 7. Mounting File Systems
```bash
mount /dev/sdX2 /mnt
mkdir /mnt/boot
mount /dev/sdX1 /mnt/boot
```

## 8. Installing Essential Packages
```bash
pacstrap /mnt base base-devel linux linux-firmware
```

## 9. Configuring the System
```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
vim /etc/locale.gen  # Uncomment en_US.UTF-8 UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo myhostname > /etc/hostname
```

## 10. Boot Loader Installation
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## 11. Network Configuration
```bash
pacman -S networkmanager
systemctl enable NetworkManager
```

## 12. Setting Root Password
```bash
passwd
```

## 13. Creating User and Granting Sudo Privileges
```bash
useradd -m -G wheel -s /bin/bash username
passwd username
pacman -S sudo
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL) ALL
```

## 14. Installing Graphics Drivers
Intel:
```bash
pacman -S mesa lib32-mesa xf86-video-intel vulkan-intel
```
AMD:
```bash
pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon
```
NVIDIA:
```bash
pacman -S nvidia nvidia-utils lib32-nvidia-utils
```

## 15. Installing Xorg
```bash
pacman -S xorg-server xorg-xinit xorg-apps
```

## 16. Installing Hyprland
```bash
pacman -S wayland wlroots libinput hyprland
mkdir -p ~/.config/hypr
echo "exec Hyprland" > ~/.xinitrc
```

## 17. Installing and Configuring Waybar
```bash
pacman -S waybar
mkdir -p ~/.config/waybar
echo '{
    "layer": "top",
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["network", "battery"],
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}"
    },
    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""]
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠"
    }
}' > ~/.config/waybar/config
```

## 18. Installing Yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 19. Installing and Configuring Vim
```bash
pacman -S vim
echo "set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
syntax on" > ~/.vimrc
```

## 20. Final Steps
```bash
exit
umount -R /mnt
reboot
```
After reboot, login and start Hyprland:
```bash
startx
```
