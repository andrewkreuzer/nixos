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
            ceph-0 = {
              name = "ceph-0";
              size = "256G";
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
          "USERDATA" = {
            type = "zfs_fs";
          };
          "USERDATA/akreuzer" = {
            type = "zfs_fs";
            mountpoint = "/home/akreuzer";
            options."com.sun:auto-snapshot" = "true";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/USERDATA/akreuzer@blank$' || zfs snapshot rpool/USERDATA/akreuzer@blank";
          };
          "USERDATA/root" = {
            type = "zfs_fs";
            mountpoint = "/root";
          };
          "ROOT/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/ROOT/nixos@blank$' || zfs snapshot rpool/ROOT/nixos@blank";
          };
          "ROOT/nixos/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "ROOT/nixos/nix/store" = {
            type = "zfs_fs";
            mountpoint = "/nix/store";
          };
          "ROOT/nixos/var/lib/docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
          };
        };
      };
    };
  };
}
