{ pkgs, lib, config, ... }:
{
  options = {
    gaming.enable =
      lib.mkEnableOption "Enables Steam, gamescope, OBS";
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

    # OBS Studio with plugins
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-composite-blur
      obs-shaderfilter
      obs-scale-to-sound
      obs-move-transition
      obs-gradient-source
      obs-replay-source
      obs-source-clone
      obs-3d-effect
      obs-livesplit-one
      waveform
      obs-gstreamer
      obs-vaapi
      obs-vkcapture
      ];
    };
  };
}
