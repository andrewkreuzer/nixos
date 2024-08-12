{ lib,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  nixos-generators,
  agenix,
}:
let
  mk = import ../lib { inherit lib nixos-generators nixpkgs nixpkgs-unstable; };
in
with mk;
{
  jones = mkGenerator {
    inherit lib;
    name = "jones";
    format = "qcow";
    system = "x86_64-linux";
    extraOverlays = [];
    extraMods = [
      home-manager.nixosModules.home-manager
    ];
  };

  iso = mkGenerator {
    inherit lib;
    name = "iso";
    format = "install-iso";
    system = "x86_64-linux";
    extraOverlays = [];
    extraMods = [
      home-manager.nixosModules.home-manager
    ];
  };
}
