{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  home-manager.users.${user} = {
    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        input {
            kb_layout = de
            follow_mouse = 1
            touchpad {
                natural_scroll = no
            }
        }
      '';

      settings = {
        "$mod" = "SUPER";

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0B}ee) rgba(${config.lib.stylix.colors.base0D}ee) 45deg";
          "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base02}aa)";
        };

        workspace = [
          "w[t1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        bind =
          [
            "$mod, Q, exec, alacritty"
            "$mod, C, killactive"
            "$mod, M, exit"
            "$mod, F, exec, brave"
          ]
          ++ (
            builtins.concatLists (builtins.genList (
                x:
                let
                  ws =
                    let
                      c = (x + 1) / 10;
                    in
                    builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
      };
    };
  };
}
