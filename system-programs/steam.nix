{ pkgs, ... }:
{
  enable = true;
  gamescopeSession.enable = true;
  extraCompatPackages = [ pkgs.proton-ge-bin ];
  package = pkgs.steam.override {
    extraPkgs = pkgs': [
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
    ];
  };
  protontricks.enable = true;
  remotePlay.openFirewall = true;
  localNetworkGameTransfers.openFirewall = true;
  extraPackages = with pkgs; [ gamemode ];
  config = {
    enable = true;
    closeSteam = true;
    defaultCompatTool = "Proton - Experimental";
    apps = {
      cs2 = {
        id = 730;
        compatTool = null; # Run native
        launchOptions = pkgs.lib.concatStringsSep " " [
          "LD_PRELOAD=${pkgs.SDL2}/lib/libSDL2-2.0.so"
          "~/.config/hypr/scripts/gamemode.sh"
          "gamemoderun"
          "taskset -c 2,4,6,8,10"
          "%command%"
          "-refresh 300"
          "+engine_low_latency_sleep_after_client_tick true"
          "+fps_max 300"
          "-nojoy"
          "-high"
          "-vulkan"
          "+mat_disable_fancy_blending 1"
          "-forcenovsync"
          "+r_dynamic 0"
          "+mat_queue_mode 2"
          "+engine_no_focus_sleep 0"
          "-softparticlesdefaultoff"
          "-threads 5"
          "+exec autoexec"
        ];
      };
    };
  };
}
