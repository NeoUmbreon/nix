{ pkgs, lib, config, ... }:
{
  options = {
    udevRules.enable = 
      lib.mkEnableOption "Enables udev rules for controllers and other usb devices";
  };

  config = lib.mkIf config.udevRules.enable {
    services.udev.extraRules = ''
      #xx3dsfml
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="601e", MODE="0666"

      #GameCube Controller Adapter
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337",     TAG+="uaccess"

      #Wiimotes or DolphinBar
      SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
      SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", TAG+="uaccess"
    '';
  };
}
