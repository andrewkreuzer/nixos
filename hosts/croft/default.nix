{pkgs, config, lib, ...}:
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

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/var/lib/wireguard/privatekey";

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      peers = [
        { # Phone
          publicKey = "z01oQX8wG4GQYQoX4LeLibBkzeZBDs8EF/qZXnRlvC0=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # Carnahan
          publicKey = "YMTm9W+h+WCdWoPYq1Ma1aUc6DaAebIfLK/VO5QdpTg=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
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
    nat = {
      enable = true;
      externalInterface = "eno1";
      internalInterfaces = [ "wg0" ];
    };
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
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
