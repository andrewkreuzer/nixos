{ config
, lib
, pkgs
, ...
}:

let
  package = pkgs.kubernetes;
  address = "0.0.0.0";
  port = 10250;
  registerNode = true;
  containerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
  kubeMasterAddress = "192.168.2.9";
  kubeMasterAPIServerPort = 443;
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";

  clusterDomain = "kubernetes.local";
  clusterDns = [ "172.16.0.254" ];

  healthzBind = "127.0.0.1";
  healthzPort = 10248;

  clientCaFile = "/var/lib/pki/kubernetes-ca.pem";
  tlsCertFile = "/var/lib/pki/kubelet.pem";
  tlsKeyFile = "/var/lib/pki/kubelet-key.pem";
  caFile = "/var/lib/pki/kubernetes-ca.pem";
  certFile = "/var/lib/pki/kubelet-client.pem";
  keyFile = "/var/lib/pki/kubelet-client-key.pem";

  dataDir = "/var/lib/kubernetes";

  path = [ ];

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

  cniConfig = (pkgs.buildEnv {
    name = "kubernetes-cni-config";
    paths = lib.imap
      (
        i: entry: pkgs.writeTextDir "${toString (10 + i)}-${entry.type}.conf" (builtins.toJSON entry)
      ) [{
      cniVersion = "0.3.1";
      name = "cilium";
      type = "cilium-cni";
      plugins = [{
        type = "cilium-cni";
        enable-debug = true;
        log-file = "/var/log/cilium-cni.log";
      }];
    }];
  });

  kubeletConfig = pkgs.writeText "kubelet-config" (
    builtins.toJSON {
      apiVersion = "kubelet.config.k8s.io/v1beta1";
      kind = "KubeletConfiguration";
      address = address;
      port = port;
      authentication = {
        x509 = lib.optionalAttrs (clientCaFile != null) { clientCAFile = clientCaFile; };
        webhook = {
          enabled = true;
          cacheTTL = "10s";
        };
      };
      authorization = {
        mode = "Webhook";
      };
      cgroupDriver = "systemd";
      hairpinMode = "hairpin-veth";
      registerNode = registerNode;
      containerRuntimeEndpoint = containerRuntimeEndpoint;
      healthzPort = healthzPort;
      healthzBindAddress = healthzBind;
      tlsCertFile = tlsCertFile;
      tlsPrivateKeyFile = tlsKeyFile;
      clusterDomain = clusterDomain;
      clusterDNS = clusterDns;
    }
  );
in
{

  config = {
    environment.etc."cni/net.d".source = cniConfig;

    boot.kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.ipv4.ip_forward" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
    };

    systemd.services.kubelet = {
      description = "Kubernetes Kubelet Service";
      wantedBy = [ "kubernetes.target" ];
      after = [
        "containerd.service"
        "network.target"
        "kube-apiserver.service"
      ];
      path =
        with pkgs;
        [
          gitMinimal
          openssh
          util-linuxMinimal
          iproute2
          ethtool
          thin-provisioning-tools
          iptables
          socat
        ]
        ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package
        ++ path;
      preStart = ''
        rm /opt/cni/bin/* || true
        ${lib.concatMapStrings (pkg: ''
          echo "Linking cni package: ${pkg}"
          ln -fs ${pkg}/bin/* /opt/cni/bin
        '') [ pkgs.cni-plugins ]}
      '';
      serviceConfig = {
        Slice = "kubernetes.slice";
        CPUAccounting = true;
        MemoryAccounting = true;
        Restart = "on-failure";
        RestartSec = "1000ms";
        ExecStart = ''
          ${package}/bin/kubelet \
          --config=${kubeletConfig} \
          --kubeconfig=${kubeconfig} \
          --pod-infra-container-image=pause \
          --root-dir=${dataDir} \
        '';
        WorkingDirectory = dataDir;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };

    boot.kernelModules = [
      "br_netfilter"
      "overlay"
    ];
  };
}
