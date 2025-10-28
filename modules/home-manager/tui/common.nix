{ pkgs, ... }:
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      #CLI
      htop
      jq
      rclone
      ripgrep
      unzip
      zoxide

      azure-cli
      gh

      kubelogin
      minikube
      kubectl

      pulsemixer
      yubikey-manager

      # Dev
      gcc
      glibc
      gnumake
      python3
      signify
      ;
  };
}

