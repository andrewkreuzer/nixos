{ lib, pkgs, ... }:
let
  kubeMasterIP = "192.168.2.11";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
  kubeMasterCertMgrPort = 8888;
  kubeletAPI = 10250;
  kubeSchedularAPI = 10259;
  kubeProxyAPI = 10256;
  kubeControllerManagerAPI = 10257;
in
{
  boot.kernelModules = [ "br_netfilter" ];
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  # should probably add these [ports](https://kubernetes.io/docs/reference/networking/ports-and-protocols/#control-plane)
  networking.firewall.allowedTCPPorts = [
    kubeMasterAPIServerPort
    kubeMasterCertMgrPort
    kubeletAPI
    kubeSchedularAPI
    kubeProxyAPI
    kubeControllerManagerAPI
  ];
  networking.firewall.allowedTCPPortRanges = [
    { from = 2379; to = 2380; } # etcd
    { from = 30000; to = 32767; } # NodePort Services
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 30000; to = 32767; } # NodePort Services
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
