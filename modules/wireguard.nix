{ pkgs, inputs, ... }:
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.255.0.2/32" ];
      dns = [ "10.10.0.1" ];

      privateKeyFile = "~/.keys/wg.key";

      peers = [
        {
          publicKey = "tyywSkk2XIjivlmyfXJecOAkLl6oHYC5wrmIHR8YrHw=";

          allowedIPs = [ "10.0.0.0/8" ];

          endpoint = "qusch.dyndns64.de:51820";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
