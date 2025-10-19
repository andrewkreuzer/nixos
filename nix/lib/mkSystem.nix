{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  pkgsConfig = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };
  };
in
systemConfig: lib.nixosSystem {
  inherit (self) specialArgs;
  modules = [
    pkgsConfig
    systemConfig
    inputs.nixpkgs.nixosModules.notDetected
  ];
}
