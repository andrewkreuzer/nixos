{ lib, ... }:
{
  security = {
    pam.services.hyprlock = {};
    pam.services.swaylock = { };
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "akreuzer" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = lib.mkForce false;
  };
}
