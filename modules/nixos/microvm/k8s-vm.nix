{ self, inputs, lib, ... }:
let
  relativeToRoot = self.lib.relativeToRoot;
in
{
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Name = lib.mkDefault "ens4";
    networkConfig = {
      Gateway = "192.168.2.1";
      DNS = [ "192.168.2.1" ];
      DHCP = "no";
    };
  };

  # avoid issues like slow ceph commands or mons falling out of quorum.
  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
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
        sandbox_image = "registry.k8s.io/pause:latest";

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
    self.modules.nixos.kubernetes.master
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

    sa.owner = "kubernetes";
    sa.group = "kubernetes";
    sa.file = relativeToRoot
      "secrets/k8s-sa.age";

    sa-key.owner = "kubernetes";
    sa-key.group = "kubernetes";
    sa-key.file = relativeToRoot
      "secrets/k8s-sa-key.age";
  };

  microvm = {
    hypervisor = "cloud-hypervisor";
    vsock.cid = 3;
    volumes = [{
      image = "/var/lib/microvms/k8s/containerd.img";
      autoCreate = true;
      size = 65536;
      fsType = "ext4";
      mountPoint = "/var/lib/containerd";
    }];
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
      tag = "rook";
      source = "rook";
      mountPoint = "/var/lib/rook";
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
