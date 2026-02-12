{ pkgs, ... }:
{
  enable = true;
  args = [
    "-w 2560"
    "-h 1440"
    "-r 144"
    "--fullscreen"
    "--immediate-flips"
    "--force-grab-cursor"
    "--adaptive-sync"
    "--backend sdl"
    "--expose-wayland"
    "-s 1.0"
  ];
  env = {
    "ENABLE_GAMESCOPE_WSI" = "1";
  };
  capSysNice = true;
}
