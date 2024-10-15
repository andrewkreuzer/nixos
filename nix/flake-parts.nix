{ self, inputs, config, ... }:
let
  specialArgs = {
    inherit (config) me;
    inherit self inputs;
  };

  pkgsConfig = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };
  };
in
{
  config.flake = {
    overlays = self.utils.files.forAllNixFiles ../overlays
      (fn: import fn { inherit inputs; });

    nixosModules = {
      default = {
        imports = [
          ../system
          ../pkgs
          ../users
          pkgsConfig
          inputs.agenix.nixosModules.default
        ];
      };

      home-manager = {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "bak";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };

    nixosConfigurations = self.utils.files.forAllNixFiles ../hosts
      (fn: self.lib.mkSystem fn);
  };
}
