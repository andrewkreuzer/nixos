{ self, inputs, ... }:
let
  name = baseNameOf ./.;
  tags = [ "coven" ];
  systemConfig = {
    imports = [
      ./disk-config.nix
      ./configuration.nix
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko

      self.nixosModules.common
      self.nixosModules.users
      self.nixosModules.tui

      self.nixosModules.home-manager
      {
        home-manager.sharedModules = [
          self.homeModules.tui
        ];
      }
    ];

    system.stateVersion = "25.05";
    networking.hostName = "day";
    networking.hostId = "10a3abb9";
  };

  systemArgs = { inherit tags systemConfig; };
in
{
  flake.colmena.${name} = self.lib.mkColmenaSystem systemArgs;
  flake.nixosConfigurations.${name} = self.lib.mkSystem systemConfig;
}
