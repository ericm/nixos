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
    defaultCompatTool = "Proton - Experimental";
    apps = {
      cs2 = {
        id = 730;
        compatTool = null; # Run native
        launchOptions = pkgs.lib.concatStringsSep " " [
          # Use env to clear LD_PRELOAD and set vars before gamescope
          # "env"
          "LD_PRELOAD=${pkgs.SDL2}/lib/libSDL2-2.0.so"
          "RADV_PERFTEST=aco"
          "MESA_SHADER_CACHE_DIR=/home/eric/.cache/mesa-shaders"
          "AMD_USERQ=1"
          "SDL_VIDEODRIVER=wayland"
          # "ENABLE_GAMESCOPE_WSI=1"

          # Gamescope
          # "gamescope"
          # "-w 1280"
          # "-h 960"
          # "-W 2560"
          # "-H 1440"
          # "-r 144"
          # "-o 144"
          # "-f"
          # "-S stretch"
          # "--immediate-flips"
          # "--force-grab-cursor"
          # "--mouse-sensitivity 2.0"
          # # "--force-composition"
          # "--backend wayland"
          # "--"

          # Game command
          # "gamemoderun"
          # "mangohud"
          "taskset -c 2,4,6,8"
          "%command%"

          # CS2 launch options
          "-refresh 300"
          "+engine_low_latency_sleep_after_client_tick true"
          "+fps_max 300"
          "-nojoy"
          "-high"
          "-vulkan"
          # "-quit"
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
