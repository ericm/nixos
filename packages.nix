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
  vesktop
  gnome-shell-extensions
  pkgsi686Linux.gperftools
  libdecor
  vulkan-tools
  dig
  amp
  nodejs_20
  btop
  pciutils
  jetbrains.idea-community
  android-studio  # Includes Android emulator

  # Steam stuff:
  mangohud
  pkgsi686Linux.gamemode
  protonup-qt
  protontricks
  winetricks
  wineWowPackages.stable
  # lutris
  # heroic
  # bottles
  libdrm
]
