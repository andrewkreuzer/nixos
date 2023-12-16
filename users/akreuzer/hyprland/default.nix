{pkgs}:
{
  enable = true;
  extraConfig = builtins.readFile ./hyprland.conf;
}
