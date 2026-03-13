{ config, pkgs, ... }:

{
  # Bootloader (Systemd-boot ist Standard für EFI-Systeme)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Netzwerk
  networking.hostName = "mein-pc"; # Muss mit dem Namen in der flake.nix übereinstimmen!
  networking.networkmanager.enable = true;

  # Zeit und Sprache
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Flakes systemweit aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # =========================================
  # HYPRLAND & WAYLAND SETUP
  # =========================================

  # Aktiviert Hyprland (setzt automatisch Wayland-Variablen)
  programs.hyprland.enable = true;

  # XWayland wird oft für ältere Apps (z.B. Spiele) gebraucht
  programs.xwayland.enable = true;

  # Ein Login-Manager (Display Manager). SDDM unterstützt Wayland sehr gut.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Polkit ist zwingend nötig, damit GUI-Apps (wie GParted) nach sudo-Rechten fragen können
  security.polkit.enable = true;

  # Basis-Pakete, die du in einer nackten Hyprland-Umgebung dringend brauchst
  environment.systemPackages = with pkgs; [
    kitty      # Das Standard-Terminal für Hyprland
    wofi       # Ein simpler App-Launcher (wie das Windows-Startmenü)
    waybar     # Eine Statusleiste für oben/unten
    dunst      # Für Desktop-Benachrichtigungen
    networkmanagerapplet # WLAN-Icon für die Taskleiste
    git
    nano
    wget
  ];

  # =========================================
  # BENUTZER SETUP
  # =========================================
  
  users.users.quentin = {
    isNormalUser = true;
    description = "Quentin";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    hashedPassword = "$6$IlJj8p4wR.otvdju$ZWE76.pmCo1HcqZHE4lBqaQpNkqgwmm2bxIve3QYdnjO5d4WqWSTocctNyGdRQQlYbyQnMizhxa3fFvVG1q5G/"; 
  };

  # Erlaube unfreie Software (z.B. für NVIDIA)
  nixpkgs.config.allowUnfree = true;

  # Diese Version sollte der entsprechen, mit der du ursprünglich installiert hast.
  # Bitte NICHT ändern, auch wenn du später Updates machst!
  system.stateVersion = "23.11"; 
}
