#!/bin/bash

options="Logout\nReboot\nShutdown"

selected=$(echo -e $options | wofi --dmenu --cache-file /dev/null --prompt "Power Menu" --width 250 --height 180 --location top --yoffset 30)

case $selected in
    Logout)
        hyprctl dispatch exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
