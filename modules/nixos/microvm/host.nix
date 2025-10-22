{ self, inputs, pkgs, lib, ... }:
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
      specialArgs = self.specialArgs;

      config = {
        system.stateVersion = "25.05";
        microvm.mem = 10240;
        microvm.vcpu = 4;

        environment.systemPackages = builtins.attrValues {
          inherit (pkgs)
            htop
            ;
        };

        imports = [
          self.modules.nixos.security.openssh-root
          self.modules.nixos.microvm.vm
        ];
      };
    };
  };
}
