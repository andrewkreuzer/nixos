{ config, lib, pkgs, ... }:
let
  kubeMasterIP = "192.168.2.9";
  kubeMasterAddress = "192.168.2.9";
  apiserverbindAddress = "0.0.0.0";
  apiserverAddress = "https://${kubeMasterAddress}:443";

  clusterCidr = "172.17.0.0/24";
  serviceCidr = "172.16.0.0/24";
  apiAudiences = "api,https://kubernetes.default.svc";
  serviceAccountIssuer = "https://kubernetes.default.svc";

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

  etcdcaFile = "";
  etcdKeyFile = "";
  etcdCertFile = "";
  etcdClientPort = 2379;
  etcdPeerPort = 2380;
  etcdDataDir = "/var/lib/etcd";
  etcdTrustedCaFile = "";
  etcdCLientEndpoints = [
    "https://192.168.2.11:2379"
    "https://192.168.2.21:2379"
    "https://192.168.2.31:2379"
  ];
  etcdPeerEndpoints = [
    "https://192.168.2.11:2380"
    "https://192.168.2.21:2380"
    "https://192.168.2.31:2380"
  ];

  storageBackend = "etcd3";

  # controller manager
  allocateNodeCIDRs = true;
  controllerManagerBindAddress = "127.0.0.1";
  controllerManagerLeaderElect = true; # start before main loop;
  controllerManagerSecurePort = 10252;

  # kubelet
  kubeletBindAddress = "0.0.0.0";
  kubeletClusterDns = "";
  kubeletClusterDomain = "cluster.local";
  kubeletCniPackage = "flannel"; # change to cilium
  kubeletCniConfig = "";
  kubeletCniConfigDir = "";
  kubeletcontainerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
  kubeletHealthzBindAddress = "127.0.0.1";
  kubeletHealthzPort = 10248;
  kubeletHostName = lib.toLower config.networking.fqdnOrHostName;
  kubeletNodeTaints = "";
  kubeletUnschedulable = false;

  # proxy
  proxyBindAddress = "0.0.0.0";
  proxyHostName = lib.toLower config.networking.fqdnOrHostName;

  # scheduler
  schedulerBindAddress = "127.0.0.1";
  schedulerLeaderElect = true;
  schedulerPort = 10251;

  dataDir = "/var/lib/kubernetes";
  secretsPath = "/var/lib/pki";
  caFile = secretsPath + "/kubernetes-ca.pem"; # will likely be agenix path
  clientCaFile = secretsPath + "";
  kubeletClientCaFile = "";
  kubeletClientCertFile = "";
  kubeletClientKeyFile = "";

  proxyClientCertFile = "";
  proxyClientKeyFile = "";

  runtimeConfig = "authentication.k8s.io/v1beta1=true";

  tokenAuthFile = "";
  authorizationMode = "RBAC";
  enableAdmissionPlugins = [
    "NamespaceLifecycle"
    "LimitRanger"
    "ServiceAccount"
    "ResourceQuota"
    "DefaultStorageClass"
    "DefaultTolerationSeconds"
    "NodeRestriction"
  ];
in
{
  boot.initrd.kernelModules = [ "br_netfilter" ];
  boot.initrd.availableKernelModules = [ "br_netfilter" ];
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
    { from = 2379; to = 2380; } # etcd
    { from = 30000; to = 32767; } # NodePort Services
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 30000; to = 32767; } # NodePort Services
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
