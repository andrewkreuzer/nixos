{ config, pkgs, pkgs-unstable, lib, inputs, specialArgs, options, modulesPath, nixosConfig, osConfig, userName }:
let
  hypr = import ./hypr { inherit pkgs inputs; };
  alacritty = import ./alacritty.nix { inherit pkgs config; };
  zsh = import ./zsh.nix { inherit pkgs config; };
  starship = import ./starship.nix { inherit pkgs config; };
  tmux = import ./tmux.nix { inherit pkgs; };
  neovim = import ./neovim.nix { inherit pkgs pkgs-unstable; };
  scripts = import ./scripts.nix { inherit pkgs; };
  waybar = import ./waybar { inherit pkgs; };
  sway = import ./sway.nix { inherit pkgs scripts; };
in
{
  # _module.args.pkgs = lib.mkForce pkgs-unstable;
  imports = [ ../../pkgs/hyprpaper.nix ];
  programs = {
    alacritty = alacritty;
    zsh = zsh;
    starship = starship;
    tmux = tmux;
    zoxide.enable = true;
    neovim = neovim;
    waybar = waybar;
    swaylock = sway.lock;
    hyprpaper = hypr.hyprpaper;

    java.enable = true;

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

  wayland.windowManager.hyprland = hypr.hyprland;
  services = {
    swayidle = sway.idle;
    mako = {
      enable = true;
      backgroundColor = "#0f2028";
      textColor = "#f6e8f4";
      anchor="bottom-right";
      defaultTimeout = 20000;
    };
  };

  home = {
    stateVersion = "24.05";
    packages = [
     (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ])
    ] ++ builtins.attrValues {
      inherit (pkgs)
        # GUI
        firefox
        brave
        slack
        android-studio
        remmina
        openlens
        postman
        wireshark
        vscode
        burpsuite

        # CLI
        gh
        jq
        rclone
        ripgrep
        unzip
        zoxide
        htop
        pulsemixer
        azure-cli
        minikube
        kubelogin
        yubikey-manager

        # Dev
        gnumake
        signify
        gcc
        glibc
        python3

        # Tools 
        libnotify
        rofi-wayland
        grim
        slurp
        geeqie
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
