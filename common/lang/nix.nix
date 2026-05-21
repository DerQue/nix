{ pkgs, user, ... }:

{
  environment.systemPackages = [ pkgs.nixfmt ];

  home-manager.users.${user} = {
    programs.nixvim = {
      plugins.lsp.servers.nixd.enable = true;

      plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
    };
  };
}
