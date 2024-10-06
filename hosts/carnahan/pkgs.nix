{pkgs, ...}:
{
  config.akreuzer.homemanager.packages = [
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
  };
}
