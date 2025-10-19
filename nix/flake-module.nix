{ self, inputs, config, ... }:
let
  inherit (inputs) haumea;
in
{
  imports = [ ../hosts ];

  flake = {
    overlays = self.lib.scanDirWithFn ../overlays
      (fn: import fn { inherit inputs; });

    specialArgs = {
      inherit (config) me;
      inherit self inputs;
    };

    modules = haumea.lib.load {
      loader = haumea.lib.loaders.verbatim;
      src = ../modules;
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
    } // self.colmenaConfigurations);
  };

  perSystem = { pkgs, ... }: {
    packages = import ../packages { inherit pkgs; };
  };
}
