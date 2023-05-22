{lib, nixos-generators, nixpkgs, nixpkgs-unstable}:
with lib;
let
  config = { allowUnfree = true; };
in
{
  mkSystem = { name, lib, system, extraOverlays ? [], extraMods ? [], ...}:
  let
    overlays = import ../overlays;
    pkgs = import nixpkgs { inherit system config; overlays = [overlays] ++ extraOverlays; };
  in
    nixosSystem {
      inherit system pkgs lib;
      modules = [
        ../hosts/${name}
        ../system
        ../users
        ../pkgs

        "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
      ] ++ extraMods;
    };


  mkGenerator = { name, lib, system, format, extraOverlays ? [], extraMods ? [], ...}:
  let
    pkgs = import nixpkgs { inherit system config; overlays = [overlays] ++ extraOverlays; };
  in
    nixos-generators.nixosGenerate {
      inherit system pkgs lib format;
      modules = [
        ../hosts/${name}
        ../system
        ../users
      ] ++ extraMods;
    };
}
