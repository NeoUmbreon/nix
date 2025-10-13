{ pkgs, lib, config, ... }:
{
  options = {
    gaming.enable =
      lib.mkEnableOption "Enables Steam, gamescope";
  };

  config = lib.mkIf config.gaming.enable {
    # Hardware and gaming
    hardware.steam-hardware.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.xone.enable = true;
    hardware.xpadneo.enable = true;
    hardware.opentabletdriver.enable = true;
    programs.gamemode.enable = true;
    programs.steam.enable = true;
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;
  };
}
