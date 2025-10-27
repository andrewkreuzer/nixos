{ self, inputs, ... }:
let
  relativeToRoot = self.lib.relativeToRoot;
in
{
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Name = "ens2";
    networkConfig = {
      Gateway = "192.168.2.1";
      DNS = [ "192.168.2.1" ];
      DHCP = "no";
    };
  };

  virtualisation.containerd = {
    enable = true;
    settings = {
      version = 2;
      root = "/var/lib/containerd";
      state = "/run/containerd";
      oom_score = 0;

      grpc = {
        address = "/run/containerd/containerd.sock";
      };

      plugins."io.containerd.grpc.v1.cri" = {
        sandbox_image = "pause:latest";

        cni = {
          bin_dir = "/opt/cni/bin";
          max_conf_num = 0;
        };

        containerd.runtimes.runc = {
          runtime_type = "io.containerd.runc.v2";
          options.SystemdCgroup = true;
        };
      };
    };
  };

  imports = [
    inputs.agenix.nixosModules.default
    self.modules.nixos.kubernetes.pki.certmgr
  ];
  age.secrets = {
    k8s-ca.owner = "multirootca";
    k8s-ca.group = "multirootca";
    k8s-ca.file = relativeToRoot
      "secrets/k8s-ca.age";

    k8s-ca-key.owner = "multirootca";
    k8s-ca-key.group = "multirootca";
    k8s-ca-key.file = relativeToRoot
      "secrets/k8s-ca-key.age";

    multirootca-auth-key.owner = "multirootca";
    multirootca-auth-key.group = "multirootca";
    multirootca-auth-key.file = relativeToRoot
      "secrets/multirootca-auth-key.age";
  };

  microvm = {
    hypervisor = "cloud-hypervisor";
    shares = [{
      tag = "etc";
      source = "etc";
      mountPoint = "/etc";
      proto = "virtiofs";
    }
      {
        tag = "multirootca";
        source = "multirootca";
        mountPoint = "/var/lib/multirootca";
        proto = "virtiofs";
      }
      {
        tag = "etcd";
        source = "etcd";
        mountPoint = "/var/lib/etcd";
        proto = "virtiofs";
      }
      {
        tag = "cfssl";
        source = "cfssl";
        mountPoint = "/var/lib/cfssl";
        proto = "virtiofs";
      }
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        proto = "virtiofs";
      }];
  };
}
