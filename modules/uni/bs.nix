{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.vscode
  ];
}
