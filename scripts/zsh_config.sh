#!/bin/bash

# install_zsh_config.sh

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing Zsh..."
    sudo apt update && sudo apt install zsh -y
fi

# Install required packages
echo "Installing required packages..."
sudo apt update && sudo apt install git curl -y

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# Backup existing .zshrc if it exists
if [ -f ~/.zshrc ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv ~/.zshrc ~/.zshrc.backup
fi

# Download the .zshrc file
echo "Downloading .zshrc file..."
curl -fLo ~/.zshrc https://raw.githubusercontent.com/yourusername/yourrepo/main/.zshrc

# Install Zinit
echo "Installing Zinit..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Install Powerlevel10k fonts
echo "Installing Powerlevel10k fonts..."
font_dir="$HOME/.local/share/fonts"
mkdir -p "$font_dir"
curl -fLo "$font_dir/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "$font_dir/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "$font_dir/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "$font_dir/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v

echo "Zsh configuration completed successfully!"
echo "Please log out and log back in for the changes to take effect."
echo "After logging back in, run 'p10k configure' to set up your Powerlevel10k theme."
