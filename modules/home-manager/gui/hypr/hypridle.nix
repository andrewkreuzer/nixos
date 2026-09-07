{ pkgs, inputs, ... }:
let
pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.hypridle = {
    enable = true;
    package = pkgs-unstable.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
      };

      listener = [
        {
          timeout = 150;
            on-timeout = "brightness 10";
            on-resume = "brightness 30";
        }

        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 330;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && brightnessctl -r";
        }
      ];
    };
  };
}
