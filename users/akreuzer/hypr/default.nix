{pkgs, inputs}:
{
  hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = builtins.readFile ./hyprland.conf;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };
  hyprpaper = {
    enable = true;
    extraConfig = builtins.readFile ./hyprpaper.conf;
  };
}
