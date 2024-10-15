{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
    xkb.options = "caps:escape_shifted_capslock";
  };
}
