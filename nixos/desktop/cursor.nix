{ pkgs, user, ... }:

{
  environment.sessionVariables = {
    XCURSOR_THEME = "macOS";
    XCURSOR_SIZE = "24";
  };

  home-manager = {
    users.${user} = {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.apple-cursor;
        name = "macOS";
        size = 24;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "hyprctl setcursor macOS 24"
          ];
        };
      };
    };
  };
}
