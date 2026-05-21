{
  config,
  pkgs,
  ...
}:

let
  leafs-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves";
    themeConfig = {
      FormPosition = "left";
      Locale = "de-DE";
      CursorTheme = "macOS";

      Background = "${../../assets/wallpapers/green-mountains.jpg}";

      MainColor = "#${config.lib.stylix.colors.base0B}";
      AccentColor = "#${config.lib.stylix.colors.base0B}";
      BackgroundColor = "#${config.lib.stylix.colors.base00}";
      TextColor = "#${config.lib.stylix.colors.base07}";
      InputColor = "#${config.lib.stylix.colors.base01}";
      InputTextColor = "#${config.lib.stylix.colors.base07}";
    };
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ leafs-theme pkgs.apple-cursor ];
  };

  environment.systemPackages = with pkgs; [
    leafs-theme
    kdePackages.qtmultimedia
    kdePackages.qtsvg
  ];
}
