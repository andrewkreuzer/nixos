{ config, lib, pkgs, ... }:
{
  boot =
    let
      devNodes = "/dev/disk/by-id/";
      bootDevices = [
        "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z"
        "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T"
      ];
    in
    {
      zfs.devNodes = devNodes;
      loader = {
        efi = {
          canTouchEfiVariables = false;
          efiSysMountPoint = ("/boot/efis/" + (lib.head bootDevices) + "-part1");
        };
        generationsDir.copyKernels = true;
        grub = {
          enable = true;
          devices = (map (diskName: devNodes + diskName) bootDevices);
          efiInstallAsRemovable = true;
          copyKernels = true;
          efiSupport = true;
          zfsSupport = true;
          extraInstallCommands = (toString (map
            (diskName: ''
              set -x
              ${pkgs.coreutils-full}/bin/cp -r ${config.boot.loader.efi.efiSysMountPoint}/EFI /boot/efis/${diskName}-part1
              set +x
            '')
            (lib.tail bootDevices)));
        };
      };
    };
}
