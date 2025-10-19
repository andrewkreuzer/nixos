{ pkgs, pkgs-unstable, ... }:
let
  # broke again :(
  # idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [ "github-copilot" ]);
  idea = (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community []);
in
{

  home.packages = [
    idea
    pkgs-unstable.claude-code
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

