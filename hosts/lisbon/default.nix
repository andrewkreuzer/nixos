{config, lib, ...}:
{
  networking.hostId = "2fd09238";
  time.timeZone = "America/Toronto";
  networking = {
    hostName = "lisbon";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
  };
}
