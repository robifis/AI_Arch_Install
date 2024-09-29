#!/bin/bash

# Comprehensive Reflector Setup and Update Script

# Function to print messages
print_message() {
    echo "===> $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
   print_message "This script must be run as root" 
   exit 1
fi

# Install reflector if not present
if ! command_exists reflector; then
    print_message "Reflector is not installed. Installing now..."
    pacman -Sy --noconfirm reflector
    if [ $? -ne 0 ]; then
        print_message "Failed to install reflector. Please check your internet connection and try again."
        exit 1
    fi
    print_message "Reflector installed successfully."
else
    print_message "Reflector is already installed."
fi

# Backup current mirrorlist
print_message "Backing up current mirrorlist"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Update the mirror list
print_message "Updating mirror list"
reflector --country 'United States,Canada' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Check if the new mirrorlist is empty
if [ ! -s /etc/pacman.d/mirrorlist ]; then
    print_message "Error: New mirrorlist is empty. Restoring backup."
    mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist
else
    print_message "Successfully updated mirrorlist"
    # Update the databases
    pacman -Sy
fi

# Create systemd service file
print_message "Creating systemd service file"
cat > /etc/systemd/system/reflector.service << EOF
[Unit]
Description=Pacman mirrorlist update
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --country 'United States,Canada' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

[Install]
RequiredBy=multi-user.target
EOF

# Create systemd timer file
print_message "Creating systemd timer file"
cat > /etc/systemd/system/reflector.timer << EOF
[Unit]
Description=Run reflector weekly

[Timer]
OnCalendar=weekly
RandomizedDelaySec=12h
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start the timer
print_message "Enabling and starting reflector timer"
systemctl enable reflector.timer
systemctl start reflector.timer

print_message "Reflector setup and initial update completed. Weekly updates have been scheduled."
