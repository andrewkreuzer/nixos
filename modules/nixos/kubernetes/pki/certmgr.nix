{ config, lib, pkgs, ... }:
let
  cfg = config.certmgr;
  cfsslAddress = "localhost";
  cfsslPort = 8888;
  caCert = config.age.secrets.k8s-ca.path;
  certmgrAPITokenPath = config.age.secrets.multirootca-auth-key.path;

  secretsPath = "/var/lib/pki";
  secret = name: "${secretsPath}/${name}.pem";

  mkCert =
    { name
    , CN
    , hosts ? [ ]
    , fields ? { }
    , label ? ""
    , profile ? "default"
    , action ? ""
    , remote ? cfg.remote
    , caFile ? null
    , privateKeyOwner ? "kubernetes"
    , privateKeyGroup ? "kubernetes"
    ,
    }: rec {
      inherit
        name
        caCert
        CN
        hosts
        fields
        label
        profile
        remote
        caFile
        action
        ;
      cert = secret name;
      key = secret "${name}-key";
      privateKeyOptions = {
        owner = privateKeyOwner;
        group = privateKeyGroup;
        mode = "0600";
        path = key;
      };
    };

  mkCa =
    { name
    , label ? ""
    , profile ? "default"
    , action ? ""
    , remote ? cfg.remote
    ,
    }: rec {
      inherit
        name
        caCert
        label
        profile
        remote
        action
        ;
      CN = null;
      caFile.path = secret name;
    };

  certs = {
    kubernetesCa = mkCa {
      name = "kubernetes-ca";
      label = "kubernetes_ca";
      action = "systemctl restart kube-apiserver.service";
    };
    etcdCa = mkCa {
      name = "etcd-ca";
      label = "etcd_ca";
      action = "systemctl restart etcd.service";
    };
    frontProxyCa = mkCa {
      name = "front-proxy-ca";
      label = "front_proxy_ca";
      action = "systemctl restart kube-apiserver.service";
    };
    etcd = mkCert {
      name = "kube-etcd";
      CN = "kube-etcd";
      label = "etcd_ca";
      profile = "server_client";
      hosts = [
        "localhost"
        "127.0.0.1"
        "k8s-day"
        "k8s-goode"
        "k8s-montgomery"
        "192.168.2.11"
        "192.168.2.21"
        "192.168.2.31"
      ];
      privateKeyOwner = "etcd";
      privateKeyGroup = "etcd";
      action = "systemctl restart etcd.service";
    };
    etcdPeer = mkCert {
      name = "kube-etcd-peer";
      CN = "kube-etcd-peer";
      label = "etcd_ca";
      profile = "server_client";
      hosts = [
        "localhost"
        "127.0.0.1"
        "k8s-day"
        "k8s-goode"
        "k8s-montgomery"
        "192.168.2.11"
        "192.168.2.21"
        "192.168.2.31"
      ];
      privateKeyOwner = "etcd";
      privateKeyGroup = "etcd";
      action = "systemctl restart etcd.service";
    };
    # TODO: not sure where I'm actually suppose
    # to use this cert
    # etcdHealthCheck = mkCert {
    #   name = "kube-etcd-healthcheck-client";
    #   CN = "kube-etcd-healthcheck-client";
    #   label = "etcd_ca";
    #   profile = "client";
    #   action = "systemctl restart kube-apiserver.service";
    # };
    apiserverEtcdClient = mkCert {
      name = "kube-apiserver-etcd-client";
      CN = "etcd-client";
      label = "etcd_ca";
      profile = "client";
      action = "systemctl restart kube-apiserver.service";
    };

    apiServer = mkCert {
      name = "kube-apiserver";
      CN = "kubernetes";
      label = "kubernetes_ca";
      profile = "server";
      hosts = [
        "kubernetes.default.svc"
        "127.0.0.1"
        "172.16.0.1"
        "192.168.2.9"
        "192.168.2.11"
        "192.168.2.21"
        "192.168.2.31"
      ];
      action = "systemctl restart kube-apiserver.service";
    };
    apiserverKubeletClient = mkCert {
      name = "kube-apiserver-kubelet-client";
      CN = "system:kube-apiserver";
      label = "kubernetes_ca";
      profile = "client";
    };
    apiserverProxyClient = mkCert {
      name = "kube-apiserver-proxy-client";
      CN = "front-proxy-client";
      label = "front_proxy_ca";
      profile = "client";
      action = "systemctl restart kube-apiserver.service";
    };

    serviceAccount = mkCert {
      name = "service-account";
      CN = "system:service-account-signer";
      label = "kubernetes_ca";
      profile = "service_account";
      action = ''
        systemctl restart \
        kube-apiserver.service \
        kube-controller-manager.service
      '';
    };
    clusterAdmin = mkCert {
      name = "cluster-admin";
      CN = "cluster-admin";
      label = "kubernetes_ca";
      profile = "client";
      fields = {
        O = "system:masters";
      };
      privateKeyOwner = "root";
    };

    controllerManager = mkCert {
      name = "kube-controller-manager";
      CN = "kube-controller-manager";
      label = "kubernetes_ca";
      profile = "server";
      action = "systemctl restart kube-controller-manager.service";
    };
    controllerManagerClient = mkCert {
      name = "kube-controller-manager-client";
      CN = "system:kube-controller-manager";
      label = "kubernetes_ca";
      profile = "client";
      action = "systemctl restart kube-controller-manager.service";
    };

    kubelet = mkCert {
      name = "kubelet";
      CN = lib.toLower config.networking.fqdnOrHostName;
      label = "kubernetes_ca";
      profile = "server";
      action = "systemctl restart kubelet.service";
    };
    kubeletClient = mkCert {
      name = "kubelet-client";
      CN = "system:node:${lib.toLower config.networking.fqdnOrHostName}";
      label = "kubernetes_ca";
      profile = "client";
      fields = {
        O = "system:nodes";
      };
      action = "systemctl restart kubelet.service";
    };

    kubeProxyClient = mkCert {
      name = "kube-proxy-client";
      CN = "system:kube-proxy";
      label = "kubernetes_ca";
      profile = "client";
      action = "systemctl restart kube-proxy.service";
    };

    schedulerClient = mkCert {
      name = "kube-scheduler-client";
      CN = "system:kube-scheduler";
      label = "kubernetes_ca";
      profile = "client";
      action = "systemctl restart kube-scheduler.service";
    };
  };
in
{

  options.certmgr = {
    remote = lib.mkOption {
      type = lib.types.str;
      default = "https://${cfsslAddress}:${toString cfsslPort}";
      description = "The remote address of the certmgr server.";
    };
  };

  config = {
    services.certmgr = {
      defaultRemote = cfg.remote;
      enable = true;
      package = pkgs.certmgr;
      svcManager = "command";
      specs =
        let
          mkSpec = _: cert: lib.mkMerge [
          {
            inherit (cert) action;
            authority = {
              remote = cert.remote;
              label = cert.label;
              profile = cert.profile;
              root_ca = cert.caCert;
              auth_key_file = certmgrAPITokenPath;
            };
          }
          (lib.mkIf (cert.CN == null) {
            certificate = null;
            private_key = null;
            request = null;
            authority.file = cert.caFile;
          })
          (lib.mkIf (cert.CN != null) {
            certificate.path = cert.cert;
            private_key = cert.privateKeyOptions;
            request = {
              hosts = [ cert.CN ] ++ cert.hosts;
              inherit (cert) CN;
              key = {
                algo = "ecdsa";
                size = 256;
              };
              names = [ cert.fields ];
            };
          })
        ];
        in
        lib.mapAttrs mkSpec certs;
    };
  };
}
