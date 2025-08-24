{
  description = "Home Manager configuration of dawn";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # Unstable
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # 25.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      # Unstable
      #url = "github:nix-community/home-manager";
      # 25.05
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = { nixpkgs, home-manager, plasma-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."dawn" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          plasma-manager.homeManagerModules.plasma-manager

          ./home.nix 
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { };
      };
    };
}

