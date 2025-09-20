{ pkgs, lib, config, ... }:
{
  options = {
    userPackages.enable =
      lib.mkEnableOption "Enables all of the user packages";
  };

  config = lib.mkIf config.userPackages.enable {
    # My programs
    users.users.dawn = {
      isNormalUser = true;
      description = "dawn";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" "plugdev" "dialout" "kvm" ];
      packages = with pkgs; [
        # core system packages
        git
        wineWowPackages.full
        gcc

        # Text editing
        neovim
        xed-editor
        kdePackages.kate
        kdePackages.markdownpart
        marksman
        nil

        # Development
        vscode
        github-desktop
        gh
        direnv
        texliveFull
        texstudio
        python312
        python313Packages.python-lsp-server

        # Social and Web
        discord
        google-chrome
        vesktop
        telegram-desktop

        # Launchers and Emus
        prismlauncher
        dolphin-emu

        # Gaming
        protonplus
        joystickwake

        # Media and Audio
        pwvucontrol
        #qpwgraph
        #pavucontrol
        #kdePackages.kmix

        # GUI Utilities
        fsearch
        qdirstat
        parabolic
        qbittorrent
        #qalculate-qt
        mate.mate-calc

        # CLI Utilities
        fastfetch
        tree
        ncdu
        nix-output-monitor # Better nix-build output
        bat # Better cat output
        wl-clipboard # Command-line copy/paste utilities for Wayland
        eza
        yt-dlp

        # KDE Packages
        kdePackages.sddm-kcm # Configuration module for SDDM (Login screen)
        kdePackages.discover # For Flatpak or fwupd firmware update sevice
        kdePackages.kcolorchooser # A small utility to select a color
        #kdePackages.kcalc # Calculator
        #kdiff3 # Compares and merges 2 or 3 files or directories
        #kdePackages.kolourpaint # Easy-to-use paint program

        # Office
        thunderbird
        nextcloud-client
        zoom-us

        # System Information
        hardinfo2 # System information and benchmarks for Linux systems
        wayland-utils # A utility for displaying information about the Wayland protocols supported by a Wayland compositor.
        kdePackages.ksystemlog # KDE SystemLog Application

        # Looking Glass
        looking-glass-client

        # Emacs
        cmake
        libtool
        libvterm
        gnumake
        nixd
        fd
        ripgrep
        nixfmt-classic
        shellcheck
        multimarkdown
      ];
    };
  };
}
