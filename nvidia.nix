{ config, lib, pkgs, ... }:

{
  # 1. Erlaube unfreie Pakete für dieses System
  nixpkgs.config.allowUnfree = true;

  # 2. Aktiviere grundlegende Grafik-APIs (OpenGL/Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Wichtig für viele Spiele (z.B. über Steam oder Wine)
  };

  # 3. Teile X11 und Wayland mit, dass sie NVIDIA nutzen sollen
  services.xserver.videoDrivers = [ "nvidia" ];

  # 4. Spezifische NVIDIA-Einstellungen
  hardware.nvidia = {
    # Modesetting ist heutzutage quasi Pflicht, besonders wenn du Wayland nutzen willst
    modesetting.enable = true;

    # Power-Management (experimentell). Hilft manchmal, wenn der PC aus dem Standby nicht richtig aufwacht.
    # Lass es erstmal auf false, außer du hast Probleme beim Suspend/Resume.
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # NVIDIA bietet mittlerweile einen Open-Source-Kernel-Treiber an.
    # Wenn du eine moderne Karte (Turing-Architektur, also RTX 2000 oder neuer) hast, 
    # kannst du das auf 'true' setzen. Ansonsten lass es auf 'false'.
    open = false;

    # Installiert das grafische Konfigurationstool "NVIDIA Settings"
    nvidiaSettings = true;

    # Wähle die Treiber-Version. 'stable' ist meistens die beste Wahl.
    # Alternativen: 'latest', 'beta', oder 'production'.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
