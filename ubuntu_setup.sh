#!/bin/bash

# setup_ubuntu.sh - Automate Ubuntu 24.04 configuration with i3, Hyprland, drivers, and applications.

set -e  # Exit immediately if a command exits with a non-zero status.

# Function to print messages
print_msg() {
    echo -e "\n\e[1;32m$1\e[0m\n"
}

# Update package lists and upgrade existing packages
print_msg "Updating package lists and upgrading existing packages..."
sudo apt update && sudo apt -y upgrade

# Install Graphics Drivers and related packages
print_msg "Installing graphics drivers and related packages..."
sudo apt install -y mesa-vulkan-drivers mesa-utils vulkan-tools xorg xserver-xorg

# Install Wayland and related protocols
print_msg "Installing Wayland and related protocols..."
sudo apt install -y wayland-protocols libwayland-client0 libwayland-server0

# Install dependencies for building Hyprland
print_msg "Installing dependencies for Hyprland..."
sudo apt install -y \
    build-essential cmake meson ninja-build pkg-config git \
    libwayland-dev libx11-dev libx11-xcb-dev libxkbcommon-dev libpixman-1-dev \
    libgtk-3-dev libglm-dev libevdev-dev uthash-dev libinput-dev libxcb-render0-dev \
    libxcb-render-util0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-icccm4-dev \
    libxcb-keysyms1-dev libxcb-util0-dev libxcb-cursor-dev libxcb-composite0-dev \
    libxcb-damage0-dev libxcb-ewmh-dev libxcb-image0-dev libxcb-glx0-dev \
    wayland-protocols scdoc

# Install PipeWire and WirePlumber
print_msg "Installing PipeWire and WirePlumber..."
sudo apt install -y pipewire pipewire-audio-client-libraries wireplumber libspa-0.2-bluetooth

# Enable PipeWire services
print_msg "Enabling PipeWire services..."
systemctl --user --now enable pipewire pipewire-pulse wireplumber

# Install audio control tool
print_msg "Installing pavucontrol..."
sudo apt install -y pavucontrol

# Install Bluetooth packages
print_msg "Installing Bluetooth packages..."
sudo apt install -y bluetooth bluez bluez-tools

# Enable and start Bluetooth service
print_msg "Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Install Blueman Bluetooth manager
print_msg "Installing Blueman Bluetooth manager..."
sudo apt install -y blueman

# Install OBS Studio and Wayland support
print_msg "Installing OBS Studio and Wayland support..."
sudo apt install -y obs-studio qtwayland5

# Install Neovim
print_msg "Installing Neovim..."
sudo apt install -y neovim

# Install Nerd Fonts
print_msg "Installing Nerd Fonts..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"
FONT_ZIP="FiraCode.zip"
wget -O "$FONT_ZIP" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip
unzip -o "$FONT_ZIP"
rm "$FONT_ZIP"
fc-cache -fv
cd ~

# Install Alacritty
print_msg "Installing Alacritty..."
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update
sudo apt install -y alacritty

# Install Kitty
print_msg "Installing Kitty..."
sudo apt install -y kitty

# Install dmenu
print_msg "Installing dmenu..."
sudo apt install -y suckless-tools

# Install rofi
print_msg "Installing rofi..."
sudo apt install -y rofi

# Install eza using cargo
print_msg "Installing Rust and Cargo..."
sudo apt install -y cargo

print_msg "Installing eza..."
cargo install eza

# Install git
print_msg "Installing git..."
sudo apt install -y git

# Install Zsh and Oh-My-Zsh
print_msg "Installing Zsh..."
sudo apt install -y zsh
print_msg "Changing default shell to Zsh..."
chsh -s $(which zsh)
print_msg "Installing Oh-My-Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install xclip
print_msg "Installing xclip..."
sudo apt install -y xclip

# Install feh image viewer
print_msg "Installing feh..."
sudo apt install -y feh

# Install network manager applet
print_msg "Installing Network Manager Applet..."
sudo apt install -y network-manager-gnome

# Install LightDM display manager
print_msg "Installing LightDM display manager..."
sudo apt install -y lightdm lightdm-gtk-greeter

# Enable LightDM display manager
print_msg "Enabling LightDM display manager..."
sudo systemctl enable lightdm

# Setting up i3 session
print_msg "Setting up i3 session..."
sudo bash -c 'cat > /usr/share/xsessions/i3.desktop' << EOF
[Desktop Entry]
Name=i3
Comment=Improved dynamic tiling window manager
Exec=i3
Type=Application
EOF

# Setting up Hyprland session
print_msg "Setting up Hyprland session..."
sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' << EOF
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland Compositor
Exec=Hyprland
Type=Application
EOF

# Configure scaling for X11
print_msg "Configuring HiDPI scaling for X11..."
if ! grep -q "Xft.dpi: 192" ~/.Xresources 2>/dev/null; then
    echo "Xft.dpi: 192" >> ~/.Xresources
fi
xrdb ~/.Xresources

