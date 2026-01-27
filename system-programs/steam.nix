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
    defaultCompatTool = "GE-Proton";
    apps = {
      cs2 = {
        id = 730;
        launchOptions = pkgs.lib.concatStringsSep " " [
          # "SDL_VIDEODRIVER=x11"
          # "SDL_VIDEODRIVER=wayland WAYLAND_DISPLAY=wayland-0"
          "LD_PRELOAD=\"\""
          # "LD_PRELOAD=\"${pkgs.lib.getLib pkgs.pkgsi686Linux.gamemode}/lib/libgamemode.so:${pkgs.lib.getLib pkgs.gamemode}/lib/libgamemode.so\""
          # "LD_LIBRARY_PATH=\"/run/opengl-driver/lib:/run/opengl-driver-32/lib\""
          # "RADV_PERFTEST=nggc,shaders"
          "RADV_PERFTEST=aco"
          # "SDL_VIDEO_DRIVER=wayland"
          "MESA_SHADER_CACHE_DIR=/home/eric/.cache/mesa-shaders"
          "VK_ICD_FILENAMES=\"/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json\""
          "NIXOS_OZONE_WL=1"
          "ENABLE_GAMESCOPE_WSI=1"
          "AMD_USERQ=1"
          "gamescope"
          # "-W 2560"
          # "-H 1440"
          "-w 2560"
          "-h 1440"
          "-r 144"
          "--fullscreen"
          "--immediate-flips"
          "--force-grab-cursor"
          "--adaptive-sync"
          # "--backend sdl"
          "--backend wayland"
          # "--backend headless"
          "--expose-wayland"
          "-s 1.0"
          "taskset -c 2,4,6,8"
          "--"
          "gamemoderun"
          "%command%"
          "-refresh 144"
          "+engine_low_latency_sleep_after_client_tick true"
          "+fps_max 0"
          "-vulkan"
          "-novid"
          "-nojoy"
          "-high"
          "+mat_disable_fancy_blending 1"
          "-forcenovsync"
          "+r_dynamic 0"
          "+mat_queue_mode 2"
          "+engine_no_focus_sleep 0"
          "-softparticlesdefaultoff"
          "-vulkan_disable_steam_shader_cache"
          "-threads 4"
          "+exec autoexec"
          "> ~/gamescope_cs2_debug.log 2>&1"
        ];
      };
    };
  };
}
