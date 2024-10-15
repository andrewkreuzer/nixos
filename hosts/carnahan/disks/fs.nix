{ self, ... }:
let
  libDisks = self.utils.disks;
in
{
  fileSystems = {
    "/home/akreuzer" = libDisks.mkZfsMount "rpool/USERDATA/akreuzer";
    "/root" = libDisks.mkZfsMount "rpool/USERDATA/root";
    "/etc" = libDisks.mkZfsMount "rpool/ROOT/nixos/etc";
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

    "/boot/efis/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part1" =
      libDisks.mkBootMount "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part1";

    "/boot/efis/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part1" =
      libDisks.mkBootMount "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part1";

    "/tmp" = libDisks.mkTmpfsMount "16G";
  };

  swapDevices = libDisks.mkSwap [
    "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z-part4"
    "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T-part4"
  ];
}
