{ pkgs, pkgs-unstable, ... }:
let
  # broke again :(
  # idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ]);
  idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community []);
in
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
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

      # Dev
      gnumake
      signify
      gcc
      glibc
      python3
      ;
  };
}

