{ pkgs, lib, config, ... }:
{
  options = {
    fonts.enable =
      lib.mkEnableOption "Enables custom font configuration";
  };

  config = lib.mkIf config.fonts.enable {
    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
    ];
  };
}
