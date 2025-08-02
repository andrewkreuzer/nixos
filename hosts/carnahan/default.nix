{ config, lib, pkgs, ... }:
{
  imports = [
    ./disks/fs.nix
    ./disks/boot.nix
  ];

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.82.09";
      sha256_64bit = "sha256-Puz4MtouFeDgmsNMKdLHoDgDGC+QRXh6NVysvltWlbc=";
      sha256_aarch64 = "sha256-6tHiAci9iDTKqKrDIjObeFdtrlEwjxOHJpHfX4GMEGQ=";
      openSha256 = "sha256-YB+mQD+oEDIIDa+e8KX1/qOlQvZMNKFrI5z3CoVKUjs=";
      settingsSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
      persistencedSha256 = "sha256-lbYSa97aZ+k0CISoSxOMLyyMX//Zg2Raym6BC4COipU=";
    };
    prime.offload.enable = true;
    prime.offload.enableOffloadCmd = true;
    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };

  hardware.graphics.extraPackages = [
    pkgs.intel-media-driver
    pkgs.intel-compute-runtime
    pkgs.vpl-gpu-rt 
  ];

  hardware.graphics.extraPackages32 = [
    pkgs.driversi686Linux.intel-media-driver
  ];

  services.fstrim.enable = true;
  services.pulseaudio.enable = false;
  services.thermald.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_16;
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "intel_iommu=on" ];
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };

  networking = {
    hostName = "carnahan";
    hostId = "cb023b45";
    extraHosts = ''
      192.168.2.10 ecb5fafffe997dae
    '';
  };
}
