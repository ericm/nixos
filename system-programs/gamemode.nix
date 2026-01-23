{ pkgs, ... }:
{
  enable = true;
  settings = {
    general = {
      renice = 10;
    };
  };
}
