{
  config,
  lib,
  pkgs,
  ...
}:

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

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
    }
  );
}
