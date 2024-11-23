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
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 3;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, 0";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          rounding = -1;
          font_family = "SauceCodePro Nerd Font";
          font_color = "rgb(" + (builtins.replaceStrings ["#"] [""] colors.ayu.fg) + ")";
          inner_color = "rgb(" + (builtins.replaceStrings ["#"] [""] colors.ayu.bg) + ")";
          outer_color = "rgb(" + (builtins.replaceStrings ["#"] [""] colors.ayu.ui) + ")";
          placeholder_text = "<i>Input Password...</i>";
          outline_thickness = 2;
          shadow_size = 1;
          shadow_passes = 2;
        }
      ];
    };
  };
}

