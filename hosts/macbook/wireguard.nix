{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  age.secrets.macbook-wireguard.file = ../../secrets/macbook-wireguard.age;

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.255.0.2/32" ];
      dns = [ "10.10.0.1" ];

      privateKeyFile = config.age.secrets.macbook-wireguard.path;

      peers = [
        {
          publicKey = "tyywSkk2XIjivlmyfXJecOAkLl6oHYC5wrmIHR8YrHw=";

          allowedIPs = [ "0.0.0.0/0" ];

          endpoint = "qusch.dyndns64.de:51820";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
