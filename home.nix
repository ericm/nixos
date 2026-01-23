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
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        enabled-extensions = [ "auto-move-windows@gnome-shell-extensions.gcampax.github.com" ];
      };
    };
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
        "discord.desktop"
        "steam.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
  };

  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs.discord}/share/applications/discord.desktop"
    "${pkgs.steam}/share/applications/steam.desktop"
  ];

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
    }
  );
}
