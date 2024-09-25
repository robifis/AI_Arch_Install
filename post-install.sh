#!/bin/bash

# Exit on any error
set -e

echo "Starting post-installation setup..."

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --noconfirm base-devel git zsh vim neovim alacritty kitty copyq dmenu rofi wofi eza obs-studio dunst

# Install AUR helper 'paru'
echo "Installing 'paru' AUR helper..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru

# Install AUR helper 'yay'
echo "Installing 'yay' AUR helper..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
echo "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set ZSH theme to Powerlevel10k
echo "Configuring ZSH theme to Powerlevel10k..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install Zinit
echo "Installing Zinit..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Configure Vim
echo "Configuring Vim..."
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# Install Hyprland and dependencies
echo "Installing Hyprland and dependencies..."
sudo pacman -S --noconfirm hyprland swaylock swaybg wayland wlr-randr grim slurp dunst

# Install AMD drivers
echo "Installing AMD drivers..."
sudo pacman -S --noconfirm mesa mesa-vulkan-radeon vulkan-radeon amd-ucode

# Install OBS hardware encoding dependencies
echo "Installing OBS hardware encoding dependencies..."
sudo pacman -S --noconfirm vulkan-icd-loader radeontop

# Install power management tools
echo "Installing power management tools..."
sudo pacman -S --noconfirm tlp tlp-rdw powertop preload

# Enable and start TLP and preload
echo "Enabling TLP and preload..."
sudo systemctl enable tlp
sudo systemctl start tlp
sudo systemctl enable preload
sudo systemctl start preload

# Install notification daemon
echo "Installing notification daemon..."
sudo pacman -S --noconfirm dunst

# Enable UFW and configure firewall
echo "Configuring firewall (UFW)..."
sudo pacman -S --noconfirm ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw

# Install Preload and Reflector
echo "Installing Preload and Reflector..."
sudo pacman -S --noconfirm preload reflector

# Install Themes
echo "Installing themes..."
paru -S --noconfirm catppuccin-gruvbox hyprpaper-synthwave

# Setup Hyprland configuration
echo "Setting up Hyprland configuration..."
mkdir -p ~/.config/hypr
cp /etc/hypr/hyprland.conf ~/.config/hypr/

# Create scripts for monitor layouts
echo "Creating monitor layout scripts..."
cat <<EOL > ~/.config/hypr/portrait.sh
#!/bin/bash
hyprctl dispatch monitor eDP-1 1080x1920@60Hz,1,portrait
EOL

cat <<EOL > ~/.config/hypr/normal.sh
#!/bin/bash
hyprctl dispatch monitor eDP-1 1920x1080@60Hz,1,landscape
EOL

chmod +x ~/.config/hypr/*.sh

# Configure autostart for Hyprland
echo "Configuring autostart for Hyprland..."
cat <<EOL > ~/.config/hypr/autostart.conf
exec_always dunst
exec_always nm-applet
exec_always alacritty
exec_always obs
EOL

# Enable notification daemon
echo "Enabling notification daemon..."
sudo systemctl enable dunst

# Set up Alacritty clipboard integration
echo "Configuring Alacritty..."
mkdir -p ~/.config/alacritty
cat <<EOL > ~/.config/alacritty/alacritty.yml
# Example Alacritty configuration
clipboard:
  primary: true
  secondary: true
EOL

# Install and configure yay (already installed above)

echo "Post-installation setup complete."
