{ pkgs, ... }:
{
  enable = false;
  settings = {
    general = {
      renice = 10;
    };
  };
}
