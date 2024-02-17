{pkgs}:
{
  hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
  hyprpaper = {
    enable = true;
    extraConfig = builtins.readFile ./hyprpaper.conf;
  };
}
