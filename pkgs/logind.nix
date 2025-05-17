{
  services.logind = {
    powerKey = "suspend"; # keep pressing this when scanning fprint
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "suspend";
  };
}
