{

  containers.haproxy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    config = { lib, ... }: {
      system.stateVersion = "25.05";
      boot.isContainer = true;

      services.haproxy = {
        enable = true;
        config = lib.readFile ./haproxy.conf;
      };

      services.keepalived = {
        enable = true;
        vrrpInstances.haproxy-vip = {
          state = lib.mkDefault "BACKUP";
          interface = "eth0";
          virtualRouterId = 32;
          priority = 100;
          virtualIps = [{addr = "192.168.2.9/24";}];
          trackScripts = ["chk_haproxy"];
        };
        vrrpScripts = {
          chk_haproxy = {
            script = "pidof haproxy";
            interval = 2;
            weight = 2;
          };
        };
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
