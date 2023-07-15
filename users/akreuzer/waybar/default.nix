{pkgs}:
{
  enable = true;
  package = pkgs.waybar;
  systemd.enable = true;
  settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
  style = ./style.css;
}
