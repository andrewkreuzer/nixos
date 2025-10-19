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
    # targetUser = me.username;
  };
  imports = [
    systemConfig
    inputs.nixpkgs.nixosModules.notDetected
  ];
}
