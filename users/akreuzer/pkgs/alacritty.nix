{ pkgs-unstable, ... }:
{
  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    settings = {
      "env" = {
        "TERM" = "xterm-256color";
      };
      "window" = {
        "padding" = {
          "x" = 5;
          "y" = 0;
        };
        "dynamic_padding" = true;
      };
      "font" = {
        "normal" = {
          "family" = "SauceCodePro Nerd Font";
          "style" = "Regular";
        };
        "bold" = {
          "family" = "SauceCodePro Nerd Font";
          "style" = "Bold";
        };
        "italic" = {
          "family" = "SauceCodePro Nerd Font";
          "style" = "Italic";
        };
        "size" = 8;
      };
      "colors" = {
        "primary" = {
          "background" = "#0A0E14";
          "foreground" = "#B3B1AD";
        };
        "normal" = {
          "black" = "#01060E";
          "red" = "#EA6C73";
          "green" = "#91B362";
          "yellow" = "#F9AF4F";
          "blue" = "#53BDFA";
          "magenta" = "#FAE994";
          "cyan" = "#90E1C6";
          "white" = "#C7C7C7";
        };
        "bright" = {
          "black" = "#686868";
          "red" = "#F07178";
          "green" = "#C2D94C";
          "yellow" = "#FFB454";
          "blue" = "#59C2FF";
          "magenta" = "#FFEE99";
          "cyan" = "#95E6CB";
          "white" = "#FFFFFF";
        };
      };
      "shell" = {
        "program" = "zsh";
        "args" = [
          "--login"
        ];
      };
    };
  };
}
