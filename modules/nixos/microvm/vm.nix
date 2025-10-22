{
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Name = "ens2";
    networkConfig = {
      Gateway = "192.168.2.1";
      DNS = ["192.168.2.1"];
      DHCP = "no";
    };
  };

  microvm = {
    hypervisor = "cloud-hypervisor";
    shares = [
    {
      tag = "etc";
      source = "etc";
      mountPoint = "/etc";
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
    }
    ];
  };
}
