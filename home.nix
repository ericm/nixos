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
#  dconf = {
#    enable = true;
#    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
#  };
#
#  xdg.mimeApps.defaultApplicationPackages = [ pkgs.vivaldi ];
#
#  gtk = {
#    enable = true;
#  };
#
#  dconf.settings = {
#    "org/gnome/shell" = {
#      favorite-apps = [
#        # whereis <bin> -> share/application.
#        "code.desktop"
#        "vivaldi-stable.desktop"
#        "org.gnome.Console.desktop"
#        "org.gnome.Nautilus.desktop"
#        "org.gnome.Settings.desktop"
#      ];
#    };
#  };

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
    }
  );
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      disable_logs = false;
    };
    systemd.enable = false;
  };
}
