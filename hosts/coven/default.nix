{ self, ... }:
{
  imports = [
    ./day
    ./goode
    ./montgomery
  ];
  # imports = self.lib.scanDir ./.;
}
