{ pkgs-unstable, pkgs, ... }:
let
  file = builtins.readFile ./config.jsonc;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      playerctl
      ;
  };
  programs.waybar = {
    enable = true;
    package = pkgs-unstable.waybar;
    systemd = {
      enable = true;
    };
    settings = builtins.fromJSON file;
    style = ./style.css;
  };
}
