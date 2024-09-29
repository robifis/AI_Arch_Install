#!/bin/bash

# Function to print messages
print_message() {
    echo "===> $1"
}

# Update package database
print_message "Updating package database"
sudo pacman -Sy

# Remove KDE Plasma and associated packages
print_message "Removing KDE Plasma and associated packages"
sudo pacman -Rns plasma kde-applications kde-utilities kde-system plasma-wayland-session plasma-wayland-protocols plasma-workspace plasma-desktop plasma-pa plasma-nm sddm

# Remove orphaned packages
print_message "Removing orphaned packages"
sudo pacman -Rns $(pacman -Qtdq)

# Clean package cache
print_message "Cleaning package cache"
sudo pacman -Sc

# Remove KDE configuration files
print_message "Removing KDE configuration files"
rm -rf ~/.kde4
rm -rf ~/.kde
rm -rf ~/.config/kde*
rm -rf ~/.config/plasma*
rm -rf ~/.local/share/kde*
rm -rf ~/.local/share/plasma*
rm -rf ~/.cache/kde*
rm -rf ~/.cache/plasma*

print_message "KDE Plasma removal complete. Please reboot your system."
