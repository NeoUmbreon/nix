# My NixOS Config

### main nixos configuration:

```
sudo nixos-rebuild switch --upgrade
```

```
nix-shell -p git home-manager
```

```
git clone https://github.com/NeoUmbreon/nix flakes
```

```
sudo cp /etc/nixos/hardware-configuration.nix ~/flakes/nixos/hardware-configuration.nix
```

Extras- theming, LazyVim, and obs (flatpak) plugins:
```
cp -r ~/flakes/extra/theming/.* ~/
ln -s /home/dawn/flakes/extra/nvim /home/dawn/.config/nvim
ln -s ~/flakes/extra/plugins/ ~/.var/app/com.obsproject.Studio/config/obs-studio/
```

If in a virtual machine instead of a host, edit `~/flakes/nixos/configuration.nix`:

```
  optionalServices.enable = false;
  virtualMachineGuest.enable = true;
```

<br/>

## There are 2 options to install the config. Only necessary to do ONE of these.

### 1. (best) rebuild from flake
```
sudo nixos-rebuild switch --flake ~/flakes/nixos
```

Add home-manager

```
home-manager switch --flake ~/flakes/home-manager#dawn --extra-experimental-features nix-command --extra-experimental-features flakes
```

Now you can use:

`nrs` rebuilds main config with nh

`hm` rebuilds home-manager config

<details>
<summary>
2. (easiest) use /etc/nixos/configuration.nix
</summary>

```
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak && sudo rm /etc/nixos/configuration.nix

sudo ln -s ~/flakes/nixos/configuration.nix /etc/nixos/configuration.nix

sudo nixos-rebuild switch
```

Add home-manager if you want after:

```
home-manager switch --flake ~/flakes/home-manager#dawn --extra-experimental-features nix-command --extra-experimental-features flakes
```

</details>

<br/>

### for other flakes:
These commands work in all of them, but recommended procedure below

`nix develop`
`nix build`
`nix run`

Add them all to your application menu:

```
ln -s ~/flakes/extra/applications/*.desktop ~/.local/share/applications/
```

### pokeprismv-flake
pokeprismv folder necessary, not provided

```
nix develop
```

Command from home-manager (essentially `nix build --impure`):
```
vbuild
```

Then you can run BGB:
```
nix run '/home/dawn/flakes/pokeprismv-flake#pokeprism-emulator'
```

### polished-map-flake
```
nix build
```

### xx3dsfml
```
nix build
```

### install wine programs:
```
wine ~/flakes/extra/wineprogs/putty-0.83-installer.msi
```

```
wine ~/flakes/extra/wineprogs/WinSCP-6.5.3-Setup.exe
```

Then open WinSCP and import your WinSCP.ini (not provided).
