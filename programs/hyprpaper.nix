{ pkgs, ... }:
{
  enable = true;
  settings = {
    preload = [ "~/Pictures/wallpapers/default.jpg" ];
    wallpaper = [
      "DP-1,~/Pictures/wallpapers/default.jpg"
      "HDMI-A-1,~/Pictures/wallpapers/default.jpg"
    ];
    splash = false;
  };
}
