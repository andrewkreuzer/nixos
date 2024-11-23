{ pkgs, ... }:
{
  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ /* "github-copilot" */ ]) # no copilot :(
  ] ++ builtins.attrValues {
    inherit (pkgs)
      # GUI
      firefox
      brave
      slack
      discord
      android-studio
      remmina
      # lens-desktop
      postman
      wireshark
      vscode
      burpsuite

      #CLI
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

      # Tools
      libnotify
      grim
      slurp
      geeqie

      # Dev
      gnumake
      signify
      gcc
      glibc
      python3

      # Theme
      tela-circle-icon-theme
      ;
  };
}
