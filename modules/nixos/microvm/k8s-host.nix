{ self, inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  users.mutableUsers = false;
  users.users."microvm".extraGroups = [ "disk" ];

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
          DNS = [ "192.168.2.1" ];
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "50-vm" = {
        matchConfig.Name = [ "vm-*" ];
        networkConfig.Bridge = "br0";
      };
    };
  };

  systemd.services.disable-nic-offload-enp0s31f6 = {
  description = "Disable NIC offloading for Intel I219 (hardware unit hang fix)";
  after = [ "sys-subsystem-net-devices-enp0s31f6.device" ];
  bindsTo = [ "sys-subsystem-net-devices-enp0s31f6.device" ];
  wantedBy = [ "network-pre.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp0s31f6 gso off gro off tso off tx off rx off rxvlan off txvlan off";
  };
};

  microvm.vms = {
    k8s = {
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      specialArgs = self.specialArgs;

      autostart = true;
      config = {
        system.stateVersion = "25.05";
        microvm.mem = 12288;
        microvm.vcpu = 8;

        environment.systemPackages = builtins.attrValues {
          inherit (pkgs)
            htop
            ;
        };

        imports = [
          self.modules.nixos.security.openssh-root
          self.modules.nixos.microvm.k8s-vm
        ];
      };
    };
  };
}
