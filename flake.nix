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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, stylix }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile.
      environment.systemPackages =
        [ 
	  pkgs.neovim
	  pkgs.git

	  pkgs.alacritty
          pkgs.starship
          pkgs.fish
	  pkgs.ghc
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;
      programs.zsh.enable = false;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

            users.users.quentin = {
                name = "quentin"; 
		uid = 501;
                home = "/Users/quentin"; # Darwin weiß nun, wo das Home-Verzeichnis ist
                shell = pkgs.fish;
            };
		users.knownUsers = ["quentin"];


      fonts.packages = with pkgs; [
    	nerd-fonts.fira-code # Neue Syntax für Nerd Fonts
    	# Falls du eine ältere Nixpkgs-Version nutzt, stattdessen:
    	# (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      stylix.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    };
  in
  {
    darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
      modules = [ 
	configuration
	stylix.darwinModules.stylix
	home-manager.darwinModules.home-manager
	{
#	    users.users.quentin = {
#   		name = "quentin";
#    		home = "/Users/quentin"; # Darwin weiß nun, wo das Home-Verzeichnis ist
#		shell = pkgs.fish;
#  	    };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.quentin = ./home.nix;
        }	 
      ];
    };
  };
}
