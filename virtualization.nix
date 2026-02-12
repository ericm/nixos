{
  config,
  pkgs,
  lib,
  ...
}:
let
  # GPU PCI addresses
  gpuPciAddress = "pci_0000_0a_00_0";
  gpuAudioPciAddress = "pci_0000_0a_00_1";

  # Autounattend.xml for unattended Windows install
  autounattendXml = pkgs.writeText "Autounattend.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <unattend xmlns="urn:schemas-microsoft-com:unattend">
      <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
          <SetupUILanguage>
            <UILanguage>en-US</UILanguage>
          </SetupUILanguage>
          <InputLocale>0409:00000409</InputLocale>
          <SystemLocale>en-US</SystemLocale>
          <UILanguage>en-US</UILanguage>
          <UserLocale>en-US</UserLocale>
        </component>
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
          <DiskConfiguration>
            <Disk wcm:action="add">
              <DiskID>0</DiskID>
              <WillWipeDisk>true</WillWipeDisk>
              <CreatePartitions>
                <CreatePartition wcm:action="add">
                  <Order>1</Order>
                  <Size>100</Size>
                  <Type>EFI</Type>
                </CreatePartition>
                <CreatePartition wcm:action="add">
                  <Order>2</Order>
                  <Size>16</Size>
                  <Type>MSR</Type>
                </CreatePartition>
                <CreatePartition wcm:action="add">
                  <Order>3</Order>
                  <Extend>true</Extend>
                  <Type>Primary</Type>
                </CreatePartition>
              </CreatePartitions>
              <ModifyPartitions>
                <ModifyPartition wcm:action="add">
                  <Order>1</Order>
                  <PartitionID>1</PartitionID>
                  <Format>FAT32</Format>
                  <Label>System</Label>
                </ModifyPartition>
                <ModifyPartition wcm:action="add">
                  <Order>2</Order>
                  <PartitionID>2</PartitionID>
                </ModifyPartition>
                <ModifyPartition wcm:action="add">
                  <Order>3</Order>
                  <PartitionID>3</PartitionID>
                  <Format>NTFS</Format>
                  <Label>Windows</Label>
                  <Letter>C</Letter>
                </ModifyPartition>
              </ModifyPartitions>
            </Disk>
          </DiskConfiguration>
          <ImageInstall>
            <OSImage>
              <InstallTo>
                <DiskID>0</DiskID>
                <PartitionID>3</PartitionID>
              </InstallTo>
            </OSImage>
          </ImageInstall>
          <UserData>
            <AcceptEula>true</AcceptEula>
            <ProductKey>
              <Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
              <WillShowUI>Never</WillShowUI>
            </ProductKey>
          </UserData>
        </component>
      </settings>
      <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
          <OOBE>
            <HideEULAPage>true</HideEULAPage>
            <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            <ProtectYourPC>3</ProtectYourPC>
          </OOBE>
          <FirstLogonCommands>
            <SynchronousCommand wcm:action="add">
              <Order>1</Order>
              <CommandLine>netsh advfirewall firewall set rule group="remote desktop" new enable=yes</CommandLine>
              <Description>Enable RDP Firewall</Description>
            </SynchronousCommand>
            <SynchronousCommand wcm:action="add">
              <Order>2</Order>
              <CommandLine>reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f</CommandLine>
              <Description>Enable RDP</Description>
            </SynchronousCommand>
          </FirstLogonCommands>
          <UserAccounts>
            <LocalAccounts>
              <LocalAccount wcm:action="add">
                <Name>User</Name>
                <Group>Administrators</Group>
                <Password>
                  <Value>password</Value>
                  <PlainText>true</PlainText>
                </Password>
              </LocalAccount>
            </LocalAccounts>
          </UserAccounts>
          <AutoLogon>
            <Enabled>true</Enabled>
            <Username>User</Username>
            <Password>
              <Value>password</Value>
              <PlainText>true</PlainText>
            </Password>
            <LogonCount>999</LogonCount>
          </AutoLogon>
        </component>
      </settings>
    </unattend>
  '';

  # Create an ISO with autounattend.xml
  autounattendIso =
    pkgs.runCommand "autounattend.iso"
      {
        nativeBuildInputs = [ pkgs.cdrkit ];
      }
      ''
        mkdir -p iso
        cp ${autounattendXml} iso/autounattend.xml
        ${pkgs.cdrkit}/bin/genisoimage -o $out -J -r iso
      '';

  # VM definitions - add more VMs here
  # For fresh Windows install, temporarily set:
  #   autoinstall = true;
  #   gpuPassthrough = false;
  # And change boot order in mkVmXml to: <boot dev='cdrom'/> before <boot dev='hd'/>
  # After install, revert these settings.
  vms = {
    windows = {
      memory = 20;
      cores = 12;
      threads = 1;
      diskSize = "400G";
      clockOffset = "localtime";
      hyperv = true;
      iso = "/home/eric/ISOs/Win10.iso"; # Set to path or URL, e.g., "/home/eric/ISOs/Win11.iso"
      autoinstall = false; # Set to true only for fresh install
      gpuPassthrough = true; # GPU passthrough enabled
      cpuPinning = [
        4
        5
        6
        7
        8
        9
        10
        11
        12
        13
        14
        15
      ]; # Pin vCPUs to physical cores 4-15 (leave 0-3 for host)
      # Evdev passthrough - press both Super keys to switch input between host/VM
      # Uncomment when using GPU passthrough:
      evdevKeyboard = "/dev/input/by-id/usb-Ducky_Ducky_One2_Mini_RGB_DK-V1.08-200925-event-kbd";
      evdevMouse = "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse";
    };
    # linux = {
    #   memory = 8;
    #   cores = 2;
    #   threads = 2;
    #   diskSize = "50G";
    #   clockOffset = "utc";
    #   hyperv = false;
    #   iso = null; # Set to path, e.g., "/home/eric/ISOs/nixos.iso"
    # };
    # Add more VMs:
    # windows11 = { memory = 16; cores = 4; threads = 2; diskSize = "100G"; clockOffset = "localtime"; hyperv = true; iso = null; };
  };

  # Virtio drivers ISO (fetched directly since nixpkgs no longer provides the ISO)
  virtioWinIso = pkgs.fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.262-2/virtio-win-0.1.262.iso";
    sha256 = "sha256-vcKtFyegi22KWdQOES2TD1Ois1S974WQOrqtiWIU8KM=";
  };

  # Generate VM XML template
  mkVmXml = name: cfg: ''
    <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
      <name>${name}</name>
      <memory unit='GiB'>${toString cfg.memory}</memory>
      <vcpu placement='static'>${toString (cfg.cores * cfg.threads)}</vcpu>
      <os>
        <type arch='x86_64' machine='q35'>hvm</type>
        <loader readonly='yes' type='pflash'>/run/libvirt/nix-ovmf/edk2-x86_64-code.fd</loader>
        <nvram>/var/lib/libvirt/qemu/nvram/${name}_VARS.fd</nvram>
        <boot dev='hd'/>
        <boot dev='cdrom'/>
      </os>
      <features>
        <acpi/>
        <apic/>
        ${lib.optionalString cfg.hyperv ''
          <hyperv mode='custom'>
            <relaxed state='on'/>
            <vapic state='on'/>
            <spinlocks state='on' retries='8191'/>
            <vpindex state='on'/>
            <runtime state='on'/>
            <synic state='on'/>
            <stimer state='on'/>
            <reset state='on'/>
            <vendor_id state='on' value='randomid'/>
            <frequencies state='on'/>
          </hyperv>
        ''}
        <kvm>
          <hidden state='on'/>
        </kvm>
        <vmport state='off'/>
        <ioapic driver='kvm'/>
      </features>
      <cpu mode='host-passthrough' check='none' migratable='on'>
        <topology sockets='1' dies='1' cores='${toString cfg.cores}' threads='${toString cfg.threads}'/>
        <feature policy='require' name='topoext'/>
      </cpu>
      ${lib.optionalString (cfg.cpuPinning or [ ] != [ ]) ''
        <cputune>
          ${lib.concatImapStringsSep "\n        " (
            i: core: "<vcpupin vcpu='${toString (i - 1)}' cpuset='${toString core}'/>"
          ) cfg.cpuPinning}
        </cputune>
      ''}
      <clock offset='${cfg.clockOffset}'>
        <timer name='rtc' tickpolicy='catchup'/>
        <timer name='pit' tickpolicy='delay'/>
        <timer name='hpet' present='no'/>
        ${lib.optionalString cfg.hyperv "<timer name='hypervclock' present='yes'/>"}
      </clock>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <pm>
        <suspend-to-mem enabled='no'/>
        <suspend-to-disk enabled='no'/>
      </pm>
      <devices>
        <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' cache='writeback' discard='unmap'/>
          <source file='/var/lib/libvirt/images/${name}.qcow2'/>
          <target dev='sda' bus='sata'/>
        </disk>
        ${lib.optionalString (cfg.iso != null) ''
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <source file='${cfg.iso}'/>
            <target dev='sdb' bus='sata'/>
            <readonly/>
          </disk>
        ''}
        ${lib.optionalString (cfg.iso == null) ''
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <target dev='sdb' bus='sata'/>
            <readonly/>
          </disk>
        ''}
        ${lib.optionalString cfg.hyperv ''
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <source file='${virtioWinIso}'/>
            <target dev='sdc' bus='sata'/>
            <readonly/>
          </disk>
        ''}
        ${lib.optionalString (cfg.autoinstall or false) ''
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <source file='${autounattendIso}'/>
            <target dev='sdd' bus='sata'/>
            <readonly/>
          </disk>
        ''}
        <controller type='usb' model='qemu-xhci' ports='15'/>
        <controller type='pci' model='pcie-root'/>
        <controller type='pci' model='pcie-root-port'/>
        <controller type='pci' model='pcie-root-port'/>
        <controller type='pci' model='pcie-root-port'/>
        <controller type='pci' model='pcie-root-port'/>
        <controller type='sata'/>
        <interface type='network'>
          <source network='default'/>
          <model type='virtio'/>
        </interface>
        <input type='tablet' bus='usb'/>
        <input type='keyboard' bus='usb'/>
        ${lib.optionalString (cfg.evdevKeyboard or null != null) ''
          <input type='evdev'>
            <source dev='${cfg.evdevKeyboard}' grab='all' grabToggle='meta-meta' repeat='on'/>
          </input>
        ''}
        ${lib.optionalString (cfg.evdevMouse or null != null) ''
          <input type='evdev'>
            <source dev='${cfg.evdevMouse}' grab='all' grabToggle='meta-meta'/>
          </input>
        ''}
        <sound model='ich9'/>
        <memballoon model='virtio'/>
        <graphics type='spice' autoport='yes'>
          <listen type='address' address='127.0.0.1'/>
        </graphics>
        <channel type='spicevmc'>
          <target type='virtio' name='com.redhat.spice.0'/>
        </channel>
        ${lib.optionalString (!(cfg.gpuPassthrough or false)) ''
        <video>
          <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
        </video>
        ''}
        ${lib.optionalString (cfg.gpuPassthrough or false) ''
        <video>
          <model type='none'/>
        </video>
        ''}
        ${lib.optionalString (cfg.gpuPassthrough or false) ''
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x0a' slot='0x00' function='0x0'/>
          </source>
          <rom bar='on'/>
        </hostdev>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x0a' slot='0x00' function='0x1'/>
          </source>
        </hostdev>
        ''}
      </devices>
    </domain>
  '';

  # Libvirt hook helper script
  qemuHook = pkgs.writeShellScript "qemu" ''
    GUEST_NAME="$1"
    HOOK_NAME="$2"
    STATE_NAME="$3"

    BASEDIR="$(dirname $0)"
    HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

    set -e

    if [ -f "$HOOKPATH" ]; then
      eval "$HOOKPATH" "$@"
    elif [ -d "$HOOKPATH" ]; then
      while read file; do
        eval "$file" "$@"
      done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print)"
    fi
  '';

  # Start hook - runs when VM starts (unbinds GPU from host)
  # Set keepHostDisplay = true in VM config to skip unbinding (for driver installation)
  startHook =
    vmName:
    pkgs.writeShellScript "start.sh" ''
      set -x
      exec > /var/log/libvirt-hooks-${vmName}.log 2>&1

      # Check if we should keep host display
      if [ -f /tmp/keep-host-display ]; then
        echo "Keeping host display, skipping GPU unbind"
        exit 0
      fi

      # Save Hyprland session before stopping display
      echo "Saving Hyprland session..."
      su - eric -c 'export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /tmp/hypr/ 2>/dev/null | head -1); ~/.config/hypr/scripts/session-save.sh' || true

      # Stop display manager
      systemctl stop display-manager.service || true
      sleep 2

      # Unbind VTconsoles
      echo 0 > /sys/class/vtconsole/vtcon0/bind || true
      echo 0 > /sys/class/vtconsole/vtcon1/bind || true

      # Unbind EFI Framebuffer (comment out for AMD 6000+ series)
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true

      # Detach GPU from host FIRST (required for AMD)
      ${pkgs.libvirt}/bin/virsh nodedev-detach ${gpuPciAddress} || true
      ${pkgs.libvirt}/bin/virsh nodedev-detach ${gpuAudioPciAddress} || true

      # Unload AMD GPU modules AFTER detaching (AMD-specific order)
      modprobe -r amdgpu || true

      # Load VFIO
      modprobe vfio-pci
    '';

  # Stop hook - runs when VM stops (rebinds GPU to host)
  stopHook =
    vmName:
    pkgs.writeShellScript "stop.sh" ''
      set -x
      exec >> /var/log/libvirt-hooks-${vmName}.log 2>&1

      echo "=== Stop hook starting at $(date) ==="

      # Unload VFIO first
      modprobe -r vfio-pci || true
      sleep 1

      # Reattach GPU to host
      ${pkgs.libvirt}/bin/virsh nodedev-reattach ${gpuPciAddress} || true
      ${pkgs.libvirt}/bin/virsh nodedev-reattach ${gpuAudioPciAddress} || true
      sleep 1

      # Load AMD GPU modules
      modprobe amdgpu
      sleep 3

      # Rebind VTconsoles
      echo 1 > /sys/class/vtconsole/vtcon0/bind || true
      echo 1 > /sys/class/vtconsole/vtcon1/bind || true

      # Rebind EFI framebuffer (may fail on newer GPUs - that's OK)
      echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind 2>/dev/null || true

      # Wait for GPU to initialize before starting display manager
      sleep 2

      # Restart display manager
      echo "Starting display-manager..."
      systemctl start display-manager.service
      echo "=== Stop hook completed at $(date) ==="
    '';
in
{
  # Kernel parameters for IOMMU (AMD) and GPU passthrough
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "video=efifb:off"
    "kvm.ignore_msrs=1"          # Ignore unsupported MSR accesses
    "kvm.report_ignored_msrs=0"  # Don't spam logs
    "amdgpu.dcdebugmask=0x10"
  ];

  # Kernel modules for VFIO
  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vendor-reset" # Fix AMD GPU reset bug
  ];

  # Vendor-reset for AMD Navi GPUs
  boot.extraModulePackages = [ pkgs.linuxPackages.vendor-reset ];

  # Enable libvirtd
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
    onBoot = "ignore";
    onShutdown = "shutdown";
    allowedBridges = [ "virbr0" ];
  };

  # Enable default NAT network
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
  };

  # Allow QEMU access to input devices for evdev passthrough
  users.users.root.extraGroups = [ "input" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="input", GROUP="input", MODE="0660"
    # Force vendor-reset for AMD Navi GPU (fixes reset bug)
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x731f", ATTR{reset_method}="device_specific"
  '';

  # Enable spice USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Virt-manager
  programs.virt-manager.enable = true;

  # Auto-setup VMs after rebuild
  systemd.services.libvirt-vm-setup = {
    description = "Setup libvirt VMs";
    after = [
      "libvirtd.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.qemu
      pkgs.libvirt
    ];
    restartTriggers = [
      virtioWinIso
    ]
    ++ lib.mapAttrsToList (name: cfg: mkVmXml name cfg) vms;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for libvirtd to be ready
      sleep 2

      # Ensure default network exists and is running
      if ! virsh net-info default >/dev/null 2>&1; then
        virsh net-define /etc/libvirt/qemu/networks/default.xml || true
      fi
      virsh net-start default 2>/dev/null || true
      virsh net-autostart default 2>/dev/null || true

      # Create hook directories for GPU passthrough VMs
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: cfg: lib.optionalString (cfg.gpuPassthrough or false) ''
          echo "Creating hooks for ${name}..."
          mkdir -p /var/lib/libvirt/hooks/qemu.d/${name}/prepare/begin
          mkdir -p /var/lib/libvirt/hooks/qemu.d/${name}/release/end
          ln -sf ${startHook name} /var/lib/libvirt/hooks/qemu.d/${name}/prepare/begin/start.sh
          ln -sf ${stopHook name} /var/lib/libvirt/hooks/qemu.d/${name}/release/end/stop.sh
        '') vms
      )}

      # Create VM disk images
      mkdir -p /var/lib/libvirt/images
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: cfg: ''
          if [ ! -f /var/lib/libvirt/images/${name}.qcow2 ]; then
            echo "Creating ${name} disk (${cfg.diskSize})..."
            qemu-img create -f qcow2 /var/lib/libvirt/images/${name}.qcow2 ${cfg.diskSize}
          fi
        '') vms
      )}

      # Import/update VM definitions
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: cfg: ''
          if virsh list --name | grep -q "^${name}$"; then
            echo "Stopping ${name}..."
            virsh destroy ${name} 2>/dev/null || true
          fi
          if virsh list --all --name | grep -q "^${name}$"; then
            echo "Updating ${name}..."
            virsh undefine ${name} --nvram 2>/dev/null || virsh undefine ${name} || true
          fi
          # Remove old NVRAM to ensure fresh boot order
          rm -f /var/lib/libvirt/qemu/nvram/${name}_VARS.fd
          echo "Defining ${name}..."
          virsh define /etc/libvirt/vm-templates/${name}.xml
        '') vms
      )}

      echo "VM setup complete"
    '';
  };

  # Required packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    OVMF
    swtpm
    looking-glass-client
    virtio-win
    pciutils
    tigervnc  # VNC client/server
    
    # Script to hibernate Windows VM and return to host
    (pkgs.writeShellScriptBin "vm-hibernate" ''
      # Save VM state and stop (releases GPU, triggers stop hook)
      virsh managedsave windows
      echo "VM hibernated. GPU returned to host."
    '')
    
    # Script to resume hibernated VM
    (pkgs.writeShellScriptBin "vm-resume" ''
      virsh start windows
      echo "VM resuming from hibernation..."
    '')
  ];

  # Socket-activated service for VM hibernate trigger (from Windows guest)
  systemd.sockets.vm-hibernate-trigger = {
    description = "VM Hibernate Trigger Socket";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "9999" ];
    socketConfig = {
      Accept = false;
    };
  };

  systemd.services.vm-hibernate-trigger = {
    description = "VM Hibernate Trigger Service";
    requires = [ "vm-hibernate-trigger.socket" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "vm-hibernate-trigger" ''
        # Read and discard input from socket
        cat > /dev/null || true
        # Hibernate the Windows VM (ignore errors if not running)
        ${pkgs.libvirt}/bin/virsh managedsave windows || true
      '';
      StandardInput = "socket";
    };
  };

  # Allow VM network to reach host on port 9999
  networking.firewall.interfaces."virbr0".allowedTCPPorts = [ 9999 ];

  # VNC server for headless access from Windows VM (disabled)
  systemd.services.vnc-server = {
    enable = false;
    description = "VNC Server for headless access";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      tigervnc
      xorg.xauth
      xorg.xrdb
      xorg.xsetroot
      openbox
      dbus
      bash
    ];
    environment = {
      HOME = "/home/eric";
      XDG_RUNTIME_DIR = "/run/user/1000";
      DISPLAY = ":5";
    };
    serviceConfig = {
      Type = "simple";
      User = "eric";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/eric/.vnc";
      ExecStart = pkgs.writeShellScript "start-vnc" ''
        # Clean up stale locks
        rm -f /tmp/.X5-lock /tmp/.X11-unix/X5 2>/dev/null || true
        
        ${pkgs.tigervnc}/bin/Xvnc :5 \
          -geometry 1920x1080 \
          -depth 24 \
          -rfbport 5901 \
          -SecurityTypes VncAuth \
          -PasswordFile /home/eric/.vnc/passwd &
        XVNC_PID=$!
        sleep 2
        export DISPLAY=:5
        export XDG_SESSION_TYPE=x11
        export GDK_BACKEND=x11
        
        # Start D-Bus session
        eval $(${pkgs.dbus}/bin/dbus-launch --sh-syntax)
        export DBUS_SESSION_BUS_ADDRESS
        
        # Start GNOME session
        exec ${pkgs.gnome-session}/bin/gnome-session
      '';
      Restart = "on-failure";
    };
  };

  # VNC only accessible from localhost (VM user-mode networking routes through QEMU internally)
  # No external firewall port needed - QEMU handles VM->host routing

  # Libvirt hooks for single GPU passthrough (only for VMs with gpuPassthrough = true)
  systemd.tmpfiles.rules =
    let
      gpuVms = lib.filterAttrs (name: cfg: cfg.gpuPassthrough or false) vms;
      gpuVmNames = lib.attrNames gpuVms;
    in
    [
      "d /var/lib/libvirt/hooks 0755 root root -"
      "d /var/lib/libvirt/hooks/qemu.d 0755 root root -"
      "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuHook}"
      "d /var/lib/libvirt/images 0755 root root -"
      "d /var/lib/libvirt/qemu/nvram 0775 root root -"
    ]
    ++ lib.flatten (
      map (vm: [
        "d /var/lib/libvirt/hooks/qemu.d/${vm} 0755 root root -"
        "d /var/lib/libvirt/hooks/qemu.d/${vm}/prepare 0755 root root -"
        "d /var/lib/libvirt/hooks/qemu.d/${vm}/prepare/begin 0755 root root -"
        "d /var/lib/libvirt/hooks/qemu.d/${vm}/release 0755 root root -"
        "d /var/lib/libvirt/hooks/qemu.d/${vm}/release/end 0755 root root -"
        "L+ /var/lib/libvirt/hooks/qemu.d/${vm}/prepare/begin/start.sh - - - - ${startHook vm}"
        "L+ /var/lib/libvirt/hooks/qemu.d/${vm}/release/end/stop.sh - - - - ${stopHook vm}"
      ]) gpuVmNames
    );

  # VM templates and setup script
  environment.etc = {
    # Script to find and hibernate the VM with GPU passthrough, then restore display
    "libvirt/hibernate-gpu-vm.sh" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        exec >> /var/log/hibernate-gpu-vm.log 2>&1
        echo "$(date): Hibernate triggered"
        
        # Find running VM with GPU attached
        for vm in $(${pkgs.libvirt}/bin/virsh list --name 2>/dev/null); do
          if ${pkgs.libvirt}/bin/virsh dumpxml "$vm" 2>/dev/null | grep -q "0a:00.0"; then
            echo "Hibernating $vm..."
            ${pkgs.libvirt}/bin/virsh managedsave "$vm"
            echo "Starting display manager..."
            systemctl start display-manager
            exit 0
          fi
        done
        echo "No running VM with GPU found"
      '';
    };
    # VNC xstartup script for GNOME session
    "vnc/xstartup" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        export XDG_SESSION_TYPE=x11
        export GDK_BACKEND=x11
        exec ${pkgs.gnome-session}/bin/gnome-session
      '';
    };
    "libvirt/vm-templates/setup-vms.sh" = {
      mode = "0755";
      text = ''
        #!/usr/bin/env bash
        set -e

        echo "Creating VM disk images..."
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: cfg: ''
            if [ ! -f /var/lib/libvirt/images/${name}.qcow2 ]; then
              echo "Creating ${name} disk (${cfg.diskSize})..."
              qemu-img create -f qcow2 /var/lib/libvirt/images/${name}.qcow2 ${cfg.diskSize}
            else
              echo "${name} disk already exists, skipping..."
            fi
          '') vms
        )}

        echo ""
        echo "Importing VM definitions..."
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: cfg: ''
            if ! virsh list --all --name | grep -q "^${name}$"; then
              echo "Importing ${name}..."
              virsh define /etc/libvirt/vm-templates/${name}.xml
            else
              echo "${name} already defined, skipping..."
            fi
          '') vms
        )}

        echo ""
        echo "Setup complete! Available VMs:"
        virsh list --all

        echo ""
        echo "Next steps:"
        echo "1. Attach ISO: virsh attach-disk <vm-name> /path/to/iso sda --type cdrom"
        echo "2. For Windows, also attach virtio-win.iso from: /run/current-system/sw/share/virtio-win/"
        echo "3. Add GPU passthrough in virt-manager: Add Hardware > PCI Host Device"
        echo "4. Start VM: virsh start <vm-name> OR use virt-manager"
      '';
    };
  }
  // lib.mapAttrs' (
    name: cfg:
    lib.nameValuePair "libvirt/vm-templates/${name}.xml" {
      text = mkVmXml name cfg;
    }
  ) vms;
}
