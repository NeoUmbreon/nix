{ pkgs, lib, config, ... }:
{
  options = {
    recording.enable =
      lib.mkEnableOption "Enables OBS with plugins";
  };

  config = lib.mkIf config.gaming.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # From NixOS documentation
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vaapi #AMD hardware acceleration
        obs-vkcapture

        # Extras
        #obs-composite-blur
        #obs-shaderfilter
        obs-scale-to-sound
        #obs-move-transition
        #obs-gradient-source
        #obs-replay-source
        #obs-source-clone
        obs-livesplit-one
        #obs-3d-effect
        #waveform
      ];
    };
  };
}
