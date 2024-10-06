{pkgs, ...}:
{
  config.akreuzer.homemanager.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ])
  ] ++ builtins.attrValues {
    inherit (pkgs)
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
      ;
  };
}
