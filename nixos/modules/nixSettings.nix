{ pkgs, lib, config, ... }:
{
  options = {
    nixSettings.enable =
      lib.mkEnableOption "Enables flakes, nix commands, unfree packages";
  };

  config = lib.mkIf config.nixSettings.enable {
    # Enable flakes and things like nix-shell
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.auto-optimise-store = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
