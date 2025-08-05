{
  description = "Polished Map++ with FLTK built from source";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        fltk = pkgs.stdenv.mkDerivation {
          name = "fltk-1.3.7";
          src = pkgs.fetchFromGitHub {
            owner = "fltk";
            repo = "fltk";
            rev = "release-1.3.7";
            sha256 = "sha256-9jHtDZ3TSZcm8DJWVnejRlht7Tglz6av31jTu93M6/k=";
          };

          nativeBuildInputs = [ pkgs.autoconf pkgs.automake pkgs.libtool pkgs.gcc pkgs.gnumake pkgs.pkg-config ];
          buildInputs = [
            pkgs.zlib pkgs.libpng pkgs.libjpeg pkgs.fontconfig pkgs.alsa-lib
            pkgs.xorg.libX11 pkgs.xorg.libXpm pkgs.xorg.libXft
            pkgs.xorg.libXinerama pkgs.xorg.libXext pkgs.xorg.libXrender pkgs.xorg.libXfixes
          ];

          configureFlags = [
            "--with-abiversion=10307"
          ];

          preConfigure = ''
            ./autogen.sh
          '';

          installPhase = ''
            make install prefix=$out
          '';
        };

        polishedMap = pkgs.stdenv.mkDerivation {
          name = "polishedmap-plusplus";
          src = pkgs.fetchFromGitHub {
            owner = "Rangi42";
            repo = "polished-map";
            rev = "plusplus"; # or a commit hash
            sha256 = "sha256-9h9Wiw5rPnwaPbhjIuLWktVx0gMirFYYLeO6fE5QmTM=";
          };

          nativeBuildInputs = [ pkgs.gcc pkgs.gnumake pkgs.pkg-config ];
          buildInputs = [
            fltk
                        pkgs.zlib pkgs.libpng pkgs.libjpeg pkgs.fontconfig pkgs.alsa-lib
            pkgs.xorg.libX11 pkgs.xorg.libXpm pkgs.xorg.libXft
            pkgs.xorg.libXinerama pkgs.xorg.libXext pkgs.xorg.libXrender pkgs.xorg.libXfixes

          ];


          makeFlags = [ "FLTK_CONFIG=${fltk}/bin/fltk-config" ];

          installPhase = ''
            mkdir -p $out/bin
            cp bin/polishedmap-plusplus $out/bin/
          '';
        };
      in {
        packages.default = polishedMap;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc pkgs.gnumake pkgs.pkg-config
            pkgs.autoconf pkgs.automake pkgs.libtool
            fltk
          ];
        };

        apps.default = {
          type = "app";
          program = "${polishedMap}/bin/polishedmap-plusplus";
        };
      }
    );
}

