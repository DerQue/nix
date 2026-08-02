{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  home-manager.users.${user} = {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          spacing = 4;
          margin-top = 8;
          margin-left = 8;
          margin-right = 8;
          margin-bottom = -8;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "cpu"
            "memory"
            "pulseaudio"
            "network"
            "tray"
          ];

          "hyprland/workspaces" = {
            format = "{id}";
            on-click = "activate";
          };

          "hyprland/window" = {
            max-length = 60;
          };

          clock = {
            locale = "de_DE.UTF-8";
            format = "{:%a, %d. %b %H:%M}";
            tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          };

          cpu = {
            format = "󰻠 {usage}%";
            interval = 5;
          };

          memory = {
            format = "󰍛 {percentage}%";
            interval = 10;
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 muted";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          };

          network = {
            format-wifi = "󰤨 {essid}";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "󰤭 offline";
            tooltip-format = "{ipAddr}  {bandwidthUpBits}  {bandwidthDownBits}";
          };

          tray = {
            spacing = 8;
          };
        };
      };

      style = lib.mkForce ''
        * {
          font-family: "JetBrainsMono Nerd Font Mono";
          font-size: 13px;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background-color: transparent;
          color: #${config.lib.stylix.colors.base05};
        }

        .modules-left,
        .modules-center,
        .modules-right {
          margin: 6px 8px;
        }

        /* workspaces pill */
        #workspaces {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 9999px;
          padding: 4px 6px;
        }

        #workspaces button {
          padding: 2px 10px;
          margin: 2px 2px;
          color: #${config.lib.stylix.colors.base04};
          background-color: transparent;
          border-radius: 9999px;
        }

        #workspaces button:hover {
          background-color: #${config.lib.stylix.colors.base03};
          color: #${config.lib.stylix.colors.base07};
        }

        #workspaces button.active {
          background-color: #${config.lib.stylix.colors.base0B};
          color: #${config.lib.stylix.colors.base00};
          font-weight: bold;
        }

        #workspaces button.urgent {
          background-color: #${config.lib.stylix.colors.base08};
          color: #${config.lib.stylix.colors.base00};
        }

        /* window pill */
        #window {
          background-color: #${config.lib.stylix.colors.base02};
          color: #${config.lib.stylix.colors.base05};
          border-radius: 9999px;
          padding: 2px 14px;
          margin-left: 8px;
        }

        /* clock pill */
        #clock {
          background-color: #${config.lib.stylix.colors.base02};
          color: #${config.lib.stylix.colors.base07};
          font-weight: bold;
          border-radius: 9999px;
          padding: 2px 16px;
        }

        /* right-side pills */
        #cpu,
        #memory,
        #pulseaudio,
        #network,
        #tray {
          background-color: #${config.lib.stylix.colors.base02};
          border-radius: 9999px;
          padding: 2px 14px;
          margin-left: 6px;
        }

        #cpu {
          color: #${config.lib.stylix.colors.base0B};
        }

        #memory {
          color: #${config.lib.stylix.colors.base0C};
        }

        #pulseaudio {
          color: #${config.lib.stylix.colors.base0E};
        }

        #pulseaudio.muted {
          color: #${config.lib.stylix.colors.base03};
        }

        #network {
          color: #${config.lib.stylix.colors.base0D};
        }

        #network.disconnected {
          color: #${config.lib.stylix.colors.base08};
        }

        #tray {
          padding: 6px;
        }
      '';
    };
  };
}
