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
      hm = "home-manager switch --flake ~/flakes/home-manager#dawn";
      nrs = "sudo nixos-rebuild switch --flake ~/flakes/nixos";
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

  programs.kate = {
    enable = true;
  };
  programs.plasma = {
    enable = true;
    workspace = {
      wallpaper = /home/dawn/Desktop/Wallpapers/umbreon_background_by_luciana_vee_d7vi8sn.png;
      theme = "Se7enAeroStyle";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "Nova7";
      cursor.theme = "CatPaw";
    };
    shortcuts = {
      "kwin"."Window Close" = "Meta+Q,Alt+F4,Close Window";
      "kwin"."Window Maximize" = "Meta+Up,Meta+PgUp,Maximize Window";
      "kwin"."Window Minimize" = "Meta+Down,Meta+PgDown,Minimize Window";
      "plasmashell"."activate application launcher" = ["Meta" "Alt+F1,Meta" "Alt+F1,Activate Application Launcher"];
      "services/org.kde.konsole.desktop"."_launch" = "Meta+Return";
    };
    configFile = {
      "dolphinrc"."General"."DoubleClickViewAction" = "none";
      "dolphinrc"."General"."RememberOpenedTabs" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."PreviewSettings"."Plugins" = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mltpreview,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      "kactivitymanagerdrc"."activities"."adc66c17-1296-46a8-880b-43ec586eb8df" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "adc66c17-1296-46a8-880b-43ec586eb8df";
      "katerc"."General"."Allow Tab Scrolling" = true;
      "katerc"."General"."Auto Hide Tabs" = false;
      "katerc"."General"."Close After Last" = false;
      "katerc"."General"."Close documents with window" = true;
      "katerc"."General"."Cycle To First Tab" = true;
      "katerc"."General"."Days Meta Infos" = 30;
      "katerc"."General"."Diagnostics Limit" = 12000;
      "katerc"."General"."Diff Show Style" = 0;
      "katerc"."General"."Elide Tab Text" = false;
      "katerc"."General"."Enable Context ToolView" = false;
      "katerc"."General"."Expand Tabs" = false;
      "katerc"."General"."Icon size for left and right sidebar buttons" = 32;
      "katerc"."General"."Modified Notification" = false;
      "katerc"."General"."Mouse back button action" = 0;
      "katerc"."General"."Mouse forward button action" = 0;
      "katerc"."General"."Open New Tab To The Right Of Current" = false;
      "katerc"."General"."Output History Limit" = 100;
      "katerc"."General"."Output With Date" = false;
      "katerc"."General"."Quickopen Filter Mode" = 0;
      "katerc"."General"."Quickopen List Mode" = true;
      "katerc"."General"."Recent File List Entry Count" = 10;
      "katerc"."General"."Restore Window Configuration" = true;
      "katerc"."General"."SDI Mode" = false;
      "katerc"."General"."Save Meta Infos" = true;
      "katerc"."General"."Show Full Path in Title" = false;
      "katerc"."General"."Show Menu Bar" = true;
      "katerc"."General"."Show Status Bar" = true;
      "katerc"."General"."Show Symbol In Navigation Bar" = true;
      "katerc"."General"."Show Tab Bar" = true;
      "katerc"."General"."Show Tabs Close Button" = true;
      "katerc"."General"."Show Url Nav Bar" = true;
      "katerc"."General"."Show output view for message type" = 1;
      "katerc"."General"."Show text for left and right sidebar" = false;
      "katerc"."General"."Show welcome view for new window" = true;
      "katerc"."General"."Startup Session" = "manual";
      "katerc"."General"."Stash new unsaved files" = true;
      "katerc"."General"."Stash unsaved file changes" = false;
      "katerc"."General"."Sync section size with tab positions" = false;
      "katerc"."General"."Tab Double Click New Document" = true;
      "katerc"."General"."Tab Middle Click Close Document" = true;
      "katerc"."General"."Tabbar Tab Limit" = 0;
      "katerc"."Konsole"."AutoSyncronizeMode" = 0;
      "katerc"."Konsole"."KonsoleEscKeyBehaviour" = true;
      "katerc"."Konsole"."KonsoleEscKeyExceptions" = "vi,vim,nvim,git";
      "katerc"."Konsole"."RemoveExtension" = false;
      "katerc"."Konsole"."RunPrefix" = "";
      "katerc"."Konsole"."SetEditor" = false;
      "katerc"."filetree"."editShade" = "31,81,106";
      "katerc"."filetree"."listMode" = false;
      "katerc"."filetree"."middleClickToClose" = false;
      "katerc"."filetree"."shadingEnabled" = true;
      "katerc"."filetree"."showCloseButton" = false;
      "katerc"."filetree"."showFullPathOnRoots" = false;
      "katerc"."filetree"."showToolbar" = true;
      "katerc"."filetree"."sortRole" = 0;
      "katerc"."filetree"."viewShade" = "81,49,95";
      "katerc"."lspclient"."AllowedServerCommandLines" = "/etc/profiles/per-user/dawn/bin/marksman server";
      "katerc"."lspclient"."AutoHover" = true;
      "katerc"."lspclient"."AutoImport" = true;
      "katerc"."lspclient"."BlockedServerCommandLines" = "";
      "katerc"."lspclient"."CompletionDocumentation" = true;
      "katerc"."lspclient"."CompletionParens" = true;
      "katerc"."lspclient"."Diagnostics" = true;
      "katerc"."lspclient"."FormatOnSave" = false;
      "katerc"."lspclient"."HighlightGoto" = true;
      "katerc"."lspclient"."IncrementalSync" = false;
      "katerc"."lspclient"."InlayHints" = false;
      "katerc"."lspclient"."Messages" = true;
      "katerc"."lspclient"."ReferencesDeclaration" = true;
      "katerc"."lspclient"."SemanticHighlighting" = true;
      "katerc"."lspclient"."ServerConfiguration" = "";
      "katerc"."lspclient"."ShowCompletions" = true;
      "katerc"."lspclient"."SignatureHelp" = true;
      "katerc"."lspclient"."SymbolDetails" = false;
      "katerc"."lspclient"."SymbolExpand" = true;
      "katerc"."lspclient"."SymbolSort" = false;
      "katerc"."lspclient"."SymbolTree" = true;
      "katerc"."lspclient"."TypeFormatting" = false;
      "kcminputrc"."Mouse"."cursorTheme" = "CatPaw";
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
      "kdeglobals"."Icons"."Theme" = "Nova7";
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
      "plasmarc"."Theme"."name" = "Se7enAeroStyle";
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
      "kate/anonymous.katesession"."Plugin:kateprojectplugin:"."projects" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."BinaryFiles" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."CurrentExcludeFilter" = "-1";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."CurrentFilter" = "-1";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."ExcludeFilters" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."ExpandSearchResults" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Filters" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."FollowSymLink" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."HiddenFiles" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."MatchCase" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Place" = 1;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Recursive" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Replaces" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Search" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeAllProjects" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeCurrentFile" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeFolder" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeOpenFiles" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeProject" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchDiskFiles" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchDiskFiless" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SizeLimit" = 128;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."UseRegExp" = false;
      "kate/anonymous.katesession"."Plugin:ktexteditorpreviewplugin:MainWindow:0"."automaticUpdate" = true;
      "kate/anonymous.katesession"."Plugin:ktexteditorpreviewplugin:MainWindow:0"."documentLocked" = false;
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

