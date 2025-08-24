# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  services.udev.extraRules = ''
    #xx3dsfml
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="601e", MODE="0666"

    #GameCube Controller Adapter
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337",     TAG+="uaccess"

    #Wiimotes or DolphinBar
    SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
    SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", TAG+="uaccess"
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define Hostname
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  #time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};
 
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    #wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # My programs
  users.users.dawn = {
    isNormalUser = true;
    description = "dawn";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" ];
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

      # Development
      vscode
      github-desktop

      # Social and Web
      discord
      google-chrome
      vesktop

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
    ];
  };

  # Partition Manager
  programs.partition-manager.enable = true;

  # QEMU/KVM Guest Tools
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Android
  programs.adb.enable = true;

  # NH (better output for nixos-rebuild switch and other commands)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/dawn/flakes/nixos"; # sets NH_OS_FLAKE variable for you
  };
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

  #libfuse2 apps
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Nix ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    fuse
    icu
    icu.dev
    onnxruntime
    sdl3
    freetype
    harfbuzz
    fwupd
  ];

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

  # Install firefox.
  programs.firefox.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
