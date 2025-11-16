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
      nixModules.tailscale.default

      nixModules.home-manager
      {
        home-manager.sharedModules = [
          homeModules.tui.default
        ];
      }

      nixModules.microvm.k8s-host
      nixModules.nix-containers.haproxy.default
    ];

    system.stateVersion = "25.05";
    networking.hostName = "goode";
    networking.hostId = "550589ae";
  };

  systemArgs = { inherit tags systemConfig; };
in
{
  flake.nixosConfigurations.${name} = self.lib.mkSystem systemConfig;
  flake.colmenaConfigurations.${name} = self.lib.mkColmenaSystem systemArgs;
}
