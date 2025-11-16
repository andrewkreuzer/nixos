{ self, ... }:
{
  imports = [
    self.modules.nixos.kubernetes.pki.certmgr
    self.modules.nixos.kubernetes.addon-manager

    self.modules.nixos.etcd
    self.modules.nixos.kubernetes.default
    self.modules.nixos.kubernetes.apiserver
    self.modules.nixos.kubernetes.kubelet
    # self.modules.nixos.kubernetes.proxy
    self.modules.nixos.kubernetes.scheduler
    self.modules.nixos.kubernetes.controller-manager

    self.modules.nixos.kubernetes.coredns
    self.modules.nixos.kubernetes.cilium.default
    self.modules.nixos.kubernetes.metallb.default
  ];
}
