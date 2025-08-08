{
  description = "xx3dsfml - Makefile-based flake (SFML + libftd3xx)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;

      libftd3xx_version = "1.0.5";
      libftd3xx_sha256 = "1pfz4h0drvn7khqba9c6hddnn60j3jzv9sqxgbi9zp2r4lnw7mm2";
      libftd3xx_url = "https://ftdichip.com/wp-content/uploads/2023/03/libftd3xx-linux-x86_64-${libftd3xx_version}.tgz";

      # small derivation to unpack the vendor libftd3xx archive
      libftd3xx = pkgs.stdenv.mkDerivation {
        name = "libftd3xx-${libftd3xx_version}";
        src = pkgs.fetchurl {
          url = libftd3xx_url;
          sha256 = libftd3xx_sha256;
        };

        unpackPhase = ''
          tar -xzf $src --strip-components=1
        '';

        phases = [ "unpackPhase" "installPhase" ];

        installPhase = ''
          mkdir -p $out/include/ftd3xx
          cp *.h $out/include/ftd3xx/
          mkdir -p $out/lib
          cp libftd3xx.so.${libftd3xx_version} $out/lib/
          ln -s libftd3xx.so.${libftd3xx_version} $out/lib/libftd3xx.so
        '';
      };

      # main package — explicitly runs make (no CMake/configure)
      xx3dsfml = pkgs.stdenv.mkDerivation {
        pname = "xx3dsfml";
        version = "unstable";
        dontStrip = true;

        # keep source clean but preserve Makefile/C++ files
        src = pkgs.lib.cleanSource ./.;

        # build tools (compiler + make)
        nativeBuildInputs = [
          pkgs.gnumake
          pkgs.gcc
        ];

        # runtime / link deps (SFML, vendor lib, and C++ runtime)
        buildInputs = [
          pkgs.sfml_2
          libftd3xx
          pkgs.gcc.cc.lib   # ensures libstdc++.so.6 is in the closure
        ];

        # Force make-based build (this skips any configure/cmake probing)
        buildPhase = ''
          set -euo pipefail
          echo "=> Building with Makefile"
          make clean || true
          make CXXFLAGS="-I${libftd3xx}/include -I${pkgs.sfml_2}/include" \
               LDFLAGS="-L${libftd3xx}/lib -L${pkgs.sfml_2}/lib"
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp xx3dsfml $out/bin/
        '';

        meta = with pkgs.lib; {
          description = "XX3DSFML (SFML + libftd3xx) - Makefile build";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.gnumake
          pkgs.gcc
          pkgs.sfml_2
          libftd3xx
        ];

        shellHook = ''
          export CXXFLAGS="-I${libftd3xx}/include -I${pkgs.sfml_2}/include"
          export LDFLAGS="-L${libftd3xx}/lib -L${pkgs.sfml_2}/lib"
          export LD_LIBRARY_PATH="${libftd3xx}/lib:${pkgs.sfml_2}/lib:${pkgs.gcc.cc.lib}/lib:$LD_LIBRARY_PATH"
        '';
      };
    in
    {
      packages.${system} = {
        xx3dsfml = xx3dsfml;
        default = xx3dsfml;
      };


      # simple `nix run` entry
      apps.${system}.default = {
        type = "app";
        program = "${xx3dsfml}/bin/xx3dsfml";
      };

      devShells.${system}.default = devShell;
    };
}
