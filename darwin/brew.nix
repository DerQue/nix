{ ... }:
{
  homebrew = {
    enable = true;

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
