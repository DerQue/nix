{ user, ... }:

{
  home-manager.users.${user} = {
    programs.alacritty.settings = {
      window.decorations = "transparent";

      keyboard.bindings = [
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
      ];
    };

    programs.fish.shellAliases = {
      update = "darwin-rebuild switch --flake ~/.nix#macbookpro";
    };
  };
}
