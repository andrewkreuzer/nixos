{ pkgs, ... }:
{
  services.kea = {
    dhcp4 = {
      enable = true;
      valid-lifetime = 4000;
      renew-timer = 1000;
      rebind-timer = 2000;
      interfaces-config = {
        interfaces = [
          "eth0"
        ];
      };
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      subnet4 = [
        {
          id = 1;
          subnet = "192.0.2.0/24";
          pools = [
            {
              pool = "192.0.2.100 - 192.0.2.240";
            }
          ];
        }
      ];
    };
  };
}
