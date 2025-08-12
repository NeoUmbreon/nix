{
  description = "Home Manager configuration of dawn";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ADD THIS:
    nyx.url = "github:Peritia-System/Nyx-Tools";
  };

  outputs = { nixpkgs, home-manager, nyx, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."dawn" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];

        # So `home.nix` can use `inputs.nyx`
        extraSpecialArgs = { inherit nyx; };
      };
    };
}

