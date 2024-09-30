#!/bin/bash
# ~/.config/hypr/switch_theme.sh

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
WAYBAR_CONFIG="$HOME/.config/waybar/config"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"

switch_theme() {
    theme=$1
    # Update Hyprland config
    sed -i "s|^source.*themes.*conf$|source = ~/.config/hypr/themes/${theme}.conf|" $HYPR_CONFIG
    
    # Update Waybar style
    cp ~/.config/waybar/themes/${theme}.css $WAYBAR_STYLE

        # Update Alacritty config
    sed -i "s|^import = .*|import = [\"~/.config/alacritty/themes/${theme}.toml\"]|" "$ALACRITTY_CONFIG"
    
    # Reload Hyprland config
    hyprctl reload
    
    # Restart Waybar
    killall waybar
    waybar &
}

case $1 in
    1) switch_theme "dracula" ;;
    2) switch_theme "gruvbox" ;;
    3) switch_theme "nord" ;;
    *) echo "Invalid theme number. Use 1 for Dracula, 2 for Gruvbox, or 3 for Nord." ;;
esac
