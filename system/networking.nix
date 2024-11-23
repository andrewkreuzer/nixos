{
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 5216 ]; # Spotifyd
    firewall.allowedUDPPorts = [ 5353 ]; # Spotifyd
  };
}
