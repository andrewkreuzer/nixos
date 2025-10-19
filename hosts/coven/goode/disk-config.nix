{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "noatime" "nofail" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "lz4";
          relatime = "on";
          acltype = "posixacl";
          xattr = "sa";
          normalization = "formD";
          canmount = "off";
          dnodesize = "auto";
          sync = "disabled";
          "com.sun:auto-snapshot" = "true";
        };
        options.ashift = "12";
        options.autotrim = "on";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool@blank$' || zfs snapshot rpool@blank";
        datasets = {
          "rpool/USERDATA" = {
            type = "zfs_fs";
          };
          "rpool/USERDATA/akreuzer" = {
            type = "zfs_fs";
            mountpoint = "/home/akreuzer";
            options."com.sun:auto-snapshot" = "true";
          };
          "rpool/USERDATA/root" = {
            type = "zfs_fs";
            mountpoint = "/root";
          };
          "rpool/ROOT/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "rpool/ROOT/nixos/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "rpool/ROOT/nixos/nix/store" = {
            type = "zfs_fs";
            mountpoint = "/nix/store";
          };
          "rpool/ROOT/nixos/var/lib/docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
          };
        };
      };
    };
  };
}
