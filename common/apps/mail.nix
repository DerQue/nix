{ user, ... }:
{
  home-manager.users.${user} = {
    programs.thunderbird = {
      enable = true;
    };
  };
}
