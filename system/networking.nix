let
  exceptPort = 6667;
  spotifydTCPPort = 5216;
  mDNS = 5353;
  pyHttpServer = 8000;
in
{
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [spotifydTCPPort exceptPort pyHttpServer];
    firewall.allowedUDPPorts = [mDNS];
  };
}
