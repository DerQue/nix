{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.nodejs
  ];
}
