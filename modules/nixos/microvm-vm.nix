{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
    {
      microvm.hypervisor = "cloud-hypervisor";
    }
  ];
}
