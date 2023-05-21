{config, lib, ...}:
{
  networking.hostId = "aa475dad";
  time.timeZone = "America/Toronto";
  networking = {
    hostName = "iso";
    useDHCP = false;
  };
}
