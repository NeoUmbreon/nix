{ pkgs, lib, config, ... }:
{
  options = {
    kdePlasma.enable =
      lib.mkEnableOption "Enables KDE Plasma on Wayland and SDDM";
  };

  config = lib.mkIf config.kdePlasma.enable {
    # Enable SDDM as the display manager
    services.displayManager.sddm.enable = true;

    # Enable KDE Plasma Desktop Environment
    services.desktopManager.plasma6.enable = true;
  };
}
