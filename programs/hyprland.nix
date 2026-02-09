{ pkgs, ... }:
{
  enable = true;
  settings = {
    "$mod" = "SUPER";

    monitor = [
      "DP-1,2560x1440@144,0x0,1"
      "HDMI-A-1,1920x1080@60,-1080x-200,1,transform,1"
    ];

    # General window layout
    general = {
      gaps_in = 10;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      layout = "dwindle";
      resize_on_border = true;
      no_border_on_floating = false;
    };

    # Smart gaps - no gaps/border when only one window
    workspace = [
      "w[tv1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];

    windowrulev2 = [
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "rounding 0, floating:0, onworkspace:w[tv1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 0, floating:0, onworkspace:f[1]"
      "workspace 2 silent,class:^(discord)$"
      "float,class:^(.*pavucontrol.*)$"
      "size 800 600,class:^(.*pavucontrol.*)$"
      "center,class:^(.*pavucontrol.*)$"
    ];

    # Decoration (blur, shadows, rounding) - Glass effect
    decoration = {
      rounding = 14;
      active_opacity = 0.95;
      inactive_opacity = 0.85;
      fullscreen_opacity = 1.0;

      blur = {
        enabled = true;
        size = 8;
        passes = 4;
        new_optimizations = true;
        ignore_opacity = true;
        xray = true;
        noise = 0.01;
        contrast = 1.0;
        brightness = 1.0;
        vibrancy = 0.2;
        vibrancy_darkness = 0.5;
        popups = true;
      };

      shadow = {
        enabled = true;
        range = 40;
        render_power = 3;
        color = "rgba(00000066)";
      };
    };

    # Animations (End-4 style)
    animations = {
      enabled = true;

      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
        "md2, 0.4, 0, 0.2, 1"
      ];

      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "windowsIn, 1, 3, md3_decel, popin 60%"
        "windowsOut, 1, 3, md3_accel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 3, md3_decel"
        "layersIn, 1, 3, menu_decel, slide"
        "layersOut, 1, 1.6, menu_accel"
        "fadeLayersIn, 1, 2, menu_decel"
        "fadeLayersOut, 1, 4.5, menu_accel"
        "workspaces, 1, 7, menu_decel, slide"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };

    # Layouts
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      # new_status = "master";
    };

    # Input
    input = {
      kb_layout = "gb";
      follow_mouse = 1;
      sensitivity = 0;
    };

    # Misc
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      initial_workspace_tracking = 1;
    };

    # Keybindings (ML4W style)
    bind = [
      # Applications
      "$mod, Return, exec, kitty"
      "$mod, B, exec, vivaldi"
      "$mod, E, exec, nautilus"

      # Windows
      "$mod, Q, killactive"
      "$mod, F, fullscreen, 0"
      "$mod, M, fullscreen, 1"
      "$mod, T, togglefloating"
      "$mod SHIFT, T, workspaceopt, allfloat"
      "$mod, J, togglesplit"
      "$mod, K, swapsplit"
      "$mod, G, togglegroup"

      # Focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Resize with keyboard
      "$mod SHIFT, right, resizeactive, 100 0"
      "$mod SHIFT, left, resizeactive, -100 0"
      "$mod SHIFT, down, resizeactive, 0 100"
      "$mod SHIFT, up, resizeactive, 0 -100"

      # Swap windows
      "$mod ALT, left, swapwindow, l"
      "$mod ALT, right, swapwindow, r"
      "$mod ALT, up, swapwindow, u"
      "$mod ALT, down, swapwindow, d"

      # Alt-Tab
      "ALT, Tab, cyclenext"
      "ALT, Tab, bringactivetotop"

      # Actions
      "$mod CTRL, R, exec, hyprctl reload"
      "$mod, D, exec, rofi -show drun"
      "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mod, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mod ALT, F, exec, grim - | wl-copy"
      "$mod CTRL, Q, exec, wlogout"
      "$mod CTRL, L, exec, hyprlock"

      # Workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      "$mod, Tab, workspace, m+1"
      "$mod SHIFT, Tab, workspace, m-1"

      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
      "$mod CTRL, down, workspace, empty"

      # Media keys
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # Custom
      "$mod SHIFT, H, exec, /etc/libvirt/hibernate-gpu-vm.sh"
      "$mod, slash, exec, cat ~/.config/hypr/keybinds.txt | rofi -dmenu -i -p 'Keybinds'"
      "$mod SHIFT, F, movetoworkspace, empty"
      "$mod, S, exec, pavucontrol"
      "$mod SHIFT, S, exec, ~/.config/hypr/scripts/session-save.sh"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    exec-once = [
      "waybar"
      "swaync"
      "wl-paste --watch cliphist store"
      "hypridle"
      "~/.config/hypr/scripts/startup-workspace2.sh"
      "steam -silent"
      "~/.config/hypr/scripts/session-restore.sh"
    ];
  };
}
