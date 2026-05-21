{ user, ... }:
{
  home-manager.users.${user} = {
    programs.nixvim = {
      plugins = {
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
