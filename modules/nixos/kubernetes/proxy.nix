{ config, pkgs, ... }:

# with lib;

let
  package = pkgs.kubernetes;

  bindAddress = "0.0.0.0";
  clusterCidr = "172.17.0.0/24";
  kubeMasterAddress = "192.168.2.9";
  kubeMasterAPIServerPort = 443;
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";

  dataDir = "/var/lib/kubernetes";

  caFile = "/var/lib/pki/kubernetes-ca.pem";
  certFile = "/var/lib/pki/kube-proxy-client.pem";
  keyFile = "/var/lib/pki/kube-proxy-client-key.pem";

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
    systemd.services.kube-proxy = {
      description = "Kubernetes Proxy Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      path = with pkgs; [
        iptables
        conntrack-tools
      ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''
          ${package}/bin/kube-proxy \
          --bind-address=${bindAddress} \
          --cluster-cidr=${clusterCidr} \
          --kubeconfig=${kubeconfig} \
        '';
        WorkingDirectory = dataDir;
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };
  };
}
