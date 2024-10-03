#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect the operating system
if command_exists pacman; then
    OS="arch"
elif command_exists apt-get; then
    OS="debian"
elif command_exists dnf; then
    OS="fedora"
else
    echo "Unsupported operating system"
    exit 1
fi

# Function to install packages
install_packages() {
    case $OS in
        arch)
            sudo pacman -S --needed --noconfirm "$@"
            ;;
        debian)
            sudo apt-get update
            sudo apt-get install -y "$@"
            ;;
        fedora)
            sudo dnf install -y "$@"
            ;;
    esac
}

# Install base dependencies
case $OS in
    arch)
        install_packages base-devel git cmake meson
        ;;
    debian)
        install_packages build-essential git cmake meson
        ;;
    fedora)
        install_packages @development-tools git cmake meson
        ;;
esac

# Install i3-gaps dependencies
case $OS in
    arch)
        install_packages xcb-util-keysyms xcb-util-wm xcb-util-cursor libev startup-notification libxkbcommon-x11 libxcb xcb-util-xrm libxcb xcb-util-cursor cairo pango
        ;;
    debian)
        install_packages libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev
        ;;
    fedora)
        install_packages libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel yajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel git gcc automake
        ;;
esac

# Install Polybar dependencies
case $OS in
    arch)
        install_packages cairo libxcb python python-sphinx xcb-proto xcb-util-image xcb-util-wm alsa-lib libpulse libmpdclient libnl curl
        ;;
    debian)
        install_packages libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev libcurl4-openssl-dev libiw-dev libcairo2-dev libxcb-composite0-dev libuv1-dev libjsoncpp-dev python3-sphinx
        ;;
    fedora)
        install_packages cairo-devel xcb-util-devel libxcb-devel xcb-proto python3-sphinx xcb-util-image-devel xcb-util-wm-devel alsa-lib-devel pulseaudio-libs-devel libmpdclient-devel libnl3-devel wireless-tools-devel libcurl-devel jsoncpp-devel
        ;;
esac

# Clone and install i3-gaps
git clone https://github.com/Airblader/i3 i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson --prefix /usr/local
ninja
sudo ninja install
cd ../..

# Install Polybar
git clone --recursive https://github.com/polybar/polybar
cd polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Install additional tools
case $OS in
    arch)
        install_packages rofi picom feh lxappearance pavucontrol dunst nitrogen arandr flameshot playerctl
        ;;
    debian)
        install_packages rofi compton feh lxappearance pavucontrol dunst picom nitrogen arandr flameshot playerctl
        ;;
    fedora)
        install_packages rofi picom feh lxappearance pavucontrol dunst nitrogen arandr flameshot playerctl
        ;;
esac

echo "Installation complete! You may need to log out and log back in to use i3-gaps."
