{ self, inputs, config, ... }:
let
  inherit (self.inputs.nixpkgs) lib;
  specialArgs = {
    inherit self inputs;
    inherit (config) me;
  };
in
{
  config.flake = {
    lib = {
      mkSystem = sysConfig:
        lib.nixosSystem {
          inherit lib specialArgs;
          modules = [
            self.nixosModules.default
            self.nixosModules.home-manager
            sysConfig

            # not sure I need this
            "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
          ];
        };
    };
  };
}
