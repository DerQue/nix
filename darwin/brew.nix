{ ... }:
{
  homebrew = {
    enable = true;

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = [ "--force" ];

    casks = [
      "anki"
      "docker"
      "whatsapp"
    ];
  };
}
