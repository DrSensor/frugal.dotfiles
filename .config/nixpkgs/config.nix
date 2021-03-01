{
  # https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
  packageOverrides = pkgs: with pkgs; {
    myWorkflow = buildEnv {
      name = "workflow-utils";
      paths = [
        taskwarrior # todo manager
        taskwarrior-tui
      ];
    };

    myIDE = buildEnv {
      name = "development-environment";
      paths = let
        editor = [
          # normal editor
          micro # tui
          lite # gui
          # modal editor
          kak
          kak-lsp
        ];
        git-toolkit = [
          # {c,t}ui for git
          # gitin
          # lazygit
          # grv
          gitui

          git-interactive-rebase-tool
          delta # diff viewer
          gitbatch # manage multiple .git project
          fac # manage merge conflict
          git-machete # maintain easy-to-review Pull Request (super useful!)

          onefetch # neofetch but for .git project
          stagit # static pages generator for .git projects

          # TODO: ~/Projects should support currently-working-on folder
          # git-standup # list commit in multiple .git project
          # git-workspace # manage multiple repo in a workspace
        ];
        general = [
          nushell # power-user shell
          nix-direnv # auto-switch environment
          broot # fuzzy search
          zoxide # `cd` command that learns
          python39Packages.howdoi # intellicode as cli
        ];
        essential = [
          watchexec # watch change then run command
          editorconfig-checker # universal linter
          rs-git-fsmonitor # git config core.fsmonitor rs-git-fsmonitor
        ];
        language = [
          # nix
          rnix-lsp
          nixpkgs-fmt
        ];
      in
        editor ++ essential
        ++ language
        ++ general
        ++ git-toolkit
      ;
    };

    myWebdev = buildEnv {
      name = "webdev-toolkit";
      paths = with nodePackages_latest;
        [
          devd
          h2o
          # hurl
          # shell2http
          websocketd
          websocat
        ] ++ [ nodejs pnpm closurecompiler ];
    };

    mySysdev = buildEnv {
      name = "sysdev-toolkit";
      paths = [ rust go zig nim ]
      ++ [ xmake sccache binutils lld ]
        # ++ [ ld valgrind-light perf-tools bcal hexyl elfutils elfinfo ] # inspect
        # ++ [ hotspot elf-dissector rehex massif-visualizer ] # GUI for inspect
      ;
    };

    myScripting = buildEnv {
      name = "scripting-toolkit";
      paths = [
        # bpkg
        # lua
        # luajitPackages.luarocks-nix
        # python3
        # pypi2nix
      ];
    };

    myEmu = buildEnv {
      name = "cross-platform-emulation";
      paths = [ qemu kvm wine darling-dmg virt-manager ];
    };

    # currently not in nixpkgs
    # blockbench dust3d pixelorama material-maker butler

    myGamedev = buildEnv {
      name = "gamedev-toolkit";
      paths = let
        game-engine = [
          love
          godot
          # babylonjs-editor
        ];
        shader-material = [
          shadered # shader IDE
          # material-maker
        ];
        pixel-art = [
          # pixelorama
          # aseprite-unfree # pixel-art editor
          xprite-editor # pixel-art editor
          pikopixel # pixel-art editor
          rx # pixel editor
          tiled # tile map editor
        ];
        math = [
          zegrapher # plot equation
          plotutils # collection of plot tools
          # manim # animation engine for explanatory math
          # mathinspector # visual programming environment for math
          # openscad # parametric CAD modeling
        ];
        release = [
          # butler # itch.io
        ];
      in
        game-engine
        # ++ pixel-art
        ++ shader-material
        ++ math
      ;
    };

    myArt = buildEnv {
      name = "art-toolkit";
      paths = let

        _3d-model = [
          # blockbench
          goxel # voxel editor
          # freecad # CAD editor
          # sweethome3d.application # interior design
        ];
        _3d-character = [
          # dust3d
        ];
        _3d = []
        ++ [ blender ]
        ++ _3d-model
        ++ _3d-character
        ;

        _2d-animation = [
          opentoonz
          synfigstudio
        ];
        _2d-drawing = [
          # krita
          inkscape
        ];
        _2d = []
        ++ _2d-drawing
          # ++ _2d-animation
        ;

        misc = [
          gimp # image editor
          # opencolorio # color management framework
        ];
      in
        _3d ++ _2d
      ;
    };

    # TODO: package obs.input-overlay
    # https://github.com/univrsal/input-overlay
    myStream = buildEnv {
      name = "youtuber-toolkit";
      paths = let
        chat = let
          #TODO: use packageOverride like in nix python pills
          weechatWithScripts = with weechatScripts;
            [
              # cosmetics
              colorize_nicks
              weechat-autosort
              weechat-notify-send

              #platform
              # weechat-twitch
            ] ++ [ weechat ];
        in
          [ weechatWithScripts irssi ];
        record = [
          # screen recorder
          # obs-browser # https://github.com/obsproject/obs-browser/issues/219#issuecomment-773240464
          # obs-text-pango # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=obs-text-pango#n27
          # obs-input-overlay # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=obs-input-overlay-bin#n20
          obs-gstreamer
          obs-v4l2sink
          simplescreenrecorder # support OpenGL recording
          # terminal recorder
          asciinema
          # termtosvg
        ];
        download = [ youtube-dl tartube ];
        edit = [
          # lossless-cut # cut,split,trim video
          audacity # audio editor
          blender # video editor
          # opencolorio # color management
          # tts # mozilla deep-learning text-to-speech
          mimic # mycroft machine-learning text-to-speech
          # talkfilters # English text to humoruous text
        ];
      in
        record ++ edit
        ++ download
      ;
    };
  };
}
