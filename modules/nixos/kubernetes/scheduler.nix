{ lib
, pkgs
, ...
}:
let
  package = pkgs.kubernetes;

  address = "127.0.0.1";
  port = 10251;
  leaderElect = true;
  kubeMasterAPIServerPort = 443;
  kubeMasterAddress = "192.168.2.9";
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";
  dataDir = "/var/lib/kubernetes";

  caFile = "/var/lib/pki/kubernetes-ca.pem";
  certFile = "/var/lib/pki/kube-scheduler-client.pem";
  keyFile = "/var/lib/pki/kube-scheduler-client-key.pem";

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
    systemd.services.kube-scheduler = {
      description = "Kubernetes Scheduler Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''
          ${package}/bin/kube-scheduler \
          --bind-address=${address} \
          --kubeconfig=${kubeconfig} \
          --leader-elect=${lib.boolToString leaderElect} \
          --secure-port=${toString port} \
        '';
        WorkingDirectory = dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };
  };
}
