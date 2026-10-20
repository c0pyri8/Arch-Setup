#!/bin/bash

echo "=== System Verification ==="

PACKAGES=(
    ark
    base-devel
    btop
    cool-retro-term
    curl
    dolphin
    fakeroot
    fastfetch
    ghostty
    git
    kio-admin
    steam
    vlc
    wget
    zram-generator
    caido-desktop
    google-chrome
    notepadqq
    signal-desktop
    spotify
    brave-origin-bin
)

for pkg in "${PACKAGES[@]}"; do
    if pacman -Q "$pkg" &> /dev/null; then
        echo -e "\033[0;32m[INSTALLED]\033[0m $pkg"
    else
        echo -e "\033[0;31m[MISSING]\033[0m   $pkg"
    fi
done

echo "=== Done ==="
