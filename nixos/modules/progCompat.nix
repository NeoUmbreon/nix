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
    ];
  };
}
