#!/bin/bash

# Directory containing theme configs
THEME_DIR="$HOME/.config/hypr/themes"

# Current theme (extract from hyprland.conf)
CURRENT_THEME=$(grep "import" ~/.config/hypr/hyprland.conf | awk -F'/' '{print $NF}' | sed 's/.conf//')

# Define the themes in order
THEMES=("gruvbox" "dracula" "synthwave" "catppucci")

# Find the next theme
NEXT_THEME=""
found_current=false
for theme in "${THEMES[@]}"; do
    if [ "$found_current" = true ]; then
        NEXT_THEME=$theme
        break
    fi
    if [ "$theme" == "$CURRENT_THEME" ]; then
        found_current=true
    fi
done

# If current theme is the last one, cycle back to first
if [ -z "$NEXT_THEME" ]; then
    NEXT_THEME=${THEMES[0]}
fi

# Update hyprland.conf with the next theme
sed -i "s|import = .*|import = $THEME_DIR/$NEXT_THEME.conf|" ~/.config/hypr/hyprland.conf

# Apply the new configuration
hyprctl reload

echo "Switched to theme: $NEXT_THEME"
