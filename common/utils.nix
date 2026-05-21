{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    zip
    unzip
  ];
}
