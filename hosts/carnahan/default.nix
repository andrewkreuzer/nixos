{ config, inputs, lib, ... }:
{
  imports = [
    ./disks
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
  ];

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  services.pulseaudio.enable = false;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.nvidia = {
    open = lib.mkForce false; # suspend on lid close is still broken on open
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime.offload.enableOffloadCmd = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };

  networking = {
    hostName = "carnahan";
    hostId = "cb023b45";
    extraHosts = ''
      192.168.2.10 ecb5fafffe997dae
    '';
  };
}
