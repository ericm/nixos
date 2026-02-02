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

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.vivaldi ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.packages = with pkgs; [
    # Launchers
    wlogout

    # Notifications
    swaynotificationcenter

    # Screenshots and clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # File manager
    nautilus

    # Wallpaper and lock
    hyprpaper
    hyprlock
    hypridle

    # Fonts
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    fira

    # Media
    playerctl
    brightnessctl

    # Misc
    libnotify
    jq
    pavucontrol
    networkmanagerapplet
  ];

  wayland.windowManager.hyprland = import ./programs/hyprland.nix { inherit pkgs; };

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
      exclude = [ "hyprland.nix" ];
    }
  );
}
