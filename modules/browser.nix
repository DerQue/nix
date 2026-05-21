{ config, ... }:
{
  home-manager.users.${config.userConfig.name} = {
    programs.brave = {
      enable = true;

      commandLineArgs = [
        # "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];

      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden Passwortmanager
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
    };
  };
}
