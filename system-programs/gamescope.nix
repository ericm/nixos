{ pkgs, ... }:
{
  enable = true;
  args = [
    "-W 2560"
    "-H 1440"
    "-w 2560"
    "-h 1440"
    "-r 144"
    "-f"
    "--immediate-flips"
    "--force-grab-cursor"
    "--backend sdl"
  ];
  capSysNice = true;
}
