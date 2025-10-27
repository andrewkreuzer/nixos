{ config, lib, ... }:
let
  hostname = config.networking.hostName;
  clientPort = 2379;
  peerPort = 2380;

  trustedCaFile = "/var/lib/pki/etcd-ca.pem";
  certFile = "/var/lib/pki/kube-etcd.pem";
  keyFile = "/var/lib/pki/kube-etcd-key.pem";
  peerTrustedCaFile = trustedCaFile;
  peerCertFile = "/var/lib/pki/kube-etcd-peer.pem";
  peerKeyFile = "/var/lib/pki/kube-etcd-peer-key.pem";

  ips = {
    k8s-day = "192.168.2.11";
    k8s-goode = "192.168.2.21";
    k8s-montgomery = "192.168.2.31";
  };

  genInitialCluster = port: lib.mapAttrsToList
    (
      name: value: "${name}=https://${value}:${toString port}"
    )
    ips;

  peerUrls = genInitialCluster peerPort;
  peerListeningUrls = [ "https://${ips.${hostname}}:${toString peerPort}" ];
  clientListeningUrls = [ "https://${ips.${hostname}}:${toString clientPort}" ];
in
{
  networking.extraHosts = ''
    192.168.2.11 k8s-day
    192.168.2.21 k8s-goode
    192.168.2.31 k8s-montgomery
  '';

  services.etcd = {
    inherit
      certFile
      keyFile
      trustedCaFile
      peerCertFile
      peerKeyFile
      peerTrustedCaFile
      ;
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/etcd";
    clientCertAuth = true;
    peerClientCertAuth = true;
    initialClusterState = "new";
    initialCluster = peerUrls;
    initialAdvertisePeerUrls = peerListeningUrls;
    listenPeerUrls = peerListeningUrls;
    advertiseClientUrls = clientListeningUrls;
    listenClientUrls = clientListeningUrls
      ++ [ "https://127.0.0.1:${toString clientPort}" ];
  };
}
