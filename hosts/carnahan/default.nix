{ self, ... }:
let
  nixModules = self.modules.nixos;
  homeModules = self.modules.home-manager;
in
let
  name = baseNameOf ./.;
  tags = [ "laptop" ];
  systemConfig = {
    imports = [
      ./nvidia.nix
      ./configuration.nix
      ./hardware-configuration.nix

      nixModules.users
      nixModules.laptop

      nixModules.home-manager
      {
        home-manager.sharedModules = [
          homeModules.gui.default
          homeModules.tui.default
        ];
      }
    ];

    system.stateVersion = "22.11";
    networking.hostName = "carnahan";
    networking.hostId = "cb023b45";
  };

  systemArgs = { inherit tags systemConfig; };
in
{
  flake.nixosConfigurations.${name} = self.lib.mkSystem systemConfig;
  flake.colmenaConfigurations.${name} = self.lib.mkColmenaSystem systemArgs;
}
