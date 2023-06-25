{ config, pkgs, ... }:
let
  alacritty = import ./alacritty.nix { inherit pkgs config; };
  zsh = import ./zsh.nix { inherit pkgs config; };
  starship = import ./starship.nix { inherit pkgs config; };
  sway = import ./sway.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
  neovim = import ./neovim.nix { inherit pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  programs = {
    alacritty = alacritty;
    zsh = zsh;
    starship = starship;
    tmux = tmux;
    zoxide.enable = true;
    neovim = neovim;

    java.enable = true;
    swaylock = sway.lock;

    git = {
      enable = true;
      userName  = "andrewkreuzer";
      userEmail = "me@andrewkreuzer.com";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services = {
    swayidle = sway.idle;
    mako = {
      enable = true;
      backgroundColor = "#0f2028";
      textColor = "#f6e8f4";
    };
  };

  home = {
    stateVersion = "22.11";

    packages = builtins.attrValues {
      inherit (pkgs)
        firefox
        brave
        htop
        hyprpaper
        pulsemixer
        rofi-wayland
        waybar
        wluma
        grim
        slurp

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

        openlens
        postman
        wireshark

        signify
        gcc
        glibc
        go
        lua
        python3
        gopls
        rustup
        opam
        xxd
        _0x
        inotify-tools
        libnotify
        yubikey-manager
      ;
    } ++ [
      scripts.screenshot
      scripts.brightness
      scripts.hypr-powersave
      scripts.work
      scripts.launch-waybar
    ];
  };
}
