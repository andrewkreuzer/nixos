{ inputs, ... }:
{
  imports = [
    ./hyprpaper.nix
    ./hyprcursor.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];
  xdg.configFile."hypr/plugins/split-monitor-workspaces".source = inputs.split-monitor-workspaces;
  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    configType = "lua";
    portalPackage = null;
    extraConfig = builtins.readFile ./hyprland.lua;
    plugins = [ ];
  };
  programs.hyprpaper = {
    enable = true;
    extraConfig = builtins.readFile ./hyprpaper.conf;
  };
  programs.hyprcursor = {
    enable = true;
  };
}
