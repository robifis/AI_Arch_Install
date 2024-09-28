#!/bin/bash

# install_nerd_fonts.sh

# Array of font names to install
fonts=(
    "JetBrainsMono"
    "VictorMono"
    "FiraCode"
    "CascadiaCode"
    "FontAwesome"
)

# Base URL for Nerd Fonts releases
base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2"

# Directory to store and install fonts
font_dir="/usr/local/share/fonts/NerdFonts"

# Create font directory if it doesn't exist
sudo mkdir -p "$font_dir"

# Function to download and install a font
install_font() {
    local font_name="$1"
    local zip_file="${font_name}.zip"
    local download_url="${base_url}/${zip_file}"

    echo "Downloading ${font_name}..."
    if curl -L -o "$zip_file" "$download_url"; then
        echo "Installing ${font_name}..."
        sudo unzip -o "$zip_file" -d "$font_dir"
        rm "$zip_file"
        echo "${font_name} installed successfully."
    else
        echo "Failed to download ${font_name}."
    fi
}

# Check if necessary tools are installed
if ! command -v curl &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "Installing required packages..."
    sudo pacman -Sy --noconfirm curl unzip
fi

# Install each font
for font in "${fonts[@]}"; do
    install_font "$font"
done

# Update font cache
echo "Updating font cache..."
sudo fc-cache -f

echo "All specified Nerd Fonts have been installed!"
echo "You may need to log out and log back in for the fonts to be available in all applications."
