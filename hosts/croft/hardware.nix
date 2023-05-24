{config, lib, pkgs, ...}:
let
  devNodes = "/dev/disk/by-id/";
  bootDevice = "ata-SanDisk_SDSSDA480G_163758443009";
in {
  age.secrets.boot.file = ../../secrets/boot.age;


  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  boot = {
    kernelPackages =  config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd = {
      secrets = {
       "/run/boot_secret" = config.age.secrets.boot.path;
      };
      availableKernelModules = [
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
    };
    kernelModules = [ "kvm-intel" ];
    kernelParams = [];
    supportedFilesystems = [ "zfs" ];
    zfs = {
      devNodes = devNodes;
      forceImportRoot =  false;
      # allowHibernate = mkDefault true;
    };
    loader = {
      supportsInitrdSecrets = true;
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = ("/boot/efis/" + bootDevice + "-part1");
      };
      generationsDir.copyKernels = true;
      grub = {
        enable = true;
        device = "/dev/disk/by-id/ata-SanDisk_SDSSDA480G_163758443009";
        efiInstallAsRemovable = true;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
      };
    };
  };
}
