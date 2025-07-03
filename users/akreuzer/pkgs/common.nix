{ pkgs, ... }:
let
  # broke again :(
  # idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ]);
  idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community []);
in
{
  home.packages = [
    idea
  ] ++ builtins.attrValues {
    inherit (pkgs)
      # GUI
      firefox
      brave
      slack
      discord
      remmina
      # lens-desktop
      postman
      wireshark
      vscode
      burpsuite
      gimp

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
      claude-code

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
