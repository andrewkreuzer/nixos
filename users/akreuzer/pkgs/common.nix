{ pkgs, ... }:
{
  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ])
  ] ++ builtins.attrValues {
    inherit (pkgs)
      # GUI
      firefox
      brave
      slack
      discord
      android-studio
      remmina
      openlens
      postman
      wireshark
      vscode
      burpsuite
      tela-circle-icon-theme

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
      rofi-wayland
      grim
      slurp
      geeqie

      # Dev
      gnumake
      signify
      gcc
      glibc
      python3
      ;
  };
}
