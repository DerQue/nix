{ user, ... }:
{
  home-manager.users.${user} = {
    programs.brave = {
      enable = true;

      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
    };
  };
}
