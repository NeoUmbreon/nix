# My NixOS Config

main nixos configuration:

nix-shell -p git

git clone https://github.com/NeoUmbreon/nix flakes

(Download VMWare workstation .bundle and put in overlays folder)

nix-prefetch-url --type sha256 file:///home/dawn/flakes/nixos/overlays/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle

sudo nixos-rebuild switch --flake /home/dawn/flakes/nixos
<br/>

home-manager configuration:

home-manager switch --flake ~/flakes/home-manager#dawn

nyx-rebuild --update 

nyx-rebuild --flake ~/flakes/nixos

nyx-rebuild
<br/>

for other flakes:

nix develop

nix build

nix run
