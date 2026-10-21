#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Determine the absolute path of the repository root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CUSTOM_DIR="$REPO_DIR/Customization"
FONT_SRC="$CUSTOM_DIR/Fonts"
WALLPAPER_SRC="$CUSTOM_DIR/Wallpapers"

# Target system paths
FONT_DEST="/usr/share/fonts/custom"
WALLPAPER_DEST="/usr/share/backgrounds"

echo "==> Starting customization deployment..."

# 1. Deploy Fonts
if [ -d "$FONT_SRC" ]; then
    echo " -> Deploying fonts to $FONT_DEST..."
    sudo mkdir -p "$FONT_DEST"
    sudo cp -rf "$FONT_SRC"/* "$FONT_DEST"/
    
    # Set correct permissions
    sudo chmod 644 "$FONT_DEST"/*
    
    # Refresh Font Cache
    echo " -> Updating font cache..."
    sudo fc-cache -f -v > /dev/null
    echo " [+] Fonts deployed and cached successfully."
else
    echo " [!] Warning: $FONT_SRC directory not found."
fi

# 2. Deploy Wallpapers
if [ -d "$WALLPAPER_SRC" ]; then
    echo " -> Deploying wallpapers to $WALLPAPER_DEST..."
    sudo mkdir -p "$WALLPAPER_DEST"
    sudo cp -rf "$WALLPAPER_SRC"/* "$WALLPAPER_DEST"/
    
    # Set correct permissions (read for all)
    sudo chmod 644 "$WALLPAPER_DEST"/* 2>/dev/null || true
    echo " [+] Wallpapers deployed successfully."
else
    echo " [!] Warning: $WALLPAPER_SRC directory not found."
fi

echo "==> Deployment complete!"
