{
  config,
  lib,
  pkgs,
  ...
}:

let
  dir = ./programs.nix;
  files = builtins.readDir dir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;
  programsField = lib.mapAttrs (name: _: import (dir + "/${name}")) nixFiles;
in
{
  home.username = "eric";
  home.homeDirectory = "/home/eric";
  home.stateVersion = "25.11";
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return youtube dislike
    ];
    commandLineArgs = [
      "--enable-accelerated-2d-canvas"
      "--enable-gpu-rasterization"
      "--enable-smooth-scrolling"
      "--enable-zero-copy"
      "--ignore-gpu-blacklist"
      "--ozone-platform=wayland"
      "--smooth-scrolling"
    ];
  };
  xdg.mimeApps.defaultApplicationPackages = [ pkgs.vivaldi ];

  gtk = {
    enable = true;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        # whereis <bin> -> share/application.
        "code.desktop"
        "vivaldi-stable.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Eric Moynihan";
        email = "git@moynihan.io";
      };
    };
  };

  # programs = programsConfig;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      eamodio.gitlens
      (ms-vscode-remote.remote-ssh.override {
        useLocalExtensions = true;
      })

      bierner.comment-tagged-templates
      bierner.emojisense
      bierner.markdown-checkbox
      bierner.markdown-emoji
      bierner.markdown-preview-github-styles
      editorconfig.editorconfig
      mkhl.direnv
      shardulm94.trailing-spaces
      sourcegraph.amp

      # Theme
      mskelton.one-dark-theme
      pkief.material-icon-theme

      # Language support
      dbaeumer.vscode-eslint
      jnoortheen.nix-ide
      xadillax.viml
      nefrob.vscode-just-syntax
      golang.go
    ];
    profiles.default.userSettings = {
      # Much of the following adapted from https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
      "editor.tabSize" = 2;
      "editor.fontLigatures" = true;
      "editor.guides.indentation" = true;
      "editor.insertSpaces" = true;
      "editor.formatOnSave" = true;
      "editor.suggestSelection" = "first";
      "editor.scrollBeyondLastLine" = false;
      "editor.cursorBlinking" = "solid";
      "editor.minimap.enabled" = false;
      "files.trimTrailingWhitespace" = true;
      "workbench.colorTheme" = "One Dark";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.accessibilitySupport" = "off";
      "oneDark.bold" = true;
      "window.zoomLevel" = 1;
      "window.menuBarVisibility" = "visible";
      #"terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
    };
    keybindings = [
      {
        key = "shift+f";
        command = "workbench.action.terminal.focusFind";
      }
    ];
  };
}
