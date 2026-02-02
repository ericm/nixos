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
      name = "catppuccin-mocha-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
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

    # Lock
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

  services.hyprpaper = import ./programs/hyprpaper.nix { inherit pkgs; };

  xdg.configFile."hypr/scripts/startup-workspace2.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Start Discord on workspace 2
      hyprctl dispatch workspace 2
      discord &

      # Wait for Discord to open
      sleep 2

      # Preselect down direction, then open Vivaldi below
      hyprctl dispatch layoutmsg preselect d
      vivaldi &

      # Return to workspace 1
      sleep 0.5
      hyprctl dispatch workspace 1
    '';
  };

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
      exclude = [ "hyprland.nix" "hyprpaper.nix" ];
    }
  );
}
