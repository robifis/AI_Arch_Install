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
sudo pacman -S --noconfirm wayland wayland-protocols libwayland-egl xorg-xwayland

# Install audio support
print_message "Installing audio support"
sudo pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

# Install graphics drivers
print_message "Installing graphics drivers"
# Uncomment the line for your GPU
# sudo pacman -S --noconfirm mesa intel-media-driver libva-intel-driver  # Intel
# sudo pacman -S --noconfirm mesa libva-mesa-driver mesa-vdpau  # AMD
# sudo pacman -S --noconfirm nvidia nvidia-utils  # NVIDIA

# Install Wayland-specific tools
print_message "Installing Wayland-specific tools"
sudo pacman -S --noconfirm qt5-wayland qt6-wayland glfw-wayland wl-clipboard

# Install screen capture and sharing tools
print_message "Installing screen capture and sharing tools"
sudo pacman -S --noconfirm grim slurp wf-recorder

# Install notification daemon
print_message "Installing notification daemon"
sudo pacman -S --noconfirm mako

# Install application launcher
print_message "Installing application launcher"
sudo pacman -S --noconfirm wofi

# Install color temperature adjustment tool
print_message "Installing color temperature adjustment tool"
sudo pacman -S --noconfirm gammastep

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

# Install Wayland-native terminal
print_message "Installing Wayland-native terminal"
sudo pacman -S --noconfirm foot

# Install HiDPI support
print_message "Installing HiDPI support"
sudo pacman -S --noconfirm xorg-xrdb

# Install Polkit authentication agent
print_message "Installing Polkit authentication agent"
sudo pacman -S --noconfirm polkit-gnome

# Create Hyprland config directory
print_message "Creating Hyprland config directory"
mkdir -p ~/.config/hypr

# Create basic Hyprland config
print_message "Creating basic Hyprland config"
cat << EOF > ~/.config/hypr/hyprland.conf
# Start notification daemon
exec-once = mako

# Start polkit agent
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# Set environment variables
env = QT_QPA_PLATFORM,wayland
env = GDK_BACKEND,wayland
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Example for 1.5x scaling (adjust as needed)
monitor=,preferred,auto,1.5
EOF

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
sudo tee /etc/environment.d/10-wayland-hidpi.conf > /dev/null << EOF
XCURSOR_SIZE=24
GDK_SCALE=1.5
GDK_DPI_SCALE=1.5
QT_AUTO_SCREEN_SCALE_FACTOR=1
QT_SCALE_FACTOR=1.5
EOF

print_message "Setup complete! Please log out and log back in for changes to take effect."
