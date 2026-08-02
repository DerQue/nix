{ pkgs, user, name, surname, email, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    claude-code
  ];

  home-manager.users.${user} = {
    programs.git = {
      enable = true;
      userName = "${name} ${surname}";
      userEmail = "${email}";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
