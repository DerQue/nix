{ pkgs, ... }:

{

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  stylix = {
    enable = true;

    base16Scheme = {
      base00 = "121c19";
      base01 = "1b2724";
      base02 = "25332f";
      base03 = "4c615a";

      base04 = "99b0a6";
      base05 = "e1eed2";
      base06 = "ecf6e3";
      base07 = "f5fbf0";

      base08 = "e57474";
      base09 = "e6987a";
      base0A = "e5c76b";
      base0B = "8ccf7e";
      base0C = "6cbfbf";
      base0D = "67b0e8";
      base0E = "c47fd5";
      base0F = "b3684f";
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
