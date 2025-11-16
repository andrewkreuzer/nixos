{ config
, lib
, pkgs
, ...
}:
let
  package = pkgs.kubernetes;
  allowPrivileged = true;
  bindAddress = "0.0.0.0";

  dataDir = "/var/lib/kubernetes";
  authorizationMode = "RBAC,Node";

  clientCaFile = "/var/lib/pki/kubernetes-ca.pem";
  etcdcaFile = "/var/lib/pki/etcd-ca.pem";
  etcdCertFile = "/var/lib/pki/kube-apiserver-etcd-client.pem";
  etcdKeyFile = "/var/lib/pki/kube-apiserver-etcd-client-key.pem";
  kubeletClientCaFile = "/var/lib/pki/kubernetes-ca.pem";
  kubeletClientCertFile = "/var/lib/pki/kube-apiserver-kubelet-client.pem";
  kubeletClientKeyFile = "/var/lib/pki/kube-apiserver-kubelet-client-key.pem";
  proxyClientCertFile = "/var/lib/pki/kube-apiserver-proxy-client.pem";
  proxyClientKeyFile = "/var/lib/pki/kube-apiserver-proxy-client-key.pem";
  tlsCertFile = "/var/lib/pki/kube-apiserver.pem";
  tlsKeyFile = "/var/lib/pki/kube-apiserver-key.pem";

  securePort = 6443;
  storageBackend = "etcd3";
  serviceClusterIpRange = "172.16.0.0/24";
  runtimeConfig = "authentication.k8s.io/v1beta1=true";
  apiAudiences = "https://kubernetes.default.svc";

  serviceAccountIssuer = "https://kubernetes.default.svc";
  serviceAccountSigningKeyFile = config.age.secrets.sa-key.path;
  serviceAccountKeyFile = config.age.secrets.sa.path;

  enableAdmissionPlugins = [
    "NamespaceLifecycle"
    "LimitRanger"
    "ServiceAccount"
    "ResourceQuota"
    "DefaultStorageClass"
    "DefaultTolerationSeconds"
    "NodeRestriction"
  ];

  etcdCLientEndpoints = [
    "https://192.168.2.11:2379"
    "https://192.168.2.21:2379"
    "https://192.168.2.31:2379"
  ];
in
{
  config = {
    systemd.services.kube-apiserver = {
      description = "Kubernetes APIServer Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''
          ${package}/bin/kube-apiserver \
          --allow-privileged=${lib.boolToString allowPrivileged} \
          --authorization-mode=${authorizationMode} \
          --bind-address=${bindAddress} \
          --client-ca-file=${clientCaFile} \
          --enable-admission-plugins=${lib.concatStringsSep "," enableAdmissionPlugins} \
          --etcd-servers=${lib.concatStringsSep "," etcdCLientEndpoints} \
          --etcd-cafile=${etcdcaFile} \
          --etcd-certfile=${etcdCertFile} \
          --etcd-keyfile=${etcdKeyFile} \
          --kubelet-certificate-authority=${kubeletClientCaFile} \
          --kubelet-client-certificate=${kubeletClientCertFile} \
          --kubelet-client-key=${kubeletClientKeyFile} \
          --proxy-client-cert-file=${proxyClientCertFile} \
          --proxy-client-key-file=${proxyClientKeyFile} \
          --runtime-config=${runtimeConfig} \
          --secure-port=${toString securePort} \
          --api-audiences=${toString apiAudiences} \
          --service-account-issuer=${toString serviceAccountIssuer} \
          --service-account-signing-key-file=${serviceAccountSigningKeyFile} \
          --service-account-key-file=${serviceAccountKeyFile} \
          --service-cluster-ip-range=${serviceClusterIpRange} \
          --storage-backend=${storageBackend} \
          --tls-cert-file=${tlsCertFile} \
          --tls-private-key-file=${tlsKeyFile}
        '';
        WorkingDirectory = dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        AmbientCapabilities = "cap_net_bind_service";
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };

    kubernetes.addonManager.bootstrapAddons = {
      apiserver-kubelet-api-admin-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "system:kube-apiserver:kubelet-api-admin";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "system:kubelet-api-admin";
        };
        subjects = [
          {
            kind = "User";
            name = "system:kube-apiserver";
          }
        ];
      };
    };
  };
}
