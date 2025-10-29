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
      # General / system libraries
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
      libgbm
      libxkbcommon

      # X11 core libraries
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXrender
      xorg.libXi
      xorg.libXinerama
      xorg.libXfixes
      xorg.libXfixes.out
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXScrnSaver
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libxcb

      # Audio
      alsa-lib
      libpulseaudio
      SDL2
      pulseaudio
      pipewire
      openal
      libsndfile

      # Bizhawk / Lua
      gtk2.out
      gdk-pixbuf.out
      pango.out
      xorg.libXi.out
      SDL2
      lua
      lua5_3
      lua5_4
      lua5_3_compat
      lua5_4_compat

      # GTK3 stack
      gtk3
      gdk-pixbuf
      pango
      atk
      cairo
      glib
      adwaita-icon-theme
      fontconfig
      expat

      # Torch / compute
      zstd
      zstd.out
      zstd.dev
      ncurses
      numactl
      libdrm
      rocmPackages.rocm-runtime
      llvmPackages.openmp

      # NSS / DBus / printing
      nss
      nspr
      dbus
      cups
      ];
  };
}
