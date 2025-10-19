{ lib, ... }:
{
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "akreuzer" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };
  security.sudo.enable = lib.mkForce false;
}
