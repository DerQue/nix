{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.jetbrains.idea
    pkgs.jetbrains-toolbox
  ];
}
