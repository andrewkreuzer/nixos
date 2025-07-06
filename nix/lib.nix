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
      mkSystem = sysConfig: lib.nixosSystem {
        inherit lib specialArgs;
        modules = [
          self.nixosModules.default
          self.nixosModules.home-manager
          sysConfig

          # not sure I need this
          "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
        ];
      };
      mkHome = homeConfig: inputs.home-manager.lib.homeManagerConfiguration {
        inherit lib;
        modules = [
          {
            home.username = config.me.username;
            home.homeDirectory = "/home/${config.me.username}";
          }
          homeConfig
        ];
        extraSpecialArgs = specialArgs;
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };
      };
    };
  };
}
