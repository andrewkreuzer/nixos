{ config, pkgs, ... }:
let
  kubeMasterIP = "192.168.2.11";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
  kubeMasterCertMgrPort = 8888;
in
{
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  # should probably add these [ports](https://kubernetes.io/docs/reference/networking/ports-and-protocols/#control-plane)
  networking.firewall.allowedTCPPorts = [
    kubeMasterAPIServerPort
    kubeMasterCertMgrPort
  ];

  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };

    addons.dns.enable = true;
  };
}
