{ lib, ... }:
{
  security = {
    pam.services.hyprlock = {
      logFailures = true;
    };
    pam.services.greetd = {
      logFailures = true;
      unixAuth = true;
      fprintAuth = true;
    };
    # pam.services.swaylock = {};
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
