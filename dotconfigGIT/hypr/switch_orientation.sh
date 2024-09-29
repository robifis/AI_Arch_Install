#!/bin/bash

# Get current resolution
CURRENT_RESOLUTION=$(hyprctl monitors | grep -Eo 'res [0-9]+x[0-9]+' | awk '{print $2}')

if [ "$CURRENT_RESOLUTION" == "3840x2160" ]; then
    # Switch to Portrait
    hyprctl dispatch output HDMI-A-1 res 2160x3840 pos 0,0
    echo "Switched to Portrait Mode"
elif [ "$CURRENT_RESOLUTION" == "2160x3840" ]; then
    # Switch to Landscape
    hyprctl dispatch output HDMI-A-1 res 3840x2160 pos 0,0
    echo "Switched to Landscape Mode"
else
    echo "Unknown resolution: $CURRENT_RESOLUTION"
    exit 1
fi
