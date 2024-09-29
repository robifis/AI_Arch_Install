#!/bin/bash

# Comprehensive Arch Linux Update and Clean Script

# Function to print messages
print_message() {
    echo "===> $1"
}

# Check if script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
   print_message "This script must be run as root" 
   exit 1
fi

# Update system
print_message "Updating system"
pacman -Syu --noconfirm

# Clean package cache
print_message "Cleaning package cache"
paccache -r

# Remove orphaned packages
print_message "Removing orphaned packages"
pacman -Qtdq | pacman -Rns - --noconfirm

# Clean journal logs
print_message "Cleaning journal logs"
journalctl --vacuum-time=7d

# Clean thumbnails cache
print_message "Cleaning thumbnails cache"
rm -rf /home/*/.cache/thumbnails/*
rm -rf /root/.cache/thumbnails/*

# Remove old log files
print_message "Removing old log files"
find /var/log -type f -name "*.old" -delete
find /var/log -type f -name "*.gz" -delete

# Remove temporary files
print_message "Removing temporary files"
rm -rf /tmp/*
rm -rf /var/tmp/*

print_message "System update and cleanup completed"

# Create systemd service file
print_message "Creating systemd service file"
cat > /etc/systemd/system/arch-update-clean.service << EOF
[Unit]
Description=Arch Linux update and clean
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/arch-update-clean.sh

[Install]
RequiredBy=multi-user.target
EOF

# Create systemd timer file
print_message "Creating systemd timer file"
cat > /etc/systemd/system/arch-update-clean.timer << EOF
[Unit]
Description=Run Arch Linux update and clean daily

[Timer]
OnCalendar=daily
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Copy this script to /usr/local/bin
print_message "Copying script to /usr/local/bin"
cp "$0" /usr/local/bin/arch-update-clean.sh
chmod +x /usr/local/bin/arch-update-clean.sh

# Enable and start the timer
print_message "Enabling and starting Arch update and clean timer"
systemctl enable arch-update-clean.timer
systemctl start arch-update-clean.timer

print_message "Arch Linux update and clean setup completed. Daily updates and cleaning have been scheduled."
