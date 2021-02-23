{
  # https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
  packageOverrides = pkgs: with pkgs; {
    myIDE = buildEnv {
      name = "development-environment";
      paths = let
        editor = [
          # normal editor
          micro
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

    myWebdev = {
      name = "webdev-toolkit";
      paths = with nodePackages_latest;
        [ h2o nodejs pnpm closurecompiler ];
    };

    # currently not in nixpkgs
    # blockbench dust3d pixelorama material-maker butler

    myGamedev = {
      name = "gamedev-toolkit";
      paths = let
        game-engine = [ godot ];
        shader-material = [
          shadered # shader IDE
          # material-maker
        ];
        pixel-art = [
          # aseprite-unfree # pixel-art editor
          # pixelorama
          xprite-editor # pixel-art editor
          pikopixel # pixel-art editor
          rx # pixel editor
          tiled # tile map editor
        ];
        math = [
          zegrapher # plot equation
          manim # animation engine for explanatory math
          plotutils # collection of plot tools
          openscad # parametric CAD modeling
        ];
        release = [
          # butler # itch.io
        ];
      in
        game-engine
        ++ shader-material
        ++ math
      ;
    };

    myArt = {
      name = "art-toolkit";
      paths = let

        _3d-model = [
          goxel # voxel editor
          # blockbench
          freecad # CAD editor
          sweethome3d.application # interior design
        ];
        _3d-character = [
          # dust3d
        ];
        _2d-animation = [ opentoonz synfigstudio ];
        _2d-drawing = [ krita inkscape ];

        _3d = [ blender ] ++ _3d-model;
        _2d = _2d-animation ++ _2d-drawing;
        misc = [
          gimp # image editor
          opencolorio # color management framework
        ];
      in
        _3d ++ _2d
      ;
    };

    myStream = {
      name = "youtuber-toolkit";
      paths = let
        record = [
          # screen recorder
          obs-gstreamer
          simplescreenrecorder # support OpenGL recording
          # terminal recorder
          asciinema
          termtosvg
        ];
        download = [ youtube-dl tartube ];
        edit = [
          audacity # audio editor
          blender # video editor
          opencolorio # color management
          tts # mozilla deep-learning text-to-speech
          mimic # mycroft machine-learning text-to-speech
          talkfilters # English text to humoruous text
        ];
      in
        record ++ edit;
    };
  };
}
