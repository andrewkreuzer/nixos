{ pkgs, inputs, colors, ... }:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  programs.hyprlock = {
    enable = true;
    package = pkgs-unstable.hyprlock;
    settings = {
      general = {
        hide_cursor = true;
        fractional_scaling = 1;
      };

      bezier = "linear, 1, 1, 0, 0";
      animation = "fade, 1, 1.8, linear";

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 3;
        }
      ];

      shape = [
        {
          size = "400px, 140px";
          color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.bg) + ")";
          rounding = 50; # circle
          border_size = 1;
          border_color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.ui) + ")";
          position = "0, 0";
          halign = "center";
          valign = "center";
          zindex = 0;
        }
      ];

      label = [
        {
          text = "Good luck, <i>$USER</i>";
          font_size = "14";
          font_family = "SauceCodePro Nerd Font";
          color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.fg) + ")";
          position = "-60, 30";
          halign = "center";
          valign = "center";
          zindex = 1;
        }
        {
          text = "cmd[update:200] echo \"<i>$PROMPT</i>\"";
          font_size = "8";
          font_family = "SauceCodePro Nerd Font";
          color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.fg) + ")";
          position = "0, 0";
          halign = "center";
          valign = "center";
          zindex = 1;
        }
      ];

      input-field = [
        {
          size = "300, 35";
          position = "0, -30";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          rounding = -1;
          font_family = "SauceCodePro Nerd Font";
          font_color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.fg) + ")";
          inner_color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.bg) + ")";
          outer_color = "rgb(" + (builtins.replaceStrings [ "#" ] [ "" ] colors.ayu.ui) + ")";
          placeholder_text = "<i>input password...</i>";
          outline_thickness = 2;
          shadow_size = 1;
          shadow_passes = 2;
          zindex = 1;
        }
      ];
    };
  };
}

