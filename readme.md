Certainly! Below is the revised, more generic Markdown documentation for setting up an optimized dual-boot Arch Linux system. This version includes alternatives for both AMD and Intel hardware, additional explanations, and cautions for users to tailor the setup to their specific requirements.

---

# Optimized Dual-Boot Arch Linux Setup for Modern PCs

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Creating a Bootable Arch Linux USB Drive](#3-creating-a-bootable-arch-linux-usb-drive)
4. [Disk Partitioning for Dual Boot](#4-disk-partitioning-for-dual-boot)
5. [Base System Installation](#5-base-system-installation)
6. [Post-Installation Configuration](#6-post-installation-configuration)
7. [Installing Essential Software](#7-installing-essential-software)
8. [Setting Up the Graphical Environment](#8-setting-up-the-graphical-environment)
9. [Security Enhancements](#9-security-enhancements)
10. [Power Management Optimizations](#10-power-management-optimizations)
11. [Optimizing OBS for Hardware Encoding](#11-optimizing-obs-for-hardware-encoding)
12. [Automation Scripts](#12-automation-scripts)
13. [Documentation](#13-documentation)
14. [Final Steps and Reboot](#14-final-steps-and-reboot)
15. [Troubleshooting](#15-troubleshooting)
16. [Additional Tips](#16-additional-tips)
17. [License](#17-license)

---

## 1. Introduction

This guide provides comprehensive instructions to set up an **optimized Arch Linux** environment tailored for modern PCs. Whether you have an **AMD** or **Intel** processor, 16GB RAM, and a **512GB NVMe SSD**, this setup includes a **dual-boot configuration with Windows**, a lightweight window manager (**Hyprland**), essential development tools, power management optimizations, and specialized configurations for **OBS Studio** leveraging hardware encoding capabilities.

**_Note:_** *This documentation serves as a template. Users should adjust partition sizes, hardware configurations, and other settings according to their specific requirements and hardware specifications.*

## 2. Prerequisites

Before proceeding, ensure you have the following:

### **Hardware:**
- **PC Specifications:**
  - CPU: AMD Ryzen, Intel Core, or equivalent modern processor.
  - RAM: 16GB.
  - Storage: 512GB NVMe SSD (or as per your system).
- **Existing OS:** Windows installed on the NVMe SSD for dual-boot.
- **Bootable USB Drive:** Minimum 8GB capacity for Arch Linux installation media.

### **Software:**
- **Another Computer:** With internet access to create the bootable USB.
- **Stable Internet Connection:** Preferably gigabit for faster downloads.

### **Knowledge:**
- **Basic Linux Command-Line:** Familiarity with terminal commands.
- **Dual-Boot Systems:** Understanding of partitioning and bootloader configurations.

### **Caution:**
- **Data Backup:** Always back up important data before modifying disk partitions to prevent data loss.

---

## 3. Creating a Bootable Arch Linux USB Drive

To install Arch Linux, you'll first need to create a bootable USB drive using tools like `curl` or `wget` along with the `dd` command. This section guides you through the process.

### **Steps:**

### **1. Download the Arch Linux ISO**

Choose your preferred method to download the Arch Linux ISO. Ensure you verify the integrity of the downloaded ISO using checksums provided on the [Arch Linux Downloads](https://archlinux.org/download/) page.

- **Using `curl`:**

  ```bash
  curl -LO https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso
  ```

- **Using `wget`:**

  ```bash
  wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso
  ```

### **2. Identify the USB Drive**

Insert your USB drive and identify its device name to avoid overwriting the wrong drive.

```bash
lsblk
```

*Example Output:*

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 476.9G  0 disk 
├─sda1        8:1    0   500M  0 part /boot/efi
├─sda2        8:2    0    16G  0 part /
└─sda3        8:3    0  460.4G  0 part /home
sdb           8:16   1    8G   0 disk 
└─sdb1        8:17   1    8G   0 part /run/media/user/USB
```

*In this example, `/dev/sdb` is the USB drive.*

### **3. Create the Bootable USB**

Use the `dd` command to write the ISO to the USB drive. **Ensure you replace `/dev/sdX` with your actual USB drive identifier (`/dev/sdb` in this example).**

```bash
sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

- **Parameters Explained:**
  - `if`: Input file (the downloaded ISO).
  - `of`: Output file (your USB drive).
  - `bs=4M`: Sets the block size to 4 Megabytes.
  - `status=progress`: Displays progress during the operation.
  - `oflag=sync`: Ensures all writes are synchronized.

### **4. Safely Eject the USB Drive**

After the `dd` command finishes, safely eject the USB drive.

```bash
sudo eject /dev/sdX
```

Your bootable Arch Linux USB drive is now ready for installation.

---

## 4. Disk Partitioning for Dual Boot

This section guides you through partitioning your **512GB NVMe SSD** to allocate **256GB for Arch Linux**, preserving the existing Windows installation for a dual-boot setup.

### **_Important:_** *Ensure you have backed up all important data before modifying disk partitions.*

### **Steps:**

### **1. Boot into Windows**

It's recommended to use Windows' built-in tools to shrink the existing partition and create unallocated space for Arch Linux.

### **2. Shrink Windows Partition**

- Press `Win + R`, type `diskmgmt.msc`, and press `Enter` to open Disk Management.
- Right-click on the main Windows partition (usually `C:`) and select **Shrink Volume**.
- Enter the amount to shrink (e.g., `262144` MB for 256GB) and proceed. This will leave **256GB of unallocated space** for Arch Linux.

### **3. Boot from the Arch Linux USB Drive**

- Insert the bootable USB drive.
- Restart your PC and enter the BIOS/UEFI settings (commonly by pressing `F2`, `F10`, `DEL`, or similar keys during boot).
- Set the USB drive as the primary boot device.
- Disable Secure Boot if enabled.
- Save and exit to boot into the Arch installer.

### **4. Verify the NVMe Drive**

Once in the live environment, identify your NVMe SSD.

```bash
lsblk
```

*Assume the NVMe drive is `/dev/nvme0n1`.*

### **5. Partition the Unallocated Space**

We'll use `gdisk` for partitioning. This example assumes you have an existing EFI partition from Windows. If not, you'll need to create one.

```bash
sudo gdisk /dev/nvme0n1
```

- **Create Root (`/`) Partition:**
  - **Size:** 40GB
  - **Type:** `8300` (Linux filesystem)

- **Create Home (`/home`) Partition:**
  - **Size:** Remaining unallocated space (~216GB)
  - **Type:** `8300` (Linux filesystem)

- **(Optional) Create Swap Partition/File:**
  - With 16GB RAM, swap is optional unless you plan to use hibernation.

- **Write Changes and Exit:**
  - Press `w` to write the partition table and exit.

*_Note:_* *Adjust partition sizes and numbers according to your specific setup.*

### **6. Format the Partitions**

- **Root Partition:**

  ```bash
  sudo mkfs.ext4 /dev/nvme0n1p3  # Replace with your root partition identifier
  ```

- **Home Partition:**

  ```bash
  sudo mkfs.ext4 /dev/nvme0n1p4  # Replace with your home partition identifier
  ```

- **(Optional) Create and Format Swap:**

  ```bash
  sudo mkswap /dev/nvme0n1p5  # Replace with your swap partition identifier
  sudo swapon /dev/nvme0n1p5
  ```

### **7. Mount the Partitions**

```bash
sudo mount /dev/nvme0n1p3 /mnt
sudo mkdir /mnt/home
sudo mount /dev/nvme0n1p4 /mnt/home
```

- **Mount EFI Partition:**

  Assuming EFI partition is `/dev/nvme0n1p1`.

  ```bash
  sudo mkdir /mnt/boot
  sudo mount /dev/nvme0n1p1 /mnt/boot
  ```

### **8. Verify the Filesystem Layout**

Ensure that `/mnt` points to the root partition, `/mnt/home` to the home partition, and `/mnt/boot` to the EFI partition.

```bash
lsblk -f
```

---

## 5. Base System Installation

With partitions set up, install the base Arch Linux system.

### **Steps:**

### **1. Set the System Clock**

```bash
timedatectl set-ntp true
```

### **2. Select Mirrors (Optional but Recommended)**

Use **Reflector** to update the mirror list for faster package downloads.

```bash
sudo pacman -Sy --noconfirm reflector
sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
```

*This command selects the 5 most recently updated and fastest mirrors.*

### **3. Install Base Packages**

```bash
sudo pacstrap /mnt base linux linux-firmware vim sudo networkmanager
```

### **4. Generate `fstab`**

```bash
sudo genfstab -U /mnt >> /mnt/etc/fstab
```

### **5. Chroot into the New System**

```bash
sudo arch-chroot /mnt
```

### **6. Set the Time Zone**

```bash
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
```

*_Note:_* *Replace `Europe/London` with your actual time zone if different.*

### **7. Localization**

- **Edit `/etc/locale.gen`:**

  ```bash
  vim /etc/locale.gen
  ```

  Uncomment the following lines by removing the `#`:

  ```
  en_GB.UTF-8 UTF-8
  en_US.UTF-8 UTF-8
  ```
  
  *Add or uncomment lines relevant to your locale if different.*

- **Generate Locales:**

  ```bash
  locale-gen
  ```

- **Set Locale:**

  ```bash
  echo "LANG=en_GB.UTF-8" > /etc/locale.conf
  ```

### **8. Network Configuration**

- **Set Hostname:**

  ```bash
  echo "archpc" > /etc/hostname
  ```

- **Configure `/etc/hosts`:**

  ```bash
  vim /etc/hosts
  ```

  Add the following lines:

  ```
  127.0.0.1   localhost
  ::1         localhost
  127.0.1.1   archpc.localdomain archpc
  ```

### **9. Set Root Password**

```bash
passwd
```

*Enter a secure password when prompted.*

### **10. Install Bootloader**

**Using `systemd-boot`:**

- **Install `systemd-boot`:**

  ```bash
  bootctl install
  ```

- **Create `loader.conf`:**

  ```bash
  vim /boot/loader/loader.conf
  ```

  Add the following:

  ```
  default arch
  timeout 3
  editor no
  ```

- **Create Boot Entry for Arch Linux:**

  - **Find the `PARTUUID` for the root partition:**

    ```bash
    blkid /dev/nvme0n1p3
    ```

    *Example Output:*

    ```
    /dev/nvme0n1p3: UUID="abcd-1234" TYPE="ext4" PARTUUID="abcd1234-03"
    ```

  - **Create Entry File:**

    ```bash
    vim /boot/loader/entries/arch.conf
    ```

    Add the following (replace `<root-partition-uuid>` with your actual PARTUUID):

    ```
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options root=PARTUUID=<root-partition-uuid> rw
    ```

- **Add Windows Boot Entry (if not auto-detected):**

  `systemd-boot` should automatically detect Windows if it's installed in UEFI mode. If not, you can manually add an entry.

  ```bash
  mkdir -p /boot/loader/entries
  vim /boot/loader/entries/windows.conf
  ```

  Add the following (replace `<EFI-Partition-UUID>` with your EFI partition's UUID, usually `/dev/nvme0n1p1`):

  ```
  title   Windows 10
  efi     /EFI/Microsoft/Boot/bootmgfw.efi
  ```

  *Ensure Windows is installed in UEFI mode.*

### **11. Create a Standard User (`bobby`)**

```bash
useradd -m -G wheel -s /bin/zsh bobby
passwd bobby
```

*Replace `bobby` with your desired username.*

### **12. Grant Sudo Privileges**

```bash
EDITOR=vim visudo
```

Uncomment the following line by removing the `#`:

```
%wheel ALL=(ALL) ALL
```

### **13. Enable NetworkManager**

```bash
systemctl enable NetworkManager
```

### **14. Exit Chroot and Reboot**

```bash
exit
sudo umount -R /mnt
sudo reboot
```

---

## 6. Post-Installation Configuration

After rebooting into your new Arch Linux system, perform the following configurations to set up your environment.

### **Steps:**

### **1. Log In as `bobby`**

Use the credentials you set during installation.

### **2. Update the System**

```bash
sudo pacman -Syu
```

### **3. Install Base Development Tools**

```bash
sudo pacman -S --noconfirm base-devel git
```

### **4. Install AUR Helpers (`paru` and `yay`)**

**_Note:_** *Installing multiple AUR helpers is generally not recommended due to potential conflicts. Choose one based on your preference. This guide includes instructions for both.*

- **Install `paru`:**

  ```bash
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm
  cd ..
  rm -rf paru
  ```

- **Install `yay`:**

  ```bash
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
  ```

### **5. Install ZSH and Oh-My-Zsh**

```bash
sudo pacman -S --noconfirm zsh
```

- **Install Oh-My-Zsh:**

  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ```

### **6. Install Powerlevel10k Theme**

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

- **Set Theme in ZSH Configuration:**

  ```bash
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
  ```

### **7. Install Zinit**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
```

### **8. Install Vim and Neovim with Configuration**

```bash
sudo pacman -S --noconfirm vim neovim
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
```

*Customize `~/.vimrc` as needed for coding, Markdown, etc.*

### **9. Install Additional Essentials**

```bash
sudo pacman -S --noconfirm alacritty kitty copyq dmenu rofi wofi eza obs-studio dunst
```

---

## 7. Installing Essential Software

This section covers the installation of various essential applications to enhance your system's functionality.

### **List of Essential Applications:**

- **Terminal Emulators:**
  - **Alacritty:** Fast GPU-accelerated terminal.
  - **Kitty:** Feature-rich terminal emulator.

- **Clipboard Managers:**
  - **CopyQ:** Advanced clipboard manager with editing and scripting capabilities.

- **Editors:**
  - **Vim:** Highly configurable text editor.
  - **Neovim:** Modern refactor of Vim with enhanced features.

- **Application Launchers:**
  - **dmenu:** Dynamic menu for launching applications.
  - **rofi:** Window switcher, application launcher, and dmenu replacement.
  - **wofi:** Wayland-native application launcher.

- **Utilities:**
  - **Eza:** A modern and colorful replacement for `ls`.
  - **OBS Studio:** Open Broadcaster Software for streaming and recording.
  - **Dunst:** Lightweight notification daemon.

### **Installation Command:**

```bash
sudo pacman -S --noconfirm alacritty kitty copyq dmenu rofi wofi eza obs-studio dunst
```

---

## 8. Setting Up the Graphical Environment

Set up a lightweight and efficient graphical environment using **Hyprland**. This section also includes configuring hardware-specific drivers and scripts for monitor layouts.

### **Steps:**

### **1. Install Hyprland and Dependencies**

```bash
sudo pacman -S --noconfirm hyprland swaylock swaybg wayland wlr-randr grim slurp dunst
```

### **2. Install Graphics Drivers**

#### **For AMD Systems:**

Ensure comprehensive AMD support by installing necessary drivers.

```bash
sudo pacman -S --noconfirm mesa mesa-vulkan-radeon vulkan-radeon amd-ucode
```

#### **For Intel Systems:**

Install Intel-specific drivers and Vulkan support.

```bash
sudo pacman -S --noconfirm mesa mesa-vulkan-intel vulkan-intel intel-ucode
```

*Choose the appropriate command based on your CPU manufacturer. Do **not** install AMD and Intel drivers simultaneously.*

### **3. Install OBS Hardware Encoding Dependencies**

**_Note:_** *These dependencies are necessary for leveraging GPU hardware encoding in OBS Studio.*

```bash
sudo pacman -S --noconfirm vulkan-icd-loader radeontop
```

### **4. Configure Hyprland**

- **Create Configuration Directory:**

  ```bash
  mkdir -p ~/.config/hypr
  cp /etc/hypr/hyprland.conf ~/.config/hypr/
  ```

  *_Note:_* *Modify `/etc/hypr/hyprland.conf` as needed for your setup.*

- **Create Scripts for Monitor Layouts:**

  - **Portrait Mode (`~/.config/hypr/portrait.sh`):**

    ```bash
    #!/bin/bash
    hyprctl dispatch monitor eDP-1 1080x1920@60Hz,1,portrait
    ```

  - **Normal Mode (`~/.config/hypr/normal.sh`):**

    ```bash
    #!/bin/bash
    hyprctl dispatch monitor eDP-1 1920x1080@60Hz,1,landscape
    ```

  *_Note:_* *Replace `eDP-1` and resolution/refresh rates with your actual monitor identifiers and desired settings. Use `hyprctl monitors` to list connected monitors.*

- **Make Scripts Executable:**

  ```bash
  chmod +x ~/.config/hypr/*.sh
  ```

- **Bind Keys in `hyprland.conf` to Switch Layouts:**

  Open `~/.config/hypr/hyprland.conf` and add key bindings. Example:

  ```
  bind = $mod, F6, exec, ~/.config/hypr/portrait.sh
  bind = $mod, F7, exec, ~/.config/hypr/normal.sh
  ```

### **5. Configure Autostart Applications**

```bash
vim ~/.config/hypr/autostart.conf
```

Add the following lines:

```
exec_always dunst
exec_always nm-applet
exec_always alacritty
exec_always obs
```

### **6. Set Up a Notification Daemon**

**Dunst** is already installed. Ensure it's configured:

```bash
vim ~/.config/dunst/dunstrc
```

*Customize notification settings as desired.*

### **7. Install a Display Manager (Optional)**

If you prefer using a display manager like `lightdm` over manual TTY login:

```bash
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
```

*Otherwise, you can start Hyprland manually from a TTY.*

### **8. Start Hyprland**

- **Using Display Manager:**
  - If `lightdm` is enabled, Hyprland should appear as an option on the login screen.

- **Manual Start:**
  - Switch to a TTY (`Ctrl + Alt + F2`), log in, and run:

    ```bash
    hyprland
    ```

---

## 9. Security Enhancements

Enhance your system's security by configuring a firewall and other best practices.

### **1. Firewall Setup with UFW**

**UFW** (Uncomplicated Firewall) simplifies firewall management.

- **Install UFW:**

  ```bash
  sudo pacman -S --noconfirm ufw
  ```

- **Enable and Configure UFW:**

  - **Set Default Policies:**

    ```bash
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    ```

  - **Allow Specific Services (Optional):**

    - **SSH (if needed):**

      ```bash
      sudo ufw allow ssh
      ```

  - **Enable UFW:**

    ```bash
    sudo ufw enable
    ```

- **Enable UFW at Startup:**

  ```bash
  sudo systemctl enable ufw
  ```

### **2. Additional Security Measures (Optional)**

- **Automatic Security Updates:**

  - **Install `unattended-upgrades`:**

    ```bash
    sudo pacman -S --noconfirm unattended-upgrades
    ```

  - **Configure `unattended-upgrades`:**

    Follow the [Arch Wiki guidelines](https://wiki.archlinux.org/title/Automatic_maintenance#Unattended_UPgrades) to set up automatic security updates.

---

## 10. Power Management Optimizations

Optimize your system for lower power consumption and silent operation.

### **Steps:**

### **1. Install TLP for Advanced Power Management**

```bash
sudo pacman -S --noconfirm tlp tlp-rdw
```

### **2. Enable and Start TLP**

```bash
sudo systemctl enable tlp
sudo systemctl start tlp
```

### **3. Install `powertop` and Apply Auto-Tuning**

```bash
sudo pacman -S --noconfirm powertop
sudo powertop --auto-tune
```

*Optionally, configure `powertop` to apply auto-tuning at boot by adding it to autostart scripts or systemd services.*

### **4. Install `preload` for Application Load Time Optimization**

```bash
sudo pacman -S --noconfirm preload
sudo systemctl enable preload
sudo systemctl start preload
```

### **5. Disable Unnecessary Services**

Review and disable services not required to reduce power draw.

```bash
systemctl list-unit-files --type=service --state=enabled
sudo systemctl disable <service_name>
```

*Replace `<service_name>` with the actual service you wish to disable.*

---

## 11. Optimizing OBS for Hardware Encoding

Leverage your CPU's integrated GPU for hardware encoding in OBS Studio to enhance streaming and recording performance.

### **Steps:**

### **1. Install Necessary Graphics Encoding Libraries**

Depending on your CPU manufacturer:

- **For AMD Systems:**

  ```bash
  sudo pacman -S --noconfirm mesa-vulkan-radeon vulkan-icd-loader radeontop
  ```

- **For Intel Systems:**

  ```bash
  sudo pacman -S --noconfirm mesa-vulkan-intel vulkan-icd-loader intel-ucode
  ```

### **2. Install OBS Studio**

```bash
sudo pacman -S --noconfirm obs-studio
```

### **3. Configure OBS for Hardware Encoding**

- **Open OBS Studio.**
- Navigate to **Settings** > **Output**.
- Under **Streaming** or **Recording**, set the **Encoder** to:
  - **For AMD:** `AMF (AMD Advanced Media Framework)`
  - **For Intel:** `Quick Sync Video` (if supported) or `VAAPI`.
- Adjust settings such as bitrate, presets, and keyframe interval based on your streaming or recording needs.

### **4. Increase OBS Priority (Optional)**

To ensure OBS gets sufficient CPU resources, you can increase its process priority.

```bash
sudo renice -n -10 -p $(pgrep obs)
```

### **5. Monitor GPU Usage**

Use `radeontop` (AMD) or equivalent tools for Intel to monitor GPU load during streaming or recording.

- **For AMD Systems:**

  ```bash
  radeontop
  ```

- **For Intel Systems:**

  Use tools like `intel-gpu-tools`.

  ```bash
  sudo pacman -S --noconfirm intel-gpu-tools
  sudo intel_gpu_top
  ```

---

## 12. Automation Scripts

To streamline the installation and configuration process, automation scripts are essential. Below are two scripts: `install.sh` and `post_install.sh`. These scripts automate base system setup, installing essential packages, configuring the environment, and applying all optimizations.

### **1. `install.sh`**

**Purpose:** Automates the base Arch Linux installation, including partitioning, formatting, and bootloader setup.

```bash
#!/bin/bash

# Exit on any error
set -e

echo "Starting base Arch Linux installation..."

# Update mirror list with Reflector
echo "Updating mirror list..."
pacman -Sy --noconfirm reflector
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Install base packages
echo "Installing base packages..."
pacstrap /mnt base linux linux-firmware vim sudo networkmanager

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
echo "Configuring the new system..."
arch-chroot /mnt /bin/bash <<EOF

# Set timezone to London (Change if necessary)
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Localization
echo "Configuring locale..."
echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf

# Hostname
echo "Setting hostname..."
echo "archpc" > /etc/hostname
cat <<EOL > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archpc.localdomain archpc
EOL

# Set root password (Replace 'rootpassword' with a secure password)
echo "Setting root password..."
echo "root:rootpassword" | chpasswd

# Install systemd-boot
echo "Installing systemd-boot..."
bootctl install

# Create loader.conf
echo "Creating loader.conf..."
cat <<EOL > /boot/loader/loader.conf
default arch
timeout 3
editor no
EOL

# Get PARTUUID for root partition (Replace '/dev/nvme0n1p3' if different)
ROOT_UUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3)

# Create boot entry for Arch
echo "Creating Arch Linux boot entry..."
cat <<EOL > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=${ROOT_UUID} rw
EOL

# Optionally, create boot entry for Windows if not auto-detected
# Uncomment and modify the following lines if necessary

# echo "Creating Windows boot entry..."
# mkdir -p /boot/loader/entries
# echo "title   Windows 10" > /boot/loader/entries/windows.conf
# echo "efi     /EFI/Microsoft/Boot/bootmgfw.efi" >> /boot/loader/entries/windows.conf

# Create user 'bobby' (Replace 'bobbypassword' with a secure password)
echo "Creating user 'bobby'..."
useradd -m -G wheel -s /bin/zsh bobby
echo "bobby:bobbypassword" | chpasswd

# Configure sudoers
echo "Configuring sudoers..."
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Enable NetworkManager
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

EOF

echo "Base installation complete. You can now reboot into your new Arch Linux system."
```

**_Usage:_**

1. **Ensure Script Permissions:**

   ```bash
   chmod +x install.sh
   ```

2. **Run the Script:**

   From the live environment with partitions mounted (`/mnt`), execute:

   ```bash
   sudo ./install.sh
   ```

   *_Caution:_* *Replace `'rootpassword'` and `'bobbypassword'` with secure passwords. Adjust partition identifiers and other settings as necessary.*

### **2. `post_install.sh`**

**Purpose:** Automates post-installation configurations, including installing essential software, setting up the graphical environment, configuring power management, security enhancements, and installing AUR helpers `paru` and `yay`.

```bash
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

# Install AUR helper 'yay' (optional)
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

# Install Graphics Drivers
echo "Installing graphics drivers..."
# Choose based on your CPU:
# For AMD:
sudo pacman -S --noconfirm mesa-vulkan-radeon vulkan-radeon amd-ucode
# For Intel:
# sudo pacman -S --noconfirm mesa-vulkan-intel vulkan-intel intel-ucode

# Install OBS hardware encoding dependencies
echo "Installing OBS hardware encoding dependencies..."
sudo pacman -S --noconfirm vulkan-icd-loader radeontop
# For Intel systems, you might need additional packages:
# sudo pacman -S --noconfirm intel-gpu-tools

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

# Final Message
echo "Post-installation setup complete."
```

**_Usage:_**

1. **Ensure Script Permissions:**

   ```bash
   chmod +x post_install.sh
   ```

2. **Run the Script:**

   From your logged-in Arch Linux system:

   ```bash
   ./post_install.sh
   ```

   *This script will take some time to complete as it installs and configures numerous packages and services. Ensure you have a stable internet connection.*

**_Caution:_** *Review the script before execution, especially the sections related to graphics drivers. Choose the appropriate drivers based on your CPU (AMD or Intel) and comment out the sections that do not apply to your system to prevent conflicts.*

---

## 13. Documentation

Creating detailed Markdown documentation is essential for maintaining your setup and sharing it. Below is a template for your `README.md`. This template includes notes to customize configurations based on individual requirements.

### **`README.md`**

```markdown
# Optimized Dual-Boot Arch Linux Setup for Modern PCs

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Creating a Bootable Arch Linux USB Drive](#creating-a-bootable-arch-linux-usb-drive)
- [Disk Partitioning for Dual Boot](#disk-partitioning-for-dual-boot)
- [Base System Installation](#base-system-installation)
- [Post-Installation Configuration](#post-installation-configuration)
- [Installing Essential Software](#installing-essential-software)
- [Setting Up the Graphical Environment](#setting-up-the-graphical-environment)
- [Security Enhancements](#security-enhancements)
- [Power Management Optimizations](#power-management-optimizations)
- [Optimizing OBS for Hardware Encoding](#optimizing-obs-for-hardware-encoding)
- [Automation Scripts](#automation-scripts)
- [Troubleshooting](#troubleshooting)
- [Additional Tips](#additional-tips)
- [License](#license)

## Introduction

This repository provides scripts and documentation for setting up an optimized Arch Linux environment tailored for modern PCs with dual-boot capability alongside Windows. It includes configurations for both **AMD** and **Intel** processors, ensuring flexibility and broad compatibility.

## Prerequisites

- **Hardware:**
  - CPU: AMD Ryzen, Intel Core, or equivalent modern processor.
  - RAM: 16GB.
  - Storage: 512GB NVMe SSD (adjust according to your system's storage capacity).
  - Existing Windows installation on the NVMe SSD.
  - **USB Drive:** At least 8GB for Arch Linux installation media.

- **Software:**
  - Another computer with internet access to create the bootable USB.
  - Stable internet connection.

- **Knowledge:**
  - Basic familiarity with Linux command-line operations.
  - Understanding of dual-boot systems and partitioning.

- **Caution:**
  - **Backup Important Data:** Always back up critical data before modifying disk partitions to prevent data loss.

## Creating a Bootable Arch Linux USB Drive

Follow the instructions in [Section 3](#3-creating-a-bootable-arch-linux-usb-drive) to create a bootable Arch Linux USB drive using `curl` or `wget` and the `dd` command.

> **_Note:_** *Ensure you replace device identifiers (e.g., `/dev/sdX`) with those specific to your system to avoid overwriting important data.*

## Disk Partitioning for Dual Boot

Refer to [Section 4](#4-disk-partitioning-for-dual-boot) for detailed steps on partitioning your NVMe SSD to accommodate both Windows and Arch Linux.

> **_Note:_** *Adjust partition sizes and identifiers according to your specific hardware setup.*

## Base System Installation

Follow the steps outlined in [Section 5](#5-base-system-installation) to install the base Arch Linux system.

## Post-Installation Configuration

After installation, set up your user environment and essential configurations by following [Section 6](#6-post-installation-configuration).

## Installing Essential Software

Install additional applications to enhance your system's functionality as detailed in [Section 7](#7-installing-essential-software).

## Setting Up the Graphical Environment

Configure the graphical environment using Hyprland as described in [Section 8](#8-setting-up-the-graphical-environment).

## Security Enhancements

Enhance system security by setting up a firewall and other best practices in [Section 9](#9-security-enhancements).

## Power Management Optimizations

Optimize power consumption and improve system efficiency by following [Section 10](#10-power-management-optimizations).

## Optimizing OBS for Hardware Encoding

Leverage your CPU's integrated GPU for hardware encoding in OBS Studio for efficient streaming and recording as outlined in [Section 11](#11-optimizing-obs-for-hardware-encoding).

## Automation Scripts

Automate the installation and configuration process using the provided scripts:

- **`install.sh`**: Automates base installation.
- **`post_install.sh`**: Automates user environment setup, software installation, graphical environment configuration, and optimizations.

### **_Usage:_**

1. **Ensure Scripts are Executable:**

   ```bash
   chmod +x install.sh post_install.sh
   ```

2. **Run `install.sh` from the Live Environment:**

   ```bash
   sudo ./install.sh
   ```

3. **After Reboot, Log In as `bobby` and Run `post_install.sh`:**

   ```bash
   ./post_install.sh
   ```

> **_Caution:_** *Review the scripts before execution, especially sections related to graphics drivers. Ensure you uncomment and modify parts relevant to your hardware to prevent conflicts.*

## Troubleshooting

During installation or post-installation, you may encounter issues. Below are some common problems and their solutions.

### 1. **Bootloader Issues (Cannot Boot into Windows or Arch):**

- **Solution:**
  - Verify `loader.conf` and entries in `/boot/loader/entries/`.
  - Ensure Windows entry points to the correct EFI file.
  - Reinstall `systemd-boot` if necessary.

### 2. **NetworkManager Not Starting:**

- **Solution:**
  - Ensure NetworkManager is enabled.
  
    ```bash
    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
    ```

### 3. **Display Issues with Hyprland:**

- **Solution:**
  - Check `hyprland.conf` for correct monitor identifiers.
  - Verify that monitor layout scripts are executable.
  - Use `hyprctl monitors` to list active monitors.

### 4. **OBS Hardware Encoding Not Working:**

- **Solution:**
  - Ensure hardware drivers and Vulkan support are correctly installed.
  - Verify that OBS is set to use the correct hardware encoder (`AMF` for AMD or `Quick Sync Video` for Intel).
  - Check GPU usage with `radeontop` or `intel_gpu_top` to ensure encoding is active.

### 5. **Permission Denied Errors:**

- **Solution:**
  - Ensure your user is in the necessary groups.
  - Verify sudo privileges are correctly configured in `/etc/sudoers`.

## Additional Tips

- **Regular Backups:**
  - Use tools like `rsync`, `Timeshift`, or `Deja Dup` to regularly back up your system configurations and important data.

- **System Monitoring:**
  - Install monitoring tools such as `htop`, `glances`, or `bmon` to keep an eye on system resources.
  
    ```bash
    sudo pacman -S --noconfirm htop glances bmon
    ```

- **Customization:**
  - Explore and customize your `.zshrc`, `.vimrc`, and Hyprland configuration files to better fit your workflow.

- **Learning Resources:**
  - Explore the [Arch Wiki](https://wiki.archlinux.org/) extensively. It's one of the most comprehensive Linux documentation resources available.

- **Community Support:**
  - Join forums like the [Arch Linux Forums](https://bbs.archlinux.org/) or [Reddit's r/archlinux](https://www.reddit.com/r/archlinux/) for community support and discussions.

- **AUR Packages:**
  - Utilize `paru` or `yay` to install additional software from the Arch User Repository (AUR).

    ```bash
    paru -S <package-name>
    # or
    yay -S <package-name>
    ```

- **Regular Updates:**
  - Keep your system updated to benefit from the latest features and security patches.
  
    ```bash
    sudo pacman -Syu
    ```

- **Backup Configurations:**
  - Regularly back up your configuration files to prevent loss during updates or system changes.

---

## 17. License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

# **Summary**

You've now set up a **highly optimized dual-boot Arch Linux** environment tailored to your PC's specifications and personal preferences. This setup includes efficient power management, enhanced security, streamlined software installations, and optimized configurations for streaming and recording with OBS Studio using hardware encoding capabilities.

By leveraging **automation scripts** and detailed **Markdown documentation**, future maintenance and updates will be straightforward. Remember to regularly update your system and review configurations to ensure optimal performance and security.

Feel free to customize further based on evolving needs. **Happy Arching!**

---

# **Final Notes**

- **Customization is Key:** *This guide serves as a template. Always adjust configurations, partition sizes, and software selections based on your specific hardware and personal requirements.*

- **Stay Informed:** *Regularly consult the [Arch Wiki](https://wiki.archlinux.org/) for the latest information and best practices.*

- **Community Engagement:** *Engage with the Arch Linux community for support, ideas, and troubleshooting assistance.*

---

If you have any further questions or need additional assistance, feel free to ask. Happy computing!
