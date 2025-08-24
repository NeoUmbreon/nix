{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      sshp = "ssh -p 8253 neo@neoumbreon.com";
      sudo = "sudo ";
      hm-old = "home-manager switch --flake ~/flakes/home-manager#dawn";
      nrs-old = "sudo nixos-rebuild switch --flake ~/flakes/nixos";
      hm = "nh home switch /home/dawn/flakes/home-manager";
      nrs = "nh os switch /home/dawn/flakes/nixos";
      ncg = "nix-collect-garbage -d";
      nhc = "nh clean all --ask";

      hmedit = "nvim /home/dawn/flakes/home-manager/home.nix";
      nixedit = "nvim /home/dawn/flakes/nixos/configuration.nix";
    };
    initExtra = ''
    vbuild() {
      cd ~/flakes/pokeprismv-flake/ || return 1

      nom develop --command bash -c '
        echo "Entered nix shell temporarily. Building..."
        nom build --impure || exit 1
        cp result/pokeprism.gbc bgb/pokeprism.gbc || exit 1
        echo "Build and copy completed!"
      '
    }
    if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
    fi

    # Start ssh agent automatically
    if [ -z "$SSH_AUTH_SOCK" ]; then
      eval "$(ssh-agent -s)" > /dev/null 2>&1
    fi

    # Check if the keys are already added, and add them only if they aren't
    if ! ssh-add -l | grep -q "dawn"; then
      ssh-add ~/.ssh/id_rsa_dawn > /dev/null 2>&1
    fi

    if ! ssh-add -l | grep -q "neo"; then
      ssh-add ~/.ssh/id_rsa_neo > /dev/null 2>&1
    fi

    '';
    bashrcExtra = ''
    '';
    sessionVariables = {
      HOME_MANAGER_FLAKE = "/home/dawn/flakes/home-manager#dawn";
    };
    historySize = 1000000;
    historyFileSize = 2000000;
  };
}
