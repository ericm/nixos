{
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
    "amp.url" = "https://ampcode.com/";
    #"terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
  };
  keybindings = [
    {
      key = "shift+f";
      command = "workbench.action.terminal.focusFind";
    }
  ];
}
