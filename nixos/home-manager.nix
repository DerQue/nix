{ user, ... }:

{
  home-manager.users.${user} = {
    home.username = user;
    home.homeDirectory = "/home/${user}";
    home.stateVersion = "25.11";

    programs.home-manager.enable = true;
  };
}
