#!/bin/bash

# Exit on any error
set -e

echo "Starting base Arch Linux installation..."

# Update mirror list with Reflector
echo "Updating mirror list..."
pacman -Sy --noconfirm reflector
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Install base packages
echo "Installing base packages..."
pacstrap /mnt base linux linux-firmware vim sudo networkmanager

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
echo "Configuring the new system..."
arch-chroot /mnt /bin/bash <<EOF

# Set timezone to London
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Localization
echo "Configuring locale..."
echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf

# Hostname
echo "Setting hostname..."
echo "archpc" > /etc/hostname
cat <<EOL > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archpc.localdomain archpc
EOL

# Set root password (replace 'rootpassword' with a secure password)
echo "Setting root password..."
echo "root:rootpassword" | chpasswd

# Install systemd-boot
echo "Installing systemd-boot..."
bootctl install

# Create loader.conf
echo "Creating loader.conf..."
cat <<EOL > /boot/loader/loader.conf
default arch
timeout 3
editor no
EOL

# Get PARTUUID for root partition
ROOT_UUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3)

# Create boot entry for Arch
echo "Creating Arch Linux boot entry..."
cat <<EOL > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=${ROOT_UUID} rw
EOL

# Detect Windows Boot Manager and create entry (if not auto-detected)
# You can customize this if necessary

# Create user 'bobby' with sudo privileges (replace 'bobbypassword' with a secure password)
echo "Creating user 'bobby'..."
useradd -m -G wheel -s /bin/zsh bobby
echo "bobby:bobbypassword" | chpasswd

# Configure sudoers
echo "Configuring sudoers..."
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Enable NetworkManager
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

EOF

echo "Base installation complete. You can now reboot into your new Arch Linux system."
