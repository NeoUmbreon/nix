# My NixOS Config

### main nixos configuration:

`sudo nixos-rebuild switch --upgrade`

`nix-shell -p git home-manager`

`git clone https://github.com/NeoUmbreon/nix flakes`

`sudo cp /etc/nixos/hardware-configuration.nix ~/flakes/nixos/hardware-configuration.nix`

<br/>

## There are 2 options to install the config. 
## Only necessary to do ONE of these.

### 1. (easiest) use /etc/nixos/configuration.nix
`sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak && sudo rm /etc/nixos/configuration.nix`

`sudo ln -s ~/flakes/nixos/configuration.nix /etc/nixos/configuration.nix`

`sudo nixos-rebuild switch`

Add home-manager if you want after:

`home-manager switch --flake ~/flakes/home-manager#dawn --extra-experimental-features nix-command --extra-experimental-features flakes`

### 2. (best) rebuild from flake
`sudo nixos-rebuild switch --flake /home/dawn/flakes/nixos`

Add home-manager

`home-manager switch --flake ~/flakes/home-manager#dawn --extra-experimental-features nix-command --extra-experimental-features flakes`

Now you can use:

`nr` rebuilds main config with nyx

`hm` rebuilds home-manager config

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
```
[dawn@nixos:~/.local/share/applications]$ cat polished-map.desktop 
[Desktop Entry]
Categories=Development;Utility;
Comment=
Exec=nix run '/home/dawn/flakes/polished-map-flake/'
Icon=/home/dawn/flakes/polished-map-flake/polished-map.png
Name=Polished Map++
NoDisplay=false
Path=/home/dawn/flakes/pokeprismv-flake/pokeprismv/
StartupNotify=true
Terminal=false
Type=Application
[dawn@nixos:~/.local/share/applications]$ 
```

### xx3dsfml
`nix build`

(wip)
(Now you can create a .desktop file for the resulting binary (/home/dawn/flakes/polished-map-flake/result/bin/polishedmap-plusplus) in ~/.local/share/applications/, for example:
