{ pkgs, inputs, ... }:
{
  imports = [
    ./hyprpaper.nix
    ./hyprcursor.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = builtins.readFile ./hyprland.conf;
    plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };
  programs.hyprpaper = {
    enable = true;
    extraConfig = builtins.readFile ./hyprpaper.conf;
  };
  programs.hyprcursor = {
    enable = true;
  };
}
