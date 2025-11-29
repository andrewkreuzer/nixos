{ pkgs, ... }:
{
  # connectiq-sdk-manager = pkgs.callPackage ./garmin/connectiq-sdk-manager.nix { };
  cilium-cni = pkgs.callPackage ./cilium/cilium-cni/default.nix { };
}
