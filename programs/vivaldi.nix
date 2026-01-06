{ pkgs, ... }:
{
  enable = true;
  package = pkgs.vivaldi;
  extensions = [
    { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
    { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return youtube dislike
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
