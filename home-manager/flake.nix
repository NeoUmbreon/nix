{
  description = "NixOS Home Manager configuration flake";

  # Here, the source of Nixpkgs, Home Manager, and Plasma Manager is defined.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # Unstable
      #url = "github:nix-community/home-manager";

      # This line forces the input flake to use the same version of nixpkgs.
      # Otherwise HM can use a different version, which can cause package duplication.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      # These lines force plasma-manager to use the same version of nixpkgs.
      # Otherwise it can use a different version, which can cause package duplication.
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

        # Home configuration modules are specified here.
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

