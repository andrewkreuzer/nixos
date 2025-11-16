{ config, pkgs, ... }:
let
  kubeMasterIP = "192.168.2.9";
  kubeMasterAddress = "192.168.2.9";
  kubeMasterAPIServerPort = 443;
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";

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

  kubeApiServerPort = 6443;
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
  caFile = secretsPath + "/kubernetes-ca.pem";
in
{
  networking.firewall.enable = false;
  networking.nftables.enable = true;
  networking.nftables.ruleset = ''
    table inet filter {
      # Block all incomming connections traffic except SSH and "ping".
      chain input {
        type filter hook input priority 0;

        # accept any localhost traffic
        iifname lo accept

        # accept traffic originated from us
        ct state {established, related} accept

        # ICMP
        ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

        # allow "ping"
        ip protocol icmp icmp type echo-request accept

        # accept SSH connections (required for a server)
        tcp dport 22 accept


        tcp dport { 2379-2380, 4240, 4244-4245, 4250, 6443, 8888, 9962-9964, 10250, 10256-10257, 10259, 30000-32767 } accept
        udp dport { 8472, 30000-32767, 51871 } accept

        # count and drop any other traffic
        counter drop
      }

      # Allow all outgoing connections.
      chain output {
        type filter hook output priority 0;
        accept
      }

      chain forward {
        type filter hook forward priority 0;
        accept
      }
    }
  '';
  # networking.firewall.rejectPackets = true;
  # networking.firewall.trustedInterfaces = [
  #   "cilium_*"
  #   "lxc*"
  # ];
  # networking.firewall.logRefusedPackets = true;
  # networking.firewall.allowedTCPPorts = [
  #   kubeApiServerPort
  #   kubeMasterCertMgrPort
  #   kubeletAPI
  #   kubeSchedularAPI
  #   kubeProxyAPI
  #   kubeControllerManagerAPI
  # ];
  # networking.firewall.allowedTCPPortRanges = [
  #   { from = etcdClientPort; to = etcdPeerPort; } # etcd
  #   { from = kubeNodePortStart; to = kubeNodePortEnd; } # NodePort Services
  # ];
  # networking.firewall.allowedUDPPortRanges = [
  #   { from = kubeNodePortStart; to = kubeNodePortEnd; } # NodePort Services
  # ];

  # networking.firewall.filterForward = true;
  # networking.firewall.extraForwardRules = ''
  # '';


  networking.extraHosts = ''
    ${kubeMasterIP} ${kubeMasterAddress}
    192.168.2.11 k8s-day
    192.168.2.21 k8s-goode
    192.168.2.31 k8s-montgomery
  '';

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
