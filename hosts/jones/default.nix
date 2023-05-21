{config, lib, ...}:
{
  networking.hostId = "9411fc44";
  time.timeZone = "America/Toronto";
  networking = {
    hostName = "jones";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
  };
}
