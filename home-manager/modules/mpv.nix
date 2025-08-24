{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          #uosc
          #sponsorblock
          autoload
          mpv-webm
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );
    config = {
        window-maximized = true;
        volume = 50;
        volume-max = 300;
        keep-open = "always";
      };
  };
}
