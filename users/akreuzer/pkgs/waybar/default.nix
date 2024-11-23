{ pkgs-unstable, ... }:
let
  file = builtins.readFile ./config.jsonc;
in
{
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
