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
      kernelPackages = pkgs.linuxPackages_6_12;
      initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      kernelParams = [ "intel_iommu=on" ];
      supportedFilesystems = [ "zfs" ];
      zfs.devNodes = devNodes;
      zfs.forceImportRoot = false;

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
