{config, lib, pkgs, ...}:
  let
  inherit (lib) head;
  devNodes = "/dev/disk/by-id/";
  bootDevices = [
    "ata-SanDisk_SDSSDA480G_163758443009"
  ];
in {
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  boot = {
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
    kernelParams = [];
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
      };
    };
  };
}
