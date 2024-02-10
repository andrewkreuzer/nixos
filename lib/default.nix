{lib, nixos-generators, nixpkgs, nixpkgs-unstable}:
with lib;
let
  pkgsConfig = { allowUnfree = true; };
in
{
  mkSystem = { name, userName, lib, system, extraOverlays ? [], extraMods ? [], inputs, ...}:
  let
    overlays = import ../overlays;
    pkgs = import nixpkgs { inherit system ;config = pkgsConfig; overlays = [overlays] ++ extraOverlays; };
  in
    nixosSystem {
      inherit system pkgs lib;
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/${name}
        ../system
        ../users
        ../pkgs

        "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
      ];
      extraModules = extraMods;
    };


  mkGenerator = { name, userName, lib, system, format, extraOverlays ? [], extraMods ? [], ...}:
  let
    overlays = import ../overlays;
    pkgs = import nixpkgs { inherit system ;config = pkgsConfig; overlays = [overlays] ++ extraOverlays; };
  in
    nixos-generators.nixosGenerate {
      inherit system pkgs lib format;
      modules = [
        ../hosts/${name}
        ../system
        ../users
        ../pkgs
      ] ++ extraMods;
    };
}
