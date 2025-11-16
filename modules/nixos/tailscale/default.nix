{ self, config, ... }:
let
  relativeToRoot = self.lib.relativeToRoot;
in
{
  age.secrets.tailscale.file = relativeToRoot "secrets/tailscale.age";
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
  };
}
