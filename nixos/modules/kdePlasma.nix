{ pkgs, lib, config, ... }:
{
  options = {
    kdePlasma.enable =
      lib.mkEnableOption "KDE Plasma on Wayland/X11, and Flatpak";
  };

  config = lib.mkIf config.kdePlasma.enable {
	# Enable the KDE Plasma Desktop Environment.
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
	services.flatpak.enable = true;

	# Enable the X11 windowing system.
	# You can disable this if you're only using the Wayland session.
	#services.xserver.enable = true;

	# Configure keymap in X11
	#services.xserver.xkb = {
	#  layout = "us";
	#  variant = "";
	#};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;
  };
}
