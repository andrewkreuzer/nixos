{ pkgs-unstable, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs-unstable.ghostty;
  };
}
