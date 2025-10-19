{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.connectiq-sdk-manager
  ];
}
