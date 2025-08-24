{ pkgs, lib, config, ... }:
{
  options = {
    systemPackages.enable =
      lib.mkEnableOption "Enables base system packages for root";
  };

  config = lib.mkIf config.systemPackages.enable {
	# Install firefox.
	programs.firefox.enable = true;

    # NH (better output for nixos-rebuild switch and other commands)
	programs.nh = {
		enable = true;
		clean.enable = true;
		clean.extraArgs = "--keep-since 4d --keep 3";
		flake = "/home/dawn/flakes/nixos"; # sets NH_OS_FLAKE variable for you
	};

	environment.systemPackages = with pkgs; [
		vim
		wget
	];
  };
}
