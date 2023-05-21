{config, lib, ...}:
with lib;
{
  imports = [ ./hardware.nix ];

  services = {
    fwupd.enable = true;
    blueman.enable = true;
    #pipewire = {
    #  enable = true;
    #  package = pkgs-unstable.pipewire;
    #  wireplumber.package = pkgs-unstable.wireplumber;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
    #  pulse.enable = true;
    #};
    xserver = {
      enable = false;
      xkbOptions = "caps:escape_shifted_capslock";
    };
    openssh = {
      enable = mkDefault true;
      passwordAuthentication = mkDefault false;
      permitRootLogin = "no";
    };
  };

  virtualisation.docker = {
    enable = true;

    /* rootless = { */
    /*   enable = true; */
    /*   setSocketVariable = true; */
    /* }; */
  };

  networking.hostId = "1f42abd3";
  time.timeZone = "America/Toronto";
  networking = {
    hostName = "croft";
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
      experimental-features = mkDefault [ "nix-command" "flakes" ];
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
    "/opt" =            mkZfsMount "rpool/ROOT/nixos/opt";
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

    "/boot/efis/ata-SanDisk_SDSSDA480G_163758443009-part1" =
      mkBootMount "ata-SanDisk_SDSSDA480G_163758443009-part1";

    "/tmp" = mkTmpfsMount "2G";
  };
}
