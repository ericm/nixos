{ pkgs, ... }:
{
  enable = true;
  # With Oh-My-Zsh:
  ohMyZsh = {
    enable = true;
    plugins = [
      "git" # also requires `programs.git.enable = true;`
    ];
    theme = "robbyrussell";
  };
}
