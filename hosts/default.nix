{ self,
  inputs,
  lib,
  nixpkgs,
  nixpkgs-unstable,
}:
let
  userName = "akreuzer";
  mk = import ../lib { inherit lib nixpkgs nixpkgs-unstable; };
in
with mk;
{
  carnahan = mkSystem rec {
    inherit lib userName inputs;
    name = "carnahan";
    system = "x86_64-linux";
    extraOverlays = [
      inputs.neovim-nightly-overlay.overlays.default
      # (final: prev: {
      #   inputs.hyprland.packages.${system}.hyprland = prev.inputs.hyprland.packages.${system}.hyprland.overrideAttrs (old: {
      #     legacyRenderer = true;
      #   });
      # })
    ];
    extraMods = [
      inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];
  };
  croft = mkSystem {
    inherit lib userName;
    name = "croft";
    system = "x86_64-linux";
    extraOverlays = [ ];
    extraMods = [
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
