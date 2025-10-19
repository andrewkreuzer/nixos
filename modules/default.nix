{ self, ... }:
{
  flake.homeModules = self.lib.scanDirWithFn ./home-manager
    (module: import module);

  flake.nixosModules = self.lib.scanDirWithFn ./nixos
    (module: import module);
}
