{
  pkgs,
  config,
  ...
}:

{
  home-manager.users.${config.userConfig.name} = {
    home.packages = [
      pkgs.discord
    ];
  };
}
