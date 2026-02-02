{ pkgs, ... }:
{
  enable = false;
  settings = {
    general = {
      renice = 10;
    };
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
      amd_performance_level = "high";
    };

    # custom = {
    #   start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
    #   end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    # };
  };
  enableRenice = true;
}
