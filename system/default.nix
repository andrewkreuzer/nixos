{ config, lib, pkgs, ...}:
with lib;
{
  services.udev.packages = [ pkgs.android-udev-rules ];

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "brave-browser";
    TERM = "xterm-256color";
  };

  security = {
    pam.services.swaylock = {};
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "akreuzer" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = mkForce false;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.10.10.100/32" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = "/home/akreuzer/.cache/wireguard/key";

      peers = [
        {
          publicKey = "9+HZARi0ViE7gl2ZyuK1pGJed8pvuY2Ko2Z5mRtSeX0=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "home.andrewkreuzer.com:51820";
        }
      ];
    };
  };

  system.stateVersion = "22.11";
}
