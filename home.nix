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

  xdg.configFile."hypr/scripts/gamemode.sh" = {
    executable = true;
    text = ''
      #!/run/current-system/sw/bin/bash
      export PATH="/run/current-system/sw/bin:$PATH"
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr/ 2>/dev/null | head -1)

      hyprctl -q --batch "\
          keyword animations:enabled 0;\
          keyword decoration:shadow:enabled 0;\
          keyword decoration:blur:xray 1;\
          keyword decoration:blur:enabled 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0 ;\
          keyword decoration:active_opacity 1 ;\
          keyword decoration:inactive_opacity 1 ;\
          keyword decoration:fullscreen_opacity 1 ;\
          keyword layerrule noanim,waybar ;\
          keyword layerrule noanim,swaync-notification-window ;\
          keyword layerrule noanim,swww-daemon ;\
          keyword layerrule noanim,rofi
          "
      hyprctl 'keyword windowrule opaque,class:(.*)'

      "$@"

      hyprctl reload config-only -q
    '';
  };

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

  # Hyprland session save script - run before logout
  xdg.configFile."hypr/scripts/session-save.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      SESSION_FILE="$HOME/.cache/hyprland-session.json"
      
      # Get all windows with their workspace and class
      hyprctl clients -j | jq '[.[] | {class: .class, workspace: .workspace.id}]' > "$SESSION_FILE"
      
      notify-send "Session saved" "$(jq length "$SESSION_FILE") windows saved"
    '';
  };

  # Hyprland session restore script - run on startup
  xdg.configFile."hypr/scripts/session-restore.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      SESSION_FILE="$HOME/.cache/hyprland-session.json"
      
      if [ ! -f "$SESSION_FILE" ]; then
        exit 0
      fi
      
      # Read saved session and launch apps
      jq -r '.[] | "\(.workspace) \(.class)"' "$SESSION_FILE" | sort -u | while read -r ws class; do
        # Skip already running apps
        if hyprctl clients -j | jq -e ".[] | select(.class == \"$class\")" > /dev/null 2>&1; then
          continue
        fi
        
        # Map class names to executables (add more as needed)
        case "$class" in
          "kitty") cmd="kitty" ;;
          "vivaldi-stable") cmd="vivaldi" ;;
          "vesktop") cmd="vesktop" ;;
          "discord") cmd="discord" ;;
          "steam") cmd="steam" ;;
          "org.gnome.Nautilus") cmd="nautilus" ;;
          "code"|"Code") cmd="code" ;;
          *) cmd="" ;;
        esac
        
        if [ -n "$cmd" ]; then
          hyprctl dispatch workspace "$ws"
          $cmd &
          sleep 0.5
        fi
      done
      
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
