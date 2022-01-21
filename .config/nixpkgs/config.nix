{
  allowUnfree = true;
  # https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
  packageOverrides = pkgs: with pkgs; {
    # TODO: move this to extras.nix
    inherit (pkgs) stdenv lib;
    # TODO: urho3d - https://urho3d.github.io/documentation/1.7.1/_building.html
    Arrow = stdenv.mkDerivation rec {
      pname = "Arrow";
      version = "1.0.0";
      src = fetchTarball "https://github.com/mhgolkar/Arrow/releases/download/v${version}/Arrow-v${version}-linux-x86_64.tar.gz";
      # TODO: properly install Arrow (Game Narrative Design Tool)
      # hint: see pkgs.godot
      installPhase = "
        install -m755 -D Arrow.x86_64 $out/bin/${pname}
      ";
      meta = with lib; {
        description = "Game Narrative Design Tool";
        license = lib.licenses.mit;
        platforms = [ "x86-linux" "x86_64-linux" ];
      };
    };
    # TODO: Effekseer - https://github.com/effekseer/Effekseer/blob/master/.github/workflows/build.yml#L130-L133
    # Effekseer = stdenv.mkDerivation rec {};
    # TODO: LDtk - https://github.com/deepnight/ldtk/releases/latest
    # TODO: ogmo - https://github.com/Ogmo-Editor-3/OgmoEditor3-CE
    # LDtk = stdenv.mkDerivation rec {}
    # TODO: SpriteSheetPacker - https://github.com/amakaseev/sprite-sheet-packer
    # TODO: bitmapflow - https://github.com/Bauxitedev/bitmapflow/blob/main/.github/workflows/rust.yml
    # TODO: fontbuilder - https://github.com/andryblack/fontbuilder
    # TODO: fontbm - https://github.com/vladimirgamalyan/fontbm
    # TODO: msdf-atlas-gen - https://github.com/Chlumsky/msdf-atlas-gen
    # TODO: msdfgen - https://github.com/Chlumsky/msdfgen
    # TODO: labelme - https://github.com/wkentaro/labelme  (useful for rotoscoping)

    # TODO: athens.AppImage - https://github.com/athensresearch/athens/releases/latest
    # TODO: nxcloud - https://github.com/budde25/nxcloud
    # TODO: create_ap - https://github.com/lakinduakash/linux-wifi-hotspot#command-line-help-and-documentation
    # TODO: outrun - https://github.com/Overv/outrun
    # TODO: SysMonTask - https://github.com/KrispyCamel4u/SysMonTask
    # TODO: pipe-rename - https://github.com/marcusbuffett/pipe-rename

    ### Overlay ###
    # TODO: taskopen - fetchGit { url = "https://github.com/jschlatow/taskopen.git"; ref = "nim"; }
    ############################################################

    myWorkflow = buildEnv {
      name = "workflow-utils";
      paths = [
        dstask
        # taskwarrior # todo manager
        # taskwarrior-tui # alternative: vit
        # timewarrior
        # taskopen
        # athens menex nxcloud
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
          vis
          # vis-lspc
        ];
        # version-control = [ dolt dvc ];
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
          reptyr # reparent process to new terminal
          editorconfig-checker # universal linter
          rs-git-fsmonitor # git config core.fsmonitor rs-git-fsmonitor
        ];
        # emulation = [ ryujinx pcsx2 wine darling-dmg anbox ];
        language = [
          # nix
          rnix-lsp
          nixpkgs-fmt
        ];
        multi-device = [
            scrcpy
            # mconnect/gconnect # KDEConnect replacement
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
        # ++ [ hotspot elf-dissector rehex massif-visualizer vite ] # GUI for inspect
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
          pico8
          # babylonjs-editor
          # urho3d
          # haxe    # for using HaxeFlixel
        ];
        shader-material = [
          shadered # shader IDE
          # effekseer
        ];
        level-editor = [
          tiled # tile map editor
          # LDtk
          # ogmo
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

    asset-utils = buildEnv {
      name = "asset-utils";
      paths = let
        image-utils = [ vips exiv2 gmic imagemagick ];
        font-utils = [ msdfgen msdf-atlas-gen fontbm ];
      in
        [ image-utils ];
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
        _3d-material = [
          # material-maker
          # armorpaint
        ];
        _3d = []
        ++ [ blender ]
        ++ _3d-model
        ++ _3d-character
        ;

        _2d-animation = [
          opentoonz
          synfigstudio
          # enve
        ];
        _2d-drawing = [
          # krita
          inkscape
          # pixelorama
          # aseprite-unfree # pixel-art editor
          xprite-editor # pixel-art editor
          pikopixel # pixel-art editor
          rx # pixel editor
        ];
        _2d = []
        ++ _2d-drawing
          # ++ _2d-animation
        ;

        misc = [
          gimp # image editor
          # bitmapflow # generate inbetween animated sprites
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
        chat = [
          weechat
          (
            with weechatScripts; [
              ## cosmetics
              colorize_nicks
              weechat-autosort
              weechat-notify-send
              ## platform
              # weechat-twitch
            ]
          )
        ];
        record = [
          # linuxPackages.v4l2loopback # should be in /etc/nixos/configuration.nix
          ## Screen Recorder
          # obs-browser # https://github.com/obsproject/obs-browser/issues/219#issuecomment-773240464
          # obs-text-pango # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=obs-text-pango#n27
          # obs-rtspserver # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=obs-rtspserver-bin#n15
          # obs-input-overlay # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=obs-input-overlay-bin#n20
          # obs-streamlink # only availble on Windows 😞
          #? choose *only* one of these:
          # obs-shaderfilter # written in C (with a lot of shader presets)
          # obs-shaderfilter-plus # written in Rust (allow both HLSL & GLSL)
          # obs-streamfx # written in C++ (only HLSL)
          obs-gstreamer
          obs-v4l2sink
          simplescreenrecorder # support OpenGL recording
          ## Terminal Recorder
          asciinema
          # termtosvg
        ];
        audio = [ noisetorch pulseeffects-pw ];
        utils = [ xournalpp pavucontrol chat ];
        download = [ youtube-dl tartube streamlink ];
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
        record ++ utils
        ++ download
        # ++ edit
      ;
    };
  };
}
