{ config, pkgs, nyx, ... }:  # <-- notice nyx here

{
  home.username = "dawn";
  home.homeDirectory = "/home/dawn";
  home.stateVersion = "25.05";

  # Import Nyx module
  imports = [
    nyx.homeManagerModules.default
  ];

  nyx = {
    enable = true;
    username = "dawn";
    nixDirectory = "/home/dawn/flakes/nixos";
    logDir = "/home/dawn/.nyx/logs";
    autoPush = false;

    nyx-tool.enable    = true;
    nyx-rebuild.enable = true;
    nyx-cleanup.enable = true;
    nyx-tui.enable     = true;
  };

  home.packages = [
    # pkgs.hello
  ];

  home.file = { };
  home.sessionVariables = { };
  programs.home-manager.enable = true;
}

