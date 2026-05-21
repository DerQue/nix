{
  config,
  pkgs,
  lib,
  ...
}:
{
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  home-manager.users.${config.userConfig.name} = {
    programs.sketchybar = {
      enable = true;

      service = {
        enable = true;
      };

      extraPackages = with pkgs; [
        jq # JSON parsing
      ];

      configType = "bash";

      config.text = ''
        # ==========================================================
        #  Sketchybar Hauptkonfiguration
        #  Farben: Catppuccin Macchiato
        # ==========================================================

        PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

        # ------ Farben -------------------------------------------
        BG="0xff${config.lib.stylix.colors.base00}"
        SURFACE="0xff${config.lib.stylix.colors.base01}"
        OVERLAY="0xff${config.lib.stylix.colors.base02}"
        TEXT="0xff${config.lib.stylix.colors.base04}"
        SUBTEXT="0xff${config.lib.stylix.colors.base03}"
        BLUE="0xff${config.lib.stylix.colors.base0D}"
        GREEN="0xff${config.lib.stylix.colors.base0B}"
        RED="0xff${config.lib.stylix.colors.base08}"
        YELLOW="0xff${config.lib.stylix.colors.base0A}"
        MAUVE="0xff${config.lib.stylix.colors.base0E}"
        TEAL="0xff${config.lib.stylix.colors.base0C}"
        TRANSP="0x00000000"

        # ------ Bar -----------------------------------------------
        sketchybar --bar             \
          height=36                  \
          position=top               \
          topmost=window             \
          sticky=on                  \
          y_offset=8 \
          padding_left=8             \
          padding_right=8            \
          color=$TRANSP                  \
          border_width=1             \
          border_color=$TRANSP      \
          shadow=off                 \
          notch_width=0

        # ------ Defaults ------------------------------------------
        sketchybar --default                      \
          icon.font="SF Pro:Bold:13.0"            \
          icon.color=$TEXT                        \
          icon.padding_left=6                     \
          icon.padding_right=4                    \
          label.font="SF Pro:Semibold:13.0"       \
          label.color=$TEXT                       \
          label.padding_left=4                    \
          label.padding_right=8                   \
          background.height=28                    \
          background.corner_radius=8              \
          background.border_width=1               \
          background.border_color=$OVERLAY        \
          background.color=$TRANSP                \
          padding_left=4                          \
          padding_right=4

        # ==========================================================
        #  LINKS: AeroSpace Workspaces
        # ==========================================================
        for i in $(seq 1 9); do
          sketchybar --add item "space.$i" left                    \
            --set "space.$i"                                       \
              icon="$i"                                            \
              icon.font="SF Pro:Bold:12.0"                         \
              icon.color=$OVERLAY                                  \
              icon.padding_left=9                                  \
              icon.padding_right=9                                 \
              label.drawing=off                                    \
              background.color=$TRANSP                             \
              background.border_color=$TRANSP                      \
              background.height=24                                 \
              background.corner_radius=6                           \
              click_script="aerospace workspace $i"                \
            --subscribe "space.$i" aerospace_workspace_change
        done

        sketchybar --add bracket spaces_bracket                    \
          space.1 space.2 space.3 space.4 space.5                  \
          space.6 space.7 space.8 space.9                          \
          --set spaces_bracket                                     \
            background.color=$SURFACE                              \
            background.border_color=$OVERLAY                       \
            background.border_width=1                              \
            background.corner_radius=8                             \
            background.height=30

        # ==========================================================
        #  MITTE: Aktive App
        # ==========================================================
        sketchybar                                                 \
          --add item front_app center                              \
          --set front_app                                          \
            icon.drawing=off                                       \
            label.font="SF Pro:Semibold:13.0"                      \
            label.color=$TEXT                                      \
            background.color=$TRANSP                               \
            background.border_color=$TRANSP                        \
            script="$PLUGIN_DIR/front_app.sh"                      \
          --subscribe front_app front_app_switched

        # ==========================================================
        #  RECHTS: CPU · WLAN · Akku · Uhr
        # ==========================================================

        # CPU
        sketchybar                                                 \
          --add item cpu right                                     \
          --set cpu                                                \
            update_freq=5                                          \
            icon="󰘚"                                               \
            icon.color=$TEAL                                       \
            background.color=$SURFACE                             \
            background.border_color=$OVERLAY                       \
            script="$PLUGIN_DIR/cpu.sh"

        # WLAN
        sketchybar                                                 \
          --add item wifi right                                    \
          --set wifi                                               \
            update_freq=30                                         \
            icon="󰤨"                                               \
            icon.color=$BLUE                                       \
            background.color=$SURFACE                             \
            background.border_color=$OVERLAY                       \
            script="$PLUGIN_DIR/wifi.sh"                           \
          --subscribe wifi wifi_change

        # Akku
        sketchybar                                                 \
          --add item battery right                                 \
          --set battery                                            \
            update_freq=60                                         \
            icon="󰁹"                                               \
            icon.color=$GREEN                                      \
            background.color=$SURFACE                             \
            background.border_color=$OVERLAY                       \
            script="$PLUGIN_DIR/battery.sh"                        \
          --subscribe battery power_source_change system_woke

        # Uhr
        sketchybar                                                 \
          --add item clock right                                   \
          --set clock                                              \
            update_freq=10                                         \
            icon="󰥔"                                               \
            icon.color=$MAUVE                                      \
            background.color=$SURFACE                             \
            background.border_color=$OVERLAY                       \
            script="$PLUGIN_DIR/clock.sh"

        # Rechte Gruppe
        sketchybar --add bracket right_bracket cpu wifi battery clock \
          --set right_bracket                                      \
            background.color=$TRANSP                             \
            background.border_color=$TRANSP                       \
            background.border_width=1                              \
            background.corner_radius=8                             \
            background.height=30

        sketchybar --update
      '';
    };

    programs.aerospace = {
      enable = true;
      launchd = {
        enable = true;
      };

      settings = {

        after-startup-command = [
          "exec-and-forget sketchybar --reload"
        ];

        automatically-unhide-macos-hidden-apps = true;

        # Sketchybar bei jedem Workspace-Wechsel benachrichtigen
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE"
        ];

        # --------------------------------------------------------
        # Gaps (outer.top = Barhöhe 36 + Abstand 8)
        # --------------------------------------------------------
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 52; # Sketchybar-Höhe (36px) + Abstand (8px)
          outer.right = 8;
        };

        # --------------------------------------------------------
        # Haupt-Keybindings
        # --------------------------------------------------------
        mode.main.binding = {
          # Fokus bewegen (Vim + Pfeiltasten)
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-left = "focus left";
          alt-down = "focus down";
          alt-up = "focus up";
          alt-right = "focus right";

          # Fenster verschieben
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-shift-left = "move left";
          alt-shift-down = "move down";
          alt-shift-up = "move up";
          alt-shift-right = "move right";

          # Größe ändern
          alt-ctrl-h = "resize width -50";
          alt-ctrl-l = "resize width +50";
          alt-ctrl-k = "resize height -50";
          alt-ctrl-j = "resize height +50";

          # Layout
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-f = "layout floating tiling";
          alt-shift-f = "fullscreen";

          # Splits
          alt-ctrl-v = "join-with right";
          alt-ctrl-b = "join-with down";

          # Workspaces wechseln
          alt-ctrl-1 = "workspace 1";
          alt-ctrl-2 = "workspace 2";
          alt-ctrl-3 = "workspace 3";
          alt-ctrl-4 = "workspace 4";
          alt-ctrl-5 = "workspace 5";
          alt-ctrl-6 = "workspace 6";
          alt-ctrl-7 = "workspace 7";
          alt-ctrl-8 = "workspace 8";
          alt-ctrl-9 = "workspace 9";

          # Fenster auf Workspace verschieben
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";

          # Monitor-Wechsel
          alt-tab = "focus-monitor next";
          alt-shift-tab = "move-node-to-monitor next";

          # Service-Modus
          alt-shift-semicolon = "mode service";
        };

        # --------------------------------------------------------
        # Service-Modus
        # --------------------------------------------------------
        mode.service.binding = {
          esc = "mode main";
          enter = "mode main";

          alt-shift-r = [
            "reload-config"
            "mode main"
          ];
          alt-shift-h = [
            "flatten-workspace-tree"
            "mode main"
          ];
          alt-shift-equal = [
            "balance-sizes"
            "mode main"
          ];
          alt-shift-f = [
            "layout floating tiling"
            "mode main"
          ];
        };

        # --------------------------------------------------------
        # Workspace-zu-Monitor Zuordnung
        # --------------------------------------------------------

        # --------------------------------------------------------
        # App-spezifische Regeln
        # --------------------------------------------------------
        on-window-detected = [
          {
            "if".app-id = "com.apple.finder";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.systempreferences";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.ActivityMonitor";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.calculator";
            run = "layout floating";
          }

          {
            "if".app-id = "org.mozilla.firefox";
            run = [ "move-node-to-workspace 1" ];
          }
          {
            "if".app-id = "com.mitchellh.ghostty";
            run = [ "move-node-to-workspace 2" ];
          }
          {
            "if".app-id = "com.microsoft.VSCode";
            run = [ "move-node-to-workspace 3" ];
          }
          {
            "if".app-id = "com.tinyspeck.slackmacgap";
            run = [ "move-node-to-workspace 9" ];
          }
          {
            "if".app-id = "com.hnc.Discord";
            run = [ "move-node-to-workspace 9" ];
          }
        ];
      };
    };

    xdg.configFile = {

      "sketchybar/plugins/aerospace.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          # Aufgerufen bei jedem Workspace-Wechsel durch AeroSpace
          # %1 = verlassener Workspace, %2 = neuer Workspace
          # → beide Workspaces neu zeichnen
          update_space() {
            local WS="$1"
            local FOCUSED
            FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
            WINDOWS=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')

            if [ "$WS" = "$FOCUSED" ]; then
              sketchybar --set "space.$WS" \
                background.color="0xff8aadf4"        \
                background.border_color="0xff8aadf4" \
                icon.color="0xff24273a"
            elif [ "$WINDOWS" -gt 0 ]; then
              sketchybar --set "space.$WS" \
                background.color="0xff363a4f"        \
                background.border_color="0xff494d64" \
                icon.color="0xffcad3f5"
            else
              sketchybar --set "space.$WS" \
                background.color="0x00000000"        \
                background.border_color="0x00000000" \
                icon.color="0xff494d64"
            fi
          }

          update_space "$1"
          update_space "$2"
        '';
      };

      "sketchybar/plugins/front_app.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          sketchybar --set "$NAME" label="$INFO"
        '';
      };

      "sketchybar/plugins/battery.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
          CHARGING=$(pmset -g batt | grep 'AC Power')

          [ -z "$PERCENTAGE" ] && exit 0

          if [ -n "$CHARGING" ]; then
            ICON="󰂄"; COLOR="0xffa6da95"
          elif [ "$PERCENTAGE" -gt 80 ]; then
            ICON="󰁹"; COLOR="0xffa6da95"
          elif [ "$PERCENTAGE" -gt 60 ]; then
            ICON="󰂀"; COLOR="0xffcad3f5"
          elif [ "$PERCENTAGE" -gt 40 ]; then
            ICON="󰁾"; COLOR="0xffcad3f5"
          elif [ "$PERCENTAGE" -gt 20 ]; then
            ICON="󰁼"; COLOR="0xffeed49f"
          else
            ICON="󰁺"; COLOR="0xffed8796"
          fi

          sketchybar --set "$NAME" \
            icon="$ICON"           \
            icon.color="$COLOR"    \
            label="$PERCENTAGE%"
        '';
      };

      "sketchybar/plugins/wifi.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          WIFI=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I \
            | awk '/ SSID/ {print substr($0, index($0, $2))}')

          if [ -z "$WIFI" ] || [ "$WIFI" = "AirPort: Off" ]; then
            sketchybar --set "$NAME" \
              icon="󰤭"              \
              icon.color="0xffed8796" \
              label="Offline"
          else
            sketchybar --set "$NAME" \
              icon="󰤨"              \
              icon.color="0xff8aadf4" \
              label="$WIFI"
          fi
        '';
      };

      "sketchybar/plugins/clock.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          sketchybar --set "$NAME" label="$(date "+%d.%m.%Y %H:%M")"
        '';
      };

      "sketchybar/plugins/cpu.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
          CPU_INT=''${CPU%.*}

          if [ "$CPU_INT" -gt 80 ]; then
            COLOR="0xffed8796"
          elif [ "$CPU_INT" -gt 50 ]; then
            COLOR="0xffeed49f"
          else
            COLOR="0xff8bd5ca"
          fi

          sketchybar --set "$NAME" \
            icon.color="$COLOR"    \
            label="$CPU_INT%"
        '';
      };
    };
  };
}
