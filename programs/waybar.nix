{ pkgs, ... }:
{
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;
      spacing = 0;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "custom/notification"
      ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
        sort-by-number = true;
      };

      "hyprland/window" = {
        format = "{}";
        max-length = 50;
        separate-outputs = true;
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%A, %B %d, %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = " {usage}%";
        tooltip = true;
        interval = 2;
      };

      memory = {
        format = " {}%";
        interval = 2;
      };

      network = {
        format-wifi = " {signalStrength}%";
        format-ethernet = " {ipaddr}";
        format-disconnected = "⚠ Disconnected";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        on-click = "nm-connection-editor";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " Muted";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
        scroll-step = 5;
      };

      tray = {
        icon-size = 18;
        spacing = 10;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
    };
  };

  style = ''
    @define-color background rgba(30, 30, 46, 0.6);
    @define-color surface rgba(49, 50, 68, 0.6);
    @define-color primary #89b4fa;
    @define-color on_surface #cdd6f4;
    @define-color border_color rgba(137, 180, 250, 0.5);

    * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
    }

    window#waybar {
        background: transparent;
    }

    .modules-left,
    .modules-center,
    .modules-right {
        background-color: @background;
        border-radius: 12px;
        padding: 4px 12px;
        margin: 0 4px;
        border: 2px solid @border_color;
    }

    #workspaces {
        margin: 0 8px 0 0;
    }

    #workspaces button {
        padding: 0 8px;
        margin: 2px 4px;
        border-radius: 8px;
        color: @on_surface;
        background-color: transparent;
        transition: all 0.3s ease;
        border: 2px solid transparent;
    }

    #workspaces button.active {
        color: @background;
        background: @primary;
        border-radius: 10px;
        border-color: @primary;
    }

    #workspaces button:hover {
        background: @surface;
        border-color: @primary;
    }

    #window {
        color: @on_surface;
        padding: 0 10px;
        font-weight: normal;
    }

    window#waybar.empty #window {
        background-color: transparent;
    }

    #clock {
        color: @on_surface;
        font-weight: bold;
    }

    #cpu,
    #memory,
    #network,
    #pulseaudio,
    #tray,
    #custom-notification {
        padding: 0 10px;
        margin: 0 4px;
        color: @on_surface;
    }

    #cpu {
        color: #f38ba8;
    }

    #memory {
        color: #a6e3a1;
    }

    #network {
        color: #89b4fa;
    }

    #network.disconnected {
        color: #f38ba8;
    }

    #pulseaudio {
        color: #fab387;
    }

    #pulseaudio.muted {
        color: #6c7086;
    }

    #tray {
        margin-right: 8px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #custom-notification {
        color: @primary;
    }

    tooltip {
        background-color: @background;
        border: 2px solid @border_color;
        border-radius: 10px;
    }

    tooltip label {
        color: @on_surface;
        padding: 5px;
    }
  '';
}
