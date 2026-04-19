{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      stylix,
      nixvim,
      ...
    }:
    let
      configuration =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          options = {
            userConfig.name = lib.mkOption {
              type = lib.types.str;
            };

            userConfig.home = lib.mkOption {
              type = lib.types.str;
            };

            userConfig.uid = lib.mkOption {
              type = lib.types.int;
            };
          };

          config = {
            environment.systemPackages = [
              pkgs.neovim
              pkgs.git
              pkgs.nixfmt
            ];

            nix.settings.experimental-features = "nix-command flakes";
            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.stateVersion = 6;
            nixpkgs.hostPlatform = "aarch64-darwin";
            nixpkgs.config.allowUnfree = true;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${config.userConfig.name} = {
              
    imports = [ nixvim.homeManagerModules.nixvim ];
	      home.username = config.userConfig.name;
              home.homeDirectory = config.userConfig.home;
              home.stateVersion = "25.11";
              programs.home-manager.enable = true;
            };

            users.users.${config.userConfig.name} = {
              name = config.userConfig.name;
              uid = config.userConfig.uid;
              home = config.userConfig.home;
            };
            users.knownUsers = [ config.userConfig.name ];
          };

        };
    in
    {
      darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
	  
          configuration
          {
            userConfig.name = "quentin";
            userConfig.home = "/Users/quentin";
            userConfig.uid = 501;
          }

          ./modules/stylix.nix
          ./modules/terminal.nix
          ./modules/editor/neovim.nix
          ./modules/social.nix
        ];
      };
    };
}
