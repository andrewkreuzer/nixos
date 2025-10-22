{ self, inputs, ... }:
let
  nixModules = self.modules.nixos;
  homeModules = self.modules.home-manager;
in
let
  name = baseNameOf ./.;
  tags = [ "coven" ];
  systemConfig = {
    imports = [
      ./disk-config.nix
      ./configuration.nix
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko

      nixModules.common
      nixModules.users
      nixModules.tui.default
      nixModules.security.openssh-root
      nixModules.security.privliage-escalation

      nixModules.home-manager
      {
        home-manager.sharedModules = [
          homeModules.tui.default
        ];
      }

      nixModules.microvm.host
    ];

    system.stateVersion = "25.05";
    networking.hostName = "day";
    networking.hostId = "10a3abb9";
  };

  systemArgs = { inherit tags systemConfig; };
in
{
  flake.nixosConfigurations.${name} = self.lib.mkSystem systemConfig;
  flake.colmenaConfigurations.${name} = self.lib.mkColmenaSystem systemArgs;
}
