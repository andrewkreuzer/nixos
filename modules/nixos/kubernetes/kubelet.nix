{ inputs
, config
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

  clusterDomain = "cluster.local";
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

  kubeconfig = pkgs.writeText "kubelet-kubeconfig" (
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
          name = "kubelet";
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
            user = "kubelet";
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
        i: entry: pkgs.writeTextDir "${toString (10 + i)}-${entry.name}.conflist" (builtins.toJSON entry)
      ) [{
      cniVersion = "0.3.1";
      name = "cilium";
      plugins = [{
        type = "cilium-cni";
        enable-debug = false;
        log-file = "/var/run/cilium/cilium-cni.log";
      }];
    }];
  });


  kubeletConfig = pkgs.writeText "kubelet-config" (
    builtins.toJSON {
      apiVersion = "kubelet.config.k8s.io/v1beta1";
      kind = "KubeletConfiguration";
      address = address;
      port = port;
      authorization.mode = "Webhook";
      authentication = {
        x509.clientCAFile = clientCaFile;
        webhook.enabled = true;
        webhook.cacheTTL = "10s";
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
      # produces ContainerStatusUnknown
      # killed pods will be automatically rescheduled
      # during node shutdown and left in this state
      # shutdownGracePeriod = "30s";
      # shutdownGracePeriodCriticalPods = "10s";
    }
  );

  clusterAdminKubeconfig = "/etc/kubernetes/cluster-admin.kubeconfig";
  drainScript = pkgs.writeShellScript "kubelet-drain" ''
    set -e
    NODE_NAME=$(${pkgs.nettools}/bin/hostname)
    echo "Draining node $NODE_NAME before shutdown"
    ${pkgs.kubectl}/bin/kubectl cordon $NODE_NAME
    ${pkgs.kubectl}/bin/kubectl drain $NODE_NAME \
      --ignore-daemonsets \
      --delete-emptydir-data \
      --force \
      --grace-period=30 \
      --timeout=3m
    echo "Node $NODE_NAME drained"
  '';
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
        '') [
          pkgs.cni-plugins
          inputs.self.packages.${pkgs.system}.cilium-cni
        ]}
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
          --root-dir=${dataDir}
        '';
        WorkingDirectory = dataDir;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };

    systemd.services.kubelet-dain = {
      description = "Kubernetes Kubelet Shutdown";
      wantedBy = [ "halt.target" "poweroff.target" "reboot.target" ];
      before = [ "halt.target" "poweroff.target" "reboot.target" ];
      requires = [ "kubelet.service" ];
      after = [ "kubelet.service" ];
      path = with pkgs; [ kubectl ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        Type = "oneshot";
        ExecStart = drainScript;
        Environment = "KUBECONFIG=${clusterAdminKubeconfig}";
        WorkingDirectory = dataDir;
        TimeoutStartSec = "300";
        RemainAfterExit = true;
      };
    };

    boot.initrd.availableKernelModules = [ "br_netfilter" ];
    boot.initrd.kernelModules = [ "br_netfilter" ];
    boot.kernelModules = [ "br_netfilter" "overlay" ];
  };
}
