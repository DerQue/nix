#!/usr/bin/env bash

GITHUB_USER="DerQue"
REPO_NAME="nix"
CONFIG_NAME="$(hostname -s)"

set -e

echo "🚀 Starte nix-darwin Installation direkt via GitHub..."
echo "----------------------------------------------------"

if ! command -v nix &> /dev/null; then
    echo "⚠️ Nix ist nicht installiert. Starte den offiziellen Installer..."
    echo "🔑 (Du wirst möglicherweise nach deinem Mac-Passwort gefragt)"
    
    # Offiziellen Nix-Installer ausführen
    sh <(curl -L https://nixos.org/nix/install)
    
    # Umgebungsvariablen für das aktuelle Skript laden, damit 'nix' sofort verfügbar ist
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi

    # Sicherheitsprüfung, ob die Installation geklappt hat
    if ! command -v nix &> /dev/null; then
        echo "❌ Die Nix-Installation scheint fehlgeschlagen zu sein oder erfordert einen Terminal-Neustart."
        echo "Bitte starte dein Terminal neu und führe das Skript noch einmal aus."
        exit 1
    fi
    echo "✅ Nix wurde erfolgreich installiert und geladen!"
else
    echo "✅ Nix ist bereits installiert."
fi

for file in /etc/bashrc /etc/zshrc; do
  # Prüfen, ob die Datei existiert und eine "echte" Datei ist (kein Nix-Symlink)
  if [ -f "$file" ] && [ ! -L "$file" ]; then
    # Prüfen, ob nicht schon ein Backup von einem früheren Versuch existiert
    if [ ! -e "${file}.before-nix-darwin" ]; then
      sudo mv "$file" "${file}.before-nix-darwin"
      echo "✅ $file wurde erfolgreich umbenannt."
    else
      echo "⚠️ $file übersprungen: Die Datei ${file}.before-nix-darwin existiert bereits!"
    fi
  else
    echo "ℹ️ $file übersprungen: Existiert nicht oder ist bereits ein Nix-Symlink."
  fi
done

echo "----------------------------------------------------"
echo "⚙️ Lade und wende Konfiguration an von: github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}"
echo "Das kann beim ersten Mal einen Moment dauern..."

sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake "github:${GITHUB_USER}/${REPO_NAME}#${CONFIG_NAME}" --refresh

echo "----------------------------------------------------"
echo "🎉 Setup komplett erfolgreich abgeschlossen!"
echo "Dein System wurde konfiguriert und 'darwin-rebuild' ist nun installiert."
