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

`nr` rebuilds main config with nyx

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
ln -s ~/flakes/applications/*.desktop ~/.local/share/applications/
```

### pokeprismv-flake
pokeprismv folder necessary, not provided

```
nix develop
```

```
nix build
```

### polished-map-flake
```
nix build
```

### xx3dsfml
```
nix build
```
