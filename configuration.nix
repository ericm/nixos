# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # KVM/QEMU virtualization with single GPU passthrough
    ./virtualization.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "eric-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable the X11 windowing system (needed for GDM)
  services.xserver.enable = true;

  # GDM Display Manager with Wayland
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  # Portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = lib.mkMerge [
    # Hyprland
    {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    }
    (import ./utils/read-files.nix {
      inherit pkgs;
      inherit lib;
      dir = ./system-programs;
    })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eric = {
    isNormalUser = true;
    description = "eric";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirt"
      "kvm"
      "input"
      "corectrl"
      "video"
      "render"
      "seat"
    ];
    useDefaultShell = true;
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  # Prevent the new user dialog in zsh
  system.userActivationScripts.zshrc = "touch .zshrc";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = import ./packages.nix { inherit pkgs; };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];



  services.seatd = {
    enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32-bit games
  };

  hardware.graphics.package = pkgs.mesa;
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
    MESA_SHADER_CACHE_DIR = "/home/eric/.cache/mesa-shaders";
    AMD_USERQ = "1";
    SDL_VIDEODRIVER = "wayland";
    ENABLE_GAMESCOPE_WSI = "1";
  };

  hardware.steam-hardware.enable = true;

  # AMDGPU overclocking
  hardware.amdgpu.overdrive.enable = true;

  # LAVD scheduler (sched_ext)
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Set GPU to performance mode on boot
  systemd.services.amdgpu-performance = {
    description = "Set AMD GPU to performance mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      sleep 2
      # Set AMD GPU to high performance
      if [ -f /sys/class/drm/card1/device/power_dpm_force_performance_level ]; then
        echo "high" > /sys/class/drm/card1/device/power_dpm_force_performance_level
        echo "Set card1 to high performance"
      elif [ -f /sys/class/drm/card0/device/power_dpm_force_performance_level ]; then
        echo "high" > /sys/class/drm/card0/device/power_dpm_force_performance_level
        echo "Set card0 to high performance"
      fi
      cat /sys/class/drm/card*/device/power_dpm_force_performance_level
    '';
  };



  security.sudo.extraRules = [
    {
      users = [ "eric" ];
      commands = [
        { command = "/run/current-system/sw/bin/systemctl start cs2-gamescope"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop cs2-gamescope"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  services.udisks2.enable = true;
  security.polkit.enable = true;

  systemd.services.cs2-gamescope = {
    description = "CS2 via Gamescope DRM";
    conflicts = [ "display-manager.service" "getty@tty3.service" "autovt@tty3.service" ];
    after = [ "systemd-logind.service" ];

    serviceConfig = {
      Type = "simple";
      User = "eric";
      TTYPath = "/dev/tty3";
      StandardInput = "tty-force";
      StandardOutput = "journal";
      StandardError = "journal";
      SupplementaryGroups = [ "video" "render" "input" "seat" ];

      Environment = [
        "HOME=/home/eric"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "ENABLE_GAMESCOPE_WSI=1"
        "AMD_VULKAN_ICD=RADV"
        "RADV_PERFTEST=aco"
        "DXVK_ASYNC=1"
      ];

      ExecStartPre = [
        "+${pkgs.systemd}/bin/systemctl stop display-manager.service"
        "+${pkgs.kbd}/bin/chvt 3"
      ];

      ExecStart = let
        launchScript = pkgs.writeShellScript "cs2-gamescope-launch" ''
          exec ${pkgs.gamescope}/bin/gamescope \
            --backend drm \
            --prefer-output DP-1 \
            -w 2560 -h 1440 \
            -r 144 \
            --fullscreen \
            --immediate-flips \
            --force-grab-cursor \
            --adaptive-sync \
            -e -- \
            ${pkgs.util-linux}/bin/taskset -c 2,4,6,8,10 \
            ${pkgs.steam}/bin/steam -tenfoot -steamdeck -gamepadui \
              -applaunch 730 \
              -refresh 300 \
              +engine_low_latency_sleep_after_client_tick true \
              +fps_max 300 \
              -nojoy -high -vulkan \
              +mat_disable_fancy_blending 1 \
              -forcenovsync \
              +r_dynamic 0 \
              +mat_queue_mode 2 \
              +engine_no_focus_sleep 0 \
              -softparticlesdefaultoff \
              -threads 5 \
              +exec autoexec
        '';
      in "${launchScript}";

      ExecStopPost = "+${pkgs.systemd}/bin/systemctl start display-manager.service";

      Restart = "no";
    };
  };

  system.stateVersion = "25.11";

}
