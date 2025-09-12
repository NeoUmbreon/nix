{
  description = "Build environment for pokeprism old 2022 with RGBDS and other dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Define dependencies
        nativeBuildInputs = with pkgs; [
          gnumake
          gpp             # g++
          flex
          byacc
          git
          python3
          pkg-config
          libpng
          zlib libpng libjpeg fontconfig alsa-lib
          xorg.libX11 xorg.libXpm xorg.libXft
          xorg.libXinerama xorg.libXext xorg.libXrender xorg.libXfixes
        ];

        # You can also define rgbds yourself or pull a specific version here
        rgbds = pkgs.stdenv.mkDerivation {
          pname = "rgbds";
          version = "0.4.0";

          src = pkgs.fetchFromGitHub {
            owner = "gbdev";
            repo = "rgbds";
            rev = "v0.4.0";
            sha256 = "sha256-LfgBUokp/5kM38m/WW19WAOc29U2kfBbZuQ3zmURfUA=";
          };

          nativeBuildInputs = [ pkgs.pkg-config pkgs.makeWrapper ];
          buildInputs = [ pkgs.byacc pkgs.flex pkgs.libpng.dev ];

          buildPhase = "make Q=";
          installPhase = ''
            mkdir -p $out/bin
            cp -v rgb* $out/bin/
          '';
        };

      in {
        devShells.default = pkgs.mkShell {
          name = "pokeprism-dev-shell";
          buildInputs = nativeBuildInputs ++ [ rgbds pkgs.wineWowPackages.stable ];

          shellHook = ''
            if [ ! -d ./pokeprismv ]; then
              echo "ERROR: ./pokeprismv is missing."
              echo "Please clone the private repo manually before running nix develop."
              exit 1
            fi

            echo "Environment ready. You can now run 'make' in ./pokeprismv"
          '';
        };


        # A derivation that builds pokeprism.gbc
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "pokeprism";
          version = "nightly";

          src = builtins.path {
            path = /home/dawn/flakes/pokeprismv-old2022-flake/pokeprismv;
            name = "pokeprismv";
          };

          buildInputs = nativeBuildInputs ++ [ rgbds ];

          buildPhase = ''
            echo "Running make..."
            chmod -R +x .
            make -j4
          '';

          installPhase = ''
            mkdir -p $out
            cp pokeprism.gbc pokeprism_nodebug.gbc pokeprism.map pokeprism.sym contents/bank_ends.txt $out/
          '';
        };

        apps.pokeprism-emulator = flake-utils.lib.mkApp {
          drv = pkgs.writeShellApplication {
            name = "pokeprism-emulator";
            runtimeInputs = [ pkgs.wineWowPackages.stable ];
            text = ''
              export WINEPREFIX="$HOME/.winebgb-old2022"
              export WINEARCH=win32

              if [ ! -d "$WINEPREFIX" ]; then
                echo "Initializing 32-bit Wine prefix at $WINEPREFIX..."
                wine wineboot
              fi

              cd /home/dawn/flakes/pokeprismv-old2022-flake/bgb
              exec wine bgb.exe pokeprism.gbc -watch
            '';
          };
        };

      });
}

