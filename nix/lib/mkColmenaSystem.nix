{ inputs }:
{ tags, systemConfig }:
{
  name,
  ...
}:
{
  deployment = {
    inherit tags;
    targetHost = name;
    targetUser = "root";
  };
  imports = [
    systemConfig
    inputs.nixpkgs.nixosModules.notDetected
  ];
}
