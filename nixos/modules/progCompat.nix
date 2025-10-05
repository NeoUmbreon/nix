{ pkgs, lib, config, ... }:
{
  options = {
    progCompat.enable =
      lib.mkEnableOption "Enables program compatibility tools: nix-ld and appimage";
  };

  config = lib.mkIf config.progCompat.enable {
    #libfuse2 apps
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    # Nix ld
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
      fuse
      icu
      icu.dev
      onnxruntime
      sdl3
      freetype
      harfbuzz
      fwupd
      libGL
      mesa
      mesa_glu
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXrender
      xorg.libXi
      xorg.libXinerama
      alsa-lib
      libpulseaudio
      SDL2

      # Bizhawk
      gtk2.out
      gdk-pixbuf.out
      pango.out
      xorg.libXi.out
      xorg.libXfixes.out
      SDL2
      lua
      lua5_4
      lua5_3
      lua5_3_compat
      lua5_4_compat



      # audio
      openal
      pulseaudio
      pipewire
      alsa-lib
      libsndfile
    ];
  };
}
