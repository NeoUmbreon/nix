{ pkgs, lib, config, ... }:
{
  options = {
    cinnamon.enable =
      lib.mkEnableOption "Enables Cinnamon Desktop on X11";
  };

  config = lib.mkIf config.cinnamon.enable {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
      # Enable lightdm if SDDM (Plasma) is disabled
      #displayManager.lightdm.enable = true;

      desktopManager = {
        cinnamon.enable = true;
      };
      #displayManager.defaultSession = "cinnamon";
    };
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable cinnamon apps
    services.cinnamon.apps.enable = true;
    # Exclude packages from cinnamon apps
    #environment.cinnamon.excludePackages = []

    # Fix for QT app sizes (OBS, Kdenlive, etc.)
    environment.sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "0";
      XCURSOR_SIZE = "48";
    };
  };
}
