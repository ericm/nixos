{
  config,
  lib,
  pkgs,
  ...
}:

let
  dir = ./programs;
  files = builtins.readDir dir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;
  programsConfig = lib.mapAttrs (name: (lib.removeSuffix ".nix" name): import (dir + "/${name}")) nixFiles;
in
{
  home.username = "eric";
  home.homeDirectory = "/home/eric";
  home.stateVersion = "25.11";
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # programs.vivaldi = {
  #   enable = true;
  #   package = pkgs.vivaldi;
  #   extensions = [
  #     { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
  #     { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
  #     { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return youtube dislike
  #   ];
  #   commandLineArgs = [
  #     "--enable-accelerated-2d-canvas"
  #     "--enable-gpu-rasterization"
  #     "--enable-smooth-scrolling"
  #     "--enable-zero-copy"
  #     "--ignore-gpu-blacklist"
  #     "--ozone-platform=wayland"
  #     "--smooth-scrolling"
  #   ];
  # };
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

  # programs.git = {
  #   enable = true;
  #   settings = {
  #     user = {
  #       name = "Eric Moynihan";
  #       email = "git@moynihan.io";
  #     };
  #   };
  # };

  programs = programsConfig;

  # programs.vscode = {
  # };
}
