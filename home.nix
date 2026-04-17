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
    
    nvim-cmp
    
    # Quellen für die Vorschläge
  cmp-nvim-lsp     # Vorschläge vom Language Server
  cmp-buffer       # Wörter aus der aktuellen Datei
  cmp-path         # Dateipfade
  
  # Snippets (wichtig, damit cmp funktioniert)
  luasnip
  cmp_luasnip
  ];

  # Deine Lua-Konfiguration einbinden
  initLua = ''
  -- Globales Highlighting für alle unterstützten Dateitypen
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    
    -- Prüfen, ob für diesen Dateityp ein Parser existiert
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    
    if has_parser then
      vim.treesitter.start(bufnr, lang)
    end
  end,
})

local lspconfig = require('lspconfig')

-- Server für Nix aktivieren
vim.lsp.enable('nixd')

-- Server für Haskell aktivieren
vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

-- Tipp: Standard-Keybindings für LSP (optional aber empfohlen)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- Go to Definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)       -- Dokumentation zeigen
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Umbenennen
  end,
})
  '';

  # Abhängigkeiten (wie Compiler oder Suchtools) bereitstellen
  extraPackages = with pkgs; [
   ripgrep
    fd
    lua-language-server
    nixd
    haskell-language-server
  ];
};
}
