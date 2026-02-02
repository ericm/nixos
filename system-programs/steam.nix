{ pkgs, ... }:
{
  enable = true;
  gamescopeSession.enable = false;
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
    defaultCompatTool = "GE-Proton";
    apps = {
      cs2 = {
        id = 730;
        launchOptions = pkgs.lib.concatStringsSep " " [
          # Use env to clear LD_PRELOAD and set vars before gamescope
          # "env"
          "LD_PRELOAD="
          "RADV_PERFTEST=aco"
          "MESA_SHADER_CACHE_DIR=/home/eric/.cache/mesa-shaders"
          "AMD_USERQ=1"
          # "ENABLE_GAMESCOPE_WSI=1"

          # Gamescope
          # "gamescope"
          # "-W 2560"
          # "-H 1440"
          # "-w 2560"
          # "-h 1440"
          # "-r 144"
          # "-f"
          # "--immediate-flips"
          # "--force-grab-cursor"
          # "--mouse-sensitivity 2.0"
          # "--backend sdl"
          # "--"

          # Game command
          # "gamemoderun"
          "taskset -c 2,4,6,8"
          "%command%"

          # CS2 launch options
          "-refresh 144"
          "+engine_low_latency_sleep_after_client_tick true"
          "+fps_max 0"
          "-nojoy"
          "-high"
          "+mat_disable_fancy_blending 1"
          "-forcenovsync"
          "+r_dynamic 0"
          "+mat_queue_mode 2"
          "+engine_no_focus_sleep 0"
          "-softparticlesdefaultoff"
          "-threads 4"
          "+exec autoexec"
        ];
      };
    };
  };
}
