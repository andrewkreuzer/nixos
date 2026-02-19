{ me, self, lib, ... }:
let
  nixModules = self.modules.nixos;
  homeModules = self.modules.home-manager;

  relativeToRoot = self.lib.relativeToRoot;
in
let
  name = baseNameOf ./.;
  systemConfig = {
    imports = [
      # ./configuration.nix

      nixModules.home-manager
      {
        home-manager.sharedModules = [
          # homeModules.gui.default
          # homeModules.tui.default
        ];
      }
    ];
    home-manager.home.stateVersion = lib.mkForce "25.11";
    home-manager.users.${me.username} =
      relativeToRoot "home/${me.username}/home.nix";

    system.stateVersion = "25.11";
    # networking.hostName = name;
  };

  # systemArgs = { inherit tags systemConfig; };
in
{
  flake.darwinConfigurations.${name} = self.lib.mkDarwinSystem systemConfig;
}
