# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix      # Include the results of the hardware scan.

    ./modules/coreSystemSetup.nix     # Enables bootloader and other core system functionality
    ./modules/nixSettings.nix         # Enables flakes, nix commands, unfree packages
    ./modules/systemServices.nix      # Enables system services like sound and printing
    ./modules/systemPackages.nix      # Enables firefox, nh, partition manager, and base root packages

    ./modules/optionalServices.nix    # Enables virtualisation and adb
    ./modules/vfio.nix                # VFIO PCI Passthrough
    ./modules/virtualMachineGuest.nix # Enables Guest Tools for NixOS Guest on QEMU/KVM
    ./modules/lookingGlass.nix        # Enables configuration for Looking Glass

    ./modules/kdePlasma.nix           # Enables KDE Plasma on Wayland/X11, and Flatpak
    ./modules/userPackages.nix        # Enables all of the user packages
    ./modules/gaming.nix              # Enables Steam, gamescope
    ./modules/fonts.nix               # Enables custom font configuration
    ./modules/progCompat.nix          # Enables program compatibility tools: nix-ld and appimage
    ./modules/udevRules.nix           # Enables udev rules for controllers and other usb devices
  ];


  # Base
  coreSystemSetup.enable = true;
  nixSettings.enable = true;
  systemServices.enable = true;
  systemPackages.enable = true;

  # VM
  optionalServices.enable = true;
  vfio.enable = true;
  virtualMachineGuest.enable = false;
  lookingGlass.enable = true;

  # User
  kdePlasma.enable = true;
  userPackages.enable = true;
  gaming.enable = true;
  fonts.enable = true;
  progCompat.enable = true;
  udevRules.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
