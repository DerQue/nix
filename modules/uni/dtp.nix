{ pkgs, config, ... }:
{
  homebrew = {
    casks = [
      "ghdl"
    ];
  };

  home-manager.users.${config.userConfig.name} = {
    programs.nixvim = {
      plugins = {
        lsp.servers = {
          vhdl_ls = {
            enable = true;
          };
        };

        treesitter = {
          settings = {
            ensure_installed = [ "vhdl" ];
            highlight.enable = true;
          };
        };
      };
    };
  };
}
