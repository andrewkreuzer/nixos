{
  services.logind = {
    powerKey = "suspend"; # keep pressing this when scanning fprint
    lidSwitch = "lock";
    lidSwitchExternalPower = "suspend";
  };
}
