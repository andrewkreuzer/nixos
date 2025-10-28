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
        networkConfig.Address = [ "192.168.2.10/24" ];
      };
    };
  };
  microvm.vms = {
    k8s = {
      config = {
        networking.hostName = "k8s-day";
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig.Address = [ "192.168.2.11/24" ];
        };
        imports = [
          self.modules.nixos.kubernetes.pki.multirootca
        ];
        microvm = {
          interfaces = [{
            type = "tap";
            id = "vm-k8s";
            mac = "02:00:00:00:00:01";
          }];
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
