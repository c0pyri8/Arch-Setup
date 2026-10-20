#!/bin/bash

# Exit immediately if an unhandled error occurs
set -e

# Function to prompt user with a Y/n question
prompt_yes_no() {
    local prompt_msg="$1"
    local response
    while true; do
        read -p "$prompt_msg [Y/n]: " response
        case "$response" in
            [Yy]* | "" ) return 0 ;; # Default to Yes
            [Nn]* ) return 1 ;;
            * ) echo "Please answer yes (y) or no (n)." ;;
        esac
    done
}

echo "=================================================="
echo "          STEP 1: PRE-YAY INSTALLATION           "
echo "=================================================="

# Refresh pacman database and update system
echo "--> Syncing databases and updating system..."
sudo pacman -Syu

# Base list of required pre-yay packages (sorted alphabetically)
PACMAN_PACKAGES=(
    ark
    base-devel
    btop
    curl
    fakeroot
    fastfetch
    git
    kio-admin
    steam
    vlc
    wget
    zram-generator
)

echo -e "\n--- Optional Software Selection ---"

if prompt_yes_no "Do you want to install cool-retro-term?"; then
    PACMAN_PACKAGES+=(cool-retro-term)
fi

if prompt_yes_no "Do you want to install Dolphin (KDE File Manager)?"; then
    PACMAN_PACKAGES+=(dolphin)
fi

if prompt_yes_no "Do you want to install Ghostty Terminal?"; then
    PACMAN_PACKAGES+=(ghostty)
fi

echo -e "\n--> Installing Pacman packages..."
sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"

echo -e "\n=================================================="
echo "            STEP 2: INSTALLING YAY               "
echo "=================================================="

if command -v yay &> /dev/null; then
    echo "--> Yay is already installed! Skipping build process."
else
    echo "--> Building yay from AUR..."
    YAY_BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR"
    
    pushd "$YAY_BUILD_DIR" > /dev/null
    makepkg -si
    popd > /dev/null
    
    rm -rf "$YAY_BUILD_DIR"
    echo "--> Yay successfully installed!"
fi

echo -e "\n=================================================="
echo "         STEP 3: POST-YAY INSTALLATION           "
echo "=================================================="

# List of post-yay AUR packages (sorted alphabetically)
AUR_PACKAGES=(
    caido-desktop
    google-chrome
    notepadqq
    signal-desktop
    spotify
)

echo "--> Installing AUR packages via yay..."
yay -S --needed "${AUR_PACKAGES[@]}"

echo "--> Installing Brave Origin..."
curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh

echo -e "\n=================================================="
echo "      All package installations complete!         "
echo "=================================================="
