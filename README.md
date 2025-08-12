# My NixOS Config

### main nixos configuration:

`sudo nixos-rebuild switch --upgrade`

`nix-shell -p git home-manager`

`git clone https://github.com/NeoUmbreon/nix flakes`

`sudo cp /etc/nixos/hardware-configuration.nix ~/flakes/nixos/hardware-configuration.nix`

Ensure that you are using systemd-boot in your existing /etc/nixos/configuration.nix:

boot.loader.systemd-boot.enable = true;

boot.loader.efi.canTouchEfiVariables = true;


If not, edit ~/flakes/nixos/configuration.nix to use (assumedly) GRUB:

boot.loader.grub.enable = true;

boot.loader.grub.device = "/dev/sda";

boot.loader.grub.useOSProber = true;

> Download VMWare workstation .bundle and put in overlays folder:

`cp ~/Downloads/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle ~/flakes/nixos/overlays/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle`

`nix-prefetch-url --type sha256 file:///home/dawn/flakes/nixos/overlays/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle`

<br/>

## There are 3 options to install the config. 
## Only necessary to do ONE of these.

### 1. (easiest) use only configuration.nix
`sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak && sudo rm /etc/nixos/configuration.nix`

`sudo ln -s ~/flakes/nixos/configuration.nix /etc/nixos/configuration.nix`

`sudo nixos-rebuild switch`

### 2. rebuild from flake
`sudo nixos-rebuild switch --flake /home/dawn/flakes/nixos`

### 3. (best) home-manager + nyx
`home-manager switch --flake ~/flakes/home-manager#dawn --extra-experimental-features nix-command --extra-experimental-features flakes`

`nyx-rebuild`

Refer to here for nyx commands:

https://github.com/Peritia-System/Nyx-Tools?tab=readme-ov-file#usage

<br/>

### for other flakes:
These commands work in all of them, but recommended procedure below
`nix develop`
`nix build`
`nix run`

### pokeprismv-flake
pokeprismv folder necessary, not provided
`nix develop`
`nix build`

### polished-map-flake
`nix build`
Now you can create a .desktop file for the resulting binary (/home/dawn/flakes/polished-map-flake/result/bin/polishedmap-plusplus) in ~/.local/share/applications/, for example:
(wip)

### xx3dsfml
`nix build`
