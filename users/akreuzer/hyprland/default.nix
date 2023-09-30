{pkgs}:
{
  enable = true;
  enableNvidiaPatches = true;
  extraConfig = builtins.readFile ./hyprland.conf;
}
