{ config, pkgs, lib, inputs, specialArgs, options, modulesPath, nixosConfig, osConfig }:
let
  hyprland = import ./hyprland { inherit pkgs; };
  alacritty = import ./alacritty.nix { inherit pkgs config; };
  zsh = import ./zsh.nix { inherit pkgs config; };
  starship = import ./starship.nix { inherit pkgs config; };
  tmux = import ./tmux.nix { inherit pkgs; };
  neovim = import ./neovim.nix { inherit pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };
  waybar = import ./waybar { inherit pkgs; };
  sway = import ./sway.nix { inherit pkgs scripts; };
in
{
  programs = {
    alacritty = alacritty;
    zsh = zsh;
    starship = starship;
    tmux = tmux;
    zoxide.enable = true;
    neovim = neovim;
    waybar = waybar;

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

  wayland.windowManager.hyprland = hyprland;
  services = {
    swayidle = sway.idle;
    mako = {
      enable = true;
      backgroundColor = "#0f2028";
      textColor = "#f6e8f4";
      anchor="bottom-right";
    };
  };

  home = {
    stateVersion = "22.11";
    packages = [
     pkgs.jetbrains.idea-community
    ] ++ builtins.attrValues {
      inherit (pkgs)
        firefox
        brave
        htop
        hyprpaper
        pulsemixer
        rofi-wayland
        grim
        slurp
        geeqie
        gimp
        darktable

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
        azure-cli
        vscode
        minikube
        kubelogin
        burpsuite

        gnumake
        signify
        gcc
        glibc
        go
        lua
        python3
        gopls
        cargo
        rustc
        opam
        protobuf

        xxd
        _0x
        inotify-tools
        libnotify
        yubikey-manager
        qbittorrent
        ;
    } ++ [
      scripts.screenshot
      scripts.brightness
      scripts.hypr-powersave
      scripts.work
      scripts.whatitdo
      scripts.mkcd
    ];
  };
}
