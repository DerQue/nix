{
  config,
  pkgs,
  user,
  name,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gaming";
  networking.networkmanager.enable = true;

  services.openssh.hostKeys = [
    { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  age.secrets.gaming-password.file = ../../secrets/gaming-password.age;

  users.users.${user} = {
    isNormalUser = true;
    description = "${name}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    hashedPasswordFile = config.age.secrets.gaming-password.path;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";
}
