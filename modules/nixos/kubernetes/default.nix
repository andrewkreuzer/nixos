{ config, pkgs, ... }:
let
  kubeMasterIP = "192.168.2.9";
  kubeMasterAddress = "192.168.2.9";
  apiserverAddress = "https://${kubeMasterAddress}:443";

  adminKubeconfigCertFile = "/var/lib/pki/cluster-admin.pem";
  adminKubeconfigKeyFile = "/var/lib/pki/cluster-admin-key.pem";
  clusterAdminKubeconfig = pkgs.writeText "cluster-admin.kubeconfig" (
    builtins.toJSON {
      apiVersion = "v1";
      kind = "Config";
      clusters = [
        {
          name = "local";
          cluster.certificate-authority = caFile;
          cluster.server = apiserverAddress;
        }
      ];
      users = [
        {
          name = "cluster-admin";
          user = {
            client-certificate = adminKubeconfigCertFile;
            client-key = adminKubeconfigKeyFile;
          };
        }
      ];
      contexts = [
        {
          context = {
            cluster = "local";
            user = "cluster-admin";
          };
          name = "local";
        }
      ];
      current-context = "local";
    }
  );

  kubeMasterAPIServerPort = 6443;
  kubeMasterCertMgrPort = 8888;
  kubeletAPI = 10250;
  kubeSchedularAPI = 10259;
  kubeProxyAPI = 10256;
  kubeControllerManagerAPI = 10257;
  kubeNodePortStart = 30000;
  kubeNodePortEnd = 32767;
  etcdClientPort = 2379;
  etcdPeerPort = 2380;

  dataDir = "/var/lib/kubernetes";
  secretsPath = "/var/lib/pki";
  caFile = secretsPath + "/kubernetes-ca.pem"; # will likely be agenix path
in
{
  # boot.kernelModules = [ "br_netfilter" ];
  networking.nftables.enable = true;
  networking.extraHosts = ''
    ${kubeMasterIP} ${kubeMasterAddress}
    192.168.2.11 k8s-day
    192.168.2.21 k8s-goode
    192.168.2.31 k8s-montgomery
  '';
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
    { from = etcdClientPort; to = etcdPeerPort; } # etcd
    { from = kubeNodePortStart; to = kubeNodePortEnd; } # NodePort Services
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = kubeNodePortStart; to = kubeNodePortEnd; } # NodePort Services
  ];

  systemd.targets.kubernetes = {
    description = "Kubernetes";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.tmpfiles.rules = [
    "d /opt/cni/bin 0755 root root -"
    "d /run/kubernetes 0755 kubernetes kubernetes -"
    "d ${dataDir} 0755 kubernetes kubernetes -"
  ];

  users.users.kubernetes = {
    uid = config.ids.uids.kubernetes;
    description = "Kubernetes user";
    group = "kubernetes";
    home = dataDir;
    createHome = true;
    homeMode = "755";
  };
  users.groups.kubernetes.gid = config.ids.gids.kubernetes;

  environment.etc."kubernetes/cluster-admin.kubeconfig".source =
    clusterAdminKubeconfig;
}
