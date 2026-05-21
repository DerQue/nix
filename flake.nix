{
  description = "Nix configuration for macOS and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      stylix,
      nixvim,
      disko,
      agenix,
      ...
    }@inputs:
    let
      sharedArgs = {
        inherit inputs;
        user = "quentin";
        name = "Quentin";
        surname = "Schuster";
        email = "me@quentin-schuster.de";
      };

      darwinConfiguration =
        { user, ... }:
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ];
          home-manager.users.${user} = {
            home.username = user;
            home.homeDirectory = "/Users/${user}";
            home.stateVersion = "25.11";
            programs.home-manager.enable = true;
          };

          users.users.${user} = {
            name = user;
            uid = 501;
            home = "/Users/${user}";
          };
          users.knownUsers = [ user ];
          system.primaryUser = user;
        };
    in
    {
      darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
        specialArgs = sharedArgs;

        modules = [
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
          agenix.darwinModules.default

          darwinConfiguration

          # common
          ./common/utils.nix
          ./common/dev.nix
          ./common/stylix.nix
          ./common/terminal.nix
          ./common/editor/neovim.nix
          ./common/apps/browser.nix
          ./common/apps/mail.nix
          ./common/apps/discord.nix
          ./common/apps/vscode.nix
          ./common/lang/nix.nix
          ./common/lang/typst.nix
          ./common/lang/haskell.nix
          ./common/lang/vhdl.nix

          # darwin-specific
          ./darwin/terminal.nix
          ./hosts/macbook/wireguard.nix
          ./darwin/dock.nix
          ./darwin/brew.nix
        ];
      };

      nixosConfigurations.gaming = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = sharedArgs;

        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          agenix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ];
          }

          # common
          ./common/utils.nix
          ./common/dev.nix
          ./common/stylix.nix
          ./common/terminal.nix
          ./common/editor/neovim.nix
          ./common/apps/browser.nix
          ./common/apps/mail.nix
          ./common/apps/discord.nix
          ./common/apps/vscode.nix
          ./common/lang/nix.nix
          ./common/lang/typst.nix
          ./common/lang/haskell.nix
          ./common/lang/vhdl.nix

          # nixos-specific
          ./nixos/stylix.nix
          ./nixos/terminal.nix
          ./nixos/local.nix
          ./nixos/home-manager.nix
          ./nixos/hardware/nvidia.nix
          ./nixos/desktop/sddm.nix
          ./nixos/desktop/hyprland.nix
          ./nixos/desktop/cursor.nix
          ./nixos/games/minecraft.nix

          ./hosts/gaming/disk.nix
          ./hosts/gaming/hardware-configuration.nix
          ./hosts/gaming/default.nix
        ];
      };
    };
}
