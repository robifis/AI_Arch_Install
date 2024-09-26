#!/bin/bash

# install_ly_synthwave84.sh

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install dependencies
pacman -S --noconfirm base-devel git

# Clone Ly repository
git clone https://github.com/fairyglade/ly.git
cd ly

# Modify colors for Synthwave84 theme
cat > src/colors.c << EOF
#include "colors.h"

struct colors colors_default = {
    /* background color */
    .bg = {0x2b, 0x21, 0x3a},
    /* border color */
    .fg = {0xff, 0x7e, 0xdb},
    /* input color */
    .input = {0x4d, 0x3a, 0x63},
    /* input text color */
    .input_text = {0xf9, 0x2a, 0xad},
    /* selected color */
    .selected = {0x1a, 0x14, 0x24},
    /* selected text color */
    .selected_text = {0x36, 0xf9, 0xf6},
    /* hostname color */
    .hostname = {0xfd, 0xd7, 0x5e},
    /* date color */
    .date = {0x94, 0x58, 0xb1},
    /* other text color */
    .other = {0xfd, 0xd7, 0x5e},
};
EOF

# Compile and install Ly
make
make install

# Enable Ly service
systemctl enable ly.service

# Create Ly configuration directory
mkdir -p /etc/ly

# Create Ly configuration file
cat > /etc/ly/config.ini << EOF
# Ly configuration

# Animation enabled
animate = true

# Current selected desktop environment
default_de = 1

# Console path
console_dev = /dev/console

# Width of the input boxes
input_width = 24

# Input box top margin
input_top = 80

# Input box left margin
input_left = 50

# Number of chars to jump on keypress
char_jump = 2

# Load the X server
load_x = true

# X server command
xsetup = /etc/ly/xsetup.sh

# Blank time in minutes
blank_time = 5

# Shutdown command
shutdown_cmd = /sbin/poweroff

# Restart command
restart_cmd = /sbin/reboot

# Hide enter
hide_enter = false

# Hide borders
hide_borders = false

# Hide panels
hide_panels = false

# Clock format
clock_format = %H:%M:%S

# Date format
date_format = %a, %d %b

# Wayland support
load_wayland = true
EOF

echo "Ly has been installed and configured with a Synthwave84 theme."
echo "Please reboot your system for the changes to take effect."
