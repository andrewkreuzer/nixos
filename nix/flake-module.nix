{ self, inputs, config, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    ../modules
    ../hosts
    ../packages
  ];

  flake = {
    overlays = self.lib.scanDirWithFn ../overlays
      (fn: import fn { inherit inputs; });

    specialArgs = {
      inherit (config) me;
      inherit self inputs;
    };

    homeConfigurations = {
      ${config.me.username} = self.lib.mkHome ../users/${config.me.username}/home.nix;
    };

    colmenaHive = inputs.colmena.lib.makeHive ({
      meta = {
        inherit (self) specialArgs;
        nixpkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };
      };
    } // self.colmena);
  };
}
