{ me, lib, pkgs, ... }:
{
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  users.users.root.openssh.authorizedKeys.keys = me.sshKeys;

  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd zsh";

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  systemd.network = {
    networks = {
      "40-br0" = {
        networkConfig.Address = ["192.168.2.30/24"];
      };
    };
  };
  microvm.vms = {
    k8s = {
      config = {
        networking.hostName = "k8s-montgomery";
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig.Address = ["192.168.2.31/24"];
        };
        microvm = {
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

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
}
