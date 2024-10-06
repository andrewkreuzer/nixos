{ lib, pkgs, userName, ...}:
with lib;
{
  services.udev = {
    packages = [
      pkgs.zsa-udev-rules
      pkgs.yubikey-personalization
    ];
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
  };

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

  nix = {
    settings = {
      trusted-users = [userName];
      # experimental-features = [ "nix-command" "flakes" ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      substituters = [ "https://hyprland.cachix.org" "https://cuda-maintainers.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="];
    };
  };

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
    wg1 = {
      autostart = false;
      address = [ "10.100.0.3/32" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = "/home/akreuzer/.cache/wireguard/privatekey";

      peers = [
        {
          publicKey = "ZMOH0eU0S7VFqjQ25fEzvcJsAJD7E7UOP4dAwJU4TlI=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "home.andrewkreuzer.com:51821";
        }
      ];
    };
    azure = {
      autostart = false;
      address = [ "10.1.0.100/32" ];
      dns = [ "10.10.1.10" ];
      privateKeyFile = "/home/akreuzer/.cache/wireguard/privatekey";

      peers = [
        {
          publicKey = "AECyy0fEBSmqsEKvbNoMdXk8KfgY5mOyMvTgDgRrhE0=";
          allowedIPs = [ "10.10.0.0/16" ];
          endpoint = "40.88.124.71:51820";
        }
      ];
    };
    proton = {
      autostart = false;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/home/akreuzer/.cache/wireguard/proton";

      peers = [
        {
          publicKey = "wP/7Xi9sTiO1XMpLXf/OUJiJc1E0PA3KyskMtGajEFA=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "146.70.202.2:51820";
        }
      ];
    };
  };

  system.stateVersion = "22.11";
}
