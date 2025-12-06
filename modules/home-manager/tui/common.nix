{ pkgs, ... }:
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      #CLI
      htop
      jq
      yq-go
      rclone
      ripgrep
      unzip
      zoxide

      azure-cli
      gh

      kubelogin
      minikube
      kubectl
      cilium-cli
      hubble
      kubernetes-helm-wrapped
      fluxcd

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

