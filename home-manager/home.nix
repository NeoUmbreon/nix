{ config, pkgs, nyx, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dawn";
  home.homeDirectory = "/home/dawn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

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

  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          #uosc
          #sponsorblock
          autoload
          mpv-webm
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );
    config = {
        window-maximized = true;
        volume = 50;
        volume-max = 300;
        keep-open = "always";
      };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 500;

      format = "$git_branch$git_commit$git_status$git_state$git_metrics\\[$username@nixos:$directory\\]\\$ ";

      right_format = "";
      scan_timeout = 30;

      directory = {
        disabled = false;
        fish_style_pwd_dir_length = 0; # show full path
        format = "$path$read_only";
        home_symbol = "~";
        truncate_to_repo = false;
        use_logical_path = true;
        use_os_path_sep = true;
      };

      username = { format = "$user"; show_always = true; disabled = false; };
      hostname = { format = "$hostname"; disabled = false; };

      git_branch = { format = " $branch "; };
      git_commit = { commit_hash_length = 7; format = "$hash "; only_detached = true; };
      git_metrics = { format = "($added +$added$deleted -$deleted) "; only_nonzero_diffs = true; };
      git_status = { ahead = "$count ahead "; behind = "$count behind "; modified = "modified "; staged = "staged "; };
      git_state = { format = "$state"; };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      sshp = "ssh -p 8253 neo@neoumbreon.com";
      sudo = "sudo ";
      hm = "home-manager switch --flake ~/flakes/home-manager#dawn";
    };
    initExtra = ''
    vbuild() {
      cd ~/flakes/pokeprismv-flake/ || return 1

      nix develop --command bash -c '
        echo "Entered nix shell temporarily. Building..."
        nix build --impure || exit 1
        cp result/pokeprism.gbc bgbw64/pokeprism.gbc || exit 1
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dawn/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "neovim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

