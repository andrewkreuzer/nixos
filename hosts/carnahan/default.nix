{config, lib, pkgs, ...}:
with lib;
{
  imports = [ ./hardware.nix ];

  # disable gnomes use of power profile for tlp
  services.power-profiles-daemon.enable = mkForce false;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      libinput-gestures
    ;
  };

  services = {
    fwupd.enable = true;
    blueman.enable = true;
    hardware.bolt.enable = true;
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
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      displayManager.lightdm.enable = false;
      /* displayManager.gdm.enable = true; */
      /* desktopManager.gnome.enable = true; */
      xkbOptions = "caps:escape_shifted_capslock";
    };
    openssh = {
      enable = mkDefault true;
      passwordAuthentication = mkDefault false;
      permitRootLogin = "no";
    };
  };

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  virtualisation.docker = {
    enable = true;

    /* rootless = { */
    /*   enable = true; */
    /*   setSocketVariable = true; */
    /* }; */
  };

  location.provider = "geoclue2";
  networking.hostId = "cb023b45";
  time.timeZone = "America/Toronto";
  networking = {
    hostName = "carnahan";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
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
