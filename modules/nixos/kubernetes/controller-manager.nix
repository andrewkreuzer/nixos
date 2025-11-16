{ config
, lib
, pkgs
, ...
}:
let
  package = pkgs.kubernetes;

  kubeMasterAddress = "192.168.2.9";
  kubeMasterAPIServerPort = 443;
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";
  allocateNodeCIDRs = true;
  bindAddress = "127.0.0.1";
  clusterCidr = "172.17.0.0/22";
  leaderElect = true; # start before main loop;
  securePort = 10252;

  dataDir = "/var/lib/kubernetes";
  path = [ ];

  rootCaFile = "/var/lib/pki/kubernetes-ca.pem";
  serviceAccountKeyFile = config.age.secrets.sa-key.path;
  tlsCertFile = "/var/lib/pki/kube-controller-manager.pem";
  tlsKeyFile = "/var/lib/pki/kube-controller-manager-key.pem";

  caFile = "/var/lib/pki/kubernetes-ca.pem";
  certFile = "/var/lib/pki/kube-controller-manager-client.pem";
  keyFile = "/var/lib/pki/kube-controller-manager-client-key.pem";

  kubeconfig = pkgs.writeText "kube-scheduler-kubeconfig" (
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
          name = "kube-scheduler";
          user = {
            client-certificate = certFile;
            client-key = keyFile;
          };
        }
      ];
      contexts = [
        {
          context = {
            cluster = "local";
            user = "kube-scheduler";
          };
          name = "local";
        }
      ];
      current-context = "local";
    }
  );
in
{

  config = {
    systemd.services.kube-controller-manager = {
      description = "Kubernetes Controller Manager Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        RestartSec = "30s";
        Restart = "on-failure";
        Slice = "kubernetes.slice";
        ExecStart = ''
          ${package}/bin/kube-controller-manager \
          --allocate-node-cidrs=${lib.boolToString allocateNodeCIDRs} \
          --bind-address=${bindAddress} \
          --cluster-cidr=${clusterCidr} \
          --kubeconfig=${kubeconfig} \
          --leader-elect=${lib.boolToString leaderElect} \
          --root-ca-file=${rootCaFile} \
          --secure-port=${toString securePort} \
          --service-account-private-key-file=${serviceAccountKeyFile} \
          --tls-cert-file=${tlsCertFile} \
          --tls-private-key-file=${tlsKeyFile} \
          --use-service-account-credentials
        '';
        WorkingDirectory = dataDir;
        User = "kubernetes";
        Group = "kubernetes";
      };
      unitConfig.StartLimitIntervalSec = 0;
      path = path;
    };
  };
}
