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

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [
        "virbr0"
        "br0"
        "br1"
        "br2"
        "br3"
      ];
    };
    docker = {
      enable = false;

      /* rootless = { */
      /*   enable = true; */
      /*   setSocketVariable = true; */
      /* }; */
    };
  };

  time.timeZone = "America/Toronto";
  networking = {
    hostId = "1f42abd3";
    hostName = "croft";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
    bridges = {
      br0.interfaces = [ "enp2s0f0" ];
      br1.interfaces = [ "enp2s0f1" ];
      br2.interfaces = [ "enp2s0f2" ];
      br3.interfaces = [ "enp2s0f3" ];
    };
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
