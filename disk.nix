{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Prüfe weiterhin, ob vda oder sda korrekt ist
        content = {
          type = "gpt";
          partitions = {
            
            # 1. Die Boot-Partition (Unverschlüsselt, zwingend für UEFI)
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };

            # 2. Die Swap-Partition (Zufällig verschlüsselt)
            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true; # Wird bei jedem Boot neu & zufällig verschlüsselt
                # Hinweis: Da der Key zufällig ist, funktioniert hier kein "Suspend-to-Disk" (Ruhezustand).
                # Für eine VM ist das aber in der Regel völlig egal.
              };
            };

            # 3. Die verschlüsselte LUKS-Partition
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted"; # Name des geöffneten Laufwerks (/dev/mapper/crypted)
                settings = {
                  allowDiscards = true; # Wichtig für SSDs/VMs (leitet TRIM-Befehle weiter)
                };
                
                # BTRFS liegt *innerhalb* der verschlüsselten Partition
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  
                  subvolumes = {
                    # Das Root-System. Bei Impermanence ist das ein Wegwerf-Verzeichnis.
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    
                    # Der Nix-Store. MUSS persistent sein, sonst baut die VM bei jedem Boot alles neu!
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    
                    # Hierhin werden alle wichtigen Daten durch das Impermanence-Modul gelinkt.
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
