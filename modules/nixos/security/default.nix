{ self, ... }:
{
  imports = self.lib.scanDir ./.;
}
