{ pkgs, ... }:
{
  connectiq-sdk-manager = pkgs.callPackage ./garmin/connectiq-sdk-manager.nix {};
}
