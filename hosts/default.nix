{ self,
  inputs,
  lib,
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  hyprland,
  home-manager,
  nixos-generators,
  agenix,
  neovim-nightly-overlay,
}:
let
  userName = "akreuzer";
  mk = import ../lib { inherit lib nixos-generators nixpkgs nixpkgs-unstable; };
in
with mk;
{
  carnahan = mkSystem {
    inherit lib userName inputs;
    name = "carnahan";
    system = "x86_64-linux";
    extraOverlays = [
      hyprland.overlays.default
        neovim-nightly-overlay.overlay
    ];
    extraMods = [
      nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
        agenix.nixosModules.default
        hyprland.nixosModules.default
        home-manager.nixosModules.home-manager
    ];
  };
  lisbon = mkSystem {
    inherit lib userName;
    name = "croft";
    system = "x86_64-linux";
    extraOverlays = [ ];
    extraMods = [
      agenix.nixosModules.default
        home-manager.nixosModules.home-manager
    ];
  };
  croft = mkSystem {
    inherit lib userName;
    name = "croft";
    system = "x86_64-linux";
    extraOverlays = [ ];
    extraMods = [
      agenix.nixosModules.default
        home-manager.nixosModules.home-manager
    ];
  };
}
