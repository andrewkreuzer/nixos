{ config, colors, ... }:
let theme = import ./style.nix { inherit colors config; }; in
{
  programs.rofi = {
    enable = true;
    font = "SauceCodePro 10";
    terminal = "alacritty";
    theme = theme;
  };
}
