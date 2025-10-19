{ lib, ... }:
let
  exceptPort = 6667;
  spotifydTCPPort = 5216;
  mDNS = 5353;
  pyHttpServer = 8000;
in
{
  networking = {
    useDHCP = lib.mkForce false;
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [spotifydTCPPort exceptPort pyHttpServer];
    firewall.allowedUDPPorts = [mDNS];

    # for hue but I don't think this is
    # the right ip anymore
    extraHosts = ''
    192.168.2.10 ecb5fafffe997dae
    '';

    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.10.10.100/32" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/home/akreuzer/.cache/wireguard/key";

        peers = [
          {
            publicKey = "9+HZARi0ViE7gl2ZyuK1pGJed8pvuY2Ko2Z5mRtSeX0=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "home.andrewkreuzer.com:51820";
          }
        ];
      };
      wg1 = {
        autostart = false;
        address = [ "10.100.0.3/32" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/home/akreuzer/.cache/wireguard/privatekey";

        peers = [
          {
            publicKey = "ZMOH0eU0S7VFqjQ25fEzvcJsAJD7E7UOP4dAwJU4TlI=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "home.andrewkreuzer.com:51821";
          }
        ];
      };
      azure = {
        autostart = false;
        address = [ "10.1.0.100/32" ];
        dns = [ "10.10.1.10" ];
        privateKeyFile = "/home/akreuzer/.cache/wireguard/privatekey";

        peers = [
          {
            publicKey = "AECyy0fEBSmqsEKvbNoMdXk8KfgY5mOyMvTgDgRrhE0=";
            allowedIPs = [ "10.10.0.0/16" ];
            endpoint = "40.88.124.71:51820";
          }
        ];
      };
      proton = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = "/home/akreuzer/.cache/wireguard/proton";

        peers = [
          {
            publicKey = "wP/7Xi9sTiO1XMpLXf/OUJiJc1E0PA3KyskMtGajEFA=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "146.70.202.2:51820";
          }
        ];
      };
    };
  };
}
