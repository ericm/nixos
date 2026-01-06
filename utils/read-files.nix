{ lib, dir, ... }:
let
  files = builtins.readDir dir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;
in
builtins.listToAttrs (
  lib.mapAttrsToList (
    name: type:
    let
      nixName = lib.removeSuffix ".nix" name;
      module = import (dir + "/${name}") {
        inherit pkgs lib;
      };
    in
    lib.nameValuePair nixName module
  ) nixFiles
)
