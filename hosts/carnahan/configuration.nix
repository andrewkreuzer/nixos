{ self, config, lib, pkgs, ... }:
let
  libDisks = self.lib.disks;
in
{
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  services.greetd.settings.default_session.command =
    "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd Hyprland";

  boot =
  let
    devNodes = "/dev/disk/by-id/";
    bootDevices = [
      "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13085Z"
      "nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0RA13096T"
    ];
  in
  {
    kernelPackages = pkgs.linuxPackages_6_16;
    initrd.kernelModules = [ "i915" ];
    kernelParams = [ "intel_iommu=on" ];
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
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
