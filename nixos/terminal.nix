{ user, ... }:

{
  home-manager.users.${user} = {
    programs.fish.shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.nix#gaming";
    };
  };
}
