{ self, lib, pkgs, ... }:
{
  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd zsh";

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  systemd.network = {
    networks = {
      "40-br0" = {
        networkConfig.Address = [ "192.168.2.20/24" ];
      };
    };
  };
  microvm.vms = {
    k8s = {
      config = {
        networking.hostName = "k8s-goode";
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig.Address = [ "192.168.2.21/24" ];
        };
        certmgr.remote = "https://192.168.2.11:8888";
        imports = [
          self.modules.nixos.etcd
          self.modules.nixos.kubernetes.default
          self.modules.nixos.kubernetes.apiserver
          self.modules.nixos.kubernetes.kubelet
          self.modules.nixos.kubernetes.proxy
          self.modules.nixos.kubernetes.scheduler
          self.modules.nixos.kubernetes.controller-manager
        ];
        microvm = {
          interfaces = [
            {
              type = "tap";
              id = "vm-k8s";
              mac = "02:00:00:00:00:02";
            }
          ];
        };
      };
    };
  };

  virtualisation.libvirtd.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
}
