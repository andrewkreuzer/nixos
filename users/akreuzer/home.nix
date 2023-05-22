{ config, pkgs, lib, ... }:
{
  programs = {
    neovim.enable = true;
    direnv.enable = true;
    mako.enable = true;

    git = {
      enable = true;
      userName  = "andrewkreuzer";
      userEmail = "me@andrewkreuzer.com";
    };

  };

  home = {
    stateVersion = "22.11";

    packages = builtins.attrValues {
      inherit (pkgs)
        alacritty
        firefox
        brave
        htop
        hyprpaper
        pulsemixer
        starship
        swaylock
        rofi-wayland
        waybar
        wluma

        fluxcd
        gh
        jq
        kubectl
        nodejs
        rclone
        remmina
        ripgrep
        slack
        unzip
        zoxide

        signify
        gcc
        go
        gopls
        rustup
      ;
    };
  };
}
