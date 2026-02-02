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
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
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
    seatd
  ];

  wayland.windowManager.hyprland = import ./programs/hyprland.nix { inherit pkgs; };

  services.hyprpaper = import ./programs/hyprpaper.nix { inherit pkgs; };

  # CS2 autoexec
  home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".text =
    ''
      // Network
      rate 786432
      cl_interp_ratio 1
      cl_interp 0

      // Performance
      func_break_max_pieces 0
      r_drawtracers_firstperson 0
      cl_disable_ragdolls 1

      echo "autoexec.cfg loaded"
    '';

  xdg.configFile."hypr/scripts/startup-workspace2.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Start Discord on workspace 2
      hyprctl dispatch workspace 2
      vesktop &

      # Wait for Discord to open
      sleep 3

      # Ensure we're on workspace 2, preselect down, open Vivaldi
      hyprctl dispatch workspace 2
      hyprctl dispatch layoutmsg preselect d
      vivaldi &

      # Return to workspace 1
      sleep 1
      hyprctl dispatch workspace 1
    '';
  };

  programs = (
    import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./programs;
      exclude = [
        "hyprland.nix"
        "hyprpaper.nix"
      ];
    }
  );
}
