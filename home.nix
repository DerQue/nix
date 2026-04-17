{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "quentin";
  home.homeDirectory = "/Users/quentin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    
    shellAliases = {
      ll = "ls -la";
      update = "darwin-rebuild switch --flake ~/.dotfiles#macbook"; # Passe den Pfad an
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true; 
    
    settings = {
      add_newline = true;
      #env = {
      #  TERM = "xterm-256color";
      #};
      # Hier kannst du deine komplette starship.toml Logik abbilden
      #terminal.shell = {
      #  program = "${pkgs.fish}/bin/fish";
      #  args = [ "--login" ];
      #};
    };
  };

  programs.alacritty = {
    enable = true;
    
    settings = {
      # Hier kannst du deine komplette starship.toml Logik abbilden
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [ "--login" ];
      };

      window = {
        padding = { x = 10; y = 10; };
        decorations = "buttonless";
        dynamic_padding = true;
      };

      font = {
        normal = { family = "FiraCode Nerd Font"; style = "Regular"; };
        size = 14.0;
      };
      
      # Optional: macOS-Tastenkürzel explizit mappen (cmd+c, cmd+v, etc.)
      keyboard.bindings = [
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
      ];
    };
  };
  programs.neovim = {
  	enable = true;
  	defaultEditor = true;
  
  # Plugins über Nix installieren
  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    telescope-nvim
    nvim-treesitter.withAllGrammars
  ];

  # Deine Lua-Konfiguration einbinden
  extraLuaConfig = ''
  require('lspconfig').nil_ls.setup{}
  '';

  # Abhängigkeiten (wie Compiler oder Suchtools) bereitstellen
  extraPackages = with pkgs; [
   ripgrep
    fd
    lua-language-server
  ];
};
}
