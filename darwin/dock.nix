{ user, ... }:
{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    launchanim = false;
    orientation = "bottom";
    tilesize = 48;

    persistent-apps = [
      "/Users/${user}/Applications/Home Manager Apps/Alacritty.app"
      "/Users/${user}/Applications/Home Manager Apps/Brave Browser.app"
      "/Users/${user}/Applications/Home Manager Apps/Discord.app"
    ];
  };
}
