{ pkgs, inputs, ... }:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  # we have to install hyprland twice because the hm-module
  # doesn't install all the needed shit :(
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # When mesa doesn't match all hell breaks loose
  # also when we do update this alacritty and presumably
  # other opengl applicatoins will crash and burn
  hardware.opengl = {
    package = pkgs-unstable.mesa.drivers;
    driSupport32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  environment.systemPackages = [
    pkgs.libinput-gestures
    pkgs.egl-wayland
  ];
}
