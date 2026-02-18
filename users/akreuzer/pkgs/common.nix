{ pkgs, pkgs-unstable, ... }:
let
  # broke again :(
  # idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ]);
  idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community []);
in
{
  home.packages = [
    idea
    (pkgs.azure-cli.withExtensions [ pkgs.azure-cli.extensions.aks-preview pkgs.azure-cli.extensions.k8s-extension ])
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      cryptography
      pyyaml
    ]))
  ] ++ builtins.attrValues {
    inherit (pkgs)
      # GUI
      # firefox
      # brave
      # slack
      # discord
      # remmina
      # # lens-desktop
      # postman
      # wireshark
      # vscode
      # burpsuite
      # gimp

      #CLI
      jq
      rclone
      ripgrep
      unzip
      zoxide
      htop
      pulsemixer
      minikube
      kubelogin
      yubikey-manager
      claude-code
      k9s
      kubectl
      fluxcd
      kubernetes-helm
      terraform
      checkov
      trivy
      sops

      # Tools
      # libnotify
      # grim
      # slurp
      # geeqie

      # Dev
      gnumake
      signify
      gcc
      glibc

      # Theme
      # tela-circle-icon-theme
      ;
  } ++ builtins.attrValues {
    inherit (pkgs-unstable)
      gh
      github-copilot-cli
    ;
  };
}
