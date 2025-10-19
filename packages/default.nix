{
  perSystem = { pkgs, ... }: {
    packages.connectiq-sdk-manager = pkgs.callPackage ./garmin/connectiq-sdk-manager.nix {};
  };
}
