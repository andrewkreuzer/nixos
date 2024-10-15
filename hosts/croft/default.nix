{ pkgs, ... }:
{
  imports = [ ./disks ];

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;


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
        {
          # Phone
          publicKey = "z01oQX8wG4GQYQoX4LeLibBkzeZBDs8EF/qZXnRlvC0=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Carnahan
          publicKey = "YMTm9W+h+WCdWoPYq1Ma1aUc6DaAebIfLK/VO5QdpTg=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  virtualisation = {
    libvirtd = {
      allowedBridges = [
        "virbr0"
        "br0"
        "br1"
        "br2"
        "br3"
      ];
    };
  };

  networking = {
    nat = {
      enable = true;
      externalInterface = "eno1";
      internalInterfaces = [ "wg0" ];
    };
    hostId = "1f42abd3";
    hostName = "croft";
    bridges = {
      br0.interfaces = [ "enp2s0f0" ];
      br1.interfaces = [ "enp2s0f1" ];
      br2.interfaces = [ "enp2s0f2" ];
      br3.interfaces = [ "enp2s0f3" ];
    };
  };
}
