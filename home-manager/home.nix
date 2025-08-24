{ config, pkgs, ... }:

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

  imports = [

  ];

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

      format = "[$git_branch$git_commit$git_status$git_state$git_metrics\\[$username@nixos:$directory\\]\\$ ](bold fg:green)";

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
      git_commit = { commit_hash_length = 7; format = "$hash;"; only_detached = true; };
      git_metrics = { format = "($added +$added$deleted -$deleted) "; only_nonzero_diffs = true; };
      git_status = { ahead = "$count ahead;"; behind = "$count behind;"; modified = "modified;"; staged = "staged;"; };
      git_state = { format = "$state"; };
    };
  };

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

  programs.kate = {
    enable = true;
  };
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    #immutableByDefault = true;
    workspace = {
      clickItemTo = "select";
      wallpaper = /home/dawn/Desktop/Wallpapers/umbreon_background_by_luciana_vee_d7vi8sn.png;
      tooltipDelay = "200";
      enableMiddleClickPaste = "false";
      colorScheme = "Sweet";
      theme = "Se7enAeroStyle";
      lookAndFeel = "org.kde.breezedark.desktop";
      windowDecorations.theme = "__aurorae__svg__AeroSense";
      iconTheme = "Nova7";
      cursor.theme = "CatPaw";
      cursor.size = "24";
    };
    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Return";
      command = "konsole";
    };

    panels = [
      # Windows-like panel at the bottom
      {
        screen = "all";
        location = "bottom";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Global menu at the top
      #{
      #  screen = "all";
      #  location = "top";
      #  height = 26;
      #  widgets = [ 
      #    "org.kde.plasma.appmenu"
      #  ];
      #}
    ];

    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Window Maximize" = "Meta+Up";
        "Window Minimize" = "Meta+Down";
      };
    };
    configFile = {
      "dolphinrc"."General"."DoubleClickViewAction" = "none";
      "dolphinrc"."General"."RememberOpenedTabs" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."PreviewSettings"."Plugins" = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mltpreview,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "820,584";
      "kdeglobals"."DirSelect Dialog"."Splitter State" = "\x00\x00\x00\xff\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x8b\x00\x00\x02\xa8\x00\xff\xff\xff\xff\x01\x00\x00\x00\x01\x00";
      "kdeglobals"."General"."XftHintStyle" = "hintslight";
      "kdeglobals"."General"."XftSubPixel" = "rgb";
      "kdeglobals"."General"."font" = "Frutiger,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."menuFont" = "Frutiger,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."smallestReadableFont" = "Frutiger,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."toolBarFont" = "Frutiger,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."KDE"."ShowDeleteCommand" = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = false;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Date";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = true;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."KScreen"."ScreenScaleFactors" = "HDMI-A-2=1;DP-4=1;";
      "kdeglobals"."PreviewSettings"."EnableRemoteFolderThumbnail" = false;
      "kdeglobals"."PreviewSettings"."MaximumRemoteSize" = 0;
      "kdeglobals"."WM"."activeBackground" = "47,52,63";
      "kdeglobals"."WM"."activeBlend" = "47,52,63";
      "kdeglobals"."WM"."activeFont" = "Frutiger,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."WM"."activeForeground" = "211,218,227";
      "kdeglobals"."WM"."inactiveBackground" = "47,52,63";
      "kdeglobals"."WM"."inactiveBlend" = "47,52,63";
      "kdeglobals"."WM"."inactiveForeground" = "102,106,115";
      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kiorc"."Confirmations"."ConfirmTrash" = false;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "alwaysAsk";
      "kscreenlockerrc"."Daemon"."Autolock" = false;
      "kscreenlockerrc"."Daemon"."Timeout" = 0;
      "kservicemenurc"."Show"."compressfileitemaction" = true;
      "kservicemenurc"."Show"."extractfileitemaction" = true;
      "kservicemenurc"."Show"."forgetfileitemaction" = true;
      "kservicemenurc"."Show"."installFont" = true;
      "kservicemenurc"."Show"."kactivitymanagerd_fileitem_linking_plugin" = true;
      "kservicemenurc"."Show"."kdiff3fileitemaction" = true;
      "kservicemenurc"."Show"."kio-admin" = true;
      "kservicemenurc"."Show"."makefileactions" = true;
      "kservicemenurc"."Show"."mountisoaction" = true;
      "kservicemenurc"."Show"."movetonewfolderitemaction" = true;
      "kservicemenurc"."Show"."nextclouddolphinactionplugin" = true;
      "kservicemenurc"."Show"."runInKonsole" = true;
      "kservicemenurc"."Show"."slideshowfileitemaction" = true;
      "kservicemenurc"."Show"."tagsfileitemaction" = true;
      "kservicemenurc"."Show"."wallpaperfileitemaction" = true;
      "ksmserverrc"."General"."confirmLogout" = false;
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "ktrashrc"."\\/home\\/dawn\\/.local\\/share\\/Trash"."Days" = 7;
      "ktrashrc"."\\/home\\/dawn\\/.local\\/share\\/Trash"."LimitReachedAction" = 0;
      "ktrashrc"."\\/home\\/dawn\\/.local\\/share\\/Trash"."Percent" = 10;
      "ktrashrc"."\\/home\\/dawn\\/.local\\/share\\/Trash"."UseSizeLimit" = true;
      "ktrashrc"."\\/home\\/dawn\\/.local\\/share\\/Trash"."UseTimeLimit" = false;
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Id_1" = "de26027d-787a-4a4f-a997-c11956b90dd2";
      "kwinrc"."Desktops"."Number" = 1;
      "kwinrc"."Desktops"."Rows" = 1;
      "kwinrc"."Effect-overview"."BorderActivate" = 9;
      "kwinrc"."TabBox"."HighlightWindows" = false;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling/ace258ec-c5a7-5f8c-8782-45b1f58f2817"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/cc17c5f7-d539-546c-a9db-7f6d39e37357"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/d3a11b05-7ca9-587a-a1d4-fee58923eb92"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Xwayland"."Scale" = 1;
      "kwinrc"."Xwayland"."XwaylandEavesdrops" = "None";
      "kwinrc"."org.kde.kdecoration2"."theme" = "__aurorae__svg__AeroSense";
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasmanotifyrc"."Applications/discord"."Seen" = true;
      "plasmanotifyrc"."Applications/firefox"."Seen" = true;
      "plasmanotifyrc"."Applications/org.qbittorrent.qBittorrent"."Seen" = true;
      "plasmanotifyrc"."Applications/thunderbird"."Seen" = true;
      "plasmarc"."PlasmaToolTips"."Delay" = 200;
      "spectaclerc"."ImageSave"."lastImageSaveLocation" = "file:///home/dawn/Pictures/Screenshots/Screenshot_20250816_202853.png";
      "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
      "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
    };
    dataFile = {
      "kate/anonymous.katesession"."Kate Plugins"."cmaketoolsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."compilerexplorer" = false;
      "kate/anonymous.katesession"."Kate Plugins"."eslintplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."externaltoolsplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."formatplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katebacktracebrowserplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katebuildplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katecloseexceptplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katecolorpickerplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katectagsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katefilebrowserplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katefiletreeplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."kategdbplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."kategitblameplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katekonsoleplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."kateprojectplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."katereplicodeplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesearchplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."katesnippetsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesqlplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesymbolviewerplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katexmlcheckplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katexmltoolsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."keyboardmacrosplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."ktexteditorpreviewplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."latexcompletionplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."lspclientplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."openlinkplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."rainbowparens" = false;
      "kate/anonymous.katesession"."Kate Plugins"."rbqlplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."tabswitcherplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."templateplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."textfilterplugin" = true;
    };
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

