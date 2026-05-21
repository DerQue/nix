{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.rustc
    pkgs.cargo
  ];

  home-manager.users.${config.userConfig.name} = {
    programs.nixvim = {
      plugins = {
        lsp.servers = {
          rust_analyzer = {
            enable = true;
          };
        };

        treesitter = {
          settings = {
            ensure_installed = [ "rust" ];
            highlight.enable = true;
          };
        };
      };
    };
  };
}
