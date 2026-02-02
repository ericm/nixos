{ pkgs, ... }:
{
  enable = true;
  package = pkgs.vivaldi;
  extensions = [
    { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
    { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return youtube dislike
    { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
  ];
  commandLineArgs = [
    "--enable-accelerated-2d-canvas"
    "--enable-gpu-rasterization"
    "--enable-smooth-scrolling"
    "--enable-zero-copy"
    "--ignore-gpu-blacklist"
    "--ozone-platform=wayland"
    "--smooth-scrolling"
  ];
}
