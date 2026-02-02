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
      echo "autoexec.cfg loaded"
    '';

  xdg.configFile."hypr/scripts/cs2-gamescope.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Run from TTY2: Ctrl+Alt+F2, login, then run this script

      # Environment variables
      export LD_PRELOAD=""
      export RADV_PERFTEST=aco
      export MESA_SHADER_CACHE_DIR=/home/eric/.cache/mesa-shaders
      export AMD_USERQ=1
      export XDG_SESSION_TYPE=wayland
      export SDL_VIDEODRIVER=wayland

      gamescope \
        -W 2560 -H 1440 \
        -w 2560 -h 1440 \
        -r 144 \
        -f \
        --immediate-flips \
        --force-grab-cursor \
        --mouse-sensitivity 2.0 \
        --backend sdl \
        -- steam -applaunch 730 \
          -refresh 280 \
          +engine_low_latency_sleep_after_client_tick true \
          +fps_max 0 \
          -nojoy \
          -high \
          +mat_disable_fancy_blending 1 \
          -forcenovsync \
          +r_dynamic 0 \
          +mat_queue_mode 2 \
          +engine_no_focus_sleep 0 \
          -softparticlesdefaultoff \
          -threads 4
    '';
  };

  xdg.configFile."hypr/scripts/startup-workspace2.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Start Discord on workspace 2
      hyprctl dispatch workspace 2
      discord &

      # Wait for Discord to open
      sleep 3

      # Ensure we're on workspace 2, preselect down, open Vivaldi
      hyprctl dispatch workspace 2
      hyprctl dispatch layoutmsg preselect d
      vivaldi --new-window about:blank &

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
