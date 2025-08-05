{
  description = "Build environment for pokeprism with RGBDS and other dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
          bison
          git
          python3
          python3Packages.pypng
          pkg-config
          libpng
          zlib libpng libjpeg fontconfig alsa-lib
          xorg.libX11 xorg.libXpm xorg.libXft
          xorg.libXinerama xorg.libXext xorg.libXrender xorg.libXfixes
        ];

        # You can also define rgbds yourself or pull a specific version here
        rgbds = pkgs.stdenv.mkDerivation {
          pname = "rgbds";
          version = "0.6.1";

          src = pkgs.fetchFromGitHub {
            owner = "gbdev";
            repo = "rgbds";
            rev = "v0.6.1";
            sha256 = "sha256-3mx4yymrOQnP5aJCzPWl5G96WBxt1ixU6tdzhhOsF04=";
          };

          nativeBuildInputs = [ pkgs.pkg-config pkgs.makeWrapper ];
          buildInputs = [ pkgs.bison pkgs.libpng.dev ];

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

          src = ./pokeprismv;

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
              export WINEPREFIX=$HOME/.wine64
              export WINEARCH=win64

              if [ ! -d "$WINEPREFIX" ]; then
                echo "Initializing 64-bit Wine prefix at $WINEPREFIX..."
                wineboot
              fi
              cd /home/dawn/flakes/pokeprismv-flake/bgbw64
              wine64 bgb64.exe pokeprism.gbc -watch
            '';
          };
        };

      });
}

