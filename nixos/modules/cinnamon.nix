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
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
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
    # Enable cinnamon apps
    services.cinnamon.apps.enable = true;
  };
}
