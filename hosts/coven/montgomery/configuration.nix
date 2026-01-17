{ self, lib, pkgs, ... }:
{
  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd zsh";

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  systemd.network = {
    networks = {
      "40-br0" = {
        networkConfig.Address = [ "192.168.2.30/24" ];
      };
    };
  };
  microvm.vms = {
    k8s = {
      config = {
        networking.hostName = "k8s-montgomery";
        systemd.network.networks."20-lan" = {
          matchConfig.Name = "ens5";
          matchConfig.Type = "ether";
          networkConfig.Address = [ "192.168.2.31/24" ];
        };
        certmgr.remote = "https://192.168.2.11:8888";
        microvm = {
          volumes = [{
            image = "/dev/disk/by-id/nvme-PM9A1_NVMe_SED_Samsung_512GB__S65SNF0R906032-part2";
            autoCreate = false;
            mountPoint = null;
          }
          {
            image = "/dev/disk/by-id/nvme-PC_SN810_NVMe_WDC_1024GB_22085J801490_1";
            autoCreate = false;
            mountPoint = null;
          }];
          interfaces = [
            {
              type = "tap";
              id = "vm-k8s";
              mac = "02:00:00:00:00:03";
            }
          ];
        };
      };
    };
  };

  containers.haproxy = rec {
    localAddress = "192.168.2.32";
    config.services.keepalived.vrrpInstances.haproxy-vip = {
      unicastSrcIp = localAddress;
      unicastPeers = [
        "192.168.2.12"
        "192.168.2.22"
      ];
    };
  };

  virtualisation.libvirtd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.zfs.package = pkgs.zfs_2_4;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
}
