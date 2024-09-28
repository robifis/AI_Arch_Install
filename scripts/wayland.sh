#!/bin/bash

# Wayland Arch Linux Setup Script

# Exit on error
set -e

# Function to print messages
print_message() {
    echo "===> $1"
}

# Update system
print_message "Updating system"
sudo pacman -Syu --noconfirm

# Install basic Wayland support
print_message "Installing basic Wayland support"
sudo pacman -S --noconfirm wayland wayland-protocols xorg-xwayland

# Install graphics drivers
print_message "Installing graphics drivers"
# Uncomment the line for your GPU
# sudo pacman -S --noconfirm mesa intel-media-driver libva-intel-driver  # Intel
sudo pacman -S --noconfirm mesa libva-mesa-driver mesa-vdpau  # AMD
# sudo pacman -S --noconfirm nvidia nvidia-utils  # NVIDIA

# Install Wayland-specific tools
print_message "Installing Wayland-specific tools"
sudo pacman -S --noconfirm qt5-wayland qt6-wayland glfw-wayland wl-clipboard

# Install GTK theme for Wayland
print_message "Installing GTK theme for Wayland"
sudo pacman -S --noconfirm gtk-layer-shell

# Install font rendering libraries
print_message "Installing font rendering libraries"
sudo pacman -S --noconfirm freetype2 fontconfig cairo

# Install multimedia codecs
print_message "Installing multimedia codecs"
sudo pacman -S --noconfirm gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav

# Install hardware video acceleration
print_message "Installing hardware video acceleration"
sudo pacman -S --noconfirm libva libva-utils vdpauinfo

# Install HiDPI support
print_message "Installing HiDPI support"
sudo pacman -S --noconfirm xorg-xrdb

# Install Polkit authentication agent
print_message "Installing Polkit authentication agent"
sudo pacman -S --noconfirm polkit-gnome

# Create Hyprland config directory
print_message "Creating Hyprland config directory"
mkdir -p ~/.config/hypr

# Create fontconfig directory
print_message "Creating fontconfig directory"
mkdir -p ~/.config/fontconfig

# Create font configuration
print_message "Creating font configuration"
cat << EOF > ~/.config/fontconfig/fonts.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintslight</const>
    </edit>
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
    <edit name="lcdfilter" mode="assign">
      <const>lcddefault</const>
    </edit>
  </match>
</fontconfig>
EOF

# Set up environment variables
print_message "Setting up environment variables"
sudo tee /etc/profile.d/wayland-hidpi.sh > /dev/null << EOF
export XCURSOR_SIZE=24
export GDK_SCALE=1.5
export GDK_DPI_SCALE=1.5
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.5
EOF

print_message "Setup complete! Please reboot your system for all changes to take effect."
