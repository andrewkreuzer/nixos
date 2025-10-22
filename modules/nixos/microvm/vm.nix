{
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Gateway = "192.168.3.1";
      DNS = ["192.168.1.1"];
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
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      proto = "virtiofs";
    }
    ];
  };
}
