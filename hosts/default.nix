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
        neovim-nightly-overlay.overlays.default
    ];
    extraMods = [
      nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
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
