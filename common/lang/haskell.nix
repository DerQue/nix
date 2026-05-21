{ pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
    ghc
    ormolu
  ];

  home-manager.users.${user} = {
    programs.nixvim = {
      plugins.lsp.servers.hls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.haskell = [ "ormolu" ];
    };
  };
}
