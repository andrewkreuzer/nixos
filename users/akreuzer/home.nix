{ config, pkgs, lib, ... }:
{
  programs = {
    neovim.enable = true;
    direnv.enable = true;

    git = {
      enable = true;
      userName  = "andrewkreuzer";
      userEmail = "me@andrewkreuzer.com";
    };

  };

  programs.mako.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

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
