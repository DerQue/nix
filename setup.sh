#!/usr/bin/env bash
set -e

GITHUB_USER="DerQue"
REPO_NAME="nix"
CONFIG_NAME="$(hostname -s)"

echo "Setting up macOS (nix-darwin)..."

# Install Nix if missing
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install)
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    if ! command -v nix &> /dev/null; then
        echo "Nix installation failed. Restart your terminal and re-run."
        exit 1
    fi
fi

# Backup shell files that conflict with nix-darwin
for file in /etc/bashrc /etc/zshrc; do
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        if [ ! -e "${file}.before-nix-darwin" ]; then
            sudo mv "$file" "${file}.before-nix-darwin"
        fi
    fi
done

# Restore SSH key before applying config (needed for agenix)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo ""
    echo "SSH private key not found at ~/.ssh/id_ed25519"
    echo "Restore it from Bitwarden before continuing, then re-run this script."
    echo ""
    echo "  mkdir -p ~/.ssh && chmod 700 ~/.ssh"
    echo "  # paste key into ~/.ssh/id_ed25519"
    echo "  chmod 600 ~/.ssh/id_ed25519"
    exit 1
fi

echo "Applying configuration from github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}..."
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch \
    --flake "github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}" \
    --refresh

echo "Done. Run 'update' to apply future changes."
