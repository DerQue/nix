# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Unified Nix configuration for macOS (nix-darwin, aarch64-darwin) and NixOS (x86_64-linux). Shared config lives in `common/` and is imported by both hosts. Platform-specific config lives in `darwin/` and `nixos/`. Host-specific config lives in `hosts/`.

Hosts:
- `macbookpro` — MacBook Pro, Apple Silicon
- `gaming` — NixOS desktop, AMD CPU + Nvidia GPU, Hyprland

## Applying Changes

**macOS:**
```bash
darwin-rebuild switch --flake ~/.nix#macbookpro
# aliased as: update
```

**NixOS:**
```bash
sudo nixos-rebuild switch --flake ~/.nix#gaming
# aliased as: update
```

**Fresh macOS install:** run `setup.sh`

**Fresh NixOS install:** run `setup-nixos.sh` from a live ISO

## Formatting

`nixfmt` — runs automatically on save via conform-nvim. Manual: `nixfmt <file>.nix`

## Architecture

`flake.nix` is the single entry point. Both hosts receive `user`, `name`, `surname`, `email` via `sharedArgs` (a shared `specialArgs` let binding). nixvim is loaded via `home-manager.sharedModules` in both configs. `darwinConfiguration` is a flat inline module with darwin-specific system settings (uid, home, stateVersion, etc.).

**Inputs:** `nixpkgs-unstable`, `nix-darwin`, `home-manager`, `stylix`, `nixvim`, `disko`, `agenix`

**Directory layout:**

```
common/
  stylix.nix          base16 dark-green scheme + fonts (shared, no wallpaper)
  terminal.nix        Alacritty, fish, starship (stylix-themed), tmux
  utils.nix           wget, zip, unzip
  dev.nix             git (with name/email), claude-code
  editor/
    neovim.nix        nixvim base: treesitter, LSP (lua/bash), telescope, cmp, autopairs
  apps/
    browser.nix       Brave + extensions (uBlock, Bitwarden, Vimium)
    discord.nix
    mail.nix          Thunderbird
    vscode.nix
  lang/
    nix.nix           nixfmt package, nixd LSP, conform-nvim formatter
    typst.nix         typst + tinymist LSP, typst-preview plugin, <leader>tp keymap
    haskell.nix       ghc, ormolu, hls LSP, ormolu formatter
    vhdl.nix          vhdl treesitter only (no LSP)

darwin/
  terminal.nix        transparent window, Command key bindings, update alias
  brew.nix            Homebrew (zap cleanup on activation)
  dock.nix            macOS Dock config (uses user arg for paths)

nixos/
  stylix.nix          sets stylix.image = assets/wallpapers/green-mountains.jpg
  terminal.nix        update alias for nixos-rebuild
  local.nix           locale: de_DE, Europe/Berlin
  home-manager.nix    home-manager user bootstrap
  hardware/
    nvidia.nix        Nvidia drivers (stable)
  desktop/
    hyprland.nix      Hyprland WM, keybindings, stylix border colors (mkForce)
    sddm.nix          SDDM login manager, astronaut/purple_leaves theme, stylix colors
    cursor.nix        macOS cursor theme for Wayland/X11
  games/
    minecraft.nix     prismlauncher, jdk17

hosts/
  macbook/
    wireguard.nix     VPN (wg0, qusch.dyndns64.de), private key via agenix
  gaming/
    default.nix       boot, networking, openssh hostKeys, user (password via agenix)
    hardware-configuration.nix  auto-generated (do not edit)
    disk.nix          disko: GPT, LUKS+btrfs, 8G swap on /dev/nvme0n1

secrets/
  secrets.nix         agenix key registry (public keys + access rules)
  gaming-password.age encrypted login password hash for gaming host
  macbook-wireguard.age encrypted WireGuard private key for macbook
  README.md           guide for managing secrets

assets/wallpapers/
  green-mountains.jpg wallpaper used by SDDM and stylix on NixOS
```

## Key Patterns

**Shared modules** use `user` from `specialArgs` for `home-manager.users.${user}`.

**Stylix:** `common/stylix.nix` sets scheme and fonts for both platforms. `nixos/stylix.nix` additionally sets the wallpaper. Colors available as `config.lib.stylix.colors.baseXX`. Use `lib.mkForce` when overriding values that stylix also sets (e.g. Hyprland border colors).

**Nixvim:** base config in `common/editor/neovim.nix`; language modules in `common/lang/` extend it by merging into `programs.nixvim.plugins`.

**Secrets (agenix):** secrets are age-encrypted with host SSH public keys. At boot they are decrypted to `/run/agenix/<name>` using `/etc/ssh/ssh_host_ed25519_key`. The host key is generated via `services.openssh.hostKeys` without running an SSH server. See `secrets/README.md` for full workflow.

**Bootstrap:** SSH private key must be restored from Bitwarden to `~/.ssh/id_ed25519` (chmod 600) before secrets can be encrypted/decrypted from the command line.
