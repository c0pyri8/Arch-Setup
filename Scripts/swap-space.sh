#!/bin/bash

# Exit immediately if an unhandled error occurs
set -e

echo "=================================================="
echo "          SETTING UP SWAP SPACE                   "
echo "=================================================="

# --------------------------------------------------
# 1. CONFIGURE ZRAM SWAP (2.5 GiB, zstd)
# --------------------------------------------------
echo "--> Configuring zram-generator (2.5GiB, zstd)..."
sudo mkdir -p /etc/systemd/zram-generator.conf.d

sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf.d/zram.conf
[zram0]
zram-size = 2560M
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF'

sudo systemctl daemon-reload
echo "--> ZRAM swap configured successfully!"

# --------------------------------------------------
# 2. CONFIGURE SSD SWAPFILE (7.5 GiB via DD)
# --------------------------------------------------
echo "--> Setting up 7.5 GiB SSD swapfile using dd..."

# Check if swapfile already exists
if [ -f /swapfile ]; then
    echo "--> /swapfile already exists. Skipping creation."
else
    echo "--> Allocating 7.5 GiB using dd (this may take a moment)..."
    sudo dd if=/dev/zero of=/swapfile bs=1M count=7685 status=progress
    
    echo "--> Setting secure permissions (600)..."
    sudo chmod 600 /swapfile
    
    echo "--> Formatting file as swap..."
    sudo mkswap /swapfile
    
    echo "--> Enabling swapfile..."
    sudo swapon /swapfile
    
    # Add to fstab if not already present
    if ! grep -q "/swapfile" /etc/fstab; then
        echo "--> Adding swapfile to /etc/fstab for persistence..."
        echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
    fi
    echo "--> SSD swapfile configured successfully!"
fi

echo -e "\n=================================================="
echo "        Swap Space Setup Complete!                "
echo "=================================================="
