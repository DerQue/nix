#!/usr/bin/env bash
set -e

# Run this from a NixOS live ISO after booting.
# The repo must be accessible at the current directory or cloned first.

GITHUB_USER="DerQue"
REPO_NAME="nix"
CONFIG_NAME="gaming"
DISK="/dev/nvme0n1"

echo "Setting up NixOS (gaming)..."

# Partition and format disk
echo "Partitioning $DISK with disko..."
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- \
    --mode disko \
    "github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}"

# Generate SSH host key so agenix secrets can be encrypted for this machine
echo "Generating SSH host key..."
sudo mkdir -p /mnt/etc/ssh
sudo ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""

echo ""
echo "Host public key:"
cat /mnt/etc/ssh/ssh_host_ed25519_key.pub
echo ""
echo "If this is a NEW machine, add the above key to secrets/secrets.nix"
echo "and re-encrypt gaming-password.age before continuing:"
echo ""
echo "  nix run github:ryantm/agenix -- -e secrets/gaming-password.age"
echo ""
read -p "Press Enter when secrets are ready..."

# Install NixOS
echo "Installing NixOS..."
sudo nixos-install --flake "github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}" --no-root-passwd

echo ""
echo "Done. Reboot into your new system."
echo "After reboot, restore your SSH key from Bitwarden to ~/.ssh/id_ed25519 (chmod 600)."
