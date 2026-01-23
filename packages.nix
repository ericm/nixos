{ pkgs, ... }:

with pkgs;
[
  vim
  wget
  git
  virt-manager
  libvirt
  qemu
  nixfmt
  jq
  direnv
  discord
  gnome-shell-extensions
  pkgsi686Linux.gperftools
  libdecor
  vulkan-tools

  # Steam stuff:
  mangohud
  protonup-qt
  protontricks
  winetricks
  wineWowPackages.stable
  lutris
  heroic
  bottles
  gamemode
  libdrm
]
