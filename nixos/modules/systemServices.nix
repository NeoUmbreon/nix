{ pkgs, lib, config, ... }:
{
  options = {
    systemServices.enable =
      lib.mkEnableOption "Enables system services like sound and printing";
  };

  config = lib.mkIf config.systemServices.enable {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      #wireplumber.enable = true;
    };

    # Enable CUPS to print documents.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
      cups-filters
      cups-browsed
      ];
    };
  };
}
