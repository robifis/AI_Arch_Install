#!/bin/bash

# This script sets up hardware acceleration and enables screen capture for OBS Studio on Arch Linux with an AMD Ryzen 5 5600H processor using Hyprland and Wayland.
# It checks for required packages, installs missing ones, removes obsolete/conflicting packages,
# and ensures that PipeWire and xdg-desktop-portal services are properly configured.

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
    # Graphics drivers and hardware acceleration
    mesa                 # Provides OpenGL library
    vulkan-radeon        # Vulkan driver for AMD GPUs
    vulkan-tools         # Vulkan utilities (includes vulkaninfo)
    libva-mesa-driver    # VA-API drivers for AMD
    mesa-vdpau           # VDPAU drivers for video acceleration
    libva-utils          # Tools for VA-API (vainfo)

    # PipeWire and Wayland screen capture dependencies
    pipewire             # Media server for audio and video streams
    pipewire-pulse       # PulseAudio replacement
    gst-plugin-pipewire  # GStreamer plugin for PipeWire
    xdg-desktop-portal   # Desktop portal for PipeWire screen sharing
    xdg-desktop-portal-hyprland  # Hyprland-specific xdg-desktop-portal backend
    # Alternatively, if 'xdg-desktop-portal-hyprland' is not available, use 'xdg-desktop-portal-wlr'
    # xdg-desktop-portal-wlr

    # OBS Studio with Wayland support
    obs-studio           # OBS Studio (ensure latest version with Wayland support)
    # Alternatively, you can use 'obs-studio-wayland' from the AUR for better Wayland support
)

# Obsolete or conflicting packages to remove
conflicting_packages=(
    mesa-vulkan-radeon   # Obsolete package replaced by vulkan-radeon
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

echo -e "\n=== Removing conflicting or obsolete packages ==="
for pkg in "${conflicting_packages[@]}"; do
    if is_installed "$pkg"; then
        echo -e "\nRemoving conflicting package $pkg..."
        sudo pacman -Rns --noconfirm "$pkg"
    else
        echo -e "\n$pkg is not installed."
    fi
done

echo -e "\n=== Verifying Vulkan support ==="
if vulkaninfo > /dev/null 2>&1; then
    echo -e "\nVulkan is working correctly."
else
    echo -e "\nVulkan is not working correctly. Please check your Vulkan installation."
    echo "You may need to reboot your system after installing Vulkan drivers."
    exit 1
fi

echo -e "\n=== Verifying VA-API support ==="
if vainfo > /dev/null 2>&1; then
    echo -e "\nVA-API is working correctly."
else
    echo -e "\nVA-API is not working correctly. Please check your VA-API installation."
    echo "You may need to reboot your system after installing VA-API drivers."
    exit 1
fi

echo -e "\n=== Ensuring PipeWire and xdg-desktop-portal Services are Running ==="
# Enable and start PipeWire services
systemctl --user enable --now pipewire.socket pipewire.service
systemctl --user enable --now pipewire-pulse.socket pipewire-pulse.service

# Restart xdg-desktop-portal services
echo -e "\nRestarting xdg-desktop-portal services..."
systemctl --user restart xdg-desktop-portal.service
systemctl --user restart xdg-desktop-portal-hyprland.service

echo -e "\n=== Configuration Instructions for OBS Studio under Wayland ==="
echo "To enable screen capture in OBS Studio under Wayland:"
echo "1. Ensure you are running OBS Studio with Wayland support."
echo "   - You can launch OBS with Wayland support by running: QT_QPA_PLATFORM=wayland obs"
echo "2. In OBS Studio, add a new source and select 'Screen Capture (PipeWire)'."
echo "3. If prompted, select the display or window you want to capture."
echo "4. Verify that the screen capture is working as expected."

echo -e "\n=== Script completed successfully ==="
echo "Please log out and log back in or reboot your system to ensure all changes take effect."
