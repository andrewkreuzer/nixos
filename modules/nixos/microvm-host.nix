{ inputs, lib, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  networking.useDHCP = lib.mkForce false;
  systemd.network.enable = true;
  systemd.network = {
    netdevs = {
      "20-br0" = {
        netdevConfig.Kind = "bridge";
        netdevConfig.Name = "br0";
      };
    };
    networks = {
      "30-enp0s31f6" = {
        matchConfig.Name = "enp0s31f6";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "40-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Gateway = "192.168.2.1";
          DNS = ["192.168.2.1"];
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "50-vm" = {
        matchConfig.Name = ["vm-*"];
        networkConfig.Bridge = "br0";
      };
      "60-docker" = {
        matchConfig.Name = "veth*";
        linkConfig.Unmanaged = true;
      };
    };
  };

  microvm.vms = {
    k8s = {
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };

      #specialArgs = {};

      config = {
        system.stateVersion = "25.05";

        systemd.network.enable = true;
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig = {
            Gateway = "192.168.3.1";
            DNS = ["192.168.1.1"];
            DHCP = "no";
          };
        };

        users.users.root.password = "toor";
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };

        microvm = {
          mem = 8192;
          vcpu = 4;
          hypervisor = "cloud-hypervisor";
          shares = [
            {
              tag = "etc";
              source = "etc";
              mountPoint = "/etc";
              proto = "virtiofs";
            }
            {
              tag = "ro-store";
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              proto = "virtiofs";
            }
          ];
        };
      };
    };
  };
}
