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
    LC_TIME = "de_DE.UTF-8";
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    grimblast
    wofi
    dunst
    libnotify
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
          gaps_in = 8;
          gaps_out = 16;
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0B}ee)";
          "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base02}aa)";
        };

        decoration = {
          rounding = 16;
          blur = {
            enabled = true;
            size = 6;
            passes = 3;
          };
          shadow = {
            enabled = true;
            range = 12;
            color = lib.mkForce "rgba(${config.lib.stylix.colors.base00}cc)";
          };
        };

        animations = {
          enabled = true;
          bezier = "ease, 0.25, 0.1, 0.25, 1";
          animation = [
            "windows, 1, 3, ease, slide"
            "fade, 1, 3, ease"
            "workspaces, 1, 4, ease, slide"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        workspace = [ ];

        exec-once = [
          "dunst"
          "waybar"
          "steam"
          "discord"
        ];

        bind = [
          "$mod, Q, exec, alacritty"
          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, F, exec, brave"
          "$mod, R, exec, wofi --show run"
          "$mod, V, togglefloating"
          "$mod, P, pseudo"
          "$mod SHIFT, S, exec, grimblast copy area"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
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
          ) 10
        ));

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
