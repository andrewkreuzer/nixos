{ self, ... }:
let
  libDisks = self.utils.disks;
in
{
  fileSystems =
    {
      "/home/akreuzer" = libDisks.mkZfsMount "rpool/USERDATA/akreuzer";
      "/root" = libDisks.mkZfsMount "rpool/USERDATA/root";
      "/opt" = libDisks.mkZfsMount "rpool/ROOT/nixos/opt";
      "/nix" = libDisks.mkZfsMount "rpool/ROOT/nixos/nix";
      "/nix/store" = libDisks.mkZfsMount "rpool/ROOT/nixos/nix/store";
      "/usr" = libDisks.mkZfsMount "rpool/ROOT/nixos/usr";
      "/usr/local" = libDisks.mkZfsMount "rpool/ROOT/nixos/usr/local";
      "/var" = libDisks.mkZfsMount "rpool/ROOT/nixos/var";
      "/var/cache" = libDisks.mkZfsMount "rpool/ROOT/nixos/var/cache";
      "/var/lib" = libDisks.mkZfsMount "rpool/ROOT/nixos/var/lib";
      "/var/lib/docker" = libDisks.mkZfsMount "rpool/ROOT/nixos/var/lib/docker";
      "/var/log" = libDisks.mkZfsMount "rpool/ROOT/nixos/var/log";
      "/boot" = libDisks.mkZfsMount "bpool/BOOT/nixos";
      "/" = libDisks.mkZfsMount "rpool/ROOT/nixos";

      "/boot/efis/ata-SanDisk_SDSSDA480G_163758443009-part1" =
        libDisks.mkBootMount "ata-SanDisk_SDSSDA480G_163758443009-part1";

      "/tmp" = libDisks.mkTmpfsMount "12G";
    };
}
