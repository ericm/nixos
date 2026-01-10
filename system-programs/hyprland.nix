{ pkgs, ... }:
{
  enable = true;
  withUWSM = true;
  package = pkgs.hyprland;
  portalPackage = pkgs.xdg-desktop-portal-hyprland;
  xwayland.enable = true;
}
