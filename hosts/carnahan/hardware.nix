{config, lib, pkgs, ...}:
{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opengl.enable = true;
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime.offload.enableOffloadCmd = true;

    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };

  boot =
  let
    inherit (lib) head tail;
    devNodes = "/dev/disk/by-id/";
    bootDevices = [
      "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z"
      "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T"
    ];
  in {
    kernelPackages =  config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd.availableKernelModules = [
      # TODO: it seems like a lot of these are enabled by default

      # for booting virtual machine
      # with virtio disk controller
      "virtio_pci"
      "virtio_blk"
      # for sata drive
      "ahci"
      # for nvme drive
      "nvme"
      # for external usb drive
      "uas"

      "xhci_pci"
      "thunderbolt"
      "usbhid"
      "rtsx_pci_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "mem_sleep_default=deep" "intel_iommu=on" ];
    supportedFilesystems = [ "zfs" ];
    zfs = {
      devNodes = devNodes;
      forceImportRoot =  false;
      # allowHibernate = mkDefault true;
    };
    loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = ("/boot/efis/" + (head bootDevices) + "-part1");
      };
      generationsDir.copyKernels = true;
      grub = {
        enable = true;
        devices = (map (diskName: devNodes + diskName) bootDevices);
        efiInstallAsRemovable = true;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
        extraInstallCommands = (toString (map (diskName: ''
          set -x
          ${pkgs.coreutils-full}/bin/cp -r ${config.boot.loader.efi.efiSysMountPoint}/EFI /boot/efis/${diskName}-part1
          set +x
        '') (tail bootDevices)));
      };
    };
  };
}
