{ pkgs, ... }:
{
  enable = true;
  args = [
    "-w 2560"
    "-h 1440"
    "-r 144"
    "--fullscreen"
    "--immediate-flips"
    "--force-grab-cursor"
    "--adaptive-sync"
    "--backend wayland"
    "--expose-wayland"
    "-s 1.0"
  ];
  # env = {
  #   "LD_PRELOAD" = "";
  #   "RADV_PERFTEST" = "nggc,shaders";
  #   # "MESA_SHADER_CACHE_DIR" = "/home/eric/.cache/mesa-shaders";
  #   "VK_ICD_FILENAMES" =
  #     "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
  #   "NIXOS_OZONE_WL" = "1";
  #   "ENABLE_GAMESCOPE_WSI" = "1";
  #   "AMD_USERQ" = "1";
  # };
  capSysNice = false;
}
