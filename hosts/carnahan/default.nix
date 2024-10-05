{config, lib, pkgs, inputs, ...}:
with lib;
{
  imports = [ ./hardware.nix ];

  # disable gnomes use of power profile for tlp
  services.power-profiles-daemon.enable = mkForce false;

  # we have to install hyprland twice because the hm-module
  # doesn't install all the needed shit :(
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services = {
    logind = {
      powerKey = "poweroff";
      lidSwitch="suspend";
      lidSwitchExternalPower= "suspend";
    };
    fwupd.enable = true;
    blueman.enable = true;
    hardware.bolt.enable = true;
    gnome = {
      gnome-keyring.enable = true;
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    tlp = {
      enable = true;
      settings = {
        SOUND_POWER_SAVE_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_MAX_PERF_ON_BAT = 30;
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };
    xserver = {
      enable = true;
      displayManager.lightdm.enable = false;
      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = false;
      xkb.options = "caps:escape_shifted_capslock";
    };
    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = "no";
      };
    };
  };

  # environment.etc = let
  # json = pkgs.formats.json {};
  # in {
  #   "pipewire/pipewire-conf.d/91-rtp-sinks.conf".source = json.generate "91-rtp-sinks.conf" {
  #      context.modules = [{
  #        name = "libpipewire-module-rtp-sink";
  #        args = {
  #          local.ifname = "enp7s0";
  #          destination.ip = "192.168.2.122";
  #          destination.port = 46666;
  #          stream.props = {
  #              node.name = "rtp-sink";
  #          };
  #        };
  #     }];
  #   };
  # };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;

      /* rootless = { */
      /*   enable = true; */
      /*   setSocketVariable = true; */
      /* }; */
    };
  };

  location.provider = "geoclue2";
  time.timeZone = "America/Toronto";
  networking = {
    hostId = "cb023b45";
    hostName = "carnahan";
    useDHCP = false;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      interfaces."enp7s0".allowedTCPPorts = [ 5173 ];
      interfaces."wlp0s20f3".allowedTCPPorts = [ 5173 ];
    };
    extraHosts =
    ''
      192.168.2.205 ecb5fafffe997dae
    '';
  };

  fileSystems = let
    mkZfsMount = dataset: {
      device = "${dataset}";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "noatime" ];
      neededForBoot = true;
    };
    mkBootMount = device: {
      device = "/dev/disk/by-id/${device}";
      fsType = "vfat";
      options = [
        "x-systemd.idle-timeout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
        "noatime"
        "X-mount.mkdir"
      ];
    };
    mkTmpfsMount = size: {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=${size}" "mode=777" ];
    };
  in {
    "/home/akreuzer" =  mkZfsMount "rpool/USERDATA/akreuzer";
    "/root" =           mkZfsMount "rpool/USERDATA/root";
    "/etc" =            mkZfsMount "rpool/ROOT/nixos/etc";
    "/nix" =            mkZfsMount "rpool/ROOT/nixos/nix";
    "/nix/store" =      mkZfsMount "rpool/ROOT/nixos/nix/store";
    "/usr" =            mkZfsMount "rpool/ROOT/nixos/usr";
    "/usr/local" =      mkZfsMount "rpool/ROOT/nixos/usr/local";
    "/var" =            mkZfsMount "rpool/ROOT/nixos/var";
    "/var/cache" =      mkZfsMount "rpool/ROOT/nixos/var/cache";
    "/var/lib" =        mkZfsMount "rpool/ROOT/nixos/var/lib";
    "/var/lib/docker" = mkZfsMount "rpool/ROOT/nixos/var/lib/docker";
    "/var/log" =        mkZfsMount "rpool/ROOT/nixos/var/log";
    "/boot" =           mkZfsMount "bpool/BOOT/nixos";
    "/" =               mkZfsMount "rpool/ROOT/nixos";

    "/boot/efis/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part1" =
      mkBootMount "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part1";

    "/boot/efis/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part1" =
      mkBootMount "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part1";

    "/tmp" = mkTmpfsMount "16G";
  };

  swapDevices =
  let
  swapPartitions = [
    "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part4"
    "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part4"
  ];
  in (map (swap: {
    device = "/dev/disk/by-id/${swap}";
    discardPolicy = mkDefault "both";
    randomEncryption = {
      enable = true;
      allowDiscards = mkDefault true;
    };
  }) swapPartitions);
}
