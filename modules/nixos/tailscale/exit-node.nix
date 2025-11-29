{ self, ... }:
{
  imports = [
    self.modules.nixos.tailscale.default
  ];

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--advertise-routes=192.168.2.0/24"
    ];
  };
}
