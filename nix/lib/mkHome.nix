{ self, inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
homeConfig: inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib;
  modules = [
  {
    home.username = config.me.username;
    home.homeDirectory = "/home/${config.me.username}";
  }
  homeConfig
  ];
  extraSpecialArgs = self.specialArgs;
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
}

