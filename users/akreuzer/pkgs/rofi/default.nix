{ config, pkgs, colors, ... }:
let theme = import ./style.nix { inherit colors config; }; in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "SauceCodePro 10";
    terminal = "alacritty";
    theme = theme;
  };
}
