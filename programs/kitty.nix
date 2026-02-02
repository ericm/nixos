{ pkgs, ... }:
{
  enable = true;
  settings = {
    font_family = "JetBrainsMono Nerd Font";
    font_size = 12;
    bold_font = "auto";
    italic_font = "auto";
    bold_italic_font = "auto";

    remember_window_size = false;
    initial_window_width = 950;
    initial_window_height = 500;

    cursor_blink_interval = "0.5";
    cursor_stop_blinking_after = 1;

    scrollback_lines = 2000;
    wheel_scroll_min_lines = 1;

    enable_audio_bell = false;
    window_padding_width = 10;
    hide_window_decorations = true;

    background_opacity = "0.85";
    dynamic_background_opacity = true;

    confirm_os_window_close = 0;

    selection_foreground = "none";
    selection_background = "none";

    # Catppuccin Mocha colors
    foreground = "#cdd6f4";
    background = "#1e1e2e";
    cursor = "#f5e0dc";

    color0 = "#45475a";
    color1 = "#f38ba8";
    color2 = "#a6e3a1";
    color3 = "#f9e2af";
    color4 = "#89b4fa";
    color5 = "#f5c2e7";
    color6 = "#94e2d5";
    color7 = "#bac2de";
    color8 = "#585b70";
    color9 = "#f38ba8";
    color10 = "#a6e3a1";
    color11 = "#f9e2af";
    color12 = "#89b4fa";
    color13 = "#f5c2e7";
    color14 = "#94e2d5";
    color15 = "#a6adc8";
  };
}
