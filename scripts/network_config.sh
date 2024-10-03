#!/bin/bash

# This script installs and configures necessary packages and services to enable network browsing and access to NAS drives on Arch Linux.

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null
}

# Function to install a package
install_pkg() {
    echo -e "\nInstalling $1..."
    sudo pacman -S --needed --noconfirm "$1"
}

# Required packages
required_packages=(
    gvfs                 # Virtual filesystem layer
    gvfs-smb             # SMB/CIFS (Windows shares) support for gvfs
    smbclient            # Samba client utilities
    nss-mdns             # mDNS support for hostname resolution
    avahi                # Avahi mDNS/DNS-SD services
)

echo "=== Updating package database ==="
sudo pacman -Sy

echo -e "\n=== Checking and installing required packages ==="
for pkg in "${required_packages[@]}"; do
    if ! is_installed "$pkg"; then
        install_pkg "$pkg"
    else
        echo -e "\n$pkg is already installed."
    fi
done

echo -e "\n=== Configuring nss-mdns ==="
# Add 'mdns4' to the hosts line in /etc/nsswitch.conf
if ! grep -q 'mdns4_minimal' /etc/nsswitch.conf; then
    echo -e "\nUpdating /etc/nsswitch.conf to include 'mdns4_minimal' for hostname resolution..."
    sudo sed -i 's/^\(hosts:.*\) files dns \(.*\)$/\1 files mdns4_minimal [NOTFOUND=return] dns \2/' /etc/nsswitch.conf
else
    echo -e "\n/etc/nsswitch.conf already configured for mdns4_minimal."
fi

echo -e "\n=== Enabling and Starting Avahi Daemon ==="
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

echo -e "\n=== Checking Firewall Settings ==="
# Check if ufw is installed and active
if is_installed ufw; then
    if sudo ufw status | grep -q 'Status: active'; then
        echo -e "\nConfiguring ufw to allow Avahi and Samba traffic..."
        sudo ufw allow 5353/udp      # mDNS
        sudo ufw allow 137/udp       # NetBIOS Name Service
        sudo ufw allow 138/udp       # NetBIOS Datagram Service
        sudo ufw allow 139/tcp       # NetBIOS Session Service
        sudo ufw allow 445/tcp       # Microsoft-DS (SMB)
    else
        echo -e "\nufw is not active. No firewall configuration needed."
    fi
else
    echo -e "\nufw is not installed. If you have another firewall, ensure the necessary ports are open."
fi

echo -e "\n=== Instructions to Access Your NAS Drive ==="
echo "1. Open your file manager (e.g., Nautilus, Thunar, Dolphin)."
echo "2. Navigate to 'Network' or 'Browse Network'."
echo "3. You should now see your NAS drive listed. Double-click to access it."
echo "4. If you don't see it, try accessing it directly by entering the address in the location bar:"
echo "   smb://[NAS-Hostname-or-IP]/"
echo "5. If prompted, enter your username and password for the NAS."

echo -e "\n=== Script completed successfully ==="
echo "Please log out and log back in or reboot your system to ensure all changes take effect."
