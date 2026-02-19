{ self, inputs, ... }:
let
  inherit (inputs.darwin) lib;
  pkgsConfig = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };
  };
in
systemConfig: lib.darwinSystem  {
  inherit (self) specialArgs;
  system = "aarach64-darwin";
  modules = [
    pkgsConfig
    systemConfig
  ];
}
