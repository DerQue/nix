{ config, ... }:
{
  home-manager.users.${config.userConfig.name} = {
    programs.thunderbird = {
      enable = true;
    };
  };
}
