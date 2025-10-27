{ lib, ... }:
{

  containers.haproxy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.2.9/24";
    config = { lib, ... }: {
      system.stateVersion = "25.05";
      boot.isContainer = true;

      services.haproxy = {
        enable = true;
        config = lib.readFile ./haproxy.conf;
      };

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 443 8404 ];
        };
        useHostResolvConf = lib.mkForce false;
      };
      services.resolved.enable = true;
    };
  };
}
