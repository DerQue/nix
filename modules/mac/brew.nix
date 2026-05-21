{ ... }:
{
  homebrew = {
    enable = true;

    casks = [
      # "brave-browser"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
